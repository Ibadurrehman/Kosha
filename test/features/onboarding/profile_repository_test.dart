import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/settings/settings_store.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/onboarding/data/profile_repository_impl.dart';
import 'package:kosha/features/onboarding/domain/area.dart';
import 'package:kosha/features/onboarding/domain/profile_repository.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late ProfileRepository repository;

  setUp(() {
    db = testDatabase();
    repository = DriftProfileRepository(
      db,
      FixedClock(testNow),
      SettingsStore(db, FixedClock(testNow)),
    );
  });

  tearDown(() => db.close());

  test('seeds a single row on first read', () async {
    final profile = await repository.current();
    expect(profile.id, 'local');
    expect(profile.onboardingCompleted, isFalse);
    expect(profile.joinedAt, testNow);
    expect(profile.currency, 'INR');
  });

  test('seeding is idempotent — reading twice never inserts a second row',
      () async {
    await repository.current();
    await repository.current();
    final rows = await db.select(db.profiles).get();
    expect(rows, hasLength(1));
  });

  test('watchProfile emits the seeded row then any update', () async {
    final emissions = <bool>[];
    final subscription =
        repository.watchProfile().map((p) => p.onboardingCompleted).listen(emissions.add);
    addTearDown(subscription.cancel);

    await pumpEventQueue();
    // The seeding insert can land a duplicate identical notification on top
    // of the initial fetch — assert the meaningful transition, not the exact
    // emission count.
    expect(emissions, everyElement(isFalse));
    await repository.completeOnboarding();
    await pumpEventQueue();

    expect(emissions.last, isTrue);
  });

  test('visibleAreas defaults before anything is chosen', () async {
    expect(await repository.visibleAreas(), defaultVisibleAreas);
  });

  test('setVisibleAreas round-trips through the settings store', () async {
    await repository.setVisibleAreas({OnboardingArea.vehicle, OnboardingArea.goals});
    expect(
      await repository.visibleAreas(),
      {OnboardingArea.vehicle, OnboardingArea.goals},
    );
  });
}
