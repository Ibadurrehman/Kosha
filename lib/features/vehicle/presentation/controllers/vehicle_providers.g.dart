// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The vehicle v1's UI manages; null before one has been added.

@ProviderFor(primaryVehicle)
final primaryVehicleProvider = PrimaryVehicleProvider._();

/// The vehicle v1's UI manages; null before one has been added.

final class PrimaryVehicleProvider
    extends
        $FunctionalProvider<AsyncValue<Vehicle?>, Vehicle?, Stream<Vehicle?>>
    with $FutureModifier<Vehicle?>, $StreamProvider<Vehicle?> {
  /// The vehicle v1's UI manages; null before one has been added.
  PrimaryVehicleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'primaryVehicleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$primaryVehicleHash();

  @$internal
  @override
  $StreamProviderElement<Vehicle?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Vehicle?> create(Ref ref) {
    return primaryVehicle(ref);
  }
}

String _$primaryVehicleHash() => r'd34986a34ff4ae14fca05805b6ab34a9a2eeb629';

@ProviderFor(vehicleRenewals)
final vehicleRenewalsProvider = VehicleRenewalsFamily._();

final class VehicleRenewalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VehicleRenewal>>,
          List<VehicleRenewal>,
          Stream<List<VehicleRenewal>>
        >
    with
        $FutureModifier<List<VehicleRenewal>>,
        $StreamProvider<List<VehicleRenewal>> {
  VehicleRenewalsProvider._({
    required VehicleRenewalsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'vehicleRenewalsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vehicleRenewalsHash();

  @override
  String toString() {
    return r'vehicleRenewalsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<VehicleRenewal>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<VehicleRenewal>> create(Ref ref) {
    final argument = this.argument as String;
    return vehicleRenewals(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VehicleRenewalsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vehicleRenewalsHash() => r'fff5ae0f641f129c6660e4b0a481772cf78622f9';

final class VehicleRenewalsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<VehicleRenewal>>, String> {
  VehicleRenewalsFamily._()
    : super(
        retry: null,
        name: r'vehicleRenewalsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VehicleRenewalsProvider call(String vehicleId) =>
      VehicleRenewalsProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'vehicleRenewalsProvider';
}

/// Newest first — the Vehicle screen only ever previews the first few.

@ProviderFor(serviceHistory)
final serviceHistoryProvider = ServiceHistoryFamily._();

/// Newest first — the Vehicle screen only ever previews the first few.

final class ServiceHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ServiceRecord>>,
          List<ServiceRecord>,
          Stream<List<ServiceRecord>>
        >
    with
        $FutureModifier<List<ServiceRecord>>,
        $StreamProvider<List<ServiceRecord>> {
  /// Newest first — the Vehicle screen only ever previews the first few.
  ServiceHistoryProvider._({
    required ServiceHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serviceHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceHistoryHash();

  @override
  String toString() {
    return r'serviceHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ServiceRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ServiceRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return serviceHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceHistoryHash() => r'25059632363881db3afb96f1f5af61dc4c2eff82';

/// Newest first — the Vehicle screen only ever previews the first few.

final class ServiceHistoryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ServiceRecord>>, String> {
  ServiceHistoryFamily._()
    : super(
        retry: null,
        name: r'serviceHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Newest first — the Vehicle screen only ever previews the first few.

  ServiceHistoryProvider call(String vehicleId) =>
      ServiceHistoryProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'serviceHistoryProvider';
}

@ProviderFor(fuelMonthSummary)
final fuelMonthSummaryProvider = FuelMonthSummaryFamily._();

final class FuelMonthSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<FuelMonthSummary>,
          FuelMonthSummary,
          Stream<FuelMonthSummary>
        >
    with $FutureModifier<FuelMonthSummary>, $StreamProvider<FuelMonthSummary> {
  FuelMonthSummaryProvider._({
    required FuelMonthSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fuelMonthSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fuelMonthSummaryHash();

  @override
  String toString() {
    return r'fuelMonthSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<FuelMonthSummary> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<FuelMonthSummary> create(Ref ref) {
    final argument = this.argument as String;
    return fuelMonthSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FuelMonthSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fuelMonthSummaryHash() => r'8a2a9fcbd52a0245526fd29fa3291497258bd211';

final class FuelMonthSummaryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<FuelMonthSummary>, String> {
  FuelMonthSummaryFamily._()
    : super(
        retry: null,
        name: r'fuelMonthSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FuelMonthSummaryProvider call(String vehicleId) =>
      FuelMonthSummaryProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'fuelMonthSummaryProvider';
}
