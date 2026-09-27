import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/documents/domain/entities/document.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/finance/presentation/widgets/new_expense_sheet.dart';
import 'package:kosha/features/spaces/domain/entities/space.dart';
import 'package:kosha/features/spaces/presentation/space_detail_screen.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  Future<Space> seedStudio({
    Set<SpaceHolds> holds = const {SpaceHolds.tasks, SpaceHolds.expenses},
  }) =>
      testSpaceRepository(db).create(NewSpace(name: 'Studio', holds: holds));

  Future<void> pumpDetail(WidgetTester tester, String id) async {
    await tester.pumpWidget(
      wrapPushedScreen(SpaceDetailScreen(spaceId: id), db: db),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the header names the space and what it holds', (tester) async {
    final space = await seedStudio();

    await pumpDetail(tester, space.id);

    expect(find.text('Studio'), findsWidgets);
    expect(find.text('Tasks and Expenses'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('sections pull the items filed under the space', (tester) async {
    final space = await seedStudio();
    await testRepository(db).create(
      NewTask(title: 'Wire the bench', spaceId: space.id),
    );
    await testRepository(db).create(const NewTask(title: 'Somewhere else'));
    await testTransactionRepository(db).create(
      NewTransaction(
        amountMinor: 45000,
        type: TransactionType.expense,
        date: testToday,
        category: 'Shopping',
        label: 'Bench vice',
        spaceId: space.id,
      ),
    );

    await pumpDetail(tester, space.id);

    expect(find.text('Wire the bench'), findsOneWidget);
    expect(find.text('Somewhere else'), findsNothing);
    expect(find.text('Bench vice'), findsOneWidget);
    // The stats read the same figures as the grid's sub-line.
    expect(find.text('₹450'), findsWidgets);
    await settleAndDispose(tester);
  });

  // Documents had no entry point in the whole app until this section existed
  // — the header offered them, the space could hold them, and nothing showed
  // them. Found by the Phase 3 device pass (plan §12.5.5).
  testWidgets('a space holding documents shows them and links onward',
      (tester) async {
    final space = await seedStudio(
      holds: {SpaceHolds.tasks, SpaceHolds.documents},
    );
    await testDocumentRepository(db).create(
      NewDocument(
        name: 'Studio lease',
        category: DocumentCategory.property,
        spaceId: space.id,
      ),
    );
    await testDocumentRepository(db).create(
      const NewDocument(name: 'Filed elsewhere', category: DocumentCategory.identity),
    );

    await pumpDetail(tester, space.id);

    expect(find.text('DOCUMENTS'), findsOneWidget);
    expect(find.text('Studio lease'), findsOneWidget);
    expect(find.text('Filed elsewhere'), findsNothing);
    expect(find.text('See all'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('a space with no documents in it says so', (tester) async {
    final space = await seedStudio(
      holds: {SpaceHolds.tasks, SpaceHolds.documents},
    );

    await pumpDetail(tester, space.id);

    expect(find.text('No documents filed here.'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('a section the space does not hold is not built',
      (tester) async {
    final space = await seedStudio(holds: {SpaceHolds.tasks});

    await pumpDetail(tester, space.id);

    expect(find.text('TASKS'), findsOneWidget);
    expect(find.text('MONEY'), findsNothing);
    expect(find.text('DOCUMENTS'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('an empty section says so rather than showing nothing',
      (tester) async {
    final space = await seedStudio();

    await pumpDetail(tester, space.id);

    expect(find.text('No open tasks filed here.'), findsOneWidget);
    expect(find.text('Nothing spent against this space yet.'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('archiving the space turns detail into its archived state',
      (tester) async {
    final space = await seedStudio();
    await pumpDetail(tester, space.id);

    await testSpaceRepository(db).archive(space.id);
    await tester.pumpAndSettle();

    expect(find.text('This space is archived'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('space settings edits the space in place', (tester) async {
    final space = await seedStudio();
    await pumpDetail(tester, space.id);

    await tester.tap(find.byTooltip('Space settings'));
    await tester.pumpAndSettle();

    expect(find.text('Space settings'), findsWidgets);
    await tester.enterText(find.byType(TextField).first, 'Workshop');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Workshop'), findsWidgets);
    await settleAndDispose(tester);
  });

  group("section 6.5's acceptance criterion", () {
    testWidgets('a space holding expenses is selectable in the expense sheet',
        (tester) async {
      await seedStudio(holds: {SpaceHolds.expenses});

      await tester.pumpWidget(
        wrapScreen(
          const Scaffold(body: NewExpenseSheet()),
          db: db,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Space'), findsOneWidget);
      expect(find.text('Studio'), findsOneWidget);
      await settleAndDispose(tester);
    });

    testWidgets('a space that does not hold expenses is not offered',
        (tester) async {
      await seedStudio(holds: {SpaceHolds.notes});

      await tester.pumpWidget(
        wrapScreen(
          const Scaffold(body: NewExpenseSheet()),
          db: db,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Studio'), findsNothing);
      await settleAndDispose(tester);
    });
  });
}
