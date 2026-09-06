import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/kosha_colors.dart';
import '../../core/theme/kosha_shapes.dart';

/// The 12-key amount entry grid shared by the New expense sheet and, later,
/// the shared-expense sheet (section 7.4).
///
/// The widget itself only renders; [pressKey] is the pure reducer so it can
/// be unit-tested without pumping a widget (section 15's "keypad reducer").
class AmountKeypad extends StatelessWidget {
  const AmountKeypad({super.key, required this.value, required this.onChanged});

  /// The amount typed so far, e.g. `"150.5"`. Empty means nothing typed yet.
  final String value;
  final ValueChanged<String> onChanged;

  /// Digits, "." then backspace, matching the prototype's `pressKey`.
  ///
  /// A digit is dropped once [current] is 9 characters long or already has 2
  /// digits after the decimal point; "." is dropped once one is already
  /// present. Both caps come from section 6.6.
  static String pressKey(String current, String key) {
    if (key == 'backspace') {
      return current.isEmpty ? current : current.substring(0, current.length - 1);
    }
    if (key == '.') {
      return current.contains('.') ? current : (current.isEmpty ? '0.' : '$current.');
    }
    // A digit.
    if (current.length >= 9) return current;
    final dot = current.indexOf('.');
    if (dot != -1 && current.length - dot - 1 >= 2) return current;
    return current + key;
  }

  static const List<String> _keys = [
    '1', '2', '3',
    '4', '5', '6',
    '7', '8', '9',
    '.', '0', 'backspace',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [for (final key in _keys) _Key(label: key, onTap: () => _press(key))],
    );
  }

  void _press(String key) {
    HapticFeedback.selectionClick();
    onChanged(pressKey(value, key));
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Material(
      color: c.sunk,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KoshaRadius.card)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        child: Center(
          child: label == 'backspace'
              ? Icon(Symbols.backspace_rounded, color: c.text2, size: 20)
              : Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
