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
import '../domain/entities/custom_record.dart';
import '../domain/entities/record_template.dart';
import 'controllers/record_providers.dart';
import 'record_actions.dart';
import 'record_labels.dart';
import 'space_icons.dart';
import 'widgets/record_editor_sheet.dart';

/// One record type's rows — Appendix A's "Custom records" screen, titled with
/// the template's own name ("My Insurance") rather than the feature's.
class CustomRecordsScreen extends ConsumerWidget {
  const CustomRecordsScreen({super.key, required this.templateId});

  final String templateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = ref.watch(recordTemplateProvider(templateId));
    final records = ref.watch(recordsOfTemplateProvider(templateId));
    final today = ref.watch(clockProvider).today();

    return template.when(
      loading: () => const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(KoshaSpace.screen),
          child: SkeletonList(),
        ),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this record type",
          body: 'Something went wrong reading the database.',
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(recordTemplateProvider(templateId)),
        ),
      ),
      // Null means deleted — including deleted from this very screen's own
      // menu, which is why this is a real state and not an error.
      data: (value) => value == null
          ? Scaffold(
              appBar: AppBar(),
              body: const EmptyState(
                icon: Symbols.dataset_rounded,
                title: 'This record type is gone',
                body: 'It was deleted. Undo from the toast brings it back.',
              ),
            )
          : _Loaded(
              template: value,
              records: records.value ?? const [],
              loading: records.isLoading,
              today: today,
            ),
    );
  }
}

class _Loaded extends ConsumerWidget {
  const _Loaded({
    required this.template,
    required this.records,
    required this.loading,
    required this.today,
  });

  final RecordTemplate template;
  final List<CustomRecord> records;
  final bool loading;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(template.name),
        actions: [
          IconButton(
            tooltip: 'Add record',
            icon: const Icon(Symbols.add_rounded),
            onPressed: () => unawaited(
              showRecordEditorSheet(context, template: template),
            ),
          ),
          IconButton(
            tooltip: 'Delete record type',
            icon: const Icon(Symbols.delete_rounded),
            onPressed: () => unawaited(
              _deleteTemplate(context, ref),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          KoshaSpace.screen,
          KoshaSpace.md,
          KoshaSpace.screen,
          KoshaSpace.xxxl,
        ),
        children: [
          Text(
            'Everything you keep under ${template.name}, with the fields you '
            'chose for it.',
            style: t.bodyMedium?.copyWith(color: c.text2),
          ),
          const SizedBox(height: KoshaSpace.lg),
          if (loading)
            const SkeletonList(rows: 2)
          else if (records.isEmpty)
            EmptyState(
              icon: spaceIcon(template.iconKey),
              title: 'No records yet',
              body: 'Add the first one and it will show the fields you set up.',
              actionLabel: 'Add record',
              onAction: () => unawaited(
                showRecordEditorSheet(context, template: template),
              ),
            )
          else
            for (final record in records)
              Padding(
                padding: const EdgeInsets.only(bottom: KoshaSpace.md),
                child: _RecordCard(
                  record: record,
                  template: template,
                  today: today,
                  onTap: () => unawaited(
                    showRecordEditorSheet(
                      context,
                      template: template,
                      existing: record,
                    ),
                  ),
                  onDelete: () => unawaited(
                    confirmAndDeleteRecord(context, ref, record),
                  ),
                ),
              ),
          const SizedBox(height: KoshaSpace.lg),
          _FieldsCard(
            template: template,
            onEdit: () => context.push(Routes.recordTemplateFields(template.id)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTemplate(BuildContext context, WidgetRef ref) async {
    await confirmAndDeleteTemplate(
      context,
      ref,
      template,
      recordCount: records.length,
    );
    if (context.mounted && context.canPop()) context.pop();
  }
}

/// Title, pill, and the template's fields with their values — Appendix A's
/// "3 record cards (title, pill, 4 fields)".
class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.record,
    required this.template,
    required this.today,
    required this.onTap,
    required this.onDelete,
  });

  final CustomRecord record;
  final RecordTemplate template;
  final DateTime today;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final status = recordRenewalStatus(record, today);
    final label = recordStatusLabel(record, today);
    // Only fields that were actually filled in: an empty row would be the
    // card asking a question rather than answering one.
    final filled = [
      for (final field in template.fields)
        if (record.value(field.key) case final value?) (field, value),
    ];

    return InkWell(
      onTap: onTap,
      onLongPress: onDelete,
      borderRadius: BorderRadius.circular(KoshaRadius.card),
      child: Container(
        padding: const EdgeInsets.all(KoshaSpace.md),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(KoshaRadius.card),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    record.title,
                    style: t.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (label != null) ...[
                  const SizedBox(width: KoshaSpace.sm),
                  StatusPill(recordPillStatus(status), label: label),
                ],
              ],
            ),
            if (filled.isNotEmpty) ...[
              const SizedBox(height: KoshaSpace.sm),
              for (final (field, value) in filled)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          field.label,
                          style: t.bodySmall?.copyWith(color: c.text2),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          formatRecordValue(field.type, value),
                          style: t.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "Fields in this record" + Edit fields (Appendix A). It is the only way into
/// the template builder, and it doubles as the explanation of what a record
/// type *is*.
class _FieldsCard extends StatelessWidget {
  const _FieldsCard({required this.template, required this.onEdit});

  final RecordTemplate template;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(KoshaSpace.md),
      decoration: BoxDecoration(
        color: c.sunk,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Fields in this record', style: t.titleSmall),
          const SizedBox(height: KoshaSpace.sm),
          if (template.fields.isEmpty)
            Text(
              'No fields yet — every record here is just a title.',
              style: t.bodySmall?.copyWith(color: c.text2),
            )
          else
            Wrap(
              spacing: KoshaSpace.sm,
              runSpacing: KoshaSpace.sm,
              children: [
                for (final field in template.fields)
                  KoshaChip(
                    label:
                        field.isRequired ? '${field.label} *' : field.label,
                    selected: false,
                    onTap: onEdit,
                  ),
              ],
            ),
          const SizedBox(height: KoshaSpace.md),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Symbols.tune_rounded, size: 18),
              label: const Text('Edit fields'),
            ),
          ),
        ],
      ),
    );
  }
}
