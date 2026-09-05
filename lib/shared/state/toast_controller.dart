import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A transient message at the bottom of the screen, optionally offering to undo
/// the action that produced it.
@immutable
class KoshaToast {
  const KoshaToast({required this.id, required this.message, this.onUndo});

  /// Increments on every [ToastController.show] so a replacement message
  /// re-runs the entrance animation even when the text is identical.
  final int id;
  final String message;
  final VoidCallback? onUndo;

  bool get canUndo => onUndo != null;
}

/// Holds the single toast the app shows at a time. A new message replaces the
/// current one, matching the prototype.
class ToastController extends Notifier<KoshaToast?> {
  /// The prototype dismisses after 3.4 seconds.
  static const Duration visibleFor = Duration(milliseconds: 3400);

  Timer? _timer;
  int _nextId = 0;

  @override
  KoshaToast? build() {
    ref.onDispose(_cancelTimer);
    return null;
  }

  void show(String message, {VoidCallback? onUndo}) {
    _cancelTimer();
    state = KoshaToast(id: _nextId++, message: message, onUndo: onUndo);
    _timer = Timer(visibleFor, dismiss);
  }

  /// Runs the undo action and clears the toast. Does nothing when the current
  /// message has no undo.
  void undo() {
    final action = state?.onUndo;
    dismiss();
    action?.call();
  }

  void dismiss() {
    _cancelTimer();
    state = null;
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

final toastControllerProvider =
    NotifierProvider<ToastController, KoshaToast?>(ToastController.new);
