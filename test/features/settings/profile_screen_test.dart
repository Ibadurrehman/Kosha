import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/settings/presentation/profile_screen.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  testWidgets('shows the seeded default name and real this-month stats',
      (tester) async {
    final tasks = testRepository(db, now: testNow);
    await tasks.create(const NewTask(title: 'Buy groceries'));
    final done = await tasks.create(const NewTask(title: 'Renew passport'));
    await tasks.setDone(done.id, done: true);
    // Outside this month — must not be counted.
    final earlier = testRepository(db, now: DateTime(2026, 7, 1));
    await earlier.create(const NewTask(title: 'Old task'));

    await tester.pumpWidget(wrapScreen(const ProfileScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('You'), findsOneWidget);
    expect(find.text('Tasks completed'), findsOneWidget);
    expect(find.text('Tasks added'), findsOneWidget);
    // 2 created this month (groceries + passport); 1 completed this month.
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
