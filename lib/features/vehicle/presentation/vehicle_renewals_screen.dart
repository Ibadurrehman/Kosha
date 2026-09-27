import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/vehicle_repository_impl.dart';
import '../domain/entities/vehicle_renewal.dart';
import 'controllers/vehicle_providers.dart';
import 'vehicle_labels.dart';
import 'widgets/edit_renewal_sheet.dart';

/// One row per renewal kind (section 6.9): insurance, PUC, registration,
/// permit. Tapping a row opens the sheet that sets or renews it.
///
/// Takes no vehicle id: v1 manages exactly one vehicle, so this screen reads
/// [primaryVehicleProvider] itself rather than carrying an id through the
/// route, the same way [VehicleEditScreen] does.
class VehicleRenewalsScreen extends ConsumerWidget {
  const VehicleRenewalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(primaryVehicleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Renewals')),
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
        data: (loaded) => loaded == null
            ? const EmptyState(
                icon: Symbols.directions_car_rounded,
                title: 'No vehicle yet',
                body: 'Add one from the Vehicle screen before setting its '
                    'renewals.',
              )
            : _RenewalsBody(vehicleId: loaded.id),
      ),
    );
  }
}

class _RenewalsBody extends ConsumerWidget {
  const _RenewalsBody({required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renewals = ref.watch(vehicleRenewalsProvider(vehicleId));

    return renewals.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(KoshaSpace.screen),
        child: SkeletonList(),
      ),
      error: (_, _) => const Padding(
        padding: EdgeInsets.all(KoshaSpace.screen),
        child: _SectionError(),
      ),
      data: (list) {
        final byKind = {for (final renewal in list) renewal.kind: renewal};
        final today = ref.watch(clockProvider).today();
        return ListView(
          padding: const EdgeInsets.all(KoshaSpace.screen),
          children: [
            for (final kind in VehicleRenewalKind.values)
              Padding(
                padding: const EdgeInsets.only(bottom: KoshaSpace.md),
                child: _RenewalRow(
                  kind: kind,
                  renewal: byKind[kind],
                  today: today,
                  onTap: () => unawaited(
                    _edit(context, ref, kind: kind, existing: byKind[kind]),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, {
    required VehicleRenewalKind kind,
    VehicleRenewal? existing,
  }) async {
    final draft = await showEditRenewalSheet(
      context,
      kind: kind,
      existing: existing,
    );
    if (draft == null) return;

    await ref.read(vehicleRepositoryProvider).upsertRenewal(
          vehicleId,
          kind,
          validTill: draft.validTill,
          reminderOffsetDays: draft.reminderOffsetDays,
        );
    if (!context.mounted) return;
    ref.read(toastControllerProvider.notifier).show('Saved');
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError();

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Text(
      "Couldn't load renewals.",
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.error),
    );
  }
}

class _RenewalRow extends StatelessWidget {
  const _RenewalRow({
    required this.kind,
    required this.renewal,
    required this.today,
    required this.onTap,
  });

  final VehicleRenewalKind kind;
  final VehicleRenewal? renewal;
  final DateTime today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final renewal = this.renewal;

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(KoshaRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        child: Container(
          padding: const EdgeInsets.all(KoshaSpace.md),
          decoration: BoxDecoration(
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(KoshaRadius.card),
          ),
          child: Row(
            children: [
              IconTile(vehicleRenewalKindIcon(kind)),
              const SizedBox(width: KoshaSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kind.label, style: t.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      renewal == null
                          ? 'Not set'
                          : vehicleRenewalBadgeLabel(renewal, today),
                      style: t.bodySmall?.copyWith(color: c.text3),
                    ),
                  ],
                ),
              ),
              if (renewal != null)
                StatusPill(
                  vehicleRenewalPillStatus(vehicleRenewalStatus(renewal, today)),
                ),
              const SizedBox(width: 4),
              Icon(Symbols.chevron_right_rounded, color: c.text3),
            ],
          ),
        ),
      ),
    );
  }
}
