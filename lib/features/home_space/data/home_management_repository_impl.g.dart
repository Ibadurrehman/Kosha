// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_management_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeManagementRepository)
final homeManagementRepositoryProvider = HomeManagementRepositoryProvider._();

final class HomeManagementRepositoryProvider
    extends
        $FunctionalProvider<
          HomeManagementRepository,
          HomeManagementRepository,
          HomeManagementRepository
        >
    with $Provider<HomeManagementRepository> {
  HomeManagementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeManagementRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeManagementRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeManagementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeManagementRepository create(Ref ref) {
    return homeManagementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeManagementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeManagementRepository>(value),
    );
  }
}

String _$homeManagementRepositoryHash() =>
    r'6042af7fa0ccc7117a812b9e521c0d7c27342b94';
