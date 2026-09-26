import 'entities/fuel_log.dart';
import 'entities/service_record.dart';
import 'entities/vehicle.dart';
import 'entities/vehicle_renewal.dart';

/// Reads and writes vehicles and everything filed under one: renewals,
/// service history and fuel logs (section 6.9).
///
/// Every write that touches a renewal re-syncs the reminder the operating
/// system holds, the same discipline `DocumentRepository` and
/// `BillRepository` keep — one entry point owns the row change and its
/// side effect, so nothing can drift out of sync with the notification tray.
abstract interface class VehicleRepository {
  /// The vehicle v1's UI manages — the oldest live row, or null before one has
  /// been added. The model supports many (D10); nothing here stops a second
  /// row existing, but no v1 screen ever asks for one by anything but this.
  Stream<Vehicle?> watchPrimary();

  Future<Vehicle?> findById(String id);

  /// Creates the vehicle in its own system space — Vehicle's, found the way
  /// `SpaceRepository.findBySystemKey` describes; every vehicle shares that
  /// one space rather than picking one.
  Future<Vehicle> create(NewVehicle draft);

  /// Applies an edit. Every argument is optional; omitting one leaves that
  /// field alone. `purchaseDate` cannot be cleared through this method — no
  /// surface removes it once set.
  Future<Vehicle> edit(
    String id, {
    String? name,
    String? makeModel,
    String? registration,
    int? odometerKm,
    DateTime? purchaseDate,
  });

  /// Marks the vehicle deleted and cancels every renewal reminder it holds.
  Future<void> softDelete(String id);

  Future<void> restore(String id);

  /// Every renewal kind recorded for [vehicleId], in `VehicleRenewalKind`
  /// declaration order — the Vehicle screen's stat tiles and the Renewals
  /// editor both read this directly.
  Stream<List<VehicleRenewal>> watchRenewals(String vehicleId);

  /// Renewals across every live vehicle needing attention, most urgent first —
  /// Home's Needs attention section.
  Stream<List<VehicleRenewal>> watchRenewalsNeedingAttention({
    required DateTime today,
  });

  /// Renewals due in `[from, to)` across every live vehicle — Home's Upcoming
  /// section and the Calendar aggregator.
  Stream<List<VehicleRenewal>> watchRenewalsDueBetween(
    DateTime from,
    DateTime to,
  );

  /// Creates [kind]'s row for [vehicleId] if none exists yet, otherwise
  /// updates it in place — what the Renewals editor calls "renewing". A
  /// unique index on (vehicleId, kind) is what makes this an upsert rather
  /// than a second write path.
  Future<VehicleRenewal> upsertRenewal(
    String vehicleId,
    VehicleRenewalKind kind, {
    required DateTime validTill,
    int reminderOffsetDays = defaultVehicleRenewalReminderDays,
    String? documentId,
  });

  /// Service history, newest first.
  Stream<List<ServiceRecord>> watchServiceHistory(String vehicleId);

  /// Logs a service and, when its odometer reading is ahead of the vehicle's
  /// stored one, advances the vehicle's own reading to match — the header
  /// stat is otherwise only as fresh as the last edit through [edit].
  Future<ServiceRecord> addServiceRecord(
    String vehicleId,
    NewServiceRecord draft,
  );

  /// Fuel log, oldest first — the order "fuel this month" and a km/l
  /// computation both want it in.
  Stream<List<FuelLog>> watchFuelLogs(String vehicleId);

  /// Logs a fill-up and advances the vehicle's odometer reading the same way
  /// [addServiceRecord] does.
  Future<FuelLog> addFuelLog(String vehicleId, NewFuelLog draft);
}
