import 'entities/upcoming_item.dart';

/// One feature's contribution to Home's "Upcoming" section.
abstract interface class UpcomingSource {
  /// Items due in `[from, to)` — end exclusive, matching the rest of the
  /// app's date-range convention (see `DriftTaskRepository.watchDueOn`).
  Stream<List<UpcomingItem>> watch({required DateTime from, required DateTime to});
}
