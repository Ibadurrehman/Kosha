import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_section.freezed.dart';

/// The 5 sections Home can show, in their default order (Appendix A).
enum HomeSectionKey {
  attention('Needs attention'),
  today('Today'),
  upcoming('Upcoming'),
  quickAccess('Quick access'),
  recent('Recent');

  const HomeSectionKey(this.label);

  final String label;
}

/// One row from Customize dashboard: whether a section shows on Home, and
/// where.
@freezed
abstract class DashboardSection with _$DashboardSection {
  const factory DashboardSection({
    required HomeSectionKey key,
    required bool enabled,
    required int sortOrder,
  }) = _DashboardSection;
}
