import 'entities/event.dart';

/// Reads and writes events. Mirrors `TaskRepository`'s shape — same
/// soft-delete/undo pattern, same reminder-resync-on-launch contract.
abstract interface class EventRepository {
  /// Events starting in `[from, to)` — end exclusive.
  Stream<List<Event>> watchInRange(DateTime from, DateTime to);

  /// Emits null once the event is deleted.
  Stream<Event?> watchById(String id);

  Future<Event?> findById(String id);

  Future<Event> create(NewEvent draft);

  Future<Event> save(Event event);

  /// Marks the event deleted but keeps the row so [restore] can bring it back.
  Future<void> softDelete(String id);

  Future<void> restore(String id);

  /// Removes the row for good. Used to undo a creation, where nothing should
  /// be left behind.
  Future<void> purge(String id);

  /// Re-registers the reminder for every open, dated event. Scheduled
  /// notifications do not survive a reinstall, so the app re-states what it
  /// expects on launch — same contract as `TaskRepository.resyncReminders`.
  Future<void> resyncReminders();

  /// Every open event with a reminder lead time set — the candidates
  /// notification-inbox reconciliation checks for a fire moment in the past.
  Future<List<Event>> remindable();
}
