import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment.freezed.dart';

/// Owner type stored on every document attachment, so the same table can carry
/// a vehicle's service invoices and an appliance's warranty later — the shape
/// `ActivityEntries` already uses.
const String documentOwnerType = 'document';

/// A file inside the app sandbox, pointed at by a record.
///
/// The database stores a path *relative* to the attachments directory, never
/// an absolute one: iOS rewrites an app's container path on some updates and
/// restores, so an absolute path saved today can name nothing tomorrow.
/// [FileService] resolves it against the current directory on every read.
@freezed
abstract class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String ownerType,
    required String ownerId,

    /// What to call the file in the UI and in a share sheet — the name the
    /// user's file had, or one built for a scan ("Passport scan.pdf").
    required String fileName,
    required String mime,
    required int sizeBytes,

    /// Relative to the attachments directory, e.g. `a1b2c3.pdf`.
    required String relativePath,
    required DateTime createdAt,

    /// Hex sha256 of the bytes, for the dedupe §8.4 asks for. Null for a file
    /// written before hashing, never for one this app wrote.
    String? sha256,
  }) = _Attachment;

  const Attachment._();

  bool get isPdf => mime == 'application/pdf';

  bool get isImage => mime.startsWith('image/');

  /// `1.4 MB` — what the detail screen's preview strip puts under a file.
  String get readableSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
