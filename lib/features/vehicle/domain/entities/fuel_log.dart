import 'package:freezed_annotation/freezed_annotation.dart';

part 'fuel_log.freezed.dart';

/// One fill-up (section 6.9's "fuel this month"): a fact about a moment, like
/// [ServiceRecord] — nothing edits a row in place once it exists, only
/// inserts or removes one.
@freezed
abstract class FuelLog with _$FuelLog {
  const factory FuelLog({
    required String id,
    required String vehicleId,
    required DateTime date,
    required double litres,
    required int costMinor,
    required int odometerKm,
    required DateTime createdAt,
  }) = _FuelLog;
}

/// Fields a caller supplies to log a fill-up; the repository fills in the id
/// and timestamp.
class NewFuelLog {
  const NewFuelLog({
    required this.date,
    required this.litres,
    required this.costMinor,
    required this.odometerKm,
  });

  final DateTime date;
  final double litres;
  final int costMinor;
  final int odometerKm;
}
