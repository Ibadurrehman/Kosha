import 'package:freezed_annotation/freezed_annotation.dart';

part 'space_summary.freezed.dart';

/// What a space currently holds, for the grid's live sub-line
/// ("₹42,500 spent · 3 bills", section 6.5).
///
/// Counts only what exists today. Documents, notes and lists join this class
/// in the phase that adds their tables; a field with nothing to count would
/// read as "0 documents" and be a lie about a feature that has not shipped.
@freezed
abstract class SpaceSummary with _$SpaceSummary {
  const factory SpaceSummary({
    @Default(0) int openTasks,
    @Default(0) int bills,

    /// Expenses dated inside the current calendar month, in paise.
    @Default(0) int spentThisMonthMinor,
  }) = _SpaceSummary;

  const SpaceSummary._();

  static const SpaceSummary empty = SpaceSummary();

  bool get isEmpty =>
      openTasks == 0 && bills == 0 && spentThisMonthMinor == 0;
}

/// Which figure a [SpaceTally] row carries.
enum SpaceTallyKind { openTasks, bills, spentMinor }

/// One grouped figure for one space, as it comes back from a `GROUP BY`.
///
/// The three queries produce different shapes of number, so they are carried
/// as a common row type and folded into [SpaceSummary] afterwards — that is
/// what lets them go through `combineLatestLists`, the same merge-point
/// primitive Home's aggregators and the calendar use.
class SpaceTally {
  const SpaceTally(this.spaceId, this.kind, this.value);

  final String spaceId;
  final SpaceTallyKind kind;
  final int value;
}

/// Folds grouped tallies into one summary per space.
Map<String, SpaceSummary> foldTallies(List<SpaceTally> tallies) {
  final summaries = <String, SpaceSummary>{};
  for (final tally in tallies) {
    final current = summaries[tally.spaceId] ?? SpaceSummary.empty;
    summaries[tally.spaceId] = switch (tally.kind) {
      SpaceTallyKind.openTasks => current.copyWith(openTasks: tally.value),
      SpaceTallyKind.bills => current.copyWith(bills: tally.value),
      SpaceTallyKind.spentMinor =>
        current.copyWith(spentThisMonthMinor: tally.value),
    };
  }
  return summaries;
}
