import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// `ReminderScheduler` turns a wall-clock reminder into an instant by looking
/// up whatever zone id the platform reports. Android reports the device's own
/// setting, which is frequently a legacy alias — this project's emulator says
/// `Asia/Calcutta`, not `Asia/Kolkata` — and the trimmed `latest` database
/// carries only the canonical names.
///
/// Missing the lookup is quiet: the scheduler falls back to UTC and every
/// reminder fires five and a half hours late for an Indian user. Found by the
/// Phase 3 device pass (plan §12.5.5); `bootstrap()` loads `latest_all`
/// because of it.
void main() {
  setUpAll(tz.initializeTimeZones);

  test('the zone ids Android actually reports all resolve', () {
    // Legacy aliases on the left, the canonical zone each is a link to on the
    // right. `latest` has the right-hand column only.
    const reported = {
      'Asia/Calcutta': 'Asia/Kolkata',
      'Asia/Rangoon': 'Asia/Yangon',
      'Asia/Saigon': 'Asia/Ho_Chi_Minh',
      'Europe/Kiev': 'Europe/Kyiv',
      'America/Godthab': 'America/Nuuk',
    };

    for (final MapEntry(key: alias, value: canonical) in reported.entries) {
      expect(
        () => tz.getLocation(alias),
        returnsNormally,
        reason: 'a device set to $alias would schedule its reminders on UTC',
      );
      expect(
        tz.getLocation(alias).currentTimeZone.offset,
        tz.getLocation(canonical).currentTimeZone.offset,
        reason: '$alias and $canonical are the same place',
      );
    }
  });
}
