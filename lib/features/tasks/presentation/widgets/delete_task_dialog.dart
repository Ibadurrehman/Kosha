import 'package:flutter/material.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../domain/entities/task.dart';

/// Confirms deleting a task. Returns true when the user chose Delete.
///
/// The copy differs for a repeating task, which loses its future occurrences
/// as well. Deleting is still undoable from the toast that follows, so the
/// dialog says so rather than warning that it is permanent.
Future<bool> showDeleteTaskDialog(
  BuildContext context, {
  required Task task,
}) async {
  final c = context.kosha;
  final body = task.repeats
      ? '“${task.title}” repeats. Deleting it removes the future repeats too.'
      : '“${task.title}” will be removed from your lists.';

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete this task?'),
      content: Text('$body You can undo this straight away.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Keep it'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(foregroundColor: c.error),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
