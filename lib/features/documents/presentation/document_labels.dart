import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/status_pill.dart';
import '../domain/entities/document.dart';

/// The shared status vocabulary's value for a document's derived status.
///
/// [DocumentStatus.noExpiry] maps to [KoshaStatus.valid] because the pill has
/// no fifth colour to give it and "nothing to worry about" is the right
/// reading — [documentStatusLabel] is where the two stop looking alike.
KoshaStatus documentPillStatus(DocumentStatus status) => switch (status) {
      DocumentStatus.expired => KoshaStatus.expired,
      DocumentStatus.expiring => KoshaStatus.expiring,
      DocumentStatus.valid || DocumentStatus.noExpiry => KoshaStatus.valid,
    };

/// "Expires in 15 days" / "Expired 3 days ago" / "No expiry" — what the pill
/// actually says (Appendix A's document detail).
String documentStatusLabel(Document document, DateTime today) {
  final days = daysUntilExpiry(document, today);
  if (days == null) return 'No expiry';
  return switch (days) {
    0 => 'Expires today',
    1 => 'Expires tomorrow',
    -1 => 'Expired yesterday',
    < 0 => 'Expired ${-days} days ago',
    _ => 'Expires in $days days',
  };
}

/// The short form a grid tile has room for: "15 days", "Expired", "No expiry".
String documentTileStatusLabel(Document document, DateTime today) {
  final days = daysUntilExpiry(document, today);
  if (days == null) return 'No expiry';
  if (days < 0) return 'Expired';
  if (days == 0) return 'Today';
  return '$days ${days == 1 ? 'day' : 'days'}';
}

/// The line under a document's name in a list: its number if it has one, else
/// when it was issued, else its category.
String documentSubtitle(Document document) {
  final number = document.number;
  if (number != null && number.isNotEmpty) return number;
  final issued = document.issuedOn;
  if (issued != null) return 'Issued ${Dates.dayMonthYear(issued)}';
  return document.category.label;
}

/// A recognisable icon per category — the prototype's document tiles are
/// distinguishable at a glance rather than eight identical folders.
IconData documentCategoryIcon(DocumentCategory category) => switch (category) {
      DocumentCategory.identity => Symbols.badge_rounded,
      DocumentCategory.financial => Symbols.account_balance_rounded,
      DocumentCategory.insurance => Symbols.shield_rounded,
      DocumentCategory.vehicle => Symbols.directions_car_rounded,
      DocumentCategory.education => Symbols.school_rounded,
      DocumentCategory.property => Symbols.apartment_rounded,
      DocumentCategory.medical => Symbols.health_and_safety_rounded,
      DocumentCategory.other => Symbols.description_rounded,
    };

/// "30 days before" — how a reminder lead reads in a form row.
String reminderLeadLabel(int days) => switch (days) {
      0 => 'On the day',
      1 => '1 day before',
      _ => '$days days before',
    };

/// The lead times the Add and Edit forms offer. Thirty is the default §5.1
/// gives documents; the rest bracket it for things that renew on shorter or
/// longer notice.
const List<int> documentReminderLeadChoices = [0, 7, 15, 30, 60, 90];
