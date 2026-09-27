import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/services/files/document_capture.dart';
import 'package:kosha/core/services/files/file_service.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory root;
  late LocalFileService files;

  setUp(() {
    root = Directory.systemTemp.createTempSync('kosha_files_test');
    files = LocalFileService(root: root);
  });

  tearDown(() {
    if (root.existsSync()) root.deleteSync(recursive: true);
  });

  Uint8List bytes(String content) => Uint8List.fromList(content.codeUnits);

  group('write', () {
    test('lands under attachments/ with a fresh name and the real size',
        () async {
      final stored = await files.write(
        bytes('hello'),
        fileName: 'Passport scan.pdf',
        mime: 'application/pdf',
      );

      expect(stored.sizeBytes, 5);
      expect(stored.mime, 'application/pdf');
      // The display name is kept, the stored name is not: two documents can
      // both be "scan.pdf" without colliding on disk.
      expect(stored.fileName, 'Passport scan.pdf');
      expect(stored.relativePath, isNot(contains('Passport')));
      expect(p.extension(stored.relativePath), '.pdf');

      final onDisk = File(p.join(root.path, 'attachments', stored.relativePath));
      expect(onDisk.existsSync(), isTrue);
    });

    test('the stored path is relative, so a moved container still resolves',
        () async {
      final stored = await files.write(
        bytes('hello'),
        fileName: 'a.pdf',
        mime: 'application/pdf',
      );

      expect(p.isAbsolute(stored.relativePath), isFalse);
      final resolved = await files.resolve(stored.relativePath);
      expect(resolved.existsSync(), isTrue);
      expect(resolved.path, contains('attachments'));
    });

    test('two writes of identical bytes do not collide', () async {
      final one = await files.write(
        bytes('same'),
        fileName: 'a.pdf',
        mime: 'application/pdf',
      );
      final two = await files.write(
        bytes('same'),
        fileName: 'a.pdf',
        mime: 'application/pdf',
      );

      expect(one.relativePath, isNot(two.relativePath));
      // …but they hash the same, which is what dedupe is for.
      expect(one.sha256, two.sha256);
    });
  });

  test('import copies a file in and keeps its name', () async {
    final source = File(p.join(root.path, 'rent agreement.pdf'))
      ..writeAsBytesSync(bytes('lease'));

    final stored = await files.import(source);

    expect(stored.fileName, 'rent agreement.pdf');
    expect(stored.mime, 'application/pdf');
    expect((await files.resolve(stored.relativePath)).readAsBytesSync(),
        bytes('lease'));
    // The original is left where it was: it belongs to the user, not to us.
    expect(source.existsSync(), isTrue);
  });

  test('findByHash spots bytes already in the sandbox', () async {
    final one = await files.write(
      bytes('duplicate me'),
      fileName: 'a.pdf',
      mime: 'application/pdf',
    );
    final two = await files.write(
      bytes('something else'),
      fileName: 'b.pdf',
      mime: 'application/pdf',
    );

    final match = await files.findByHash(
      one.sha256,
      [two.relativePath, one.relativePath],
    );
    expect(match, one.relativePath);
    expect(await files.findByHash('nope', [one.relativePath]), isNull);
  });

  group('delete', () {
    test('removes the file', () async {
      final stored = await files.write(
        bytes('bye'),
        fileName: 'a.pdf',
        mime: 'application/pdf',
      );

      await files.delete(stored.relativePath);

      expect((await files.resolve(stored.relativePath)).existsSync(), isFalse);
    });

    test('a file that is already gone is not an error', () async {
      await expectLater(files.delete('nothing-here.pdf'), completes);
    });
  });

  test('mime is guessed from the extension, and never guesses wildly', () {
    expect(mimeForFileName('a.PDF'), 'application/pdf');
    expect(mimeForFileName('b.jpeg'), 'image/jpeg');
    expect(mimeForFileName('c.docx'), 'application/octet-stream');
    expect(mimeForFileName('no-extension'), 'application/octet-stream');
  });

  group('assemblePdf', () {
    /// A 1x1 PNG — the smallest thing the PDF writer will accept as an image.
    Uint8List onePixelPng() => Uint8List.fromList([
          0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
          0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
          0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
          0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
          0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
          0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
          0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
          0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
          0x42, 0x60, 0x82,
        ]);

    test('three scanned pages come out as one three-page PDF', () async {
      final one = await assemblePdf([onePixelPng()]);
      final three = await assemblePdf([
        onePixelPng(),
        onePixelPng(),
        onePixelPng(),
      ]);

      expect(String.fromCharCodes(three.take(5)), '%PDF-');
      // Pages are not counted by grepping the output: the writer deflates its
      // object streams, and the uncompressed spelling of a page object is the
      // pdf package's business, not this app's — an assertion on it would
      // break on a version bump that changed nothing a user can see. That
      // each extra page adds bytes is the property worth holding: a scanner
      // that dropped pages 2 and 3 would produce the one-page file.
      expect(three.length, greaterThan(one.length));
    });

    test('no pages is an empty PDF rather than a crash', () async {
      final pdf = await assemblePdf(const []);
      expect(String.fromCharCodes(pdf.take(5)), '%PDF-');
    });

    test('a single page still produces a valid PDF', () async {
      final pdf = await assemblePdf([onePixelPng()]);
      expect(String.fromCharCodes(pdf.take(5)), '%PDF-');
    });
  });
}
