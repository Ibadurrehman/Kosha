import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/notifications/reminder_scheduler.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/calendar/data/event_repository_impl.dart';
import 'package:kosha/features/calendar/domain/entities/event.dart';
import 'package:kosha/features/calendar/presentation/controllers/calendar_providers.dart';
import 'package:kosha/features/tasks/data/task_repository_impl.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

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
        reminderSchedulerProvider.overrideWithValue(const NoopReminderScheduler()),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() => db.close());

  test('merges tasks and events in range, grouped and time-sorted by day',
      () async {
    final tasks = container.read(taskRepositoryProvider);
    final events = container.read(eventRepositoryProvider);

    await tasks.create(
      NewTask(
        title: 'Submit report',
        dueDate: DateTime(2026, 9, 10),
        dueMinutes: 14 * 60,
      ),
    );
    await events.create(
      NewEvent(title: 'Doctor', startAt: DateTime(2026, 9, 10, 10)),
    );
    await tasks.create(NewTask(title: 'Out of range', dueDate: DateTime(2026, 10, 1)));

    final range = calendarItemsByDayProvider(DateTime(2026, 9, 1), DateTime(2026, 9, 30));
    // A throwaway listener keeps this autoDispose provider alive long enough
    // for its first value — `container.read(provider.future)` alone can be
    // torn down mid-load (the exact "disposed during loading state" failure
    // this avoids), since a bare read is not an active listener.
    final subscription = container.listen(range, (_, _) {});
    final byDay = await container.read(range.future);
    subscription.close();

    final day = DateTime(2026, 9, 10);
    // Doctor (10am) sorts before Submit report (2pm).
    expect(byDay[day]?.map((i) => i.title).toList(), ['Doctor', 'Submit report']);
    expect(byDay.containsKey(DateTime(2026, 10, 1)), isFalse);
  });

  test('a completed task drops off, matching every other list', () async {
    final tasks = container.read(taskRepositoryProvider);
    final task = await tasks.create(
      NewTask(title: 'Renew passport', dueDate: DateTime(2026, 9, 10)),
    );
    await tasks.setDone(task.id, done: true);

    final range = calendarItemsByDayProvider(DateTime(2026, 9, 1), DateTime(2026, 9, 30));
    final subscription = container.listen(range, (_, _) {});
    final byDay = await container.read(range.future);
    subscription.close();

    expect(byDay[DateTime(2026, 9, 10)], isNull);
  });
}
