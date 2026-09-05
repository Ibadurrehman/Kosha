import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

/// A lightweight calendar appointment — "Doctor 10am", "Gym" — created from
/// Quick add → Reminder. Deliberately has no `recurrenceRule`: recurring
/// events are a later-phase addition, not something v1's Calendar needs.
@freezed
abstract class Event with _$Event {
  const factory Event({
    required String id,
    required String title,
    required DateTime startAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,
    DateTime? endAt,
    @Default(false) bool allDay,

    /// Minutes before [startAt] to fire a reminder; null means no reminder.
    int? reminderOffsetMinutes,
    String? spaceId,
  }) = _Event;
}

/// The fields needed to create an event. Ids and timestamps are assigned by
/// the repository so callers cannot invent them.
class NewEvent {
  const NewEvent({
    required this.title,
    required this.startAt,
    this.description,
    this.endAt,
    this.allDay = false,
    this.reminderOffsetMinutes,
    this.spaceId,
  });

  final String title;
  final DateTime startAt;
  final String? description;
  final DateTime? endAt;
  final bool allDay;
  final int? reminderOffsetMinutes;
  final String? spaceId;
}
