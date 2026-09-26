import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/state/toast_controller.dart';
import '../data/vehicle_repository_impl.dart';
import 'vehicle_labels.dart';
import 'widgets/add_fuel_sheet.dart';
import 'widgets/add_service_sheet.dart';

/// Opens the Add service sheet and logs whatever it collected. Nothing here
/// offers an undo — a service record is a fact about a moment, the same
/// reasoning `ServiceRecords`' doc comment gives for never editing one in
/// place.
Future<void> addServiceRecord(
  BuildContext context,
  WidgetRef ref, {
  required String vehicleId,
  required int currentOdometerKm,
}) async {
  final draft = await showAddServiceSheet(
    context,
    currentOdometerKm: currentOdometerKm,
  );
  if (draft == null) return;

  await ref
      .read(vehicleRepositoryProvider)
      .addServiceRecord(vehicleId, draft.record);
  ref.read(toastControllerProvider.notifier).show('Service logged');
}

/// Opens the Add fuel sheet and logs whatever it collected.
Future<void> addFuelLog(
  BuildContext context,
  WidgetRef ref, {
  required String vehicleId,
  required int currentOdometerKm,
}) async {
  final draft = await showAddFuelSheet(
    context,
    currentOdometerKm: currentOdometerKm,
  );
  if (draft == null) return;

  await ref.read(vehicleRepositoryProvider).addFuelLog(vehicleId, draft.log);
  ref.read(toastControllerProvider.notifier).show(
        'Logged ${litresLabel(draft.log.litres)}',
      );
}
