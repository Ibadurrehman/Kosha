import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/space_repository_impl.dart';
import '../../data/space_summary_source.dart';
import '../../domain/entities/space.dart';
import '../../domain/entities/space_summary.dart';

part 'space_providers.g.dart';

/// The grid: every space the user has not archived, in their own order.
@riverpod
Stream<List<Space>> activeSpaces(Ref ref) =>
    ref.watch(spaceRepositoryProvider).watchActive();

/// What the Spaces screen offers to bring back, newest archive first.
@riverpod
Stream<List<Space>> archivedSpaces(Ref ref) =>
    ref.watch(spaceRepositoryProvider).watchArchived();

/// One space for the detail and settings screens; emits null once the space is
/// archived, which is what turns Space detail into its "this is archived"
/// state rather than leaving a stale header on screen.
@riverpod
Stream<Space?> spaceById(Ref ref, String id) => ref
    .watch(spaceRepositoryProvider)
    .watchActive()
    .map((spaces) => spaces.where((space) => space.id == id).firstOrNull);

/// The spaces a picker should offer for [kind] — what makes section 6.5's
/// acceptance criterion true ("creating a space with Expenses enabled makes it
/// selectable in the New expense sheet").
@riverpod
Stream<List<Space>> spacesHolding(Ref ref, SpaceHolds kind) =>
    ref.watch(spaceRepositoryProvider).watchHolding(kind);

/// Live per-space counts for the grid's sub-lines, keyed by space id.
@riverpod
Stream<Map<String, SpaceSummary>> spaceSummaries(Ref ref) =>
    ref.watch(spaceSummarySourceProvider).watchAll();
