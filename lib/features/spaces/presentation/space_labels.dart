import '../../../core/utils/formatters.dart';
import '../domain/entities/space.dart';
import '../domain/entities/space_summary.dart';

/// The grid tile's second line — "₹42,500 spent · 3 bills" (section 6.5).
///
/// Only figures that are actually there appear, so a space with one task reads
/// "1 open task" rather than "0 spent · 0 bills · 1 open task". Money leads
/// because it is the figure the prototype's tiles open with.
String spaceSubLine(SpaceSummary summary) {
  if (summary.isEmpty) return 'Nothing yet';

  final parts = <String>[
    if (summary.spentThisMonthMinor > 0)
      '${Money.inr(summary.spentThisMonthMinor)} spent',
    if (summary.bills > 0) _plural(summary.bills, 'bill'),
    if (summary.openTasks > 0) _plural(summary.openTasks, 'open task'),
  ];
  return parts.join(' · ');
}

/// What the "What can it hold" chips read as on a settings or detail screen:
/// "Tasks, Expenses and Documents", or "Nothing yet" for an empty selection.
String holdsSummary(Set<SpaceHolds> holds) {
  if (holds.isEmpty) return 'Nothing yet';
  final labels = [
    for (final hold in SpaceHolds.values)
      if (holds.contains(hold)) hold.label,
  ];
  if (labels.length == 1) return labels.single;
  return '${labels.take(labels.length - 1).join(', ')} and ${labels.last}';
}

String _plural(int count, String noun) =>
    count == 1 ? '1 $noun' : '$count ${noun}s';
