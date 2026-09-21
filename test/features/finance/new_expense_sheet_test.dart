import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/finance/presentation/widgets/new_expense_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  Future<void> openSheet(WidgetTester tester) async {
    // The sheet (keypad + category + method chips + note field) is taller
    // than the default 600 px test viewport — same fix as the task editor.
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrapScreen(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showNewExpenseSheet(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
        db: db,
        now: testNow,
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('Save is disabled until an amount is entered', (tester) async {
    await openSheet(tester);

    final saveButton = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'));
    expect(saveButton.onPressed, isNull);

    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.text('0'));
    await tester.pump();

    final enabledSave =
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'));
    expect(enabledSave.onPressed, isNotNull);
    await settleAndDispose(tester);
  });

  testWidgets('typing an amount and saving creates a transaction with a toast',
      (tester) async {
    await openSheet(tester);

    for (final digit in ['1', '5', '0']) {
      await tester.tap(find.text(digit));
      await tester.pump();
    }
    await tester.tap(find.text('Groceries'));
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pump();

    expect(find.text('Expense of ₹150 added'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('switching to Income swaps in the income categories',
      (tester) async {
    await openSheet(tester);

    // Both sides of the toggle offer categories now that they are
    // user-editable; the seeded sets differ, which is what proves the swap.
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Salary'), findsNothing);

    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();

    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Groceries'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets(
      'fits on a small phone screen without overflowing (regression: caught live on a real device)',
      (tester) async {
    // A real Android emulator at its native size (~393x852 logical) overflowed
    // by 33px before SheetScaffold became scrollable — no widget test caught
    // it because they all forced a tall fake viewport instead. This one uses
    // a realistically small phone size on purpose.
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrapScreen(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showNewExpenseSheet(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
        db: db,
        now: testNow,
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('backspace removes the last digit', (tester) async {
    await openSheet(tester);

    await tester.tap(find.text('5'));
    await tester.pump();
    expect(find.text('₹5'), findsOneWidget);

    await tester.tap(find.byIcon(Symbols.backspace_rounded));
    await tester.pump();
    expect(find.text('₹0'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
