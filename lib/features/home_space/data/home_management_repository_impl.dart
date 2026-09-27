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
import '../domain/appliance_reminder.dart';
import '../domain/entities/appliance.dart';
import '../domain/entities/home_utility.dart';
import '../domain/entities/maintenance_job.dart';
import '../domain/home_management_repository.dart';

part 'home_management_repository_impl.g.dart';

/// SQLite-backed utilities, maintenance jobs and appliances.
///
/// Depends on [SpaceRepository] the same way [DriftVehicleRepository] does:
/// nothing here is user-scoped to a space, so every write has to ask Spaces
/// for the one Home system space it belongs to.
class DriftHomeManagementRepository implements HomeManagementRepository {
  DriftHomeManagementRepository(
    this._db,
    this._clock,
    this._scheduler,
    this._spaces,
  );

  static const Uuid _uuid = Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final ReminderScheduler _scheduler;
  final SpaceRepository _spaces;

  Future<String> _homeSpaceId() async {
    final space = await _spaces.findBySystemKey(SystemSpace.home);
    if (space == null) {
      throw StateError(
        'The Home system space has not been seeded yet — read Spaces once '
        '(SpaceRepository.watchActive/listActive) before writing here.',
      );
    }
    return space.id;
  }

  @override
  Stream<List<HomeUtility>> watchUtilities() {
    final query = _db.select(_db.homeUtilities).join([
      innerJoin(
        _db.bills,
        _db.bills.id.equalsExp(_db.homeUtilities.billId),
      ),
    ])
      ..where(_db.bills.deletedAt.isNull())
      ..orderBy([OrderingTerm.asc(_db.homeUtilities.createdAt)]);
    return query.watch().map(
          (rows) => rows
              .map((r) => _toUtilityDomain(r.readTable(_db.homeUtilities)))
              .toList(),
        );
  }

  @override
  Future<HomeUtility> addUtility(NewHomeUtility draft) async {
    final spaceId = await _homeSpaceId();
    final now = _clock.now();
    final utility = HomeUtility(
      id: _uuid.v4(),
      name: draft.name,
      iconKey: draft.iconKey,
      billId: draft.billId,
      spaceId: spaceId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.homeUtilities).insert(_toUtilityRow(utility));
    return utility;
  }

  @override
  Future<void> removeUtility(String id) async {
    await (_db.delete(_db.homeUtilities)..where((u) => u.id.equals(id))).go();
  }

  @override
  Stream<List<MaintenanceJob>> watchJobs() {
    final query = _db.select(_db.maintenanceJobs)
      ..where((j) => j.deletedAt.isNull())
      ..orderBy([(j) => OrderingTerm.desc(j.createdAt)]);
    return query.watch().map((rows) => rows.map(_toJobDomain).toList());
  }

  @override
  Stream<List<MaintenanceJob>> watchJobsNeedingAttention({
    required DateTime today,
  }) {
    final query = _db.select(_db.maintenanceJobs)
      ..where((j) => j.deletedAt.isNull())
      ..orderBy([(j) => OrderingTerm.asc(j.dueDate)]);
    return query.watch().map(
          (rows) => [
            for (final job in rows.map(_toJobDomain))
              if (maintenanceJobNeedsAttention(
                maintenanceJobDisplayStatus(job, today),
              ))
                job,
          ],
        );
  }

  @override
  Future<MaintenanceJob> createJob(NewMaintenanceJob draft) async {
    final spaceId = await _homeSpaceId();
    final now = _clock.now();
    final job = MaintenanceJob(
      id: _uuid.v4(),
      title: draft.title,
      status: draft.status,
      dueDate: draft.dueDate,
      costMinor: draft.costMinor,
      vendor: draft.vendor,
      notes: draft.notes,
      spaceId: spaceId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.maintenanceJobs).insert(_toJobRow(job));
    return job;
  }

  @override
  Future<MaintenanceJob> editJob(
    String id, {
    String? title,
    MaintenanceJobStatus? status,
    DateTime? dueDate,
    bool clearDueDate = false,
    int? costMinor,
    bool clearCost = false,
    String? vendor,
    bool clearVendor = false,
    String? notes,
    bool clearNotes = false,
    String? taskId,
  }) async {
    await (_db.update(_db.maintenanceJobs)..where((j) => j.id.equals(id)))
        .write(
      MaintenanceJobsCompanion(
        title: title == null ? const Value.absent() : Value(title),
        status: status == null ? const Value.absent() : Value(status),
        dueDate: clearDueDate
            ? const Value(null)
            : (dueDate == null ? const Value.absent() : Value(dueDate)),
        costMinor: clearCost
            ? const Value(null)
            : (costMinor == null ? const Value.absent() : Value(costMinor)),
        vendor: clearVendor
            ? const Value(null)
            : (vendor == null ? const Value.absent() : Value(vendor)),
        notes: clearNotes
            ? const Value(null)
            : (notes == null ? const Value.absent() : Value(notes)),
        taskId: taskId == null ? const Value.absent() : Value(taskId),
        updatedAt: Value(_clock.now()),
      ),
    );
    return _requireJob(id);
  }

  @override
  Future<void> softDeleteJob(String id) async {
    final now = _clock.now();
    await (_db.update(_db.maintenanceJobs)..where((j) => j.id.equals(id)))
        .write(
      MaintenanceJobsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> restoreJob(String id) async {
    await (_db.update(_db.maintenanceJobs)..where((j) => j.id.equals(id)))
        .write(
      MaintenanceJobsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
  }

  @override
  Stream<List<Appliance>> watchAppliances() {
    final query = _db.select(_db.appliances)
      ..where((a) => a.deletedAt.isNull())
      ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]);
    return query.watch().map((rows) => rows.map(_toApplianceDomain).toList());
  }

  @override
  Stream<List<Appliance>> watchAppliancesNeedingAttention({
    required DateTime today,
  }) {
    // Every live appliance is read and filtered in Dart, the same reasoning
    // `DocumentRepository.watchNeedingAttention` gives: the set is a handful
    // of rows, and there is no per-row lead time here to push into SQL either.
    final query = _db.select(_db.appliances)
      ..where((a) => a.deletedAt.isNull() & a.warrantyTill.isNotNull())
      ..orderBy([(a) => OrderingTerm.asc(a.warrantyTill)]);
    return query.watch().map(
          (rows) => [
            for (final appliance in rows.map(_toApplianceDomain))
              if (applianceNeedsAttention(
                applianceWarrantyStatus(appliance, today),
              ))
                appliance,
          ],
        );
  }

  @override
  Future<Appliance> createAppliance(NewAppliance draft) async {
    final spaceId = await _homeSpaceId();
    final now = _clock.now();
    final appliance = Appliance(
      id: _uuid.v4(),
      name: draft.name,
      makeModel: draft.makeModel,
      purchasedOn: draft.purchasedOn,
      warrantyTill: draft.warrantyTill,
      nextServiceOn: draft.nextServiceOn,
      documentId: draft.documentId,
      spaceId: spaceId,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.appliances).insert(_toApplianceRow(appliance));
    await _syncApplianceReminder(appliance);
    return appliance;
  }

  @override
  Future<Appliance> editAppliance(
    String id, {
    String? name,
    String? makeModel,
    bool clearMakeModel = false,
    DateTime? purchasedOn,
    bool clearPurchasedOn = false,
    DateTime? warrantyTill,
    bool clearWarrantyTill = false,
    DateTime? nextServiceOn,
    bool clearNextServiceOn = false,
    String? documentId,
    bool clearDocumentId = false,
  }) async {
    await (_db.update(_db.appliances)..where((a) => a.id.equals(id))).write(
      AppliancesCompanion(
        name: name == null ? const Value.absent() : Value(name),
        makeModel: clearMakeModel
            ? const Value(null)
            : (makeModel == null ? const Value.absent() : Value(makeModel)),
        purchasedOn: clearPurchasedOn
            ? const Value(null)
            : (purchasedOn == null
                ? const Value.absent()
                : Value(purchasedOn)),
        warrantyTill: clearWarrantyTill
            ? const Value(null)
            : (warrantyTill == null
                ? const Value.absent()
                : Value(warrantyTill)),
        nextServiceOn: clearNextServiceOn
            ? const Value(null)
            : (nextServiceOn == null
                ? const Value.absent()
                : Value(nextServiceOn)),
        documentId: clearDocumentId
            ? const Value(null)
            : (documentId == null ? const Value.absent() : Value(documentId)),
        updatedAt: Value(_clock.now()),
      ),
    );
    final updated = await _requireAppliance(id);
    await _syncApplianceReminder(updated);
    return updated;
  }

  @override
  Future<void> softDeleteAppliance(String id) async {
    final now = _clock.now();
    await (_db.update(_db.appliances)..where((a) => a.id.equals(id))).write(
      AppliancesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    await _scheduler.cancel(ReminderKind.appliance, id);
  }

  @override
  Future<void> restoreAppliance(String id) async {
    await (_db.update(_db.appliances)..where((a) => a.id.equals(id))).write(
      AppliancesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_clock.now()),
      ),
    );
    await _syncApplianceReminder(await _requireAppliance(id));
  }

  Future<void> _syncApplianceReminder(Appliance appliance) async {
    final reminder = reminderForAppliance(appliance, now: _clock.now());
    if (reminder == null) {
      await _scheduler.cancel(ReminderKind.appliance, appliance.id);
    } else {
      await _scheduler.schedule(reminder);
    }
  }

  Future<MaintenanceJob> _requireJob(String id) async {
    final row = await (_db.select(_db.maintenanceJobs)
          ..where((j) => j.id.equals(id)))
        .getSingleOrNull();
    if (row == null) throw StateError('No maintenance job with id $id');
    return _toJobDomain(row);
  }

  Future<Appliance> _requireAppliance(String id) async {
    final row = await (_db.select(_db.appliances)
          ..where((a) => a.id.equals(id)))
        .getSingleOrNull();
    if (row == null) throw StateError('No appliance with id $id');
    return _toApplianceDomain(row);
  }

  HomeUtility _toUtilityDomain(HomeUtilityRow row) => HomeUtility(
        id: row.id,
        name: row.name,
        iconKey: row.iconKey,
        billId: row.billId,
        spaceId: row.spaceId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  HomeUtilitiesCompanion _toUtilityRow(HomeUtility utility) =>
      HomeUtilitiesCompanion.insert(
        id: utility.id,
        name: utility.name,
        iconKey: utility.iconKey,
        billId: utility.billId,
        spaceId: utility.spaceId,
        createdAt: utility.createdAt,
        updatedAt: utility.updatedAt,
      );

  MaintenanceJob _toJobDomain(MaintenanceJobRow row) => MaintenanceJob(
        id: row.id,
        title: row.title,
        status: row.status,
        dueDate: row.dueDate,
        costMinor: row.costMinor,
        vendor: row.vendor,
        notes: row.notes,
        taskId: row.taskId,
        spaceId: row.spaceId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  MaintenanceJobsCompanion _toJobRow(MaintenanceJob job) =>
      MaintenanceJobsCompanion.insert(
        id: job.id,
        title: job.title,
        status: job.status,
        dueDate: Value(job.dueDate),
        costMinor: Value(job.costMinor),
        vendor: Value(job.vendor),
        notes: Value(job.notes),
        taskId: Value(job.taskId),
        spaceId: job.spaceId,
        createdAt: job.createdAt,
        updatedAt: job.updatedAt,
        deletedAt: Value(job.deletedAt),
      );

  Appliance _toApplianceDomain(ApplianceRow row) => Appliance(
        id: row.id,
        name: row.name,
        makeModel: row.makeModel,
        purchasedOn: row.purchasedOn,
        warrantyTill: row.warrantyTill,
        nextServiceOn: row.nextServiceOn,
        documentId: row.documentId,
        spaceId: row.spaceId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  AppliancesCompanion _toApplianceRow(Appliance appliance) =>
      AppliancesCompanion.insert(
        id: appliance.id,
        name: appliance.name,
        makeModel: Value(appliance.makeModel),
        purchasedOn: Value(appliance.purchasedOn),
        warrantyTill: Value(appliance.warrantyTill),
        nextServiceOn: Value(appliance.nextServiceOn),
        documentId: Value(appliance.documentId),
        spaceId: appliance.spaceId,
        createdAt: appliance.createdAt,
        updatedAt: appliance.updatedAt,
        deletedAt: Value(appliance.deletedAt),
      );
}

@Riverpod(keepAlive: true)
HomeManagementRepository homeManagementRepository(Ref ref) =>
    DriftHomeManagementRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(clockProvider),
      ref.watch(reminderSchedulerProvider),
      ref.watch(spaceRepositoryProvider),
    );
