import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/shared/state/toast_controller.dart';

void main() {
  ProviderContainer container() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('starts empty', () {
    expect(container().read(toastControllerProvider), isNull);
  });

  test('shows a message and clears it after 3.4 seconds', () {
    fakeAsync((async) {
      final c = container();
      c.read(toastControllerProvider.notifier).show('Task deleted');

      expect(c.read(toastControllerProvider)?.message, 'Task deleted');
      async.elapse(const Duration(milliseconds: 3399));
      expect(c.read(toastControllerProvider), isNotNull);
      async.elapse(const Duration(milliseconds: 2));
      expect(c.read(toastControllerProvider), isNull);
    });
  });

  test('a new message replaces the old one and restarts the timer', () {
    fakeAsync((async) {
      final c = container();
      final toasts = c.read(toastControllerProvider.notifier);

      toasts.show('first');
      async.elapse(const Duration(milliseconds: 3000));
      toasts.show('second');

      // The first toast's timer must not clear the second message.
      async.elapse(const Duration(milliseconds: 1000));
      expect(c.read(toastControllerProvider)?.message, 'second');

      async.elapse(const Duration(milliseconds: 2500));
      expect(c.read(toastControllerProvider), isNull);
    });
  });

  test('each message gets a new id so the animation replays', () {
    fakeAsync((async) {
      final c = container();
      final toasts = c.read(toastControllerProvider.notifier);

      toasts.show('Completed');
      final first = c.read(toastControllerProvider)!.id;
      toasts.show('Completed');
      expect(c.read(toastControllerProvider)!.id, isNot(first));

      async.elapse(const Duration(seconds: 4));
    });
  });

  test('undo runs the action once and clears the toast', () {
    fakeAsync((async) {
      final c = container();
      final toasts = c.read(toastControllerProvider.notifier);
      var undone = 0;

      toasts.show('Completed “Exercise”', onUndo: () => undone++);
      expect(c.read(toastControllerProvider)!.canUndo, isTrue);

      toasts.undo();
      expect(undone, 1);
      expect(c.read(toastControllerProvider), isNull);

      // A second undo has nothing to run.
      toasts.undo();
      expect(undone, 1);
      async.elapse(const Duration(seconds: 4));
    });
  });

  test('dismiss clears the message without running undo', () {
    fakeAsync((async) {
      final c = container();
      final toasts = c.read(toastControllerProvider.notifier);
      var undone = 0;

      toasts.show('Completed', onUndo: () => undone++);
      toasts.dismiss();

      expect(c.read(toastControllerProvider), isNull);
      expect(undone, 0);
      async.elapse(const Duration(seconds: 4));
    });
  });
}
