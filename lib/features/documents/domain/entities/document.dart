import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.freezed.dart';

/// The eight category chips the Documents screen filters by (Appendix A).
/// Persisted by index — append only.
enum DocumentCategory {
  identity('Identity'),
  financial('Financial'),
  insurance('Insurance'),
  vehicle('Vehicle'),
  education('Education'),
  property('Property'),
  medical('Medical'),
  other('Other');

  const DocumentCategory(this.label);

  final String label;
}

/// Where a document stands right now. Never stored — see [documentStatus].
enum DocumentStatus { valid, expiring, expired, noExpiry }

/// How many days before an expiry a document reminds by default (§5.1, and
/// the glossary's "documents 30 days").
const int defaultDocumentReminderDays = 30;

/// A document the user keeps: the record, not the file. Files are
/// [Attachment] rows pointing into the app sandbox.
@freezed
abstract class Document with _$Document {
  const factory Document({
    required String id,
    required String name,
    required DocumentCategory category,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Passport number, policy number, account reference — whatever
    /// identifies this document to the body that issued it.
    String? number,
    DateTime? issuedOn,

    /// Local midnight of the day it stops being valid, or null for something
    /// that never expires (a degree certificate, a birth certificate).
    DateTime? expiresOn,
    @Default(defaultDocumentReminderDays) int reminderOffsetDays,
    String? notes,
    String? spaceId,

    /// When the user archived it. Archiving is the only removal a document
    /// has — section 6.8's actions are View file / Replace / Set reminder /
    /// Archive, with no delete — so this table has no `deletedAt`, for the
    /// reason ADR 0008 gives for Spaces.
    DateTime? archivedAt,
  }) = _Document;

  const Document._();

  bool get isArchived => archivedAt != null;

  bool get expires => expiresOn != null;
}

/// Fields a caller supplies to create a document; the repository fills in the
/// id and timestamps.
class NewDocument {
  const NewDocument({
    required this.name,
    required this.category,
    this.number,
    this.issuedOn,
    this.expiresOn,
    this.reminderOffsetDays = defaultDocumentReminderDays,
    this.notes,
    this.spaceId,
  });

  final String name;
  final DocumentCategory category;
  final String? number;
  final DateTime? issuedOn;
  final DateTime? expiresOn;
  final int reminderOffsetDays;
  final String? notes;
  final String? spaceId;
}

/// Section 5.2's document status, derived and never stored.
///
/// A document with no expiry date is [DocumentStatus.noExpiry] rather than
/// [DocumentStatus.valid]: both are fine states to be in, but only one of them
/// can ever change, and the detail screen's pill says different things about
/// them ("No expiry" against "Expires in 12 days"). §5.2 groups the two under
/// "Valid" because neither needs attention — [needsAttention] is where that
/// grouping actually matters.
///
/// The expiry day itself is *not* expired: a passport valid until 19 September
/// is valid on the 19th.
DocumentStatus documentStatus(Document document, DateTime today) {
  final expires = document.expiresOn;
  if (expires == null) return DocumentStatus.noExpiry;
  if (expires.isBefore(today)) return DocumentStatus.expired;
  final window = DateTime(
    today.year,
    today.month,
    today.day + document.reminderOffsetDays,
  );
  return expires.isAfter(window)
      ? DocumentStatus.valid
      : DocumentStatus.expiring;
}

/// Whether a document belongs in Home's "Needs attention" (§5.2 lists
/// "expiring/expired documents").
bool needsAttention(DocumentStatus status) =>
    status == DocumentStatus.expired || status == DocumentStatus.expiring;

/// Whole days from [today] until the document expires: negative once it has,
/// null when it never will.
int? daysUntilExpiry(Document document, DateTime today) {
  final expires = document.expiresOn;
  if (expires == null) return null;
  return DateTime(expires.year, expires.month, expires.day)
      .difference(DateTime(today.year, today.month, today.day))
      .inDays;
}
