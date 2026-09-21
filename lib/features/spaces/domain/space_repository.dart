import 'entities/space.dart';

/// Reads and writes spaces.
///
/// The ten system spaces are seeded on first read rather than in a migration,
/// so the repository's injected `Clock` supplies the timestamps — the same
/// choice Profiles, DashboardSections and TransactionCategories made
/// (plan §12.1.3). Seeding also reads onboarding's "Pick areas" selection, so
/// it has to happen somewhere that can await another repository, which a
/// `MigrationStrategy` callback cannot.
///
/// "Active" throughout means not archived. Archiving is the only removal a
/// space has: section 6.5 asks that deleting a user space leave its items
/// alive, and ADR 0008 records why the link itself is left in place rather
/// than nulled out.
abstract interface class SpaceRepository {
  /// Live grid order, archived spaces excluded.
  Stream<List<Space>> watchActive();

  /// One read of [watchActive], for callers that only need a snapshot.
  Future<List<Space>> listActive();

  /// What the Spaces screen offers to bring back, newest archive first.
  Stream<List<Space>> watchArchived();

  /// Active spaces that accept [kind] — what the New expense sheet, the task
  /// form and the bill form put in their space pickers.
  Stream<List<Space>> watchHolding(SpaceHolds kind);

  Future<Space?> findById(String id);

  /// How a feature screen finds the space it belongs to (Finance → its own
  /// space, Vehicle → its own). Returns null only if seeding has not run yet.
  Future<Space?> findBySystemKey(SystemSpace key);

  /// Appends a user space at the end of the grid.
  Future<Space> create(NewSpace draft);

  /// Renames, re-icons or re-scopes a space. Every argument is optional;
  /// omitting one leaves that field alone.
  ///
  /// `iconKey` cannot be cleared through this method — passing null means
  /// "unchanged", not "remove the icon", because no surface offers removing
  /// one and a sentinel would cost more than it buys.
  Future<Space> edit(
    String id, {
    String? name,
    String? iconKey,
    Set<SpaceHolds>? holds,
  });

  /// Persists the grid order from a reordered list of ids.
  Future<void> reorder(List<String> orderedIds);

  /// Hides the space. Items keep pointing at it, so [restore] brings the whole
  /// space back intact — see ADR 0008.
  Future<void> archive(String id);

  Future<void> restore(String id);

  /// How many live items across every table still point at this space — what
  /// the archive confirmation tells the user before hiding it.
  Future<int> linkedItemCount(String id);
}
