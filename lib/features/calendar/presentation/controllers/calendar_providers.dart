import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/clock.dart';
import '../../../../core/utils/combine_streams.dart';
import '../../../bills/data/bill_repository_impl.dart';
import '../../../documents/data/document_repository_impl.dart';
import '../../../tasks/data/task_repository_impl.dart';
import '../../data/event_repository_impl.dart';
import '../../domain/entities/calendar_item.dart';

part 'calendar_providers.g.dart';

/// The 3 views the Calendar screen offers.
enum CalendarView {
  month('Month'),
  week('Week'),
  agenda('Agenda');

  const CalendarView(this.label);

  final String label;
}

@Riverpod(keepAlive: true)
class SelectedCalendarView extends _$SelectedCalendarView {
  @override
  CalendarView build() => CalendarView.month;

  void select(CalendarView view) => state = view;
}

/// The day the Month/Week grid is centred on and the Agenda is showing.
@Riverpod(keepAlive: true)
class SelectedCalendarDate extends _$SelectedCalendarDate {
  @override
  DateTime build() => ref.watch(clockProvider).today();

  void select(DateTime date) => state = date;
}

/// Every task with a due date, every event starting, and every bill falling
/// due in `[from, to)`, merged, sorted, and pre-grouped by day — grouping happens here rather
/// than in the widget so a 500-item month renders without re-scanning the
/// full list per cell (section 6.4's stated performance target).
///
/// Only open tasks are included, the same rule Home's Upcoming section uses:
/// a completed task drops off the calendar the way it drops off every other
/// list once it is done.
@riverpod
Stream<Map<DateTime, List<CalendarItem>>> calendarItemsByDay(
  Ref ref,
  DateTime from,
  DateTime to,
) {
  final taskItems = ref
      .watch(taskRepositoryProvider)
      .watchDueBetween(from, to)
      .map((tasks) => [for (final task in tasks) calendarItemFromTask(task)]);
  final eventItems = ref
      .watch(eventRepositoryProvider)
      .watchInRange(from, to)
      .map((events) => [for (final event in events) calendarItemFromEvent(event)]);
  final billItems = ref
      .watch(billRepositoryProvider)
      .watchDueBetween(from, to)
      .map((bills) => [for (final bill in bills) calendarItemFromBill(bill)]);

  final documentItems = ref
      .watch(documentRepositoryProvider)
      .watchExpiringBetween(from, to)
      .map((documents) =>
          [for (final document in documents) calendarItemFromDocument(document)]);

  return combineLatestLists([
    taskItems,
    eventItems,
    billItems,
    documentItems,
  ]).map((items) {
    final byDay = <DateTime, List<CalendarItem>>{};
    for (final item in items) {
      (byDay[item.date] ??= []).add(item);
    }
    for (final dayItems in byDay.values) {
      dayItems.sort(
        (a, b) => (a.minutes ?? 24 * 60).compareTo(b.minutes ?? 24 * 60),
      );
    }
    return byDay;
  });
}
