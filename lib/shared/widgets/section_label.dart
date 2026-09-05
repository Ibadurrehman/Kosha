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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text.toUpperCase(), style: Theme.of(context).textTheme.labelMedium),
          ?trailing,
        ],
      ),
    );
  }
}
