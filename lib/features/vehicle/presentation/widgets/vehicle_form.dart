import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/kosha_chip.dart';
import '../../domain/entities/vehicle.dart';

/// Everything the New vehicle sheet and the Edit vehicle screen collect. Kept
/// in one widget so the two can never fall out of step — the same split
/// `BillFormController`/`BillFormFields` make for bills.
class VehicleDraft {
  const VehicleDraft({
    required this.name,
    required this.makeModel,
    required this.registration,
    required this.odometerKm,
    this.purchaseDate,
  });

  final String name;
  final String makeModel;
  final String registration;
  final int odometerKm;
  final DateTime? purchaseDate;
}

class VehicleFormController extends ChangeNotifier {
  VehicleFormController({Vehicle? vehicle})
      : name = TextEditingController(text: vehicle?.name ?? ''),
        makeModel = TextEditingController(text: vehicle?.makeModel ?? ''),
        registration = TextEditingController(text: vehicle?.registration ?? ''),
        odometer = TextEditingController(
          text: vehicle == null ? '0' : '${vehicle.odometerKm}',
        ),
        purchaseDate = vehicle?.purchaseDate {
    for (final controller in [name, makeModel, registration, odometer]) {
      controller.addListener(notifyListeners);
    }
  }

  final TextEditingController name;
  final TextEditingController makeModel;
  final TextEditingController registration;
  final TextEditingController odometer;
  DateTime? purchaseDate;

  bool get isValid =>
      name.text.trim().isNotEmpty &&
      makeModel.text.trim().isNotEmpty &&
      registration.text.trim().isNotEmpty &&
      int.tryParse(odometer.text) != null;

  VehicleDraft toDraft() => VehicleDraft(
        name: name.text.trim(),
        makeModel: makeModel.text.trim(),
        registration: registration.text.trim(),
        odometerKm: int.tryParse(odometer.text) ?? 0,
        purchaseDate: purchaseDate,
      );

  void set(void Function() change) {
    change();
    notifyListeners();
  }

  @override
  void dispose() {
    name.dispose();
    makeModel.dispose();
    registration.dispose();
    odometer.dispose();
    super.dispose();
  }
}

/// The fields themselves, as a list the host drops into its own scroller.
class VehicleFormFields extends ConsumerWidget {
  const VehicleFormFields({super.key, required this.controller});

  final VehicleFormController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseDate = controller.purchaseDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Name, e.g. My Honda City'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.makeModel,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Make and model'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.registration,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Registration number'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.odometer,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            suffixText: 'km',
            hintText: 'Odometer reading',
          ),
        ),
        const SizedBox(height: 16),
        const _Label('Purchased on (optional)'),
        const SizedBox(height: 8),
        Row(
          children: [
            KoshaChip(
              label: purchaseDate == null
                  ? 'No date'
                  : Dates.dayMonthYear(purchaseDate),
              icon: Symbols.event_rounded,
              selected: false,
              onTap: () => unawaited(_pickDate(context, ref)),
            ),
            if (purchaseDate != null) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Clear date',
                icon: const Icon(Symbols.close_rounded, size: 18),
                onPressed: () =>
                    controller.set(() => controller.purchaseDate = null),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.purchaseDate ?? today,
      firstDate: DateTime(today.year - 30),
      lastDate: today,
    );
    if (picked == null) return;
    controller.set(
      () => controller.purchaseDate =
          DateTime(picked.year, picked.month, picked.day),
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
