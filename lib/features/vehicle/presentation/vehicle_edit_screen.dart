import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/vehicle_repository_impl.dart';
import '../domain/entities/vehicle.dart';
import 'controllers/vehicle_providers.dart';
import 'widgets/vehicle_form.dart';

/// Edits the one vehicle v1's UI manages, with the same fields the New
/// vehicle sheet collects.
class VehicleEditScreen extends ConsumerWidget {
  const VehicleEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(primaryVehicleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit vehicle')),
      body: vehicle.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load the vehicle",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(primaryVehicleProvider),
        ),
        data: (value) => value == null
            ? EmptyState(
                icon: Symbols.delete_rounded,
                title: 'There is no vehicle to edit',
                body: 'It was removed while you were editing it.',
                actionLabel: 'Back',
                onAction: () => context.pop(),
              )
            // Keyed on the row's identity so the form is built once from the
            // loaded values, never rebuilt out from under the user by a later
            // emission of the same stream.
            : _Form(key: ValueKey(value.id), vehicle: value),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late final VehicleFormController _form =
      VehicleFormController(vehicle: widget.vehicle)..addListener(_onChanged);

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

    await repository.edit(
      widget.vehicle.id,
      name: draft.name,
      makeModel: draft.makeModel,
      registration: draft.registration,
      odometerKm: draft.odometerKm,
      purchaseDate: draft.purchaseDate,
      clearPurchaseDate: draft.purchaseDate == null,
    );
    if (!mounted) return;
    toast.show('Saved');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              KoshaSpace.screen,
              12,
              KoshaSpace.screen,
              24,
            ),
            children: [VehicleFormFields(controller: _form)],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: BorderSide(color: c.border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: context.pop,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: _form.isValid ? () => unawaited(_save()) : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Save changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
