import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/files/document_capture.dart';
import '../../../core/services/files/file_service.dart';
import '../../../core/utils/clock.dart';
import '../../../shared/state/toast_controller.dart';
import '../data/document_repository_impl.dart';
import '../domain/entities/attachment.dart';

/// How a file was chosen.
enum CaptureSource { upload, scan }

/// Runs the picker or the scanner, writes whatever comes back into the app
/// sandbox, and returns an [Attachment] ready to record — or null if the user
/// backed out.
///
/// The three steps live together because they are one decision to the user
/// ("put this file in"), and because the ordering matters: nothing reaches the
/// database until the bytes are safely in the sandbox.
Future<Attachment?> captureAttachment(
  WidgetRef ref, {
  required CaptureSource source,
  required String documentId,
  required String fallbackName,
}) async {
  final capture = ref.read(documentCaptureProvider);
  final files = ref.read(fileServiceProvider);
  final now = ref.read(clockProvider).now();

  final stored = switch (source) {
    CaptureSource.upload => await () async {
        final picked = await capture.pickFile();
        return picked == null ? null : await files.import(picked);
      }(),
    CaptureSource.scan => await () async {
        final pdf = await capture.scanToPdf();
        return pdf == null
            ? null
            : await files.write(
                pdf,
                fileName: '$fallbackName.pdf',
                mime: 'application/pdf',
              );
      }(),
  };
  if (stored == null) return null;

  return Attachment(
    id: const Uuid().v4(),
    ownerType: documentOwnerType,
    ownerId: documentId,
    fileName: stored.fileName,
    mime: stored.mime,
    sizeBytes: stored.sizeBytes,
    relativePath: stored.relativePath,
    sha256: stored.sha256,
    createdAt: now,
  );
}

/// Opens an attachment in the system viewer (§8.4: `open_filex` in v1).
Future<void> openAttachment(WidgetRef ref, Attachment attachment) async {
  final file = await ref.read(fileServiceProvider).resolve(
        attachment.relativePath,
      );
  final toast = ref.read(toastControllerProvider.notifier);

  // A file can be missing for reasons outside the app: a restore that brought
  // the database back without the sandbox, or a user clearing app storage.
  // Saying so beats a silent no-op on a tapped button.
  if (!file.existsSync()) {
    toast.show("That file isn't on this device any more");
    return;
  }

  final result = await OpenFilex.open(file.path);
  if (result.type != ResultType.done) {
    toast.show('No app on this device can open ${attachment.fileName}');
  }
}

/// Hands an attachment to the system share sheet (section 6.8's share action).
Future<void> shareAttachment(
  WidgetRef ref,
  Attachment attachment, {
  required String subject,
}) async {
  final file = await ref.read(fileServiceProvider).resolve(
        attachment.relativePath,
      );
  if (!file.existsSync()) {
    ref
        .read(toastControllerProvider.notifier)
        .show("That file isn't on this device any more");
    return;
  }

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, mimeType: attachment.mime)],
      subject: subject,
    ),
  );
}

/// Replaces a document's file: the new bytes are recorded first, and only once
/// that has succeeded are the old ones deleted.
///
/// If deletion fails the user still has a working document — an orphaned file
/// costs disk, a missing one costs the document.
Future<void> replaceAttachment(
  WidgetRef ref, {
  required String documentId,
  required Attachment replacement,
}) async {
  final repository = ref.read(documentRepositoryProvider);
  final files = ref.read(fileServiceProvider);

  final previous = await repository.replaceAttachment(documentId, replacement);
  if (previous != null) {
    await files.delete(previous.relativePath);
  }
}

/// True when the sandbox still has the bytes an attachment names.
Future<bool> attachmentExists(WidgetRef ref, Attachment attachment) async {
  final File file = await ref.read(fileServiceProvider).resolve(
        attachment.relativePath,
      );
  return file.existsSync();
}
