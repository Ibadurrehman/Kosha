import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../onboarding/domain/area.dart';

part 'space.freezed.dart';

/// Built-in versus user-made (section 5.1). Persisted by index — append only.
enum SpaceKind { system, custom }

/// What a space is allowed to contain — the "What can it hold" chips on the
/// New space sheet (Appendix A).
///
/// This is a permission, not an inventory: it decides whether a space appears
/// in the New expense sheet's picker or the task form's, not what actually
/// sits inside it. A space that holds nothing is still a valid space; it just
/// aggregates nothing.
///
/// Persisted by *name* inside a comma-joined string, not by index. A set has
/// to survive re-ordering of this enum the way an `intEnum` column does not,
/// and the stored value stays legible in a database browser.
enum SpaceHolds {
  tasks('Tasks'),
  notes('Notes'),
  lists('Lists'),
  expenses('Expenses'),
  documents('Documents'),
  reminders('Reminders');

  const SpaceHolds(this.label);

  final String label;
}

/// The ten built-in spaces the prototype's grid shows (Appendix A, seed data).
///
/// Persisted by *name* (`textEnum`) rather than index: this is an identity —
/// `systemKey == SystemSpace.vehicle` is how the Vehicle screen finds its own
/// space — and an identity should not move when the enum is re-ordered.
///
/// Tasks and Bills are onboarding areas but not spaces: tasks live in their
/// own tab and bills belong to Finance, which is why [gatedBy] maps two areas
/// onto one space and leaves [OnboardingArea.tasks] out entirely.
enum SystemSpace {
  finance('Finance', 'wallet', {
    SpaceHolds.expenses,
    SpaceHolds.tasks,
    SpaceHolds.documents,
    SpaceHolds.reminders,
  }),
  home('Home', 'home_work', {
    SpaceHolds.tasks,
    SpaceHolds.expenses,
    SpaceHolds.documents,
    SpaceHolds.lists,
    SpaceHolds.reminders,
  }),
  vehicle('Vehicle', 'directions_car', {
    SpaceHolds.expenses,
    SpaceHolds.documents,
    SpaceHolds.tasks,
    SpaceHolds.reminders,
  }),
  documents('Documents', 'folder_shared', {
    SpaceHolds.documents,
    SpaceHolds.tasks,
    SpaceHolds.reminders,
  }),
  shopping('Shopping', 'shopping_basket', {
    SpaceHolds.lists,
    SpaceHolds.expenses,
    SpaceHolds.tasks,
  }),
  goals('Goals', 'flag', {
    SpaceHolds.tasks,
    SpaceHolds.notes,
    SpaceHolds.reminders,
  }),
  notes('Notes', 'sticky_note', {SpaceHolds.notes, SpaceHolds.tasks}),
  ideas('Ideas', 'lightbulb', {SpaceHolds.notes, SpaceHolds.tasks}),
  health('Health', 'health', {
    SpaceHolds.tasks,
    SpaceHolds.documents,
    SpaceHolds.expenses,
    SpaceHolds.notes,
    SpaceHolds.reminders,
  }),
  travel('Travel', 'flight', {
    SpaceHolds.expenses,
    SpaceHolds.documents,
    SpaceHolds.tasks,
    SpaceHolds.notes,
    SpaceHolds.lists,
  });

  const SystemSpace(this.label, this.iconKey, this.holds);

  final String label;

  /// A key from [spaceIconKeys] — never an `IconData`, for the reason
  /// `TransactionCategory.iconKey` gives: icon constants are tree-shaken by
  /// reference, so a persisted code point breaks the moment the last Dart
  /// reference to that icon goes away.
  final String iconKey;

  final Set<SpaceHolds> holds;

  /// The "Pick areas" choices that make this space visible on first run.
  ///
  /// Empty means "always visible": Ideas, Health and Travel were never
  /// offered on that step, and a space the user was never asked about should
  /// not start hidden.
  Set<OnboardingArea> get gatedBy => switch (this) {
        // Bills belong to Finance, so either pick brings the space along.
        SystemSpace.finance => {OnboardingArea.finance, OnboardingArea.bills},
        SystemSpace.home => {OnboardingArea.home},
        SystemSpace.vehicle => {OnboardingArea.vehicle},
        SystemSpace.documents => {OnboardingArea.documents},
        SystemSpace.shopping => {OnboardingArea.shopping},
        SystemSpace.goals => {OnboardingArea.goals},
        SystemSpace.notes => {OnboardingArea.notes},
        SystemSpace.ideas ||
        SystemSpace.health ||
        SystemSpace.travel =>
          const {},
      };
}

/// A container for anything belonging to one area of life (Appendix C).
///
/// Every other entity already carries a nullable `space_id` — Tasks, Bills,
/// Events and Transactions have since Phases 1 and 2 — so this row is what
/// finally gives those columns something to point at.
@freezed
abstract class Space with _$Space {
  const factory Space({
    required String id,
    required String name,
    required SpaceKind kind,
    required Set<SpaceHolds> holds,

    /// Position in the Spaces grid, ascending.
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Set for [SpaceKind.system] rows, null for user-made ones.
    SystemSpace? systemKey,

    /// A key from [spaceIconKeys]; null falls back to the folder icon.
    String? iconKey,

    /// When the user archived it. Archiving *is* deletion here — see the
    /// table's doc comment.
    DateTime? archivedAt,
  }) = _Space;

  const Space._();

  bool get isArchived => archivedAt != null;

  /// System spaces are seeded and cannot be removed, only archived — the
  /// prototype has no "delete Finance" affordance and nothing would own the
  /// Finance screen's rows if it did.
  bool get isSystem => kind == SpaceKind.system;

  bool holdsKind(SpaceHolds kind) => holds.contains(kind);
}

/// Fields a caller supplies to create a space; the repository fills in the id,
/// sort order and timestamps.
class NewSpace {
  const NewSpace({
    required this.name,
    required this.holds,
    this.iconKey,
  });

  final String name;
  final Set<SpaceHolds> holds;
  final String? iconKey;
}

/// The icons a space can carry, keyed by the name stored in the database.
/// `presentation/space_icons.dart` maps these to real symbols.
///
/// The first eight are the New space sheet's picks (Appendix A: "Icon (8
/// picks)"); the rest exist so the seeded system spaces can name their own.
const List<String> spaceIconKeys = [
  'home_work',
  'wallet',
  'directions_car',
  'folder_shared',
  'shopping_basket',
  'health',
  'flight',
  'flag',
  'sticky_note',
  'lightbulb',
  'school',
  'pets',
  'work',
  'family',
  'celebration',
  'folder',
];

/// The eight offered on the New space sheet, in order.
const List<String> newSpaceIconPicks = [
  'home_work',
  'wallet',
  'directions_car',
  'folder_shared',
  'shopping_basket',
  'health',
  'flight',
  'flag',
];

/// What a brand-new user space can hold before the user touches the chips.
const Set<SpaceHolds> defaultNewSpaceHolds = {
  SpaceHolds.tasks,
  SpaceHolds.notes,
  SpaceHolds.documents,
};
