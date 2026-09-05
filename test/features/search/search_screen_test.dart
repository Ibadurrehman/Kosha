import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/search/presentation/search_screen.dart';
import 'package:kosha/features/tasks/data/task_repository_impl.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftTaskRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testRepository(db);
  });

  tearDown(() => db.close());

  testWidgets('shows a prompt before typing, then results after debounce',
      (tester) async {
    await repository.create(const NewTask(title: 'Renew passport'));
    await tester.pumpWidget(wrapScreen(const SearchScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Search your tasks'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'passport');
    // Before the debounce elapses, nothing has queried yet.
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Renew passport'), findsNothing);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('Renew passport'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('an unsupported filter explains itself instead of erroring',
      (tester) async {
    await tester.pumpWidget(wrapScreen(const SearchScreen(), db: db));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'anything');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();

    expect(find.text('Notes search is arriving in a later phase'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('no matches shows a named empty state', (tester) async {
    await tester.pumpWidget(wrapScreen(const SearchScreen(), db: db));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'nothingmatchesthis');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('No matches for “nothingmatchesthis”'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
