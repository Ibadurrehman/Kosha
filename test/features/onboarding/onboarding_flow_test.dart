import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/app.dart';
import 'package:kosha/core/db/app_database.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  testWidgets('a fresh install lands on onboarding, not Home', (tester) async {
    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Your personal life, organized.'), findsOneWidget);
    expect(find.text('Good morning'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('a completed profile skips onboarding entirely', (tester) async {
    await seedCompletedProfile(db);
    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('Your personal life, organized.'), findsNothing);
    await settleAndDispose(tester);
  });

  testWidgets('Skip on the welcome step completes onboarding and reaches Home',
      (tester) async {
    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Good morning'), findsOneWidget);

    final profile = await (db.select(db.profiles)).getSingle();
    expect(profile.onboardingCompleted, isTrue);
    await settleAndDispose(tester);
  });

  testWidgets('walking through all 4 steps lands on Home', (tester) async {
    await tester.pumpWidget(wrapApp(const KoshaApp(), db: db));
    await tester.pumpAndSettle();

    // Step 1 → 2.
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('What do you want to track?'), findsOneWidget);

    // Step 2 → 3.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your dashboard'), findsOneWidget);

    // Step 3 → 4.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Add your first thing'), findsOneWidget);

    // Step 4 → Home, via Skip (no task created).
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Good morning'), findsOneWidget);

    final profile = await (db.select(db.profiles)).getSingle();
    expect(profile.onboardingCompleted, isTrue);
    await settleAndDispose(tester);
  });
}
