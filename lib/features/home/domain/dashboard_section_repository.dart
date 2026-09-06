import 'entities/dashboard_section.dart';

/// Reads and writes which Home sections show, and in what order.
abstract interface class DashboardSectionRepository {
  /// Seeds the 5 default rows on first call, then streams them in
  /// `sortOrder`.
  Stream<List<DashboardSection>> watchSections();

  Future<void> setEnabled(HomeSectionKey key, {required bool enabled});

  /// Rewrites `sortOrder` for every section to match [order]'s position.
  Future<void> reorder(List<HomeSectionKey> order);
}
