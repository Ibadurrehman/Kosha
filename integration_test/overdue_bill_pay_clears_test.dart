import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kosha/app.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/shared/widgets/kosha_bottom_nav.dart';

import '../test/helpers/test_app.dart';

/// The tab label inside the bottom bar — several screens repeat the same word.
Finder _tab(String label) =>
    find.descendant(of: find.byType(KoshaBottomNav), matching: find.text(label));

/// A minimal settle after a real, on-device write: enough for the rebuild
/// (and the toast that follows it) to land, without the extra wall-clock cost
/// of a full `pumpAndSettle()` on real hardware.
Future<void> _settleAfterWrite(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

/// Phase 2's exit criterion from section 6.7, driven through the real screens:
/// an overdue bill shows up in Home's "Needs attention" and in the
/// notification inbox, and paying it clears both.
///
/// The bill itself is seeded through the repository rather than typed into the
/// New bill sheet — reaching a date in the past means driving a Material date
/// picker on real hardware, which tests the picker rather than anything this
/// flow is about. Everything after that is real UI: Home's row, the bill
/// detail screen, the payment sheet, and the inbox.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('an overdue bill reaches Home and the inbox, and paying clears both',
      (tester) async {
    final db = testDatabase();
    addTearDown(db.close);
    // Registered first so it still runs (draining drift's pending-timer quirk
    // on close) even if an expectation below throws.
    addTearDown(() => settleAndDispose(tester));
    await seedCompletedProfile(db);

    await testBillRepository(db).create(
      NewBill(
        name: 'Society maintenance',
        amountMinor: 240000,
        // Three days before `testNow`, so its 3-day reminder already fired
        // and launch-time reconciliation has an inbox row to write.
        nextDue: DateTime(2026, 9, 1),
        frequencyRule: 'FREQ=MONTHLY;BYMONTHDAY=1',
      ),
    );

    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    // Needs attention, with the "Pay" call to action bills bring. The name
    // alone is not enough to find by: Home's Recent section shows the same
    // bill, which is right — the subtitle is what only the attention row has.
    final attentionRow = find.ancestor(
      of: find.text('₹2,400 · Overdue by 3 days'),
      matching: find.byType(InkWell),
    );
    expect(
      attentionRow,
      findsWidgets,
      reason: 'an overdue bill belongs in Needs attention',
    );
    expect(find.text('Pay'), findsOneWidget);

    // The inbox learned about the reminder that fired while the app was shut.
    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();
    expect(find.text('Society maintenance'), findsOneWidget);
    expect(find.text('₹2,400 · due in 3 days'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Home → the bill → pay it.
    await tester.tap(find.text('₹2,400 · Overdue by 3 days'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Bill')),
      findsOneWidget,
      reason: 'the Needs attention row should open the bill itself',
    );

    await tester.tap(find.text('Pay now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark as paid'));
    await _settleAfterWrite(tester);

    // The cycle advanced, so the detail screen now reads as settled.
    expect(find.text('Paid 4 Sep'), findsOneWidget);

    // Back to Home: the attention row is gone, because it reads the bill's
    // own state rather than a copy of it.
    await tester.tap(_tab('Home'));
    await tester.pumpAndSettle();
    expect(
      find.text('₹2,400 · Overdue by 3 days'),
      findsNothing,
      reason: 'paying should clear the Needs attention row',
    );

    // And the inbox row is read — the reminder did fire, so the record stays,
    // but it is no longer something asking to be dealt with.
    expect(
      tester.widget<Badge>(find.byType(Badge)).isLabelVisible,
      isFalse,
      reason: 'paying should clear the unread badge the bill caused',
    );
  });
}
