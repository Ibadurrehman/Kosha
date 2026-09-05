import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges a [Stream] to go_router's `refreshListenable`, so a `redirect`
/// callback re-runs whenever the stream emits — the standard go_router +
/// riverpod recipe, since go_router has no first-party stream-based
/// refreshListenable.
///
/// Also keeps the most recent event around as [value], so a `redirect`
/// callback can read the current state synchronously instead of waiting on
/// the stream again — pass [initial] when that state is already known (e.g.
/// from a Riverpod provider's cached value) to avoid a one-frame gap where
/// [value] would otherwise be null.
class GoRouterRefreshStream<T> extends ChangeNotifier {
  GoRouterRefreshStream(Stream<T> stream, {T? initial}) : _value = initial {
    _subscription = stream.listen((event) {
      _value = event;
      notifyListeners();
    });
  }

  T? _value;

  T? get value => _value;

  late final StreamSubscription<T> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
