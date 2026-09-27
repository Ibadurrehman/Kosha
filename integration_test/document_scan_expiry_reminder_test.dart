import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kosha/core/services/files/document_capture.dart';
import 'package:kosha/core/services/files/file_service.dart';
import 'package:kosha/core/services/notifications/reminder_scheduler.dart';
import 'package:kosha/core/services/notifications/scheduled_reminder.dart';
import 'package:kosha/features/documents/presentation/documents_screen.dart';
import 'package:kosha/shared/widgets/kosha_fab.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../test/helpers/fake_document_capture.dart';
import '../test/helpers/test_app.dart';

/// Phase 3's exit criterion from section 12: **scan to PDF to expiry
/// reminder**, driven on a real device.
///
/// What is real here: `assemblePdf` runs the `pdf` package on the device,
/// `LocalFileService` writes into the app's own sandbox (no temp-directory
/// override), the document is created through the real repository, and
/// `LocalNotificationsReminderScheduler` hands the reminder to Android, which
/// this test then reads back out of the OS with `pendingNotificationRequests`.
///
/// What is faked, and why: the camera. `CunningDocumentScanner.getPictures()`
/// opens a native scanner activity that `tester.tap` cannot drive, so
/// [DocumentCapture] — the seam that exists for exactly this — hands back page
/// images rendered here instead. Everything downstream of the shutter is the
/// real thing. Pointing a device at a piece of paper stays a manual check.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // `bootstrap()` does this for the real app, and nothing here runs it: the
  // scheduler resolves the device's zone against this database before it hands
  // Android a fire time.
  setUpAll(tz.initializeTimeZones);

  testWidgets(
      'a scanned document is stored as a PDF and schedules its expiry reminder '
      'with the OS', (tester) async {
    final db = testDatabase();
    addTearDown(db.close);
    addTearDown(() => settleAndDispose(tester));

    // The app's clock is the device's, because the second half of this test
    // asks Android what it has scheduled: a reminder the OS considers past is
    // not pending, however the app's own clock reads. Every date below is
    // relative to this, so the test does not go stale on a fixed calendar.
    final now = DateTime.now();
    final expiresOn = DateTime(now.year, now.month, now.day + 120);

    final plugin = FlutterLocalNotificationsPlugin();
    final scheduler = _RealSchedulerWithoutPrompts(
      LocalNotificationsReminderScheduler(plugin),
    );

    // Two pages, so the result is a PDF the scanner could not have produced
    // by simply renaming a photo.
    late final Uint8List pdf;
    await tester.runAsync(() async {
      pdf = await assemblePdf([
        await _pageImage(const Color(0xFF1D4ED8)),
        await _pageImage(const Color(0xFF047857)),
      ]);
    });
    expect(
      String.fromCharCodes(pdf.take(5)),
      '%PDF-',
      reason: 'assemblePdf must produce a real PDF on the device, not an image',
    );

    await tester.pumpWidget(
      wrapPushedScreen(
        const DocumentsScreen(),
        db: db,
        now: now,
        scheduler: scheduler,
        capture: FakeDocumentCapture(scanToReturn: pdf),
      ),
    );
    await tester.pumpAndSettle();

    // Add document, then Scan.
    await tester.tap(find.byType(KoshaFab));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scan'));

    // The sheet writes the bytes into the sandbox before it shows the file
    // line, and a real file write does not finish inside the fake-async zone —
    // poll a condition rather than pumping a fixed delay.
    await _until(
      tester,
      () => find.textContaining('Scan.pdf').evaluate().isNotEmpty,
    );

    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Passport');
    await tester.pumpAndSettle();

    await _pickExpiry(tester, expiresOn);
    expect(
      find.text('Remind me'),
      findsOneWidget,
      reason: 'the reminder lead chips appear once there is an expiry date',
    );

    final save = find.widgetWithText(FilledButton, 'Save');
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await _until(tester, () => find.text('Passport').evaluate().isNotEmpty);

    // ---- The file: a PDF, in the sandbox, matching what was recorded ----
    final repository = testDocumentRepository(db, scheduler: scheduler);
    late final String documentId;
    late final PendingNotificationRequest reminder;

    await tester.runAsync(() async {
      final documents = await repository.watchAll().first;
      expect(documents, hasLength(1));
      final document = documents.single;
      documentId = document.id;
      expect(document.name, 'Passport');
      expect(document.expiresOn, expiresOn);
      expect(document.reminderOffsetDays, 30);

      final attachments = await repository.listAttachments(document.id);
      expect(attachments, hasLength(1), reason: 'the scan is attached to it');
      final attachment = attachments.single;
      expect(attachment.mime, 'application/pdf');
      expect(attachment.sizeBytes, pdf.length);

      final files = LocalFileService();
      final stored = await files.resolve(attachment.relativePath);
      addTearDown(() => files.delete(attachment.relativePath));
      expect(
        stored.existsSync(),
        isTrue,
        reason: 'the PDF has to land in the sandbox, not in a cache the OS may '
            'clear: ${stored.path}',
      );
      expect(
        await stored.readAsBytes(),
        pdf,
        reason: 'the bytes on disk are the assembled PDF, unaltered',
      );

      // ---- The reminder: registered with Android, not just with us ----
      final pending = await plugin.pendingNotificationRequests();
      final id = reminderNotificationId(ReminderKind.document, document.id);
      final match = pending.where((request) => request.id == id);
      expect(
        match,
        isNotEmpty,
        reason: 'Android should be holding the expiry reminder; it has '
            '${pending.map((r) => '${r.id}/${r.title}').toList()}',
      );
      reminder = match.first;
      addTearDown(() => scheduler.cancel(ReminderKind.document, document.id));
    });

    expect(reminder.title, 'Passport');
    expect(reminder.body, 'Expires in 30 days · Identity');
    expect(
      reminder.payload,
      '/documents/$documentId',
      reason: 'tapping the reminder has to open the document it is about',
    );
  });
}

/// Pumps until [ready], instead of waiting a fixed time for real file I/O.
///
/// Pumping is forbidden inside `runAsync`, so the two alternate; pending I/O
/// keeps progressing across the `runAsync` turns.
Future<void> _until(
  WidgetTester tester,
  bool Function() ready, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 5)),
    );
    await tester.pumpAndSettle();
    if (ready()) return;
  }
  fail('timed out waiting for the screen to catch up');
}

/// Sets "Expires on" through the real Material date picker, typing the date
/// rather than paging a calendar to it.
Future<void> _pickExpiry(WidgetTester tester, DateTime date) async {
  final row = find
      .ancestor(of: find.text('Expires on'), matching: find.byType(Row))
      .first;
  final set = find.descendant(of: row, matching: find.text('Set'));
  await tester.ensureVisible(set);
  await tester.pumpAndSettle();
  await tester.tap(set);
  await tester.pumpAndSettle();

  // No localisation delegates are installed, so the picker's input mode uses
  // DefaultMaterialLocalizations: mm/dd/yyyy.
  await tester.tap(find.byTooltip('Switch to input'));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byType(TextField).last,
    '${date.month.toString().padLeft(2, '0')}/'
    '${date.day.toString().padLeft(2, '0')}/${date.year}',
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

/// A page the scanner might have handed back: a plain PNG, drawn here so the
/// test needs no asset and no camera.
Future<Uint8List> _pageImage(Color color) async {
  const width = 600;
  const height = 800;
  const bounds = Rect.fromLTWH(0, 0, width * 1.0, height * 1.0);

  final recorder = ui.PictureRecorder();
  Canvas(recorder, bounds)
    ..drawRect(bounds, Paint()..color = const Color(0xFFFFFFFF))
    ..drawRect(bounds.deflate(60), Paint()..color = color);

  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  picture.dispose();
  image.dispose();
  return data!.buffer.asUint8List();
}

/// The real scheduler, minus the permission prompt.
///
/// `requestPermission()` puts a system dialog over the app that no integration
/// test can dismiss, and POST_NOTIFICATIONS governs *showing* a notification,
/// not scheduling one — which is what this test measures. Everything else is
/// delegated untouched.
class _RealSchedulerWithoutPrompts implements ReminderScheduler {
  _RealSchedulerWithoutPrompts(this._inner);

  final ReminderScheduler _inner;

  @override
  Future<void> schedule(ScheduledReminder reminder) =>
      _inner.schedule(reminder);

  @override
  Future<void> cancel(ReminderKind kind, String ownerId) =>
      _inner.cancel(kind, ownerId);

  @override
  Future<void> setExactAlarmsEnabled(bool enabled) =>
      _inner.setExactAlarmsEnabled(enabled);

  @override
  Stream<String> get notificationTaps => _inner.notificationTaps;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<bool> requestExactAlarmsPermission() async => true;
}
