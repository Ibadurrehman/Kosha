import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../bills/domain/entities/bill.dart';
import '../../../documents/domain/entities/document.dart';
import '../../../tasks/domain/entities/task.dart';
import 'event.dart';

part 'calendar_item.freezed.dart';

/// What kind of record a calendar row points back to — Task, Event, Bill or
/// a document expiry; renewals and group trips join in later phases
/// (section 6.4). §5.2's day-dot tones read off this.
enum CalendarItemKind { task, event, bill, documentExpiry }

/// One task or event, flattened to what the Calendar screen needs to draw:
/// a day to group by, an optional time to sort and show, a title, and enough
/// to route back to the owner on tap.
@freezed
abstract class CalendarItem with _$CalendarItem {
  const factory CalendarItem({
    required String id,
    required CalendarItemKind kind,
    required String title,

    /// Local midnight of the day this item falls on — the grouping key.
    required DateTime date,

    /// Minutes since midnight, or null for "all day" / "no time".
    int? minutes,
  }) = _CalendarItem;
}

CalendarItem calendarItemFromTask(Task task) => CalendarItem(
      id: task.id,
      kind: CalendarItemKind.task,
      title: task.title,
      date: task.dueDate!,
      minutes: task.dueMinutes,
    );

/// A bill sits on its due date with no time — money is owed that day, not at
/// a particular hour — so it sorts alongside the all-day events.
CalendarItem calendarItemFromBill(Bill bill) => CalendarItem(
      id: bill.id,
      kind: CalendarItemKind.bill,
      title: bill.name,
      date: bill.nextDue!,
    );

/// A document expiry sits on its expiry day with no time, the way a bill sits
/// on its due date: the passport stops being valid that day, not at an hour.
CalendarItem calendarItemFromDocument(Document document) => CalendarItem(
      id: document.id,
      kind: CalendarItemKind.documentExpiry,
      title: document.name,
      date: document.expiresOn!,
    );

CalendarItem calendarItemFromEvent(Event event) => CalendarItem(
      id: event.id,
      kind: CalendarItemKind.event,
      title: event.title,
      date: DateTime(event.startAt.year, event.startAt.month, event.startAt.day),
      minutes: event.allDay ? null : event.startAt.hour * 60 + event.startAt.minute,
    );
