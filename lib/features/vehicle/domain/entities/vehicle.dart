import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';

/// A vehicle the user tracks (section 6.9). The model supports more than one
/// row — `space_id` always points at the single Vehicle system space, not a
/// space of its own per vehicle — but v1's UI only ever shows one (D10); see
/// `VehicleRepository.watchPrimary`.
@freezed
abstract class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String id,
    required String name,
    required String makeModel,
    required String registration,
    required int odometerKm,
    required String spaceId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? purchaseDate,

    /// Soft delete, so an undone creation or a removed vehicle can come back —
    /// the same shape as `Tasks`/`Bills`. Nothing in v1's UI exposes removing
    /// the one vehicle it manages, but the model does not assume that stays
    /// true.
    DateTime? deletedAt,
  }) = _Vehicle;

  const Vehicle._();

  bool get isDeleted => deletedAt != null;
}

/// Fields a caller supplies to create a vehicle; the repository fills in the
/// id, its space and the timestamps.
class NewVehicle {
  const NewVehicle({
    required this.name,
    required this.makeModel,
    required this.registration,
    this.odometerKm = 0,
    this.purchaseDate,
  });

  final String name;
  final String makeModel;
  final String registration;
  final int odometerKm;
  final DateTime? purchaseDate;
}
