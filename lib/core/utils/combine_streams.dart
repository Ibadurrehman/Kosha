import 'dart:async';

/// Merges the latest emission of each stream in [sources] into one
/// concatenated list, re-emitting whenever any source produces a new list.
///
/// Waits for every source to emit at least once before its first emission,
/// mirroring `Rx.combineLatest` — but without pulling in a reactive-extensions
/// dependency for what is, today, one or two sources at a time. This is the
/// merge-point primitive behind Home's aggregators and the calendar's
/// `calendarItemsProvider`: a later phase adding a source (bills, documents…)
/// is a call-site addition to the list passed in here, not a rewrite of this
/// function.
Stream<List<T>> combineLatestLists<T>(List<Stream<List<T>>> sources) {
  if (sources.isEmpty) return Stream.value(const []);
  if (sources.length == 1) return sources.single;

  late final StreamController<List<T>> controller;
  var latest = List<List<T>?>.filled(sources.length, null);
  var subscriptions = <StreamSubscription<List<T>>>[];
  var pending = 0;

  void emitIfReady() {
    if (latest.any((value) => value == null)) return;
    controller.add([for (final value in latest) ...value!]);
  }

  controller = StreamController<List<T>>.broadcast(
    onListen: () {
      latest = List<List<T>?>.filled(sources.length, null);
      pending = sources.length;
      subscriptions = [
        for (var i = 0; i < sources.length; i++)
          sources[i].listen(
            (value) {
              latest[i] = value;
              emitIfReady();
            },
            onError: controller.addError,
            onDone: () {
              pending--;
              if (pending <= 0) controller.close();
            },
          ),
      ];
    },
    // Fire-and-forget rather than awaiting each cancellation in turn: drift
    // closes a query stream with its own zero-duration timer, and awaiting
    // that sequentially per source chains up one such timer after another,
    // which needs strictly more drain passes than a test's teardown expects.
    // Each subscription cancels independently instead.
    onCancel: () {
      for (final subscription in subscriptions) {
        unawaited(subscription.cancel());
      }
    },
  );
  return controller.stream;
}
