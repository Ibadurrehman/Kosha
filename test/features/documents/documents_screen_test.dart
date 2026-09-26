import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/files/file_service.dart';
import 'package:kosha/features/documents/domain/entities/attachment.dart';
import 'package:kosha/features/documents/domain/entities/document.dart';
import 'package:kosha/features/documents/presentation/document_archive_screen.dart';
import 'package:kosha/features/documents/presentation/documents_screen.dart';
import 'package:kosha/features/documents/presentation/widgets/document_tile.dart';

import '../../helpers/fake_document_capture.dart';
import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late Directory sandbox;
  late FakeDocumentCapture capture;
  late LocalFileService files;

  setUp(() {
    db = testDatabase();
    sandbox = Directory.systemTemp.createTempSync('kosha_docs_screen');
    capture = FakeDocumentCapture();
    files = LocalFileService(root: sandbox);
  });

  tearDown(() {
    db.close();
    if (sandbox.existsSync()) sandbox.deleteSync(recursive: true);
  });

  Future<Document> seed({
    String name = 'Passport',
    DocumentCategory category = DocumentCategory.identity,
    DateTime? expiresOn,
  }) =>
      testDocumentRepository(db).create(
        NewDocument(
          name: name,
          category: category,
          number: 'P4471882',
          expiresOn: expiresOn,
        ),
      );

  Future<void> pumpList(WidgetTester tester) async {
    await tester.pumpWidget(
      wrapPushedScreen(
        const DocumentsScreen(),
        db: db,
        capture: capture,
        files: files,
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Taps the Add sheet's Save. The sheet is taller than the 800x600 test
  /// surface — Save sits at y=780 on a first run — so it is scrolled to
  /// first, which is what a user on a small phone does too.
  Future<void> tapSave(WidgetTester tester) async {
    final save = find.widgetWithText(FilledButton, 'Save');
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
  }

  /// Runs [action] with the test's fake clock stood down, so real file I/O
  /// completes. FileService writes actual bytes to a temp directory, and
  /// nothing inside the fake-async zone ever finishes those futures — drift's
  /// in-memory database needs no such help, which is why only the capture
  /// paths use this.
  /// Runs [action] outside the fake-async zone — `FileService` does real
  /// `dart:io` work, which never completes inside it — then pumps until
  /// [until] is true.
  ///
  /// A fixed delay used to stand in for [until]. Alone that was enough; under
  /// a full `flutter test` it was not, roughly three runs in five, and the
  /// half-finished `writeAsBytes` then held its handle open so `tearDown`'s
  /// sandbox delete failed with Windows errno 32 — which is the only error
  /// the run summary showed. Pumping is forbidden inside `runAsync`, so the
  /// two alternate here; pending I/O keeps progressing across the turns.
  Future<void> withRealIo(
    WidgetTester tester,
    Future<void> Function() action, {
    required bool Function() until,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.runAsync(action);
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      await tester.pumpAndSettle();
      if (until()) return;
    }
    fail('the file handler never finished');
  }

  group('the list', () {
    testWidgets('shows a tile per document with its expiry pill',
        (tester) async {
      await seed(expiresOn: DateTime(2026, 9, 19));

      await pumpList(tester);

      expect(find.byType(DocumentTile), findsOneWidget);
      expect(find.text('Passport'), findsOneWidget);
      expect(find.text('P4471882'), findsOneWidget);
      // 4 Sep to 19 Sep.
      expect(find.text('15 days'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('a document with no expiry says so rather than showing a date',
        (tester) async {
      await seed(name: 'Degree certificate');

      await pumpList(tester);

      expect(find.text('No expiry'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('an expired document reads as expired', (tester) async {
      await seed(expiresOn: DateTime(2026, 8, 1));

      await pumpList(tester);

      expect(find.text('Expired'), findsOneWidget);
      expect(find.text('1 document needs attention'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('chips carry their counts and filter the grid', (tester) async {
      await seed();
      await seed(name: 'Insurance', category: DocumentCategory.insurance);

      await pumpList(tester);
      expect(find.byType(DocumentTile), findsNWidgets(2));
      expect(find.text('Identity 1'), findsOneWidget);

      await tester.tap(find.text('Identity 1'));
      await tester.pumpAndSettle();

      expect(find.byType(DocumentTile), findsOneWidget);
      expect(find.text('Passport'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('tapping the selected chip again clears the filter',
        (tester) async {
      await seed();
      await seed(name: 'Insurance', category: DocumentCategory.insurance);

      await pumpList(tester);
      await tester.tap(find.text('Identity 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Identity 1'));
      await tester.pumpAndSettle();

      expect(find.byType(DocumentTile), findsNWidgets(2));
      await settleAndDispose(tester);
    });

    testWidgets('an empty category says so about that category', (tester) async {
      await seed();

      await pumpList(tester);
      // Financial rather than Medical: the later chips start off-screen in
      // the horizontal row, and which chip is tapped is not what this test is
      // about.
      await tester.tap(find.text('Financial'));
      await tester.pumpAndSettle();

      expect(find.text('Nothing under Financial'), findsOneWidget);
      await tester.tap(find.text('Show all documents'));
      await tester.pumpAndSettle();
      expect(find.byType(DocumentTile), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('with nothing at all it invites a first document',
        (tester) async {
      await pumpList(tester);

      expect(find.text('No documents yet'), findsOneWidget);
      expect(find.text('Add a document'), findsOneWidget);
      await settleAndDispose(tester);
    });
  });

  group('the add sheet', () {
    testWidgets('saves a document and it appears in the grid', (tester) async {
      await pumpList(tester);

      await tester.tap(find.text('Add a document'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Rent agreement');
      await tester.pumpAndSettle();
      await tapSave(tester);

      expect(find.byType(DocumentTile), findsOneWidget);
      expect(find.text('Added “Rent agreement”'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('Save is disabled until the document has a name',
        (tester) async {
      await pumpList(tester);
      await tester.tap(find.text('Add a document'));
      await tester.pumpAndSettle();

      final save = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Save'),
      );
      expect(save.onPressed, isNull);
      await settleAndDispose(tester);
    });

    testWidgets('the reminder lead only appears once there is an expiry',
        (tester) async {
      await pumpList(tester);
      await tester.tap(find.text('Add a document'));
      await tester.pumpAndSettle();

      expect(find.text('Remind me'), findsNothing);

      await tester.tap(find.widgetWithText(TextButton, 'Set').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Remind me'), findsOneWidget);
      expect(find.text('30 days before'), findsOneWidget);
      expect(
        find.text('It will also appear under Needs attention on Home.'),
        findsOneWidget,
      );
      await settleAndDispose(tester);
    });

    testWidgets('an uploaded file is attached and names the document',
        (tester) async {
      final source = File('${sandbox.path}/Rent agreement.pdf')
        ..writeAsBytesSync([1, 2, 3]);
      capture.fileToReturn = source;

      await pumpList(tester);
      await tester.tap(find.text('Add a document'));
      await tester.pumpAndSettle();

      await withRealIo(
        tester,
        () => tester.tap(find.text('Upload')),
        until: () =>
            find.textContaining('Rent agreement.pdf').evaluate().isNotEmpty,
      );

      expect(capture.pickCalls, 1);
      expect(find.textContaining('Rent agreement.pdf'), findsOneWidget);
      // The file's name fills the empty name field, so a user who uploads and
      // saves immediately still gets something readable.
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        'Rent agreement',
      );

      await tapSave(tester);

      // Read back through runAsync: drift emits a stream's first value on a
      // zero-duration timer, and inside the widget tester's fake-async zone
      // that timer only fires on a pump — so awaiting `.first` directly here
      // waits for a clock that is not running.
      late List<Attachment> attachments;
      await tester.runAsync(() async {
        final repository = testDocumentRepository(db);
        final stored = await repository.watchAll().first;
        attachments = await repository.listAttachments(stored.single.id);
      });
      expect(attachments.single.fileName, 'Rent agreement.pdf');
      await settleAndDispose(tester);
    });

    testWidgets('backing out of the picker attaches nothing', (tester) async {
      await pumpList(tester);
      await tester.tap(find.text('Add a document'));
      await tester.pumpAndSettle();

      // Nothing appears on screen to wait for, so wait on the picker having
      // been asked and come back empty-handed: the assertion below is only
      // meaningful once that has happened.
      await withRealIo(
        tester,
        () => tester.tap(find.text('Upload')),
        until: () => capture.pickCalls == 1,
      );

      expect(find.text('Remove'), findsNothing);
      await settleAndDispose(tester);
    });
  });

  group('the archive', () {
    testWidgets('lists archived documents and restores one', (tester) async {
      final document = await seed();
      await testDocumentRepository(db).archive(document.id);

      await tester.pumpWidget(
        wrapPushedScreen(const DocumentArchiveScreen(), db: db, files: files),
      );
      await tester.pumpAndSettle();

      expect(find.text('Passport'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Restore'));
      await tester.pumpAndSettle();

      expect(find.text('Nothing archived'), findsOneWidget);
      expect(find.text('Restored “Passport”'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('an empty archive says so', (tester) async {
      await tester.pumpWidget(
        wrapPushedScreen(const DocumentArchiveScreen(), db: db, files: files),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nothing archived'), findsOneWidget);
      await settleAndDispose(tester);
    });
  });
}
