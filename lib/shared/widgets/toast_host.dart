import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/kosha_colors.dart';
import '../../core/theme/kosha_shapes.dart';
import '../state/toast_controller.dart';

/// Draws the current toast above everything, including modal sheets. Installed
/// once through `MaterialApp.builder`.
class ToastHost extends ConsumerWidget {
  const ToastHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toast = ref.watch(toastControllerProvider);
    final media = MediaQuery.of(context);
    // Sit above the bottom navigation bar, or above the keyboard when one is up.
    final bottom = math.max(
      media.viewInsets.bottom + 16,
      media.padding.bottom + 84,
    );
    return Stack(
      children: [
        child,
        Positioned(
          left: 18,
          right: 18,
          bottom: bottom,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            transitionBuilder: (widget, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.35),
                  end: Offset.zero,
                ).animate(animation),
                child: widget,
              ),
            ),
            child: toast == null
                ? const SizedBox.shrink()
                : _ToastCard(key: ValueKey(toast.id), toast: toast),
          ),
        ),
      ],
    );
  }
}

class _ToastCard extends ConsumerWidget {
  const _ToastCard({super.key, required this.toast});

  final KoshaToast toast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(toastControllerProvider.notifier);
    final t = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      child: Material(
        color: KoshaColors.toastBg,
        borderRadius: BorderRadius.circular(KoshaRadius.toast),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 12, 8, 12),
          child: Row(
            children: [
              const Icon(
                Symbols.check_circle_rounded,
                size: 19,
                color: Colors.white,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  toast.message,
                  style: t.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 13.5,
                  ),
                ),
              ),
              if (toast.canUndo)
                TextButton(
                  onPressed: controller.undo,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('Undo'),
                ),
              // No `tooltip:` here — the host sits above the Navigator through
              // MaterialApp.builder, so there is no Overlay for one to use.
              Semantics(
                label: 'Dismiss',
                button: true,
                child: IconButton(
                  onPressed: controller.dismiss,
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  color: Colors.white70,
                  icon: const Icon(Symbols.close_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
