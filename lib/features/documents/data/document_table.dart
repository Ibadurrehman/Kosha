import 'package:drift/drift.dart';

import '../domain/entities/document.dart';

/// Documents (section 6.8). The row class is `DocumentRow` to match the
/// `TaskRow`/`Task` naming split.
///
/// Like `Spaces`, this table has no `deletedAt`: section 6.8's actions are
/// View file / Replace / Set reminder / Archive, with no delete anywhere, and
/// the Archive list is a real screen rather than a hidden state. ADR 0008
/// gives the reasoning — a second timestamp meaning "gone for real" would be a
/// column no surface writes.
@DataClassName('DocumentRow')
@TableIndex(name: 'documents_expires', columns: {#expiresOn})
@TableIndex(name: 'documents_category', columns: {#category})
@TableIndex(name: 'documents_space', columns: {#spaceId})
class Documents extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 500)();

  IntColumn get category => intEnum<DocumentCategory>()();

  TextColumn get number => text().nullable()();

  DateTimeColumn get issuedOn => dateTime().nullable()();

  /// Null for something that never expires. Indexed because Home's Needs
  /// attention and the Upcoming timeline both filter on it by range.
  DateTimeColumn get expiresOn => dateTime().nullable()();

  IntColumn get reminderOffsetDays =>
      integer().withDefault(const Constant(defaultDocumentReminderDays))();

  TextColumn get notes => text().nullable()();

  TextColumn get spaceId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Files belonging to a record, stored inside the app sandbox.
///
/// `ownerType`/`ownerId` rather than a foreign key to `Documents`, so a
/// vehicle service record and an appliance invoice can use the same table
/// without a second one — the shape `ActivityEntries` already established.
/// The cost is that nothing at the database level stops an orphan, which is
/// why `DocumentRepository.archive` and its file deletions go through one
/// place.
@DataClassName('AttachmentRow')
@TableIndex(name: 'attachments_owner', columns: {#ownerType, #ownerId})
@TableIndex(name: 'attachments_sha', columns: {#sha256})
class Attachments extends Table {
  TextColumn get id => text()();

  TextColumn get ownerType => text()();

  TextColumn get ownerId => text()();

  TextColumn get fileName => text()();

  TextColumn get mime => text()();

  IntColumn get sizeBytes => integer()();

  /// Relative to the attachments directory — never absolute, because iOS
  /// rewrites the container path on some restores.
  TextColumn get relativePath => text()();

  TextColumn get sha256 => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
