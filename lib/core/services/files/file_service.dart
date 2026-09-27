import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// A file that has been written into the app sandbox.
class StoredFile {
  const StoredFile({
    required this.relativePath,
    required this.fileName,
    required this.mime,
    required this.sizeBytes,
    required this.sha256,
  });

  /// Relative to the attachments directory — what the database stores.
  final String relativePath;

  /// The name to show and to share the file under.
  final String fileName;
  final String mime;
  final int sizeBytes;
  final String sha256;
}

/// Writes attachments into `<appDocuments>/attachments/` and reads them back
/// (section 8.4).
///
/// Paths are stored relative and resolved on every read, because iOS rewrites
/// an app's container path on some updates and restores: an absolute path
/// saved today can name nothing tomorrow, while the file itself is still
/// there.
///
/// Nothing here knows about documents. It moves bytes and reports where they
/// landed; `DocumentRepository` records that. Phase 6 encrypts this directory
/// (ADR 0002), which is why every write goes through one method.
abstract interface class FileService {
  /// Copies [source] into the sandbox under a fresh name.
  Future<StoredFile> import(File source, {String? fileName});

  /// Writes [bytes] into the sandbox — what the scanner's assembled PDF uses.
  Future<StoredFile> write(
    Uint8List bytes, {
    required String fileName,
    required String mime,
  });

  /// The absolute file for a stored relative path, resolved now.
  Future<File> resolve(String relativePath);

  /// Removes a stored file. Missing is not an error: the point of calling this
  /// is that the file should not be there afterwards.
  Future<void> delete(String relativePath);

  /// The stored file whose bytes hash to [sha256], if one is already here —
  /// the dedupe §8.4 asks for.
  Future<String?> findByHash(String sha256, List<String> knownPaths);
}

class LocalFileService implements FileService {
  LocalFileService({Directory? root}) : _rootOverride = root;

  static const Uuid _uuid = Uuid();
  static const String _directoryName = 'attachments';

  final Directory? _rootOverride;
  Directory? _cached;

  @override
  Future<StoredFile> import(File source, {String? fileName}) async {
    final bytes = await source.readAsBytes();
    final name = fileName ?? p.basename(source.path);
    return write(bytes, fileName: name, mime: mimeForFileName(name));
  }

  @override
  Future<StoredFile> write(
    Uint8List bytes, {
    required String fileName,
    required String mime,
  }) async {
    final directory = await _directory();
    final extension = p.extension(fileName);
    final relativePath = '${_uuid.v4()}$extension';
    final file = File(p.join(directory.path, relativePath));
    await file.writeAsBytes(bytes, flush: true);

    return StoredFile(
      relativePath: relativePath,
      fileName: fileName,
      mime: mime,
      sizeBytes: bytes.length,
      sha256: sha256.convert(bytes).toString(),
    );
  }

  @override
  Future<File> resolve(String relativePath) async {
    final directory = await _directory();
    return File(p.join(directory.path, relativePath));
  }

  @override
  Future<void> delete(String relativePath) async {
    final file = await resolve(relativePath);
    if (file.existsSync()) await file.delete();
  }

  @override
  Future<String?> findByHash(String hash, List<String> knownPaths) async {
    for (final path in knownPaths) {
      final file = await resolve(path);
      if (!file.existsSync()) continue;
      final bytes = await file.readAsBytes();
      if (sha256.convert(bytes).toString() == hash) return path;
    }
    return null;
  }

  Future<Directory> _directory() async {
    final cached = _cached;
    if (cached != null) return cached;

    final root = _rootOverride ?? await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(root.path, _directoryName));
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    return _cached = directory;
  }
}

/// Best-effort media type from a file name.
///
/// Only the types this app can actually produce or show are listed; anything
/// else is `application/octet-stream`, which the system viewer still opens by
/// extension. A full mime database would be a dependency for one line of UI
/// copy.
String mimeForFileName(String fileName) =>
    switch (p.extension(fileName).toLowerCase()) {
      '.pdf' => 'application/pdf',
      '.png' => 'image/png',
      '.jpg' || '.jpeg' => 'image/jpeg',
      '.heic' => 'image/heic',
      '.webp' => 'image/webp',
      '.txt' => 'text/plain',
      _ => 'application/octet-stream',
    };

final fileServiceProvider = Provider<FileService>((_) => LocalFileService());
