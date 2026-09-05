import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/utils/combine_streams.dart';

void main() {
  test('a single source passes through unchanged', () async {
    final source = Stream.value(const [1, 2]);
    expect(await combineLatestLists([source]).first, [1, 2]);
  });

  test('an empty source list emits one empty list', () async {
    expect(await combineLatestLists<int>([]).first, isEmpty);
  });

  test('waits for every source before the first emission', () async {
    final a = StreamController<List<int>>();
    final b = StreamController<List<int>>();
    final emissions = <List<int>>[];
    final subscription = combineLatestLists([a.stream, b.stream]).listen(emissions.add);
    addTearDown(subscription.cancel);

    a.add([1]);
    await Future<void>.delayed(Duration.zero);
    expect(emissions, isEmpty);

    b.add([2, 3]);
    await Future<void>.delayed(Duration.zero);
    expect(emissions, [
      [1, 2, 3],
    ]);

    await a.close();
    await b.close();
  });

  test('re-emits the full concatenation whenever any source updates', () async {
    final a = StreamController<List<String>>();
    final b = StreamController<List<String>>();
    final emissions = <List<String>>[];
    final subscription = combineLatestLists([a.stream, b.stream]).listen(emissions.add);
    addTearDown(subscription.cancel);

    a.add(['task']);
    b.add(['event']);
    await Future<void>.delayed(Duration.zero);
    a.add(['task', 'task2']);
    await Future<void>.delayed(Duration.zero);

    expect(emissions, [
      ['task', 'event'],
      ['task', 'task2', 'event'],
    ]);

    await a.close();
    await b.close();
  });

  test('closes once every source is done', () async {
    final a = StreamController<List<int>>();
    final b = StreamController<List<int>>();
    var done = false;
    final subscription = combineLatestLists([a.stream, b.stream]).listen(
      (_) {},
      onDone: () => done = true,
    );
    addTearDown(subscription.cancel);

    await a.close();
    expect(done, isFalse);
    await b.close();
    await Future<void>.delayed(Duration.zero);
    expect(done, isTrue);
  });
}
