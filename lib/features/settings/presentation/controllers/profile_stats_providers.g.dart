// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_stats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The two "this month" stats Profile can show honestly — the prototype's
/// other three (expenses/goals/documents) are omitted until those features
/// exist, rather than shown as fabricated zeros.

@ProviderFor(tasksCompletedThisMonth)
final tasksCompletedThisMonthProvider = TasksCompletedThisMonthProvider._();

/// The two "this month" stats Profile can show honestly — the prototype's
/// other three (expenses/goals/documents) are omitted until those features
/// exist, rather than shown as fabricated zeros.

final class TasksCompletedThisMonthProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// The two "this month" stats Profile can show honestly — the prototype's
  /// other three (expenses/goals/documents) are omitted until those features
  /// exist, rather than shown as fabricated zeros.
  TasksCompletedThisMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksCompletedThisMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksCompletedThisMonthHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return tasksCompletedThisMonth(ref);
  }
}

String _$tasksCompletedThisMonthHash() =>
    r'b1af8ca088c746491ed8887105ac40a6a1d4184a';

@ProviderFor(tasksAddedThisMonth)
final tasksAddedThisMonthProvider = TasksAddedThisMonthProvider._();

final class TasksAddedThisMonthProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  TasksAddedThisMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksAddedThisMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksAddedThisMonthHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return tasksAddedThisMonth(ref);
  }
}

String _$tasksAddedThisMonthHash() =>
    r'e7fc3e5a14c4f35952ffda4fd1d1adb729984170';
