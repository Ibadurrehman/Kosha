import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/utils/formatters.dart';
import '../domain/entities/group_member.dart';

/// The member with this id, or null once they have left the group.
GroupMember? memberById(List<GroupMember> members, String id) {
  for (final member in members) {
    if (member.id == id) return member;
  }
  return null;
}

/// The member who is the user. Null only in a group the user is somehow not
/// in, which [GroupRepository.createGroup] makes impossible for groups this
/// app creates.
GroupMember? selfMember(List<GroupMember> members) {
  for (final member in members) {
    if (member.isSelf) return member;
  }
  return null;
}

/// A member's name, or a stand-in for one who has gone. Screens read from
/// stored ids, and a row that silently vanished would be worse than one that
/// says what happened.
String memberName(List<GroupMember> members, String id) =>
    memberById(members, id)?.displayName ?? 'Someone who left';

/// "You" reads better than the user's own name in a sentence about them.
String memberNameOrYou(List<GroupMember> members, String id) {
  final member = memberById(members, id);
  if (member == null) return 'Someone who left';
  return member.isSelf ? 'You' : member.displayName;
}

/// "₹2,400 split 4 ways · ₹600 each" — §6.14's toast, and the sheet's own
/// preview line, so the two always agree.
///
/// A split that does not divide evenly says "about", because the per-head
/// figure is then one of two amounts a paisa apart and stating either as
/// exact would be a small lie.
String splitSummary(int amountMinor, int ways) {
  if (ways <= 0) return Money.inr(amountMinor);
  final each = amountMinor ~/ ways;
  final exact = each * ways == amountMinor;
  final wayLabel = ways == 1 ? '1 way' : '$ways ways';
  return '${Money.inr(amountMinor)} split $wayLabel · '
      '${exact ? '' : 'about '}${Money.inr(each)} each';
}

/// "You are owed ₹8,400" / "You owe ₹3,800" / "You are square".
String yourStanding(int netMinor) {
  if (netMinor == 0) return 'You are square';
  return netMinor > 0
      ? 'You are owed ${Money.inr(netMinor)}'
      : 'You owe ${Money.inr(-netMinor)}';
}

/// The same line about somebody else.
String theirStanding(String name, int netMinor) {
  if (netMinor == 0) return '$name is square';
  return netMinor > 0
      ? '$name is owed ${Money.inr(netMinor)}'
      : '$name owes ${Money.inr(-netMinor)}';
}

/// Maps a shared expense's stored `iconKey` to a symbol, the indirection
/// `spaceIcon` explains: a persisted code point stops rendering the moment
/// the last Dart mention of that icon is tree-shaken away.
IconData sharedExpenseIcon(String? key) => switch (key) {
      'flight' => Symbols.flight_rounded,
      'hotel' => Symbols.hotel_rounded,
      'two_wheeler' => Symbols.two_wheeler_rounded,
      'restaurant' => Symbols.restaurant_rounded,
      'local_taxi' => Symbols.local_taxi_rounded,
      'shopping_bag' => Symbols.shopping_bag_rounded,
      'receipt_long' => Symbols.receipt_long_rounded,
      _ => Symbols.receipt_long_rounded,
    };

/// The icons the shared-expense sheet offers, in order.
const List<String> sharedExpenseIconPicks = [
  'receipt_long',
  'flight',
  'hotel',
  'two_wheeler',
  'restaurant',
  'local_taxi',
  'shopping_bag',
];
