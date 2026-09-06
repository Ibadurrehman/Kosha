// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_section_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardSectionRepository)
final dashboardSectionRepositoryProvider =
    DashboardSectionRepositoryProvider._();

final class DashboardSectionRepositoryProvider
    extends
        $FunctionalProvider<
          DashboardSectionRepository,
          DashboardSectionRepository,
          DashboardSectionRepository
        >
    with $Provider<DashboardSectionRepository> {
  DashboardSectionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSectionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSectionRepositoryHash();

  @$internal
  @override
  $ProviderElement<DashboardSectionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DashboardSectionRepository create(Ref ref) {
    return dashboardSectionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardSectionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardSectionRepository>(value),
    );
  }
}

String _$dashboardSectionRepositoryHash() =>
    r'16fb15b2bf5f378c06eb3c6017160819f9e63175';
