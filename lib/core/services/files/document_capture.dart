import 'dart:io';
import 'dart:typed_data';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// How a document's file gets into the app: the file picker, or the camera
/// scanner (section 6.8's Upload / Scan tiles).
///
/// Behind an interface because both halves are platform calls that a widget
/// test cannot make — the test double returns bytes, and every layer above
/// this one is exercised for real. It is also where the two packages that
/// touch the camera and the file system are named, so swapping either (R3's
/// "evaluate two plugins") is a change to one class.
abstract interface class DocumentCapture {
  /// The file the user picked, or null if they backed out.
  Future<File?> pickFile();

  /// Scanned pages assembled into a single PDF, or null if they backed out.
  ///
  /// Returns bytes rather than a file because nothing should land in the
  /// sandbox until [FileService] decides where — the scanner writes its page
  /// images to a cache directory the OS may clear at any time.
  Future<Uint8List?> scanToPdf();
}

class PlatformDocumentCapture implements DocumentCapture {
  const PlatformDocumentCapture();

  @override
  Future<File?> pickFile() async {
    // file_picker 12 replaced the `FilePicker.platform` instance API with
    // statics, and `pickFile` is the single-selection one.
    //
    // No `type`/`allowedExtensions` filter: restricting to a list would mean
    // maintaining one, and a user who keeps a .docx rent agreement is not
    // doing anything wrong.
    final picked = await FilePicker.pickFile();
    // Null on a cloud provider that hands back a non-file URI — nothing has
    // been copied into the sandbox, so there is no file to attach.
    final path = picked?.path;
    return path == null ? null : File(path);
  }

  @override
  Future<Uint8List?> scanToPdf() async {
    // The scanner asks for camera permission itself, which is why
    // permission_handler is still not a dependency (plan §9). If that ever
    // stops being true, this is the method that has to ask first.
    final pages = await CunningDocumentScanner.getPictures();
    if (pages == null || pages.isEmpty) return null;

    return assemblePdf([
      for (final path in pages) await File(path).readAsBytes(),
    ]);
  }
}

/// Lays out scanned page images one per A4 page and returns the PDF's bytes.
///
/// Pure, so multi-page scanning — the part of section 6.8 most likely to break
/// quietly — is tested without a camera.
Future<Uint8List> assemblePdf(List<Uint8List> pageImages) async {
  final pdf = pw.Document();
  for (final bytes in pageImages) {
    final image = pw.MemoryImage(bytes);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
      ),
    );
  }
  return pdf.save();
}

final documentCaptureProvider =
    Provider<DocumentCapture>((_) => const PlatformDocumentCapture());
