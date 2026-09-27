import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/widgets.dart';
import '../../documents/presentation/widgets/new_document_sheet.dart';
import '../../finance/presentation/widgets/new_expense_sheet.dart';
import '../../tasks/presentation/widgets/new_task_sheet.dart';
import '../domain/entities/service_record.dart';
import '../domain/entities/vehicle.dart';
import '../domain/entities/vehicle_renewal.dart';
import 'controllers/vehicle_providers.dart';
import 'vehicle_actions.dart';
import 'vehicle_labels.dart';
import 'widgets/new_vehicle_sheet.dart';

/// The Vehicle overview (section 6.9): header, 3 stat tiles, service
/// history, fuel this month, and the 4 actions the prototype offers.
class VehicleScreen extends ConsumerWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(primaryVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle'),
        actions: [
          if (vehicle.value != null)
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Symbols.edit_rounded),
              onPressed: () => context.push(Routes.vehicleEdit),
            ),
        ],
      ),
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
            ? EmptyState(
                icon: Symbols.directions_car_rounded,
                title: 'No vehicle yet',
                body: 'Add one to track its insurance, PUC, service history '
                    'and fuel.',
                actionLabel: 'Add vehicle',
                onAction: () => unawaited(showNewVehicleSheet(context)),
              )
            : _VehicleBody(vehicle: loaded),
      ),
    );
  }
}

class _VehicleBody extends ConsumerWidget {
  const _VehicleBody({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renewals = ref.watch(vehicleRenewalsProvider(vehicle.id));
    final history = ref.watch(serviceHistoryProvider(vehicle.id));
    final fuel = ref.watch(fuelMonthSummaryProvider(vehicle.id));
    final today = ref.watch(clockProvider).today();
    final byKind = {
      for (final renewal in renewals.value ?? const <VehicleRenewal>[])
        renewal.kind: renewal,
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        0,
        KoshaSpace.screen,
        KoshaSpace.xxxl,
      ),
      children: [
        _Header(vehicle: vehicle),
        const SizedBox(height: KoshaSpace.xl),
        _Stats(
          vehicle: vehicle,
          insurance: byKind[VehicleRenewalKind.insurance],
          puc: byKind[VehicleRenewalKind.puc],
          today: today,
          onOpenRenewals: () => context.push(Routes.vehicleRenewals),
        ),
        const SizedBox(height: KoshaSpace.xxl),
        const SectionLabel('Service history'),
        const SizedBox(height: KoshaSpace.sm),
        history.when(
          loading: () => const SkeletonList(rows: 2),
          error: (_, _) => const _SectionError(),
          data: (list) => list.isEmpty
              ? const _SectionEmpty(text: 'No service logged yet.')
              : Column(
                  children: [
                    for (final record in list.take(3))
                      Padding(
                        padding: const EdgeInsets.only(bottom: KoshaSpace.sm),
                        child: _ServiceRow(record: record),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: KoshaSpace.xxl),
        const SectionLabel('Fuel this month'),
        const SizedBox(height: KoshaSpace.sm),
        fuel.when(
          loading: () => const SkeletonList(rows: 1),
          error: (_, _) => const _SectionError(),
          data: (summary) => _FuelSummary(summary: summary),
        ),
        const SizedBox(height: KoshaSpace.xxl),
        _Actions(vehicle: vehicle),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: c.accentSoft,
            borderRadius: BorderRadius.circular(KoshaRadius.card),
          ),
          child: Icon(Symbols.directions_car_rounded, color: c.accent),
        ),
        const SizedBox(width: KoshaSpace.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(vehicle.name, style: t.titleLarge),
              const SizedBox(height: 2),
              Text(
                '${vehicle.registration} · ${vehicle.odometerKm} km',
                style: t.bodySmall?.copyWith(color: c.text3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({
    required this.vehicle,
    required this.insurance,
    required this.puc,
    required this.today,
    required this.onOpenRenewals,
  });

  final Vehicle vehicle;
  final VehicleRenewal? insurance;
  final VehicleRenewal? puc;
  final DateTime today;
  final VoidCallback onOpenRenewals;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: KoshaSpace.md,
      children: [
        Expanded(
          child: _Stat(
            label: 'Odometer',
            value: '${vehicle.odometerKm}',
            caption: 'km',
          ),
        ),
        Expanded(
          child: _RenewalStat(
            label: 'Insurance',
            renewal: insurance,
            today: today,
            onTap: onOpenRenewals,
          ),
        ),
        Expanded(
          child: _RenewalStat(
            label: 'PUC',
            renewal: puc,
            today: today,
            onTap: onOpenRenewals,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.caption});

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(KoshaSpace.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        border: Border.all(color: c.hair),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: t.labelSmall?.copyWith(color: c.text3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(value, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(
            caption,
            style: t.bodySmall?.copyWith(color: c.text3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RenewalStat extends StatelessWidget {
  const _RenewalStat({
    required this.label,
    required this.renewal,
    required this.today,
    required this.onTap,
  });

  final String label;
  final VehicleRenewal? renewal;
  final DateTime today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final renewal = this.renewal;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(KoshaRadius.card),
      child: Container(
        padding: const EdgeInsets.all(KoshaSpace.md),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(KoshaRadius.card),
          border: Border.all(color: c.hair),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: t.labelSmall?.copyWith(color: c.text3),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            if (renewal == null)
              Text('Not set', style: t.titleMedium?.copyWith(color: c.text3))
            else
              StatusPill(
                vehicleRenewalPillStatus(vehicleRenewalStatus(renewal, today)),
              ),
            const SizedBox(height: 4),
            Text(
              renewal == null
                  ? 'Tap to set'
                  : vehicleRenewalBadgeLabel(renewal, today),
              style: t.bodySmall?.copyWith(color: c.text3),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.record});

  final ServiceRecord record;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const IconTile(Symbols.build_rounded),
      title: Text(record.description),
      subtitle: Text(
        '${Dates.dayMonthYear(record.date)} · ${record.odometerKm} km',
      ),
      trailing: Text(
        Money.inr(record.costMinor),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: c.text2),
      ),
    );
  }
}

class _FuelSummary extends StatelessWidget {
  const _FuelSummary({required this.summary});

  final FuelMonthSummary summary;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;

    return Container(
      padding: const EdgeInsets.all(KoshaSpace.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        border: Border.all(color: c.hair),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FuelFigure(
              label: 'Spent',
              value: Money.inr(summary.totalCostMinor),
            ),
          ),
          Expanded(
            child: _FuelFigure(
              label: 'Fill-ups',
              value: '${summary.fillUps}',
            ),
          ),
          Expanded(
            child: _FuelFigure(
              label: 'Efficiency',
              value: kmPerLitreLabel(summary.kmPerLitre),
            ),
          ),
        ],
      ),
    );
  }
}

class _FuelFigure extends StatelessWidget {
  const _FuelFigure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.bodySmall?.copyWith(color: c.text3)),
        const SizedBox(height: 2),
        Text(value, style: t.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: KoshaSpace.sm,
      children: [
        Expanded(
          child: _ActionButton(
            icon: Symbols.build_rounded,
            label: 'Service',
            onTap: () => unawaited(
              addServiceRecord(
                context,
                ref,
                vehicleId: vehicle.id,
                currentOdometerKm: vehicle.odometerKm,
              ),
            ),
          ),
        ),
        Expanded(
          child: _ActionButton(
            icon: Symbols.local_gas_station_rounded,
            label: 'Fuel',
            onTap: () => unawaited(
              addFuelLog(
                context,
                ref,
                vehicleId: vehicle.id,
                currentOdometerKm: vehicle.odometerKm,
              ),
            ),
          ),
        ),
        Expanded(
          child: _ActionButton(
            icon: Symbols.account_balance_wallet_rounded,
            label: 'Expense',
            onTap: () => unawaited(
              showNewExpenseSheet(
                context,
                spaceId: vehicle.spaceId,
                vehicleId: vehicle.id,
              ),
            ),
          ),
        ),
        Expanded(
          child: _ActionButton(
            icon: Symbols.folder_shared_rounded,
            label: 'Document',
            onTap: () => unawaited(
              showNewDocumentSheet(context, spaceId: vehicle.spaceId),
            ),
          ),
        ),
        Expanded(
          child: _ActionButton(
            icon: Symbols.notifications_rounded,
            label: 'Reminder',
            onTap: () => unawaited(showNewTaskSheet(context)),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              IconTile(icon, size: 34, iconSize: 18),
              const SizedBox(height: 6),
              Text(
                label,
                style: t.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionEmpty extends StatelessWidget {
  const _SectionEmpty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KoshaSpace.md),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.text3),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError();

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KoshaSpace.md),
      child: Text(
        "Couldn't load this section.",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.error),
      ),
    );
  }
}
