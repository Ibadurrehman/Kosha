import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/status_pill.dart';
import '../domain/entities/appliance.dart';
import '../domain/entities/maintenance_job.dart';

/// A recognisable icon per utility kind, keyed by [homeUtilityIconKeys].
IconData homeUtilityIcon(String iconKey) => switch (iconKey) {
      'bolt' => Symbols.bolt_rounded,
      'water_drop' => Symbols.water_drop_rounded,
      'local_fire_department' => Symbols.local_fire_department_rounded,
      'wifi' => Symbols.wifi_rounded,
      _ => Symbols.category_rounded,
    };

/// The shared status vocabulary's value for a job's *display* status —
/// [maintenanceJobDisplayStatus], never the raw stored one.
KoshaStatus maintenanceJobPillStatus(MaintenanceJobStatus status) =>
    switch (status) {
      MaintenanceJobStatus.overdue => KoshaStatus.overdue,
      MaintenanceJobStatus.active => KoshaStatus.active,
      MaintenanceJobStatus.done => KoshaStatus.done,
      MaintenanceJobStatus.upcoming => KoshaStatus.upcoming,
    };

/// "Due 6 Sep" / "No date set" — a job row's caption.
String maintenanceJobDueLabel(MaintenanceJob job) {
  final due = job.dueDate;
  if (due == null) return 'No date set';
  return 'Due ${Dates.dayMonth(due)}';
}

/// The shared status vocabulary's value for an appliance's warranty — the
/// same mapping `documentPillStatus` gives documents.
KoshaStatus appliancePillStatus(ApplianceWarrantyStatus status) =>
    switch (status) {
      ApplianceWarrantyStatus.expired => KoshaStatus.expired,
      ApplianceWarrantyStatus.expiring => KoshaStatus.expiring,
      ApplianceWarrantyStatus.valid ||
      ApplianceWarrantyStatus.noWarranty =>
        KoshaStatus.valid,
    };

/// "Warranty till 15 Mar 2028" / "No warranty on record" — an appliance row's
/// caption.
String applianceWarrantyLabel(Appliance appliance) {
  final till = appliance.warrantyTill;
  if (till == null) return 'No warranty on record';
  return 'Warranty till ${Dates.dayMonthYear(till)}';
}
