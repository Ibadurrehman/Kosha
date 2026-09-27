import 'package:flutter/material.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../domain/entities/group_member.dart';

/// A member's initials on their fixed fill.
///
/// The four tones are theme-independent (§7.1) and the initials are always
/// white, which is what keeps 4.5:1 in both themes — the prototype's own note
/// is explicit that these must never be sourced from `--accent`, because that
/// lightens in dark mode and would leave white text on a pale disc.
class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    super.key,
    required this.member,
    this.size = 34,
    this.showBorder = false,
  });

  final GroupMember member;
  final double size;

  /// A ring in the surface colour, for the overlapping row on the trip card.
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final tone = KoshaColors
        .avatarTones[member.colourIndex % KoshaColors.avatarTones.length];

    return Semantics(
      label: member.displayName,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: tone,
          shape: BoxShape.circle,
          border: showBorder ? Border.all(color: c.surface, width: 2) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          member.initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.36,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

/// Members shown as an overlapping row, newest last — Appendix A's trip card.
class MemberStack extends StatelessWidget {
  const MemberStack({
    super.key,
    required this.members,
    this.size = 34,
    this.max = 5,
  });

  final List<GroupMember> members;
  final double size;

  /// Beyond this, the row says "+2" rather than growing past the card.
  final int max;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final shown = members.take(max).toList();
    final overflow = members.length - shown.length;
    // Each disc tucks under the one before it, but only by the margin that
    // leaves two-letter initials whole: at 0.68 the device check showed "MJ"
    // rendering as "M." because the next disc covered the second character.
    // Laid out in a Stack rather than with negative padding, which Padding
    // asserts against.
    final step = size * 0.78;
    final width = shown.isEmpty ? 0.0 : size + step * (shown.length - 1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width,
          height: size,
          child: Stack(
            children: [
              for (final (index, member) in shown.indexed)
                Positioned(
                  left: step * index,
                  child: MemberAvatar(
                    member: member,
                    size: size,
                    showBorder: true,
                  ),
                ),
            ],
          ),
        ),
        if (overflow > 0)
          Padding(
            padding: EdgeInsets.only(left: shown.isEmpty ? 0 : 6),
            child: Text(
              '+$overflow',
              style: t.bodySmall?.copyWith(color: c.text2),
            ),
          ),
      ],
    );
  }
}
