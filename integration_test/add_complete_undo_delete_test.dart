import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kosha/app.dart';
import 'package:kosha/shared/widgets/kosha_bottom_nav.dart';

import '../test/helpers/test_app.dart';

/// The tab label inside the bottom bar — several screens repeat the same
/// word (Home's Quick access has a "Tasks" tile too).
Finder _tab(String label) =>
    find.descendant(of: find.byType(KoshaBottomNav), matching: find.text(label));

/// A minimal settle after a real, on-device write: enough for the resulting
/// rebuild (and the toast that follows it) to land, without the extra real
/// wall-clock time a full `pumpAndSettle()` costs on a real device/emulator —
/// every action below leads to a toast that disappears after 3.4 s
/// (`ToastController.visibleFor`), and the very next step here taps that
/// toast's Undo button, so the budget matters.
Future<void> _settleAfterWrite(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

/// The one end-to-end flow section 12.1 names as Phase 1's exit criterion:
/// add a task, complete it, undo that, then delete it for good — driven
/// through the real Tasks screen, New task sheet, task row and actions
/// sheet, not through the repository directly.
///
/// State (does the row exist? is it gone?) is asserted throughout; the exact
/// toast wording is not re-asserted here — it already has precise coverage
/// in tasks_screen_test.dart's fake-clock widget tests, and re-checking it on
/// real hardware only adds a real 3.4 s race this flow doesn't need to run.
///
/// Uses the same in-memory database and Noop reminder scheduler every other
/// test in this repo uses (see `test/helpers/test_app.dart`), so this runs
/// on a real device/emulator via `flutter test integration_test/…` — see the
/// project plan's note that CI's `check` job has no emulator step configured
/// yet, so this is a local/physical-device gate for now.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add a task, complete it, undo, then delete it for good',
      (tester) async {
    final db = testDatabase();
    addTearDown(db.close);
    // Registered first so it still runs (and drains drift's pending-timer
    // quirk on close) even if an expectation below throws.
    addTearDown(() => settleAndDispose(tester));
    await seedCompletedProfile(db);

    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    // Home → Tasks.
    await tester.tap(_tab('Tasks'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Tasks')),
        findsOneWidget, reason: 'should have landed on the Tasks screen');

    // Add: FAB → New task sheet → title → Create.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Buy groceries');
    await tester.pump();
    await tester.tap(find.text('Create task'));
    await tester.pumpAndSettle();

    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Tasks')),
        findsOneWidget, reason: 'creating should return to the Tasks screen');
    expect(find.text('Buy groceries'), findsOneWidget);
    expect(find.byKey(const Key('task-checkbox')), findsOneWidget);

    // Complete: tap the row's checkbox, then Undo from the toast it opens.
    await tester.tap(find.byKey(const Key('task-checkbox')));
    await _settleAfterWrite(tester);
    expect(find.text('Undo'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await _settleAfterWrite(tester);

    // Still there and open (not completed) after the undo.
    expect(find.text('Buy groceries'), findsOneWidget);

    // Delete: "•••" → Delete → confirm.
    await tester.tap(find.byKey(const Key('task-actions')));
    await _settleAfterWrite(tester);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await _settleAfterWrite(tester);

    expect(find.text('Buy groceries'), findsNothing);
  });
}
