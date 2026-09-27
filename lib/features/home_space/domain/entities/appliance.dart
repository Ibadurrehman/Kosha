import 'package:freezed_annotation/freezed_annotation.dart';

part 'appliance.freezed.dart';

/// Where an appliance's warranty stands right now. Never stored — see
/// [applianceWarrantyStatus]. Mirrors [DocumentStatus]'s shape exactly,
/// including [noWarranty] for the same reason `DocumentStatus.noExpiry`
/// exists: an appliance with no warranty date is a fine state, just one that
/// can never change.
enum ApplianceWarrantyStatus { valid, expiring, expired, noWarranty }

/// How many days before [Appliance.warrantyTill] a reminder fires — fixed
/// rather than a per-row field, since section 6.10's acceptance criterion
/// names one number ("warranty within 30 days") and the data model gives
/// Appliance no `reminder_offset_days` column of its own the way Document and
/// Bill each have.
const int defaultApplianceWarrantyReminderDays = 30;

/// A household appliance (section 6.10's "Appliances").
///
/// No `spaceId` picker: every row belongs to the one Home system space —
/// see `MaintenanceJob`'s doc comment for why, and
/// `HomeManagementRepository`'s for how it is found.
@freezed
abstract class Appliance with _$Appliance {
  const factory Appliance({
    required String id,
    required String name,
    required String spaceId,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? makeModel,
    DateTime? purchasedOn,
    DateTime? warrantyTill,
    DateTime? nextServiceOn,

    /// The invoice, if the user filed one under Documents.
    String? documentId,
    DateTime? deletedAt,
  }) = _Appliance;

  const Appliance._();

  bool get isDeleted => deletedAt != null;
}

/// Fields a caller supplies to create an appliance; the repository fills in
/// the id, its space and the timestamps.
class NewAppliance {
  const NewAppliance({
    required this.name,
    this.makeModel,
    this.purchasedOn,
    this.warrantyTill,
    this.nextServiceOn,
    this.documentId,
  });

  final String name;
  final String? makeModel;
  final DateTime? purchasedOn;
  final DateTime? warrantyTill;
  final DateTime? nextServiceOn;
  final String? documentId;
}

/// Section 5.2-style derived status, the same shape `documentStatus` gives
/// documents.
ApplianceWarrantyStatus applianceWarrantyStatus(
  Appliance appliance,
  DateTime today,
) {
  final till = appliance.warrantyTill;
  if (till == null) return ApplianceWarrantyStatus.noWarranty;
  if (till.isBefore(today)) return ApplianceWarrantyStatus.expired;
  final window = DateTime(
    today.year,
    today.month,
    today.day + defaultApplianceWarrantyReminderDays,
  );
  return till.isAfter(window)
      ? ApplianceWarrantyStatus.valid
      : ApplianceWarrantyStatus.expiring;
}

/// Whether an appliance belongs in Home's "Needs attention" — section 6.10's
/// acceptance criterion: "Appliance warranty within 30 days surfaces in Needs
/// attention."
bool applianceNeedsAttention(ApplianceWarrantyStatus status) =>
    status == ApplianceWarrantyStatus.expired ||
    status == ApplianceWarrantyStatus.expiring;
