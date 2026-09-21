import 'package:flutter/material.dart';

/// Uppercase, letter-spaced section heading with an optional trailing action.
class SectionLabel extends StatelessWidget {
  const SectionLabel(
    this.text, {
    super.key,
    this.trailing,
    this.padding = const EdgeInsets.only(bottom: 10),
  });

  final String text;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          // Both children flex, so a long heading or a long trailing string
          // ellipsises instead of overflowing the row. Without this the pair
          // on Home's "Today" section ("TODAY" + "12 of 15 left") overflows at
          // the 130 % text scale section 7.6 asks the app to support.
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            Flexible(child: trailing!),
          ],
        ],
      ),
    );
  }
}
