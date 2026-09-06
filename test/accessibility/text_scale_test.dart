import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/bills/domain/entities/bill.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/presentation/finance_screen.dart';
import 'package:kosha/features/home/presentation/home_screen.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';
import 'package:kosha/features/tasks/presentation/tasks_screen.dart';

import '../helpers/test_app.dart';

/// Section 7.6: "Support text scaling to 130 % without truncation on Home,
/// Tasks, Finance."
///
/// Nothing tested that before. The screens are pumped at a real small-phone
/// size rather than an inflated one, because an oversized viewport hides
/// exactly the overflow this is looking for — the same lesson §12.3 records
/// about `SheetScaffold`.
void main() {
  const phone = Size(393, 852);
  const scales = [1.0, 1.3];

  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  Future<void> seed() async {
    final tasks = testRepository(db);
    await tasks.create(
      NewTask(
        title: 'Pay the electricity bill before the late fee applies',
        dueDate: testToday,
        dueMinutes: 9 * 60,
        category: 'Home',
      ),
    );
    await tasks.create(
      NewTask(title: 'Buy groceries', dueDate: testToday, category: 'Shopping'),
    );
    await tasks.create(
      NewTask(
        title: 'Submit the rent receipt',
        dueDate: DateTime(2026, 9, 1),
        category: 'Home',
      ),
    );
    await tasks.create(
      NewTask(title: 'Renew vehicle insurance', dueDate: DateTime(2026, 9, 12)),
    );

    final transactions = testTransactionRepository(db);
    await transactions.create(
      NewTransaction(
        amountMinor: 245000,
        type: TransactionType.expense,
        date: testToday,
        category: 'Groceries',
        label: 'Big Bazaar weekly shop',
        method: TransactionMethod.upi,
      ),
    );
    await transactions.create(
      NewTransaction(
        amountMinor: 8500000,
        type: TransactionType.income,
        date: testToday,
        label: 'September salary',
      ),
    );

    await testBillRepository(db).create(
      NewBill(
        name: 'Society maintenance and sinking fund',
        amountMinor: 240000,
        nextDue: DateTime(2026, 9, 1),
        frequencyRule: 'FREQ=MONTHLY',
      ),
    );
  }

  Future<void> pumpAt(
    WidgetTester tester,
    Widget screen,
    double scale,
  ) async {
    tester.view.physicalSize = phone;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrapScreen(
        MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: screen,
        ),
        db: db,
        now: testNow,
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final scale in scales) {
    final label = '${(scale * 100).round()}%';

    testWidgets('Home lays out at $label on a 393x852 phone', (tester) async {
      await seed();
      await pumpAt(tester, const HomeScreen(), scale);

      expect(
        tester.takeException(),
        isNull,
        reason: 'Home overflowed at a $label text scale',
      );
      await settleAndDispose(tester);
    });

    testWidgets('Tasks lays out at $label on a 393x852 phone', (tester) async {
      await seed();
      await pumpAt(tester, const TasksScreen(), scale);

      expect(
        tester.takeException(),
        isNull,
        reason: 'Tasks overflowed at a $label text scale',
      );
      await settleAndDispose(tester);
    });

    testWidgets('Finance lays out at $label on a 393x852 phone', (tester) async {
      await seed();
      await pumpAt(tester, const FinanceScreen(), scale);

      expect(
        tester.takeException(),
        isNull,
        reason: 'Finance overflowed at a $label text scale',
      );
      await settleAndDispose(tester);
    });
  }
}
