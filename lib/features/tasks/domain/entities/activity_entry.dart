import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_entry.freezed.dart';

/// Owner type stored alongside every task activity row, so the same table can
/// carry document and bill history later.
const String taskOwnerType = 'task';

/// What happened to a record. Persisted by index — append only.
enum ActivityEvent {
  created('Created'),
  completed('Completed'),
  reopened('Moved back to open'),
  rescheduled('Rescheduled'),
  edited('Edited'),
  deleted('Deleted'),
  restored('Restored');

  const ActivityEvent(this.label);

  final String label;
}

/// One line in the activity history shown on a detail screen.
@freezed
abstract class ActivityEntry with _$ActivityEntry {
  const factory ActivityEntry({
    required String id,
    required ActivityEvent event,
    required DateTime at,
    String? detail,
  }) = _ActivityEntry;

  const ActivityEntry._();

  /// "Rescheduled · to 5 Sep" — the event, plus context when there is any.
  String get label {
    final extra = detail;
    return extra == null || extra.isEmpty
        ? event.label
        : '${event.label} · $extra';
  }
}
