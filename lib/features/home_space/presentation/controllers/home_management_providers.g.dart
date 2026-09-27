// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_management_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeUtilities)
final homeUtilitiesProvider = HomeUtilitiesProvider._();

final class HomeUtilitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeUtility>>,
          List<HomeUtility>,
          Stream<List<HomeUtility>>
        >
    with
        $FutureModifier<List<HomeUtility>>,
        $StreamProvider<List<HomeUtility>> {
  HomeUtilitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeUtilitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeUtilitiesHash();

  @$internal
  @override
  $StreamProviderElement<List<HomeUtility>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<HomeUtility>> create(Ref ref) {
    return homeUtilities(ref);
  }
}

String _$homeUtilitiesHash() => r'c3e34cda679ceea3f64f5e5290aa41bf8ba21aa2';

@ProviderFor(maintenanceJobs)
final maintenanceJobsProvider = MaintenanceJobsProvider._();

final class MaintenanceJobsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MaintenanceJob>>,
          List<MaintenanceJob>,
          Stream<List<MaintenanceJob>>
        >
    with
        $FutureModifier<List<MaintenanceJob>>,
        $StreamProvider<List<MaintenanceJob>> {
  MaintenanceJobsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceJobsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceJobsHash();

  @$internal
  @override
  $StreamProviderElement<List<MaintenanceJob>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MaintenanceJob>> create(Ref ref) {
    return maintenanceJobs(ref);
  }
}

String _$maintenanceJobsHash() => r'a1144d8b52757a8ffcc79fb8dbe9cea6e3043b0e';

@ProviderFor(appliances)
final appliancesProvider = AppliancesProvider._();

final class AppliancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appliance>>,
          List<Appliance>,
          Stream<List<Appliance>>
        >
    with $FutureModifier<List<Appliance>>, $StreamProvider<List<Appliance>> {
  AppliancesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appliancesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appliancesHash();

  @$internal
  @override
  $StreamProviderElement<List<Appliance>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Appliance>> create(Ref ref) {
    return appliances(ref);
  }
}

String _$appliancesHash() => r'a6feb7efa5b3c3b9e87fcc0085ad0639f367af67';
