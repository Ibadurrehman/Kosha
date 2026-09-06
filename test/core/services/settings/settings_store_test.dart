import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/settings/settings_store.dart';
import 'package:kosha/core/utils/clock.dart';

import '../../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late SettingsStore store;

  setUp(() {
    db = testDatabase();
    store = SettingsStore(db, FixedClock(testNow));
  });

  tearDown(() => db.close());

  test('reads back null for a key that was never written', () async {
    expect(await store.read('missing', (json) => json), isNull);
  });

  test('round-trips a JSON-encodable value', () async {
    await store.write('onboarding.visible_areas', ['tasks', 'finance']);
    final value = await store.read(
      'onboarding.visible_areas',
      (json) => (json as List).cast<String>(),
    );
    expect(value, ['tasks', 'finance']);
  });

  test('a second write replaces the first', () async {
    await store.write('appearance.theme_mode', 'dark');
    await store.write('appearance.theme_mode', 'light');
    expect(await store.read('appearance.theme_mode', (json) => json), 'light');
  });

  test('watch emits null then the written value', () async {
    final values = <Object?>[];
    final subscription = store
        .watch('search.recent', (json) => json)
        .listen(values.add);
    addTearDown(subscription.cancel);

    await pumpEventQueue();
    await store.write('search.recent', <String>['groceries']);
    await pumpEventQueue();

    expect(values, [null, ['groceries']]);
  });
}
