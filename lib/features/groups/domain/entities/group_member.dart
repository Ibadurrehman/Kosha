import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_member.freezed.dart';

/// Persisted by index — append only.
enum MemberRole {
  organiser('Organiser'),
  member('Member');

  const MemberRole(this.role);

  final String role;
}

/// One person in a group.
///
/// In v1 every member is local: a name the user typed, with no account behind
/// it. [profileId] is null until Phase 5 matches a member to a real account,
/// and [inviteToken] is what that matching will be done with — both are
/// columns nothing writes yet, kept because §5.1 names them and adding them
/// later would mean migrating a table that by then holds real trips.
@freezed
abstract class GroupMember with _$GroupMember {
  const factory GroupMember({
    required String id,
    required String groupId,
    required String displayName,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Two letters, shown white on [colourIndex]'s fill.
    required String initials,

    /// An index into `KoshaColors.avatarTones`, not a colour.
    ///
    /// The four tones are fixed and theme-independent (§7.1) so white initials
    /// keep 4.5:1 in both themes. Storing the index rather than the value is
    /// the same indirection `Space.iconKey` uses: a stored 0xFF415DB7 would
    /// freeze today's palette into every old row.
    @Default(0) int colourIndex,
    @Default(MemberRole.member) MemberRole role,

    /// The local profile this member *is*, once there is an account behind
    /// them (Phase 5). Null for every member v1 creates except "You".
    String? profileId,
    String? inviteToken,
    DateTime? deletedAt,
  }) = _GroupMember;

  const GroupMember._();

  bool get isDeleted => deletedAt != null;

  /// The member who is the user themselves — the one every "your share" line
  /// is about.
  bool get isSelf => profileId != null;
}

/// Fields a caller supplies to add a member.
class NewGroupMember {
  const NewGroupMember({
    required this.displayName,
    this.initials,
    this.colourIndex,
    this.role = MemberRole.member,
    this.profileId,
  });

  final String displayName;

  /// Derived from the name when the caller does not say — see [initialsFor].
  final String? initials;

  /// Assigned round-robin by the repository when the caller does not say, so
  /// the first four members of a group never share a colour.
  final int? colourIndex;
  final MemberRole role;
  final String? profileId;
}

/// "Aarav Sharma" → "AS", "Meera" → "ME", "" → "?".
///
/// Two letters, because that is what the avatar is sized for. A single-word
/// name gives its first two letters rather than one, so "Meera" and "Mohan"
/// do not both read as "M" on the same trip.
String initialsFor(String displayName) {
  final words = displayName
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) return '?';
  if (words.length == 1) {
    final word = words.single;
    return (word.length == 1 ? word : word.substring(0, 2)).toUpperCase();
  }
  return '${words.first[0]}${words[1][0]}'.toUpperCase();
}
