import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/home_management_repository_impl.dart';
import '../../domain/entities/appliance.dart';

/// Add and edit share one sheet — the same reasoning `MaintenanceJobSheet`
/// gives: section 6.10 only names "Add appliance" as a screen.
Future<void> showApplianceSheet(BuildContext context, {Appliance? existing}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ApplianceSheet(existing: existing),
  );
}

class ApplianceSheet extends ConsumerStatefulWidget {
  const ApplianceSheet({super.key, this.existing});

  final Appliance? existing;

  @override
  ConsumerState<ApplianceSheet> createState() => _ApplianceSheetState();
}

class _ApplianceSheetState extends ConsumerState<ApplianceSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _makeModel =
      TextEditingController(text: widget.existing?.makeModel ?? '');
  late DateTime? _purchasedOn = widget.existing?.purchasedOn;
  late DateTime? _warrantyTill = widget.existing?.warrantyTill;
  late DateTime? _nextServiceOn = widget.existing?.nextServiceOn;

  @override
  void initState() {
    super.initState();
    for (final controller in [_name, _makeModel]) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _makeModel.dispose();
    super.dispose();
  }

  bool get _canSave => _name.text.trim().isNotEmpty;

  Future<DateTime?> _pick(DateTime? current, {required DateTime today}) =>
      showDatePicker(
        context: context,
        initialDate: current ?? today,
        firstDate: DateTime(today.year - 20),
        lastDate: DateTime(today.year + 20),
      );

  Future<void> _pickPurchasedOn() async {
    final today = ref.read(clockProvider).today();
    final picked = await _pick(_purchasedOn, today: today);
    if (picked != null && mounted) {
      setState(
        () => _purchasedOn = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }

  Future<void> _pickWarrantyTill() async {
    final today = ref.read(clockProvider).today();
    final picked = await _pick(_warrantyTill, today: today);
    if (picked != null && mounted) {
      setState(
        () => _warrantyTill = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }

  Future<void> _pickNextServiceOn() async {
    final today = ref.read(clockProvider).today();
    final picked = await _pick(_nextServiceOn, today: today);
    if (picked != null && mounted) {
      setState(
        () => _nextServiceOn = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final repository = ref.read(homeManagementRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final name = _name.text.trim();
    final makeModel = _makeModel.text.trim();

    Navigator.of(context).pop();

    final existing = widget.existing;
    if (existing == null) {
      await repository.createAppliance(
        NewAppliance(
          name: name,
          makeModel: makeModel.isEmpty ? null : makeModel,
          purchasedOn: _purchasedOn,
          warrantyTill: _warrantyTill,
          nextServiceOn: _nextServiceOn,
        ),
      );
      toast.show('Added “$name”');
    } else {
      await repository.editAppliance(
        existing.id,
        name: name,
        makeModel: makeModel.isEmpty ? null : makeModel,
        clearMakeModel: makeModel.isEmpty,
        purchasedOn: _purchasedOn,
        clearPurchasedOn: _purchasedOn == null,
        warrantyTill: _warrantyTill,
        clearWarrantyTill: _warrantyTill == null,
        nextServiceOn: _nextServiceOn,
        clearNextServiceOn: _nextServiceOn == null,
      );
      toast.show('Saved');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: widget.existing == null ? 'Add appliance' : 'Edit appliance',
      children: [
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'e.g. Refrigerator'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _makeModel,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: 'Brand and model (optional)',
          ),
        ),
        const SizedBox(height: 16),
        _DateRow(
          label: 'Purchased on',
          value: _purchasedOn,
          onPick: () => unawaited(_pickPurchasedOn()),
          onClear: () => setState(() => _purchasedOn = null),
        ),
        const SizedBox(height: 12),
        _DateRow(
          label: 'Warranty till',
          value: _warrantyTill,
          onPick: () => unawaited(_pickWarrantyTill()),
          onClear: () => setState(() => _warrantyTill = null),
        ),
        const SizedBox(height: 12),
        _DateRow(
          label: 'Next service on',
          value: _nextServiceOn,
          onPick: () => unawaited(_pickNextServiceOn()),
          onClear: () => setState(() => _nextServiceOn = null),
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
                onPressed: _canSave ? () => unawaited(_save()) : null,
                child: Text(widget.existing == null ? 'Add' : 'Save changes'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: context.kosha.text2),
          ),
        ),
        KoshaChip(
          label: value == null ? 'No date' : Dates.dayMonthYear(value!),
          icon: Symbols.event_rounded,
          selected: false,
          onTap: onPick,
        ),
        if (value != null)
          IconButton(
            tooltip: 'Clear date',
            icon: const Icon(Symbols.close_rounded, size: 18),
            onPressed: onClear,
          ),
      ],
    );
  }
}
