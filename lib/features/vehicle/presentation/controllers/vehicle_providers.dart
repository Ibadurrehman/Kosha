import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/clock.dart';
import '../../data/vehicle_repository_impl.dart';
import '../../domain/entities/fuel_log.dart';
import '../../domain/entities/service_record.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_renewal.dart';

part 'vehicle_providers.g.dart';

/// The vehicle v1's UI manages; null before one has been added.
@riverpod
Stream<Vehicle?> primaryVehicle(Ref ref) =>
    ref.watch(vehicleRepositoryProvider).watchPrimary();

@riverpod
Stream<List<VehicleRenewal>> vehicleRenewals(Ref ref, String vehicleId) =>
    ref.watch(vehicleRepositoryProvider).watchRenewals(vehicleId);

/// Newest first — the Vehicle screen only ever previews the first few.
@riverpod
Stream<List<ServiceRecord>> serviceHistory(Ref ref, String vehicleId) =>
    ref.watch(vehicleRepositoryProvider).watchServiceHistory(vehicleId);

/// "Fuel this month" (section 6.9): fill-ups dated inside [month], their
/// total cost, and the km/l a Home-style stat card wants.
class FuelMonthSummary {
  const FuelMonthSummary({
    required this.fillUps,
    required this.totalCostMinor,
    required this.kmPerLitre,
  });

  static const FuelMonthSummary empty =
      FuelMonthSummary(fillUps: 0, totalCostMinor: 0, kmPerLitre: null);

  final int fillUps;
  final int totalCostMinor;

  /// Null when fewer than two fill-ups exist across the vehicle's whole
  /// history — km/l needs a distance between two odometer readings, which a
  /// single month's fill-ups do not always contain.
  final double? kmPerLitre;
}

@riverpod
Stream<FuelMonthSummary> fuelMonthSummary(Ref ref, String vehicleId) {
  final today = ref.watch(clockProvider).today();
  return ref
      .watch(vehicleRepositoryProvider)
      .watchFuelLogs(vehicleId)
      .map((logs) => _summarize(logs, today));
}

FuelMonthSummary _summarize(List<FuelLog> logsOldestFirst, DateTime month) {
  final inMonth = [
    for (final log in logsOldestFirst)
      if (log.date.year == month.year && log.date.month == month.month) log,
  ];
  return FuelMonthSummary(
    fillUps: inMonth.length,
    totalCostMinor: inMonth.fold(0, (sum, log) => sum + log.costMinor),
    kmPerLitre: averageKmPerLitre(logsOldestFirst),
  );
}

/// Distance covered between the earliest and latest fill-up on record,
/// divided by the litres bought at every fill-up after the first — the first
/// tank's fuel is what got the vehicle *to* that odometer reading, not
/// between it and the next (the "full-to-full" method a trip computer uses).
/// Needs at least 2 fill-ups across the vehicle's whole history; a single
/// month rarely has enough on its own.
double? averageKmPerLitre(List<FuelLog> logsOldestFirst) {
  if (logsOldestFirst.length < 2) return null;
  final distance =
      logsOldestFirst.last.odometerKm - logsOldestFirst.first.odometerKm;
  final litres = logsOldestFirst
      .skip(1)
      .fold(0.0, (sum, log) => sum + log.litres);
  if (distance <= 0 || litres <= 0) return null;
  return distance / litres;
}
