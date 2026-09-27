import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../../finance/presentation/transaction_labels.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../domain/entities/fuel_log.dart';

/// What the sheet collected. Null from [showAddFuelSheet] means the user
/// backed out.
class FuelDraft {
  const FuelDraft(this.log);

  final NewFuelLog log;
}

/// Date, litres, cost and odometer reading (section 6.9's "Add fuel").
Future<FuelDraft?> showAddFuelSheet(
  BuildContext context, {
  required int currentOdometerKm,
}) {
  return showModalBottomSheet<FuelDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _AddFuelSheet(currentOdometerKm: currentOdometerKm),
  );
}

class _AddFuelSheet extends ConsumerStatefulWidget {
  const _AddFuelSheet({required this.currentOdometerKm});

  final int currentOdometerKm;

  @override
  ConsumerState<_AddFuelSheet> createState() => _AddFuelSheetState();
}

class _AddFuelSheetState extends ConsumerState<_AddFuelSheet> {
  DateTime? _date;
  late final TextEditingController _odometer =
      TextEditingController(text: '${widget.currentOdometerKm}');
  final TextEditingController _litres = TextEditingController();
  final TextEditingController _cost = TextEditingController();

  DateTime get _effectiveDate => _date ?? ref.read(clockProvider).today();

  bool get _canSave =>
      (double.tryParse(_litres.text) ?? 0) > 0 &&
      int.tryParse(_odometer.text) != null;

  @override
  void initState() {
    super.initState();
    for (final controller in [_odometer, _litres, _cost]) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _odometer.dispose();
    _litres.dispose();
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
      FuelDraft(
        NewFuelLog(
          date: _effectiveDate,
          litres: double.parse(_litres.text),
          costMinor: parseAmountMinor(_cost.text),
          odometerKm: int.parse(_odometer.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Add fuel',
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
        const _Label('Litres'),
        const SizedBox(height: 8),
        TextField(
          controller: _litres,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Litres filled'),
        ),
        const SizedBox(height: 14),
        const _Label('Cost'),
        const SizedBox(height: 8),
        TextField(
          controller: _cost,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(prefixText: '₹ ', hintText: 'Amount'),
        ),
        const SizedBox(height: 14),
        const _Label('Odometer (km)'),
        const SizedBox(height: 8),
        TextField(
          controller: _odometer,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(hintText: 'Odometer reading'),
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
