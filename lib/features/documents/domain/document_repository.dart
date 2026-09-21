import 'entities/attachment.dart';
import 'entities/document.dart';

/// Reads and writes documents and the files attached to them.
///
/// "Live" throughout means not archived. Archiving is the only removal a
/// document has (section 6.8), and the Archive list is a screen of its own —
/// see the table's doc comment.
abstract interface class DocumentRepository {
  /// Every live document, newest first; [category] narrows to one chip.
  Stream<List<Document>> watchAll({DocumentCategory? category});

  Stream<List<Document>> watchArchived();

  Stream<Document?> watchById(String id);

  Future<Document?> findById(String id);

  /// Documents expiring inside a window — Home's Upcoming timeline and the
  /// Calendar both ask this way.
  Stream<List<Document>> watchExpiringBetween(DateTime from, DateTime to);

  /// Expired or expiring-within-their-own-offset documents, most urgent
  /// first — Home's Needs attention (§5.2).
  ///
  /// The offset is per document, so this cannot be a single date-range query:
  /// a passport reminding 30 days out and an insurance policy reminding 7 days
  /// out are both "expiring" on different days.
  Stream<List<Document>> watchNeedingAttention({required DateTime today});

  /// Documents filed under one space, newest first.
  Stream<List<Document>> watchInSpace(String spaceId, {required int limit});

  Stream<List<Document>> watchRecent({required int limit});

  Future<Document> create(NewDocument draft);

  /// Applies an edit and re-syncs the document's reminder. Every argument is
  /// optional; omitting one leaves that field alone.
  ///
  /// Nullable fields that the user can *clear* take a sentinel rather than
  /// null-means-unchanged: [clearExpiry] and [clearNumber] say so explicitly,
  /// because "remove the expiry date" is a real edit and null cannot mean both
  /// things at once.
  Future<Document> edit(
    String id, {
    String? name,
    DocumentCategory? category,
    String? number,
    bool clearNumber = false,
    DateTime? issuedOn,
    DateTime? expiresOn,
    bool clearExpiry = false,
    int? reminderOffsetDays,
    String? notes,
    String? spaceId,
  });

  /// Hides the document and cancels its reminder. The file stays on disk —
  /// an archived document is still openable from the Archive list.
  Future<void> archive(String id);

  Future<void> restore(String id);

  /// The files attached to a document, oldest first.
  Stream<List<Attachment>> watchAttachments(String documentId);

  Future<List<Attachment>> listAttachments(String documentId);

  /// Records a file that [FileService] has already written into the sandbox.
  Future<Attachment> addAttachment(String documentId, Attachment attachment);

  /// Swaps the document's file for a new one, keeping the old row's details in
  /// the activity history — section 6.8's "replacing a file keeps history in
  /// ActivityLog". Returns the attachment that was replaced, so the caller can
  /// delete its bytes once the write has succeeded.
  Future<Attachment?> replaceAttachment(
    String documentId,
    Attachment replacement,
  );

  /// How many live documents carry each category, for the chip counts.
  Stream<Map<DocumentCategory, int>> watchCategoryCounts();
}
