import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_renewal.freezed.dart';

/// The renewal kinds the Vehicle screen tracks (section 6.9): insurance and
/// PUC are two of its three stat tiles, registration and permit round out the
/// Renewals editor. Persisted by index — append only.
enum VehicleRenewalKind {
  insurance('Insurance'),
  puc('PUC'),
  registration('Registration'),
  permit('Permit');

  const VehicleRenewalKind(this.label);

  final String label;
}

/// Where a renewal stands right now. Never stored — see [vehicleRenewalStatus].
///
/// Unlike [DocumentStatus] there is no "no expiry" case: a renewal row only
/// ever exists once a `validTill` has been recorded for that kind.
enum VehicleRenewalStatus { valid, expiring, expired }

/// How many days before [VehicleRenewal.validTill] a renewal reminds by
/// default — the same lead Bills use (`defaultBillReminderDays` is 3 days for
/// money owed; a lapsed PUC or insurance policy is planned further ahead).
const int defaultVehicleRenewalReminderDays = 30;

/// One renewal kind's current standing for a vehicle.
///
/// The Renewals editor edits these in place rather than keeping history — a
/// unique index on (vehicleId, kind) is what "renewing" actually does, the
/// same reasoning `Bill.nextDue` gives for storing one date rather than a log.
@freezed
abstract class VehicleRenewal with _$VehicleRenewal {
  const factory VehicleRenewal({
    required String id,
    required String vehicleId,
    required VehicleRenewalKind kind,
    required DateTime validTill,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(defaultVehicleRenewalReminderDays) int reminderOffsetDays,

    /// The Document row this renewal was filed under (Add document, category
    /// Vehicle), if the user attached one.
    String? documentId,
  }) = _VehicleRenewal;

  const VehicleRenewal._();
}

/// Section 5.2-style derived status, the same shape `documentStatus` gives
/// documents and `billStatus` gives bills.
VehicleRenewalStatus vehicleRenewalStatus(
  VehicleRenewal renewal,
  DateTime today,
) {
  if (renewal.validTill.isBefore(today)) return VehicleRenewalStatus.expired;
  final window = DateTime(
    today.year,
    today.month,
    today.day + renewal.reminderOffsetDays,
  );
  return renewal.validTill.isAfter(window)
      ? VehicleRenewalStatus.valid
      : VehicleRenewalStatus.expiring;
}

/// Whether a renewal belongs in Home's "Needs attention" (§5.2 lists
/// "renewals due" alongside expiring documents and overdue bills).
bool vehicleRenewalNeedsAttention(VehicleRenewalStatus status) =>
    status == VehicleRenewalStatus.expired ||
    status == VehicleRenewalStatus.expiring;
