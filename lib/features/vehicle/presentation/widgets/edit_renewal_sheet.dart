import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../domain/entities/vehicle_renewal.dart';
import '../vehicle_labels.dart';

/// What the sheet collected. Null from [showEditRenewalSheet] means the user
/// backed out.
class RenewalDraft {
  const RenewalDraft({required this.validTill, required this.reminderOffsetDays});

  final DateTime validTill;
  final int reminderOffsetDays;
}

/// Sets or renews one kind's due date and reminder lead — the Renewals
/// editor's own row opens this (section 6.9).
Future<RenewalDraft?> showEditRenewalSheet(
  BuildContext context, {
  required VehicleRenewalKind kind,
  VehicleRenewal? existing,
}) {
  return showModalBottomSheet<RenewalDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _EditRenewalSheet(kind: kind, existing: existing),
  );
}

class _EditRenewalSheet extends ConsumerStatefulWidget {
  const _EditRenewalSheet({required this.kind, this.existing});

  final VehicleRenewalKind kind;
  final VehicleRenewal? existing;

  @override
  ConsumerState<_EditRenewalSheet> createState() => _EditRenewalSheetState();
}

class _EditRenewalSheetState extends ConsumerState<_EditRenewalSheet> {
  late DateTime? _validTill = widget.existing?.validTill;
  late int _reminderOffsetDays = widget.existing?.reminderOffsetDays ??
      defaultVehicleRenewalReminderDays;

  Future<void> _pickDate() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _validTill ?? today,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 10),
    );
    if (picked != null && mounted) {
      setState(() => _validTill = DateTime(picked.year, picked.month, picked.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    final validTill = _validTill;

    return SheetScaffold(
      title: '${widget.kind.label} renewal',
      children: [
        const _Label('Valid till'),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: KoshaChip(
            label: validTill == null ? 'Pick a date' : Dates.dayMonthYear(validTill),
            icon: Symbols.event_rounded,
            selected: false,
            onTap: () => unawaited(_pickDate()),
          ),
        ),
        const SizedBox(height: 16),
        const _Label('Remind me'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final days in vehicleRenewalReminderChoices)
              KoshaChip(
                label: vehicleRenewalReminderLabel(days),
                selected: _reminderOffsetDays == days,
                onTap: () => setState(() => _reminderOffsetDays = days),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            IconButton(
              onPressed: Navigator.of(context).pop,
              tooltip: 'Cancel',
              icon: const Icon(Symbols.close_rounded),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: validTill == null
                    ? null
                    : () => Navigator.of(context).pop(
                          RenewalDraft(
                            validTill: validTill,
                            reminderOffsetDays: _reminderOffsetDays,
                          ),
                        ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: context.kosha.text2),
        ),
      );
}
