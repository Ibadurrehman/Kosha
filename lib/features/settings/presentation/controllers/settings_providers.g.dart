// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskRemindersEnabled)
final taskRemindersEnabledProvider = TaskRemindersEnabledProvider._();

final class TaskRemindersEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  TaskRemindersEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRemindersEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRemindersEnabledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return taskRemindersEnabled(ref);
  }
}

String _$taskRemindersEnabledHash() =>
    r'705a4b9a19c8d0dd7723b40ec6ae7acab8baf666';

@ProviderFor(exactRemindersEnabled)
final exactRemindersEnabledProvider = ExactRemindersEnabledProvider._();

final class ExactRemindersEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  ExactRemindersEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exactRemindersEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exactRemindersEnabledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return exactRemindersEnabled(ref);
  }
}

String _$exactRemindersEnabledHash() =>
    r'1e67cac46801d1006e7384fccdcfaf0e715d7b20';
