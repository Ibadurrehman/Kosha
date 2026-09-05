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

/// One task for the detail screen; emits null once it is deleted.

@ProviderFor(taskById)
final taskByIdProvider = TaskByIdFamily._();

/// One task for the detail screen; emits null once it is deleted.

final class TaskByIdProvider
    extends $FunctionalProvider<AsyncValue<Task?>, Task?, Stream<Task?>>
    with $FutureModifier<Task?>, $StreamProvider<Task?> {
  /// One task for the detail screen; emits null once it is deleted.
  TaskByIdProvider._({
    required TaskByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskByIdHash();

  @override
  String toString() {
    return r'taskByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Task?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Task?> create(Ref ref) {
    final argument = this.argument as String;
    return taskById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskByIdHash() => r'acc4a463c2ab78de542436e6100e9175dcf1bedb';

/// One task for the detail screen; emits null once it is deleted.

final class TaskByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Task?>, String> {
  TaskByIdFamily._()
    : super(
        retry: null,
        name: r'taskByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One task for the detail screen; emits null once it is deleted.

  TaskByIdProvider call(String id) =>
      TaskByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'taskByIdProvider';
}

/// History for the detail screen's activity section, newest first.

@ProviderFor(taskActivity)
final taskActivityProvider = TaskActivityFamily._();

/// History for the detail screen's activity section, newest first.

final class TaskActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityEntry>>,
          List<ActivityEntry>,
          Stream<List<ActivityEntry>>
        >
    with
        $FutureModifier<List<ActivityEntry>>,
        $StreamProvider<List<ActivityEntry>> {
  /// History for the detail screen's activity section, newest first.
  TaskActivityProvider._({
    required TaskActivityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskActivityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskActivityHash();

  @override
  String toString() {
    return r'taskActivityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ActivityEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ActivityEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return taskActivity(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskActivityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskActivityHash() => r'88c097875ff260d5885ddd3c9bfb633a77306a8b';

/// History for the detail screen's activity section, newest first.

final class TaskActivityFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ActivityEntry>>, String> {
  TaskActivityFamily._()
    : super(
        retry: null,
        name: r'taskActivityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// History for the detail screen's activity section, newest first.

  TaskActivityProvider call(String id) =>
      TaskActivityProvider._(argument: id, from: this);

  @override
  String toString() => r'taskActivityProvider';
}

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
