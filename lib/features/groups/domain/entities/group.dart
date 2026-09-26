import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';

/// What a group is for. Persisted by index — append only.
enum GroupKind {
  trip('Trip'),
  household('Household'),
  other('Other');

  const GroupKind(this.label);

  final String label;
}

/// A set of people sharing expenses — the Goa trip in Appendix B.
///
/// v1 groups are local: members are names the user typed, there is no invite
/// and no second device. Phase 5 adds the sync, and §6.14 is explicit that the
/// UI ships first so the ledger can be used against real numbers before any
/// backend exists.
@freezed
abstract class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required GroupKind kind,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// The space this group belongs to — Travel, for a trip. Set by the
    /// caller, because a group is created from inside a space.
    String? spaceId,

    /// ISO 4217, so a Phase 5 sync between two devices in different places
    /// does not have to guess. v1 writes INR and never offers a choice.
    @Default('INR') String currency,
    DateTime? startsOn,
    DateTime? endsOn,
    DateTime? deletedAt,
  }) = _Group;

  const Group._();

  bool get isDeleted => deletedAt != null;
}

/// Fields a caller supplies to create a group; the repository fills in the id
/// and timestamps.
class NewGroup {
  const NewGroup({
    required this.name,
    this.kind = GroupKind.trip,
    this.spaceId,
    this.currency = 'INR',
    this.startsOn,
    this.endsOn,
  });

  final String name;
  final GroupKind kind;
  final String? spaceId;
  final String currency;
  final DateTime? startsOn;
  final DateTime? endsOn;
}
