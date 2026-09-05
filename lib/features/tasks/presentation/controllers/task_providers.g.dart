// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Open tasks in one Tasks-screen tab.

@ProviderFor(tasksInBucket)
final tasksInBucketProvider = TasksInBucketFamily._();

/// Open tasks in one Tasks-screen tab.

final class TasksInBucketProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  /// Open tasks in one Tasks-screen tab.
  TasksInBucketProvider._({
    required TasksInBucketFamily super.from,
    required TaskBucket super.argument,
  }) : super(
         retry: null,
         name: r'tasksInBucketProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tasksInBucketHash();

  @override
  String toString() {
    return r'tasksInBucketProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as TaskBucket;
    return tasksInBucket(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksInBucketProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tasksInBucketHash() => r'6490ee84683f509740290261f31025564b7f04ff';

/// Open tasks in one Tasks-screen tab.

final class TasksInBucketFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, TaskBucket> {
  TasksInBucketFamily._()
    : super(
        retry: null,
        name: r'tasksInBucketProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Open tasks in one Tasks-screen tab.

  TasksInBucketProvider call(TaskBucket bucket) =>
      TasksInBucketProvider._(argument: bucket, from: this);

  @override
  String toString() => r'tasksInBucketProvider';
}

/// Everything due today, completed included — Home shows those struck through.

@ProviderFor(todayTasks)
final todayTasksProvider = TodayTasksProvider._();

/// Everything due today, completed included — Home shows those struck through.

final class TodayTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  /// Everything due today, completed included — Home shows those struck through.
  TodayTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return todayTasks(ref);
  }
}

String _$todayTasksHash() => r'47e9260dd38fc5266b260381d7be4afd6b74db7b';

/// The tab the Tasks screen is showing. Kept alive so it survives tab switches
/// in the shell.

@ProviderFor(SelectedTaskBucket)
final selectedTaskBucketProvider = SelectedTaskBucketProvider._();

/// The tab the Tasks screen is showing. Kept alive so it survives tab switches
/// in the shell.
final class SelectedTaskBucketProvider
    extends $NotifierProvider<SelectedTaskBucket, TaskBucket> {
  /// The tab the Tasks screen is showing. Kept alive so it survives tab switches
  /// in the shell.
  SelectedTaskBucketProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTaskBucketProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTaskBucketHash();

  @$internal
  @override
  SelectedTaskBucket create() => SelectedTaskBucket();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskBucket value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskBucket>(value),
    );
  }
}

String _$selectedTaskBucketHash() =>
    r'd6e3f8a7653e3ca27ef66d6236d018773e4d1827';

/// The tab the Tasks screen is showing. Kept alive so it survives tab switches
/// in the shell.

abstract class _$SelectedTaskBucket extends $Notifier<TaskBucket> {
  TaskBucket build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TaskBucket, TaskBucket>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TaskBucket, TaskBucket>,
              TaskBucket,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
