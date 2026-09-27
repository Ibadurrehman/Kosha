import 'package:drift/drift.dart';

/// User-defined record types (section 6.5's "Custom records").
///
/// The row class is `RecordTemplateRow` to match the `TaskRow`/`Task` naming
/// split. Unlike `Spaces` and `Documents` this carries an ordinary
/// `deletedAt`: section 6.5 gives record types no Archive screen to live in,
/// so deleting one is a real removal with undo from the toast, the same shape
/// maintenance jobs and appliances use.
@DataClassName('RecordTemplateRow')
@TableIndex(name: 'record_templates_space', columns: {#spaceId})
class RecordTemplates extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 200)();

  /// A key into the shared icon map, the same indirection `Spaces.iconKey`
  /// uses — storing a code point would tie the database to one icon font.
  TextColumn get iconKey => text()();

  /// JSON array of `{key,label,type,required}` (§5.1). A column rather than a
  /// `RecordFields` table because nothing ever queries *across* fields: they
  /// are read whole, with their template, every single time, and a child table
  /// would buy a join and an ordering column for no query it enables.
  TextColumn get fields => text().withDefault(const Constant('[]'))();

  TextColumn get spaceId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The rows of a [RecordTemplates] type: three policies under "My Insurance".
///
/// `templateId` is a plain column, not a foreign key with a cascade: deleting
/// a template is soft, and a cascade that deleted these for real would make
/// the undo impossible. Reads filter out records whose template is gone the
/// same way `HomeUtilities` filters out a deleted bill.
@DataClassName('CustomRecordRow')
@TableIndex(name: 'custom_records_template', columns: {#templateId})
@TableIndex(name: 'custom_records_renewal', columns: {#renewalDate})
class CustomRecords extends Table {
  TextColumn get id => text()();

  TextColumn get templateId => text()();

  TextColumn get title => text().withLength(min: 1, max: 500)();

  /// JSON object of field key → value, for the reason [RecordTemplates.fields]
  /// gives.
  TextColumn get values => text().withDefault(const Constant('{}'))();

  /// The pill for a record that does not renew; a renewing one derives its
  /// own. See [CustomRecord.statusLabel].
  TextColumn get statusLabel => text().nullable()();

  /// Indexed because the renewals read filters on it by range, the way
  /// `documents_expires` serves Home's Upcoming.
  DateTimeColumn get renewalDate => dateTime().nullable()();

  TextColumn get documentId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
