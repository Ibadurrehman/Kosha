import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/finance/data/transaction_category_repository_impl.dart';
import 'package:kosha/features/finance/data/transaction_repository_impl.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/domain/entities/transaction_category.dart';
import 'package:kosha/features/finance/presentation/category_manager_screen.dart';
import 'package:kosha/shared/widgets/kosha_fab.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftTransactionCategoryRepository repository;
  late DriftTransactionRepository transactions;

  setUp(() {
    db = testDatabase();
    repository = testCategoryRepository(db);
    transactions = testTransactionRepository(db);
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrapScreen(const CategoryManagerScreen(), db: db, now: testNow),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists the seeded expense categories in order', (tester) async {
    await pump(tester);

    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Entertainment'), findsOneWidget);
    // Income lives behind its own tab.
    expect(find.text('Salary'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('the Income tab shows the income set', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();

    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Groceries'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('adding a category appends it and toasts', (tester) async {
    await pump(tester);

    await tester.tap(find.byType(KoshaFab));
    await tester.pumpAndSettle();
    expect(find.text('New category'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Travel');
    await tester.pump();
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Added “Travel”'), findsOneWidget);
    final categories = await repository.listByKind(CategoryKind.expense);
    expect(categories.last.name, 'Travel');
    await settleAndDispose(tester);
  });

  testWidgets('renaming says how many transactions moved with it',
      (tester) async {
    await transactions.create(
      NewTransaction(
        amountMinor: 45000,
        type: TransactionType.expense,
        date: testToday,
        category: 'Groceries',
      ),
    );

    await pump(tester);

    await tester.tap(find.text('Groceries'));
    await tester.pumpAndSettle();
    expect(find.text('Edit category'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Supermarket');
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('Renamed to “Supermarket” · 1 transaction updated'),
      findsOneWidget,
    );
    await settleAndDispose(tester);
  });

  testWidgets('removing warns about the transactions that keep the name',
      (tester) async {
    await transactions.create(
      NewTransaction(
        amountMinor: 45000,
        type: TransactionType.expense,
        date: testToday,
        category: 'Groceries',
      ),
    );

    await pump(tester);

    await tester.tap(find.byTooltip('Remove').first);
    await tester.pumpAndSettle();

    expect(find.text('Remove “Groceries”?'), findsOneWidget);
    expect(find.textContaining('1 transaction already'), findsOneWidget);

    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Removed “Groceries”'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);
    final remaining = await repository.listByKind(CategoryKind.expense);
    expect(remaining.map((c) => c.name), isNot(contains('Groceries')));
    await settleAndDispose(tester);
  });

  testWidgets('an unused category is removed without the extra warning',
      (tester) async {
    await pump(tester);

    await tester.tap(find.byTooltip('Remove').first);
    await tester.pumpAndSettle();

    expect(
      find.text('It will stop being offered when you log money.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    await settleAndDispose(tester);
  });
}
