import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/notifications/reminder_scheduler.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/calendar/data/event_repository_impl.dart';
import 'package:kosha/features/calendar/domain/entities/event.dart';
import 'package:kosha/features/calendar/presentation/calendar_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  testWidgets('shows the current month and switches views', (tester) async {
    await tester.pumpWidget(wrapScreen(const CalendarScreen(), db: db));
    await tester.pumpAndSettle();

    expect(find.text('September 2026'), findsOneWidget);
    expect(find.text('Task'), findsOneWidget);
    expect(find.text('Event'), findsOneWidget);

    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing on this day'), findsOneWidget);
    await settleAndDispose(tester);
  });

  testWidgets('an event on today shows up in the Agenda view', (tester) async {
    final events = DriftEventRepository(
      db,
      FixedClock(testNow),
      const NoopReminderScheduler(),
    );
    await events.create(NewEvent(title: 'Doctor', startAt: DateTime(2026, 9, 4, 10)));

    await tester.pumpWidget(wrapScreen(const CalendarScreen(), db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();
    expect(find.text('Doctor'), findsOneWidget);
    await settleAndDispose(tester);
  });
}
