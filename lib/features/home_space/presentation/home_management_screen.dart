import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/entities/appliance.dart';
import '../domain/entities/home_utility.dart';
import '../domain/entities/maintenance_job.dart';
import 'controllers/home_management_providers.dart';
import 'home_management_actions.dart';
import 'home_management_labels.dart';
import 'widgets/appliance_sheet.dart';
import 'widgets/maintenance_job_sheet.dart';
import 'widgets/new_utility_sheet.dart';

/// Home management (section 6.10): utilities, maintenance jobs and
/// appliances, the Home system space's own dedicated screen the way Vehicle
/// is Vehicle's.
class HomeManagementScreen extends ConsumerWidget {
  const HomeManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utilities = ref.watch(homeUtilitiesProvider);
    final jobs = ref.watch(maintenanceJobsProvider);
    final appliances = ref.watch(appliancesProvider);
    final today = ref.watch(clockProvider).today();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          KoshaSpace.screen,
          KoshaSpace.md,
          KoshaSpace.screen,
          KoshaSpace.xxxl,
        ),
        children: [
          SectionLabel(
            'Utilities',
            trailing: IconButton(
              tooltip: 'Add utility',
              icon: const Icon(Symbols.add_rounded),
              onPressed: () => unawaited(showNewUtilitySheet(context)),
            ),
          ),
          const SizedBox(height: KoshaSpace.sm),
          utilities.when(
            loading: () => const SkeletonList(rows: 2),
            error: (_, _) => const _SectionError(),
            data: (list) => list.isEmpty
                ? const _SectionEmpty(
                    text: 'Link a bill to see it here — Electricity, '
                        'Water, Gas or Internet.',
                  )
                : Column(
                    children: [
                      for (final utility in list)
                        Padding(
                          padding: const EdgeInsets.only(bottom: KoshaSpace.sm),
                          child: _UtilityRow(
                            utility: utility,
                            onTap: () => context.push(
                              Routes.billDetail(utility.billId),
                            ),
                            onRemove: () =>
                                unawaited(removeUtility(context, ref, utility)),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: KoshaSpace.xxl),
          SectionLabel(
            'Maintenance & repairs',
            trailing: IconButton(
              tooltip: 'Add maintenance job',
              icon: const Icon(Symbols.add_rounded),
              onPressed: () => unawaited(showMaintenanceJobSheet(context)),
            ),
          ),
          const SizedBox(height: KoshaSpace.sm),
          jobs.when(
            loading: () => const SkeletonList(rows: 2),
            error: (_, _) => const _SectionError(),
            data: (list) => list.isEmpty
                ? const _SectionEmpty(text: 'Nothing being worked on.')
                : Column(
                    children: [
                      for (final job in list)
                        Padding(
                          padding: const EdgeInsets.only(bottom: KoshaSpace.sm),
                          child: _JobRow(
                            job: job,
                            today: today,
                            onTap: () => unawaited(
                              showMaintenanceJobSheet(context, existing: job),
                            ),
                            onPromote: () =>
                                unawaited(promoteJobToTask(ref, job)),
                            onDelete: () => unawaited(
                              confirmAndDeleteJob(context, ref, job),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: KoshaSpace.xxl),
          SectionLabel(
            'Appliances',
            trailing: IconButton(
              tooltip: 'Add appliance',
              icon: const Icon(Symbols.add_rounded),
              onPressed: () => unawaited(showApplianceSheet(context)),
            ),
          ),
          const SizedBox(height: KoshaSpace.sm),
          appliances.when(
            loading: () => const SkeletonList(rows: 2),
            error: (_, _) => const _SectionError(),
            data: (list) => list.isEmpty
                ? const _SectionEmpty(text: 'No appliances on record yet.')
                : Column(
                    children: [
                      for (final appliance in list)
                        Padding(
                          padding: const EdgeInsets.only(bottom: KoshaSpace.sm),
                          child: _ApplianceRow(
                            appliance: appliance,
                            today: today,
                            onTap: () => unawaited(
                              showApplianceSheet(context, existing: appliance),
                            ),
                            onDelete: () => unawaited(
                              confirmAndDeleteAppliance(context, ref, appliance),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _UtilityRow extends StatelessWidget {
  const _UtilityRow({
    required this.utility,
    required this.onTap,
    required this.onRemove,
  });

  final HomeUtility utility;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
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
              IconTile(homeUtilityIcon(utility.iconKey)),
              const SizedBox(width: KoshaSpace.md),
              Expanded(
                child: Text(utility.name, style: Theme.of(context).textTheme.titleSmall),
              ),
              IconButton(
                tooltip: 'Remove',
                icon: const Icon(Symbols.link_off_rounded, size: 19),
                onPressed: onRemove,
              ),
              Icon(Symbols.chevron_right_rounded, color: c.text3),
            ],
          ),
        ),
      ),
    );
  }
}

class _JobRow extends StatelessWidget {
  const _JobRow({
    required this.job,
    required this.today,
    required this.onTap,
    required this.onPromote,
    required this.onDelete,
  });

  final MaintenanceJob job;
  final DateTime today;
  final VoidCallback onTap;
  final VoidCallback onPromote;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final displayStatus = maintenanceJobDisplayStatus(job, today);

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: t.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusPill(maintenanceJobPillStatus(displayStatus)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        maintenanceJobDueLabel(job),
                        if (job.vendor?.isNotEmpty ?? false) job.vendor!,
                      ].join(' · '),
                      style: t.bodySmall?.copyWith(color: c.text3),
                    ),
                  ],
                ),
              ),
              if (job.isPromoted)
                Icon(Symbols.task_alt_rounded, size: 19, color: c.success)
              else
                IconButton(
                  tooltip: 'Make a task',
                  icon: const Icon(Symbols.add_task_rounded, size: 19),
                  onPressed: onPromote,
                ),
              IconButton(
                tooltip: 'Delete',
                icon: Icon(Symbols.delete_rounded, size: 19, color: c.error),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplianceRow extends StatelessWidget {
  const _ApplianceRow({
    required this.appliance,
    required this.today,
    required this.onTap,
    required this.onDelete,
  });

  final Appliance appliance;
  final DateTime today;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final status = applianceWarrantyStatus(appliance, today);

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
              const IconTile(Symbols.home_repair_service_rounded),
              const SizedBox(width: KoshaSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appliance.name,
                      style: t.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      applianceWarrantyLabel(appliance),
                      style: t.bodySmall?.copyWith(color: c.text3),
                    ),
                  ],
                ),
              ),
              if (status != ApplianceWarrantyStatus.noWarranty)
                StatusPill(appliancePillStatus(status)),
              IconButton(
                tooltip: 'Delete',
                icon: Icon(Symbols.delete_rounded, size: 19, color: c.error),
                onPressed: onDelete,
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
