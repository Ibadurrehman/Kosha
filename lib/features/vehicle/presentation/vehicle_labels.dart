import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/status_pill.dart';
import '../domain/entities/vehicle_renewal.dart';

/// The shared status vocabulary's value for a renewal's derived status —
/// the same mapping `documentPillStatus` and `billPillStatus` give their own
/// entities.
KoshaStatus vehicleRenewalPillStatus(VehicleRenewalStatus status) =>
    switch (status) {
      VehicleRenewalStatus.expired => KoshaStatus.expired,
      VehicleRenewalStatus.expiring => KoshaStatus.expiring,
      VehicleRenewalStatus.valid => KoshaStatus.valid,
    };

/// "Due in 15 days" / "Overdue by 3 days" — a renewal stat tile's caption.
String vehicleRenewalBadgeLabel(VehicleRenewal renewal, DateTime today) {
  final status = vehicleRenewalStatus(renewal, today);
  final days = renewal.validTill
      .difference(DateTime(today.year, today.month, today.day))
      .inDays;
  if (status == VehicleRenewalStatus.expired) {
    return days == -1 ? 'Overdue since yesterday' : 'Overdue by ${-days} days';
  }
  return switch (days) {
    0 => 'Due today',
    1 => 'Due tomorrow',
    _ => 'Due ${Dates.dayMonth(renewal.validTill)}',
  };
}

/// A recognisable icon per renewal kind.
IconData vehicleRenewalKindIcon(VehicleRenewalKind kind) => switch (kind) {
      VehicleRenewalKind.insurance => Symbols.shield_rounded,
      VehicleRenewalKind.puc => Symbols.eco_rounded,
      VehicleRenewalKind.registration => Symbols.badge_rounded,
      VehicleRenewalKind.permit => Symbols.assignment_rounded,
    };

/// The lead times the Renewals editor offers — the same choices Documents
/// gives an expiring record.
const List<int> vehicleRenewalReminderChoices = [0, 7, 15, 30, 60, 90];

/// "30 days before" — how a reminder lead reads in the editor.
String vehicleRenewalReminderLabel(int days) => switch (days) {
      0 => 'On the day',
      1 => '1 day before',
      _ => '$days days before',
    };

/// "14.2 km/l" / "—" once fewer than two fill-ups exist to divide between.
String kmPerLitreLabel(double? value) =>
    value == null ? '—' : '${value.toStringAsFixed(1)} km/l';

/// "30.5 L" — how a litres field reads once parsed back, matching
/// `amountFieldText`'s trailing-zero trim for money.
String litresLabel(double litres) {
  final text = litres.toStringAsFixed(2);
  final trimmed = text.contains('.')
      ? text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '')
      : text;
  return '$trimmed L';
}
