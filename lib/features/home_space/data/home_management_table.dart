import 'package:drift/drift.dart';

import '../../bills/data/bill_table.dart';
import '../domain/entities/maintenance_job.dart';

/// A bill linked into the Home screen's Utilities row (section 6.10). The row
/// class is `HomeUtilityRow` to match the `TaskRow`/`Task` naming split.
///
/// No `deletedAt`: unlinking a utility is a real removal, the same shape
/// `Attachments` uses for a file record — there is nothing to undo a link
/// back into, unlike a bill or an appliance the user might want restored.
@DataClassName('HomeUtilityRow')
@TableIndex(name: 'home_utilities_bill', columns: {#billId}, unique: true)
@TableIndex(name: 'home_utilities_space', columns: {#spaceId})
class HomeUtilities extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get iconKey => text()();

  TextColumn get billId => text().references(Bills, #id)();

  TextColumn get spaceId => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// A repair or service job (section 6.10). The row class is
/// `MaintenanceJobRow` to match the `TaskRow`/`Task` naming split.
@DataClassName('MaintenanceJobRow')
@TableIndex(name: 'maintenance_jobs_due', columns: {#dueDate})
@TableIndex(name: 'maintenance_jobs_space', columns: {#spaceId})
class MaintenanceJobs extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  IntColumn get status => intEnum<MaintenanceJobStatus>()();

  DateTimeColumn get dueDate => dateTime().nullable()();

  IntColumn get costMinor => integer().nullable()();

  TextColumn get vendor => text().nullable()();

  TextColumn get notes => text().nullable()();

  /// The task this job was promoted into, if any — a plain nullable link
  /// with no foreign key, the same shape `Payments.transactionId` uses,
  /// since the task can be edited or deleted independently from that point.
  TextColumn get taskId => text().nullable()();

  TextColumn get spaceId => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete, so the toast's undo can bring the job back — the same
  /// shape `Tasks`/`Bills` use.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// A household appliance (section 6.10). The row class is `ApplianceRow` to
/// match the `TaskRow`/`Task` naming split.
@DataClassName('ApplianceRow')
@TableIndex(name: 'appliances_warranty', columns: {#warrantyTill})
@TableIndex(name: 'appliances_space', columns: {#spaceId})
class Appliances extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get makeModel => text().nullable()();

  DateTimeColumn get purchasedOn => dateTime().nullable()();

  /// Null for something with no warranty left to track. Indexed because Home's
  /// Needs attention filters on it by range, the same reason
  /// `Documents.expiresOn` is indexed.
  DateTimeColumn get warrantyTill => dateTime().nullable()();

  DateTimeColumn get nextServiceOn => dateTime().nullable()();

  /// The invoice, if the user filed one under Documents. A plain nullable
  /// link with no foreign key, the same shape `VehicleRenewals.documentId`
  /// uses.
  TextColumn get documentId => text().nullable()();

  TextColumn get spaceId => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
