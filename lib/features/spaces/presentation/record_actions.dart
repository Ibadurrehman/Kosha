import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../shared/state/toast_controller.dart';
import '../data/record_repository_impl.dart';
import '../domain/entities/custom_record.dart';
import '../domain/entities/record_template.dart';

Future<void> deleteRecord(WidgetRef ref, CustomRecord record) async {
  final repository = ref.read(recordRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  await repository.deleteRecord(record.id);
  toast.show(
    'Deleted “${record.title}”',
    onUndo: () => unawaited(repository.restoreRecord(record.id)),
  );
}

/// Confirms first, then deletes with an undo — the shape maintenance jobs and
/// appliances use.
Future<void> confirmAndDeleteRecord(
  BuildContext context,
  WidgetRef ref,
  CustomRecord record,
) async {
  final confirmed = await _confirm(
    context,
    title: 'Delete “${record.title}”?',
    body: 'You can undo this straight away.',
  );
  if (!confirmed || !context.mounted) return;
  await deleteRecord(ref, record);
}

/// Deleting a record type keeps its records, so the undo is one row write and
/// the toast can promise what it actually does (see [RecordRepository]).
Future<void> confirmAndDeleteTemplate(
  BuildContext context,
  WidgetRef ref,
  RecordTemplate template, {
  required int recordCount,
}) async {
  final confirmed = await _confirm(
    context,
    title: 'Delete “${template.name}”?',
    body: recordCount == 0
        ? 'You can undo this straight away.'
        : 'Its $recordCount ${recordCount == 1 ? 'record' : 'records'} go '
            'with it. Undo brings them all back.',
  );
  if (!confirmed || !context.mounted) return;

  final repository = ref.read(recordRepositoryProvider);
  final toast = ref.read(toastControllerProvider.notifier);

  await repository.deleteTemplate(template.id);
  toast.show(
    'Deleted “${template.name}”',
    onUndo: () => unawaited(repository.restoreTemplate(template.id)),
  );
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String body,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Keep it'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: dialogContext.kosha.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return confirmed == true;
}
