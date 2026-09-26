import 'package:drift/drift.dart';

import '../domain/entities/vehicle_renewal.dart';

/// Vehicles (section 6.9). The row class is `VehicleRow` to match the
/// `TaskRow`/`Task` naming split.
///
/// `spaceId` always names the single Vehicle system space rather than one
/// per vehicle — see [Vehicle]'s doc comment.
@DataClassName('VehicleRow')
@TableIndex(name: 'vehicles_space', columns: {#spaceId})
class Vehicles extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 500)();

  TextColumn get makeModel => text()();

  TextColumn get registration => text()();

  IntColumn get odometerKm => integer().withDefault(const Constant(0))();

  DateTimeColumn get purchaseDate => dateTime().nullable()();

  TextColumn get spaceId => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete — see [Vehicle.deletedAt].
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One renewal kind's current standing for a vehicle (section 6.9).
///
/// The unique index on (vehicleId, kind) is what makes `upsertRenewal` an
/// upsert instead of a second write path — the same role `spaces_system_key`
/// plays for system spaces.
@DataClassName('VehicleRenewalRow')
@TableIndex(
  name: 'vehicle_renewals_vehicle_kind',
  columns: {#vehicleId, #kind},
  unique: true,
)
class VehicleRenewals extends Table {
  TextColumn get id => text()();

  TextColumn get vehicleId => text().references(Vehicles, #id)();

  IntColumn get kind => intEnum<VehicleRenewalKind>()();

  DateTimeColumn get validTill => dateTime()();

  IntColumn get reminderOffsetDays => integer()
      .withDefault(const Constant(defaultVehicleRenewalReminderDays))();

  /// The Document row this renewal was filed under, if any.
  TextColumn get documentId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Service history (section 6.9). A completed service is a fact about a
/// moment — like `Payments`, rows are only ever inserted or removed with
/// their vehicle, never edited in place.
///
/// A service's receipt is an `Attachments` row scoped to this table's id via
/// `ownerType`/`ownerId`, the polymorphic pattern `document_table.dart`
/// already reserves this shape for.
@DataClassName('ServiceRecordRow')
@TableIndex(name: 'service_records_vehicle', columns: {#vehicleId, #date})
class ServiceRecords extends Table {
  TextColumn get id => text()();

  TextColumn get vehicleId => text().references(Vehicles, #id)();

  DateTimeColumn get date => dateTime()();

  IntColumn get odometerKm => integer()();

  TextColumn get description => text()();

  IntColumn get costMinor => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Fuel log (section 6.9's "fuel this month" and km/l). Same append-only
/// shape as `ServiceRecords`.
@DataClassName('FuelLogRow')
@TableIndex(name: 'fuel_logs_vehicle', columns: {#vehicleId, #date})
class FuelLogs extends Table {
  TextColumn get id => text()();

  TextColumn get vehicleId => text().references(Vehicles, #id)();

  DateTimeColumn get date => dateTime()();

  RealColumn get litres => real()();

  IntColumn get costMinor => integer()();

  IntColumn get odometerKm => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
