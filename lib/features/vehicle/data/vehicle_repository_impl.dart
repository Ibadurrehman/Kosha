import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/notifications/reminder_scheduler.dart';
import '../../../core/services/notifications/scheduled_reminder.dart';
import '../../../core/utils/clock.dart';
import '../../spaces/data/space_repository_impl.dart';
import '../../spaces/domain/entities/space.dart';
import '../../spaces/domain/space_repository.dart';
import '../domain/entities/fuel_log.dart';
import '../domain/entities/service_record.dart';
import '../domain/entities/vehicle.dart';
import '../domain/entities/vehicle_renewal.dart';
import '../domain/vehicle_renewal_reminder.dart';
import '../domain/vehicle_repository.dart';

part 'vehicle_repository_impl.g.dart';

/// SQLite-backed vehicles, renewals, service history and fuel logs.
///
/// Depends on [SpaceRepository] the same way `DriftBillRepository` depends on
/// a transaction repository for the "log expense" write: a vehicle's space is
/// not user-chosen, so creating one has to ask Spaces for the one it belongs
/// to rather than taking a `spaceId` argument.
class DriftVehicleRepository implements VehicleRepository {
  DriftVehicleRepository(this._db, this._clock, this._scheduler, this._spaces);

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final ReminderScheduler _scheduler;
  final SpaceRepository _spaces;

  @override
  Stream<Vehicle?> watchPrimary() {
    final query = _db.select(_db.vehicles)
      ..where((v) => v.deletedAt.isNull())
      ..orderBy([(v) => OrderingTerm.asc(v.createdAt)])
      ..limit(1);
    return query
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toDomain(row));
  }

  @override
  Future<Vehicle?> findById(String id) async {
    final row = await (_db.select(_db.vehicles)..where((v) => v.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<Vehicle> create(NewVehicle draft) async {
    final space = await _spaces.findBySystemKey(SystemSpace.vehicle);
    if (space == null) {
      throw StateError(
        'The Vehicle system space has not been seeded yet — read Spaces '
        'once (SpaceRepository.watchActive/listActive) before creating a '
        'vehicle.',
      );
    }
    final now = _clock.now();
    final vehicle = Vehicle(
      id: _uuid.v4(),
      name: draft.name,
      makeModel: draft.makeModel,
      registration: draft.registration,
      odometerKm: draft.odometerKm,
      purchaseDate: draft.purchaseDate,
      spaceId: space.id,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.vehicles).insert(_toRow(vehicle));
    return vehicle;
  }

  @override
  Future<Vehicle> edit(
    String id, {
    String? name,
    String? makeModel,
    String? registration,
    int? odometerKm,
    DateTime? purchaseDate,
    bool clearPurchaseDate = false,
  }) async {
    await (_db.update(_db.vehicles)..where((v) => v.id.equals(id))).write(
      VehiclesCompanion(
        name: name == null ? const Value.absent() : Value(name),
        makeModel:
            makeModel == null ? const Value.absent() : Value(makeModel),
        registration: registration == null
            ? const Value.absent()
            : Value(registration),
        odometerKm:
            odometerKm == null ? const Value.absent() : Value(odometerKm),
        purchaseDate: clearPurchaseDate
            ? const Value(null)
            : (purchaseDate == null ? const Value.absent() : Value(purchaseDate)),
        updatedAt: Value(_clock.now()),
      ),
    );
    return _require(id);
  }

  @override
  Future<void> softDelete(String id) async {
    final now = _clock.now();
    await (_db.update(_db.vehicles)..where((v) => v.id.equals(id))).write(
      VehiclesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    for (final renewal in await _renewalRows(id)) {
      await _scheduler.cancel(ReminderKind.vehicleRenewal, renewal.id);
    }
  }

  @override
  Future<void> restore(String id) async {
    await (_db.update(_db.vehicles)..where((v) => v.id.equals(id))).write(
      VehiclesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
    for (final row in await _renewalRows(id)) {
      await _syncRenewalReminder(_toRenewalDomain(row));
    }
  }

  @override
  Stream<List<VehicleRenewal>> watchRenewals(String vehicleId) {
    final query = _db.select(_db.vehicleRenewals)
      ..where((r) => r.vehicleId.equals(vehicleId))
      ..orderBy([(r) => OrderingTerm.asc(r.kind)]);
    return query.watch().map((rows) => rows.map(_toRenewalDomain).toList());
  }

  @override
  Stream<List<VehicleRenewal>> watchRenewalsNeedingAttention({
    required DateTime today,
  }) {
    final query = _liveRenewalsQuery()
      ..orderBy([OrderingTerm.asc(_db.vehicleRenewals.validTill)]);
    return query.watch().map(
          (rows) => [
            for (final renewal in rows.map(_toRenewalFromJoin))
              if (vehicleRenewalNeedsAttention(
                vehicleRenewalStatus(renewal, today),
              ))
                renewal,
          ],
        );
  }

  @override
  Stream<List<VehicleRenewal>> watchRenewalsDueBetween(
    DateTime from,
    DateTime to,
  ) {
    final query = _liveRenewalsQuery()
      ..where(
        _db.vehicleRenewals.validTill.isBiggerOrEqualValue(from) &
            _db.vehicleRenewals.validTill.isSmallerThanValue(to),
      )
      ..orderBy([OrderingTerm.asc(_db.vehicleRenewals.validTill)]);
    return query.watch().map((rows) => rows.map(_toRenewalFromJoin).toList());
  }

  @override
  Future<VehicleRenewal> upsertRenewal(
    String vehicleId,
    VehicleRenewalKind kind, {
    required DateTime validTill,
    int reminderOffsetDays = defaultVehicleRenewalReminderDays,
    String? documentId,
  }) async {
    final existing = await (_db.select(_db.vehicleRenewals)
          ..where(
            (r) => r.vehicleId.equals(vehicleId) & r.kind.equalsValue(kind),
          ))
        .getSingleOrNull();
    final now = _clock.now();

    final VehicleRenewal renewal;
    if (existing == null) {
      renewal = VehicleRenewal(
        id: _uuid.v4(),
        vehicleId: vehicleId,
        kind: kind,
        validTill: validTill,
        reminderOffsetDays: reminderOffsetDays,
        documentId: documentId,
        createdAt: now,
        updatedAt: now,
      );
      await _db.into(_db.vehicleRenewals).insert(_toRenewalRow(renewal));
    } else {
      await (_db.update(_db.vehicleRenewals)
            ..where((r) => r.id.equals(existing.id)))
          .write(
        VehicleRenewalsCompanion(
          validTill: Value(validTill),
          reminderOffsetDays: Value(reminderOffsetDays),
          documentId: Value(documentId),
          updatedAt: Value(now),
        ),
      );
      renewal = _toRenewalDomain(
        await (_db.select(_db.vehicleRenewals)
              ..where((r) => r.id.equals(existing.id)))
            .getSingle(),
      );
    }
    await _syncRenewalReminder(renewal);
    return renewal;
  }

  @override
  Stream<List<ServiceRecord>> watchServiceHistory(String vehicleId) {
    final query = _db.select(_db.serviceRecords)
      ..where((s) => s.vehicleId.equals(vehicleId))
      ..orderBy([(s) => OrderingTerm.desc(s.date)]);
    return query.watch().map((rows) => rows.map(_toServiceDomain).toList());
  }

  @override
  Future<ServiceRecord> addServiceRecord(
    String vehicleId,
    NewServiceRecord draft,
  ) async {
    final record = ServiceRecord(
      id: _uuid.v4(),
      vehicleId: vehicleId,
      date: draft.date,
      odometerKm: draft.odometerKm,
      description: draft.description,
      costMinor: draft.costMinor,
      createdAt: _clock.now(),
    );
    await _db.into(_db.serviceRecords).insert(_toServiceRow(record));
    await _bumpOdometer(vehicleId, draft.odometerKm);
    return record;
  }

  @override
  Stream<List<FuelLog>> watchFuelLogs(String vehicleId) {
    final query = _db.select(_db.fuelLogs)
      ..where((f) => f.vehicleId.equals(vehicleId))
      ..orderBy([(f) => OrderingTerm.asc(f.date)]);
    return query.watch().map((rows) => rows.map(_toFuelDomain).toList());
  }

  @override
  Future<FuelLog> addFuelLog(String vehicleId, NewFuelLog draft) async {
    final log = FuelLog(
      id: _uuid.v4(),
      vehicleId: vehicleId,
      date: draft.date,
      litres: draft.litres,
      costMinor: draft.costMinor,
      odometerKm: draft.odometerKm,
      createdAt: _clock.now(),
    );
    await _db.into(_db.fuelLogs).insert(_toFuelRow(log));
    await _bumpOdometer(vehicleId, draft.odometerKm);
    return log;
  }

  /// Live vehicles' renewals, joined so a deleted vehicle's rows never surface
  /// in the two cross-vehicle queries above — `watchRenewals(vehicleId)`
  /// skips the join because its caller already knows the vehicle it asked
  /// for.
  JoinedSelectStatement<dynamic, dynamic> _liveRenewalsQuery() =>
      _db.select(_db.vehicleRenewals).join([
        innerJoin(
          _db.vehicles,
          _db.vehicles.id.equalsExp(_db.vehicleRenewals.vehicleId),
        ),
      ])
        ..where(_db.vehicles.deletedAt.isNull());

  VehicleRenewal _toRenewalFromJoin(TypedResult row) =>
      _toRenewalDomain(row.readTable(_db.vehicleRenewals));

  Future<List<VehicleRenewalRow>> _renewalRows(String vehicleId) =>
      (_db.select(_db.vehicleRenewals)
            ..where((r) => r.vehicleId.equals(vehicleId)))
          .get();

  Future<void> _bumpOdometer(String vehicleId, int odometerKm) async {
    final vehicle = await findById(vehicleId);
    if (vehicle == null || odometerKm <= vehicle.odometerKm) return;
    await (_db.update(_db.vehicles)..where((v) => v.id.equals(vehicleId)))
        .write(
      VehiclesCompanion(
        odometerKm: Value(odometerKm),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  Future<void> _syncRenewalReminder(VehicleRenewal renewal) async {
    final reminder = reminderForVehicleRenewal(renewal, now: _clock.now());
    if (reminder == null) {
      await _scheduler.cancel(ReminderKind.vehicleRenewal, renewal.id);
    } else {
      await _scheduler.schedule(reminder);
    }
  }

  Future<Vehicle> _require(String id) async {
    final vehicle = await findById(id);
    if (vehicle == null) throw StateError('No vehicle with id $id');
    return vehicle;
  }

  Vehicle _toDomain(VehicleRow row) => Vehicle(
        id: row.id,
        name: row.name,
        makeModel: row.makeModel,
        registration: row.registration,
        odometerKm: row.odometerKm,
        purchaseDate: row.purchaseDate,
        spaceId: row.spaceId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  VehiclesCompanion _toRow(Vehicle vehicle) => VehiclesCompanion.insert(
        id: vehicle.id,
        name: vehicle.name,
        makeModel: vehicle.makeModel,
        registration: vehicle.registration,
        odometerKm: Value(vehicle.odometerKm),
        purchaseDate: Value(vehicle.purchaseDate),
        spaceId: vehicle.spaceId,
        createdAt: vehicle.createdAt,
        updatedAt: vehicle.updatedAt,
        deletedAt: Value(vehicle.deletedAt),
      );

  VehicleRenewal _toRenewalDomain(VehicleRenewalRow row) => VehicleRenewal(
        id: row.id,
        vehicleId: row.vehicleId,
        kind: row.kind,
        validTill: row.validTill,
        reminderOffsetDays: row.reminderOffsetDays,
        documentId: row.documentId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  VehicleRenewalsCompanion _toRenewalRow(VehicleRenewal renewal) =>
      VehicleRenewalsCompanion.insert(
        id: renewal.id,
        vehicleId: renewal.vehicleId,
        kind: renewal.kind,
        validTill: renewal.validTill,
        reminderOffsetDays: Value(renewal.reminderOffsetDays),
        documentId: Value(renewal.documentId),
        createdAt: renewal.createdAt,
        updatedAt: renewal.updatedAt,
      );

  ServiceRecord _toServiceDomain(ServiceRecordRow row) => ServiceRecord(
        id: row.id,
        vehicleId: row.vehicleId,
        date: row.date,
        odometerKm: row.odometerKm,
        description: row.description,
        costMinor: row.costMinor,
        createdAt: row.createdAt,
      );

  ServiceRecordsCompanion _toServiceRow(ServiceRecord record) =>
      ServiceRecordsCompanion.insert(
        id: record.id,
        vehicleId: record.vehicleId,
        date: record.date,
        odometerKm: record.odometerKm,
        description: record.description,
        costMinor: record.costMinor,
        createdAt: record.createdAt,
      );

  FuelLog _toFuelDomain(FuelLogRow row) => FuelLog(
        id: row.id,
        vehicleId: row.vehicleId,
        date: row.date,
        litres: row.litres,
        costMinor: row.costMinor,
        odometerKm: row.odometerKm,
        createdAt: row.createdAt,
      );

  FuelLogsCompanion _toFuelRow(FuelLog log) => FuelLogsCompanion.insert(
        id: log.id,
        vehicleId: log.vehicleId,
        date: log.date,
        litres: log.litres,
        costMinor: log.costMinor,
        odometerKm: log.odometerKm,
        createdAt: log.createdAt,
      );
}

@Riverpod(keepAlive: true)
VehicleRepository vehicleRepository(Ref ref) => DriftVehicleRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(reminderSchedulerProvider),
      ref.watch(spaceRepositoryProvider),
    );
