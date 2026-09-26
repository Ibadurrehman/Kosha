import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../../finance/presentation/transaction_labels.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../domain/entities/service_record.dart';

/// What the sheet collected. Null from [showAddServiceSheet] means the user
/// backed out.
class ServiceDraft {
  const ServiceDraft(this.record);

  final NewServiceRecord record;
}

/// Date, odometer reading, description and cost (section 6.9's "Add service").
Future<ServiceDraft?> showAddServiceSheet(
  BuildContext context, {
  required int currentOdometerKm,
}) {
  return showModalBottomSheet<ServiceDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _AddServiceSheet(currentOdometerKm: currentOdometerKm),
  );
}

class _AddServiceSheet extends ConsumerStatefulWidget {
  const _AddServiceSheet({required this.currentOdometerKm});

  final int currentOdometerKm;

  @override
  ConsumerState<_AddServiceSheet> createState() => _AddServiceSheetState();
}

class _AddServiceSheetState extends ConsumerState<_AddServiceSheet> {
  DateTime? _date;
  late final TextEditingController _odometer =
      TextEditingController(text: '${widget.currentOdometerKm}');
  final TextEditingController _description = TextEditingController();
  final TextEditingController _cost = TextEditingController();

  DateTime get _effectiveDate => _date ?? ref.read(clockProvider).today();

  bool get _canSave =>
      _description.text.trim().isNotEmpty && int.tryParse(_odometer.text) != null;

  @override
  void initState() {
    super.initState();
    for (final controller in [_odometer, _description, _cost]) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _odometer.dispose();
    _description.dispose();
    _cost.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _effectiveDate,
      firstDate: DateTime(today.year - 20),
      lastDate: today,
    );
    if (picked != null && mounted) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  void _save() {
    Navigator.of(context).pop(
      ServiceDraft(
        NewServiceRecord(
          date: _effectiveDate,
          odometerKm: int.parse(_odometer.text),
          description: _description.text.trim(),
          costMinor: parseAmountMinor(_cost.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Add service',
      children: [
        const _Label('Date'),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: KoshaChip(
            label: Dates.dayMonthYear(_effectiveDate),
            icon: Symbols.event_rounded,
            selected: false,
            onTap: _pickDate,
          ),
        ),
        const SizedBox(height: 14),
        const _Label('Odometer (km)'),
        const SizedBox(height: 8),
        TextField(
          controller: _odometer,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Odometer reading'),
        ),
        const SizedBox(height: 14),
        const _Label('What was done'),
        const SizedBox(height: 8),
        TextField(
          controller: _description,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'e.g. Periodic service'),
        ),
        const SizedBox(height: 14),
        const _Label('Cost'),
        const SizedBox(height: 8),
        TextField(
          controller: _cost,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(prefixText: '₹ ', hintText: 'Amount'),
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
                onPressed: _canSave ? _save : null,
                child: const Text('Add'),
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
