import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../bills/domain/entities/bill.dart';
import '../../../bills/presentation/controllers/bill_providers.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/home_management_repository_impl.dart';
import '../../domain/entities/home_utility.dart';
import '../controllers/home_management_providers.dart';
import '../home_management_labels.dart';

/// Links one of the user's own bills into the Utilities row (section 6.10).
/// Only bills not already linked are offered — one utility per bill, the same
/// invariant `home_utilities_bill`'s unique index holds at the database.
Future<void> showNewUtilitySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const NewUtilitySheet(),
  );
}

class NewUtilitySheet extends ConsumerStatefulWidget {
  const NewUtilitySheet({super.key});

  @override
  ConsumerState<NewUtilitySheet> createState() => _NewUtilitySheetState();
}

class _NewUtilitySheetState extends ConsumerState<NewUtilitySheet> {
  Bill? _bill;
  late String _iconKey = homeUtilityIconKeys.first;
  late final TextEditingController _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canSave => _bill != null && _name.text.trim().isNotEmpty;

  void _pickBill(Bill bill) {
    setState(() {
      _bill = bill;
      if (_name.text.trim().isEmpty) _name.text = bill.name;
    });
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final repository = ref.read(homeManagementRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);

    Navigator.of(context).pop();
    final utility = await repository.addUtility(
      NewHomeUtility(
        name: _name.text.trim(),
        iconKey: _iconKey,
        billId: _bill!.id,
      ),
    );
    toast.show(
      'Added “${utility.name}”',
      onUndo: () => unawaited(repository.removeUtility(utility.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final allBills = ref.watch(allBillsProvider);
    final linked = ref.watch(homeUtilitiesProvider);
    final linkedBillIds = {
      for (final utility in linked.value ?? const <HomeUtility>[])
        utility.billId,
    };

    return SheetScaffold(
      title: 'Add utility',
      children: [
        const _Label('Bill'),
        const SizedBox(height: 8),
        allBills.when(
          loading: () => const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const Text('Could not load bills.'),
          data: (bills) {
            final available = [
              for (final bill in bills)
                if (!linkedBillIds.contains(bill.id)) bill,
            ];
            if (available.isEmpty) {
              return Text(
                'Every bill is already linked as a utility.',
                style: TextStyle(color: c.text3),
              );
            }
            return Column(
              children: [
                for (final bill in available)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _bill?.id == bill.id
                          ? Symbols.radio_button_checked_rounded
                          : Symbols.radio_button_unchecked_rounded,
                      color: _bill?.id == bill.id ? c.accent : c.text3,
                    ),
                    title: Text(bill.name),
                    onTap: () => _pickBill(bill),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        const _Label('Label'),
        const SizedBox(height: 8),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'e.g. Electricity'),
        ),
        const SizedBox(height: 14),
        const _Label('Icon'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final key in homeUtilityIconKeys)
              ChoiceChip(
                label: Icon(homeUtilityIcon(key), size: 20),
                selected: _iconKey == key,
                onSelected: (_) => setState(() => _iconKey = key),
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
                onPressed: _canSave ? () => unawaited(_save()) : null,
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
