import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../shared/state/toast_controller.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/vehicle_repository_impl.dart';
import '../../domain/entities/vehicle.dart';
import 'vehicle_form.dart';

/// Opens the New vehicle sheet — the Vehicle screen's own empty state lands
/// here, since v1 offers no other way to add one (D10 keeps the model
/// multi-vehicle, but nothing in this UI creates a second row).
Future<void> showNewVehicleSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const NewVehicleSheet(),
  );
}

class NewVehicleSheet extends ConsumerStatefulWidget {
  const NewVehicleSheet({super.key});

  @override
  ConsumerState<NewVehicleSheet> createState() => _NewVehicleSheetState();
}

class _NewVehicleSheetState extends ConsumerState<NewVehicleSheet> {
  late final VehicleFormController _form = VehicleFormController()
    ..addListener(_onChanged);

  @override
  void dispose() {
    _form
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _save() async {
    if (!_form.isValid) return;

    final repository = ref.read(vehicleRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final draft = _form.toDraft();

    Navigator.of(context).pop();
    final vehicle = await repository.create(
      NewVehicle(
        name: draft.name,
        makeModel: draft.makeModel,
        registration: draft.registration,
        odometerKm: draft.odometerKm,
        purchaseDate: draft.purchaseDate,
      ),
    );
    toast.show('Added “${vehicle.name}”');
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Add vehicle',
      children: [
        VehicleFormFields(controller: _form),
        const SizedBox(height: 18),
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
                onPressed: _form.isValid ? () => unawaited(_save()) : null,
                child: const Text('Create'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
