import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/services/notifications/reminder_scheduler.dart';
import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../../../core/utils/clock.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../spaces/domain/entities/space.dart';
import '../../../spaces/presentation/controllers/space_providers.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/document_repository_impl.dart';
import '../../domain/entities/attachment.dart';
import '../document_actions.dart';
import 'document_form.dart';

/// Opens the Add document sheet — Quick add's "Document" tile, the Documents
/// FAB and a space's Documents section all land here.
Future<void> showNewDocumentSheet(BuildContext context, {String? spaceId}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => NewDocumentSheet(spaceId: spaceId),
  );
}

class NewDocumentSheet extends ConsumerStatefulWidget {
  const NewDocumentSheet({super.key, this.spaceId});

  final String? spaceId;

  @override
  ConsumerState<NewDocumentSheet> createState() => _NewDocumentSheetState();
}

class _NewDocumentSheetState extends ConsumerState<NewDocumentSheet> {
  late final DocumentFormController _form = DocumentFormController()
    ..addListener(_onChanged);

  /// The file chosen before the document exists. It is written into the
  /// sandbox straight away — a picked file can be a temporary copy the OS
  /// clears — but only recorded once the document is saved.
  Attachment? _pending;
  bool _busy = false;
  late String? _spaceId = widget.spaceId;

  @override
  void dispose() {
    _form
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _capture(CaptureSource source) async {
    setState(() => _busy = true);
    try {
      final attachment = await captureAttachment(
        ref,
        source: source,
        // The document does not exist yet; the id is stamped on at save.
        documentId: '',
        fallbackName: _form.name.text.trim().isEmpty
            ? 'Scan'
            : _form.name.text.trim(),
      );
      if (!mounted || attachment == null) return;
      setState(() {
        _pending = attachment;
        // A file with a usable name saves the user typing one.
        if (_form.name.text.trim().isEmpty) {
          _form.name.text = _nameFromFile(attachment.fileName);
        }
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _nameFromFile(String fileName) {
    final dot = fileName.lastIndexOf('.');
    return dot <= 0 ? fileName : fileName.substring(0, dot);
  }

  Future<void> _save() async {
    if (!_form.isValid) return;

    final repository = ref.read(documentRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final scheduler = ref.read(reminderSchedulerProvider);
    final draft = _form.toDraft(spaceId: _spaceId);
    final pending = _pending;

    Navigator.of(context).pop();
    // Permission is asked for when a reminder is first set, not at launch —
    // the rule the task and bill sheets follow. A document with no expiry
    // reminds about nothing, so it never prompts.
    if (draft.expiresOn != null) unawaited(scheduler.requestPermission());

    final document = await repository.create(draft);
    if (pending != null) {
      await repository.addAttachment(
        document.id,
        pending.copyWith(ownerId: document.id),
      );
    }
    toast.show('Added “${document.name}”');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final today = ref.read(clockProvider).today();
    final spaces = ref.watch(spacesHoldingProvider(SpaceHolds.documents));

    return SheetScaffold(
      title: 'Add document',
      children: [
        const SizedBox(height: 6),
        Row(
          spacing: KoshaSpace.md,
          children: [
            Expanded(
              child: _CaptureTile(
                icon: Symbols.upload_file_rounded,
                label: 'Upload',
                enabled: !_busy,
                onTap: () => unawaited(_capture(CaptureSource.upload)),
              ),
            ),
            Expanded(
              child: _CaptureTile(
                icon: Symbols.document_scanner_rounded,
                label: 'Scan',
                enabled: !_busy,
                onTap: () => unawaited(_capture(CaptureSource.scan)),
              ),
            ),
          ],
        ),
        if (_pending case final attached?) ...[
          const SizedBox(height: KoshaSpace.md),
          Row(
            children: [
              Icon(Symbols.check_circle_rounded, size: 18, color: c.success),
              const SizedBox(width: KoshaSpace.sm),
              Expanded(
                child: Text(
                  '${attached.fileName} · ${attached.readableSize}',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _pending = null),
                child: const Text('Remove'),
              ),
            ],
          ),
        ],
        const SizedBox(height: KoshaSpace.lg),
        DocumentFormFields(controller: _form, today: today),
        if (spaces.value case final list? when list.isNotEmpty) ...[
          const SizedBox(height: KoshaSpace.lg),
          Text('Space', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: KoshaSpace.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final space in list)
                ChoiceChip(
                  label: Text(space.name),
                  selected: _spaceId == space.id,
                  onSelected: (_) => setState(
                    () => _spaceId = _spaceId == space.id ? null : space.id,
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: KoshaSpace.xl),
        Row(
          children: [
            IconButton(
              onPressed: Navigator.of(context).pop,
              tooltip: 'Cancel',
              icon: const Icon(Symbols.close_rounded),
            ),
            const SizedBox(width: KoshaSpace.sm),
            Expanded(
              child: FilledButton(
                onPressed:
                    _form.isValid && !_busy ? () => unawaited(_save()) : null,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CaptureTile extends StatelessWidget {
  const _CaptureTile({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Material(
      color: c.sunk,
      borderRadius: BorderRadius.circular(KoshaRadius.card),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KoshaRadius.card),
            border: Border.all(color: c.hair),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: enabled ? c.accent : c.disabled),
              const SizedBox(height: KoshaSpace.sm),
              Text(label, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
