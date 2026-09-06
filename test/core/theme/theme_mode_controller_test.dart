import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/theme/theme_mode_controller.dart';
import 'package:kosha/core/utils/clock.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = testDatabase();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(FixedClock(testNow)),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() => db.close());

  test('starts as system before any preference is loaded', () {
    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('set updates state immediately and persists it', () async {
    container.read(themeModeProvider.notifier).set(ThemeMode.dark);
    expect(container.read(themeModeProvider), ThemeMode.dark);

    // A fresh container reading the same database picks up the persisted
    // choice on its own first load.
    final another = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(another.dispose);
    another.listen(themeModeProvider, (_, _) {});
    await pumpEventQueue();
    expect(another.read(themeModeProvider), ThemeMode.dark);
  });
}
