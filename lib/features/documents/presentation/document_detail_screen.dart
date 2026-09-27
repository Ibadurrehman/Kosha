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
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/document_repository_impl.dart';
import '../domain/entities/attachment.dart';
import '../domain/entities/document.dart';
import 'controllers/document_providers.dart';
import 'document_actions.dart';
import 'document_labels.dart';

/// Document detail (section 6.8): the file, the status pill, the fields, and
/// the four actions — View file / Replace / Set reminder / Archive.
class DocumentDetailScreen extends ConsumerWidget {
  const DocumentDetailScreen({super.key, required this.documentId});

  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentByIdProvider(documentId));
    final attachments =
        ref.watch(documentAttachmentsProvider(documentId)).value ?? const [];
    final today = ref.watch(clockProvider).today();

    return Scaffold(
      appBar: AppBar(
        title: Text(document.value?.category.label ?? 'Document'),
        actions: [
          if (attachments.isNotEmpty && document.value != null)
            IconButton(
              tooltip: 'Share',
              onPressed: () => unawaited(
                shareAttachment(
                  ref,
                  attachments.last,
                  subject: document.value!.name,
                ),
              ),
              icon: const Icon(Symbols.ios_share_rounded),
            ),
        ],
      ),
      body: document.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
          child: SkeletonList(),
        ),
        error: (error, _) => const EmptyState(
          icon: Symbols.error_rounded,
          title: "Couldn't load this document",
          body: 'Something went wrong reading the database.',
        ),
        data: (loaded) => loaded == null
            ? const EmptyState(
                icon: Symbols.folder_shared_rounded,
                title: 'This document is gone',
                body: 'It may have been archived from another screen.',
              )
            : _Body(
                document: loaded,
                attachments: attachments,
                today: today,
              ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.document,
    required this.attachments,
    required this.today,
  });

  final Document document;
  final List<Attachment> attachments;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final status = documentStatus(document, today);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        0,
        KoshaSpace.screen,
        KoshaSpace.xxxl,
      ),
      children: [
        _PreviewStrip(
          attachments: attachments,
          onOpen: (attachment) => unawaited(openAttachment(ref, attachment)),
        ),
        const SizedBox(height: KoshaSpace.lg),
        StatusPill(
          documentPillStatus(status),
          label: documentStatusLabel(document, today),
        ),
        const SizedBox(height: KoshaSpace.md),
        Text(document.name, style: t.headlineSmall),
        if (document.isArchived) ...[
          const SizedBox(height: KoshaSpace.sm),
          Text(
            'Archived · it reminds you about nothing while it is here.',
            style: t.bodySmall?.copyWith(color: c.text3),
          ),
        ],
        const SizedBox(height: KoshaSpace.xl),
        _Field(label: 'Category', value: document.category.label),
        _Field(label: 'Number', value: document.number),
        _Field(
          label: 'Issued on',
          value: document.issuedOn == null
              ? null
              : Dates.dayMonthYear(document.issuedOn!),
        ),
        _Field(
          label: 'Expires on',
          value: document.expiresOn == null
              ? 'Never'
              : Dates.dayMonthYear(document.expiresOn!),
        ),
        _Field(
          label: 'Reminder',
          value: document.expires
              ? reminderLeadLabel(document.reminderOffsetDays)
              : null,
        ),
        _Field(label: 'Notes', value: document.notes),
        const SizedBox(height: KoshaSpace.xl),
        _Actions(document: document, attachments: attachments),
      ],
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({required this.document, required this.attachments});

  final Document document;
  final List<Attachment> attachments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFile = attachments.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: KoshaSpace.sm,
      children: [
        FilledButton.icon(
          onPressed: hasFile
              ? () => unawaited(openAttachment(ref, attachments.last))
              : null,
          icon: const Icon(Symbols.visibility_rounded),
          label: Text(hasFile ? 'View file' : 'No file attached'),
        ),
        OutlinedButton.icon(
          onPressed: () => unawaited(_replace(context, ref)),
          icon: const Icon(Symbols.autorenew_rounded),
          label: Text(hasFile ? 'Replace file' : 'Attach a file'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(Routes.documentEdit(document.id)),
          icon: const Icon(Symbols.edit_rounded),
          label: const Text('Edit details'),
        ),
        if (document.isArchived)
          OutlinedButton.icon(
            onPressed: () => unawaited(_restore(context, ref)),
            icon: const Icon(Symbols.restart_alt_rounded),
            label: const Text('Restore'),
          )
        else
          OutlinedButton.icon(
            onPressed: () => unawaited(_archive(context, ref)),
            icon: const Icon(Symbols.inventory_2_rounded),
            label: const Text('Archive'),
          ),
      ],
    );
  }

  Future<void> _replace(BuildContext context, WidgetRef ref) async {
    final source = await showModalBottomSheet<CaptureSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Symbols.upload_file_rounded),
              title: const Text('Upload a file'),
              onTap: () => Navigator.of(context).pop(CaptureSource.upload),
            ),
            ListTile(
              leading: const Icon(Symbols.document_scanner_rounded),
              title: const Text('Scan pages'),
              onTap: () => Navigator.of(context).pop(CaptureSource.scan),
            ),
          ],
        ),
      ),
    );
    if (source == null || !context.mounted) return;

    final attachment = await captureAttachment(
      ref,
      source: source,
      documentId: document.id,
      fallbackName: document.name,
    );
    if (attachment == null || !context.mounted) return;

    await replaceAttachment(
      ref,
      documentId: document.id,
      replacement: attachment,
    );
    if (!context.mounted) return;
    ref
        .read(toastControllerProvider.notifier)
        .show(attachments.isEmpty ? 'File attached' : 'File replaced');
  }

  Future<void> _archive(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Archive “${document.name}”?'),
        content: const Text(
          'It moves to the archive and stops reminding you. The file stays on '
          'this device, and you can restore it at any time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final repository = ref.read(documentRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    await repository.archive(document.id);
    if (!context.mounted) return;
    context.go(Routes.documents);
    toast.show(
      'Archived “${document.name}”',
      onUndo: () => unawaited(repository.restore(document.id)),
    );
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    await ref.read(documentRepositoryProvider).restore(document.id);
    if (!context.mounted) return;
    ref.read(toastControllerProvider.notifier).show('Restored');
  }
}

/// The preview strip. Files are listed rather than thumbnailed: §8.4 wants
/// thumbnails eventually, but rendering a PDF's first page needs a renderer
/// this app does not ship, and a wrong-looking placeholder is worse than an
/// honest row that opens the real thing.
class _PreviewStrip extends StatelessWidget {
  const _PreviewStrip({required this.attachments, required this.onOpen});

  final List<Attachment> attachments;
  final void Function(Attachment) onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    if (attachments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(KoshaSpace.lg),
        decoration: BoxDecoration(
          color: c.sunk,
          borderRadius: BorderRadius.circular(KoshaRadius.card),
          border: Border.all(color: c.hair),
        ),
        child: Row(
          children: [
            Icon(Symbols.description_rounded, color: c.text3),
            const SizedBox(width: KoshaSpace.md),
            Expanded(
              child: Text(
                'No file attached yet.',
                style: t.bodySmall?.copyWith(color: c.text3),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final attachment in attachments)
          Padding(
            padding: const EdgeInsets.only(bottom: KoshaSpace.sm),
            child: Material(
              color: c.surface,
              borderRadius: BorderRadius.circular(KoshaRadius.card),
              child: InkWell(
                onTap: () => onOpen(attachment),
                borderRadius: BorderRadius.circular(KoshaRadius.card),
                child: Container(
                  padding: const EdgeInsets.all(KoshaSpace.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(KoshaRadius.card),
                    border: Border.all(color: c.hair),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        attachment.isPdf
                            ? Symbols.picture_as_pdf_rounded
                            : Symbols.image_rounded,
                        color: c.accent,
                      ),
                      const SizedBox(width: KoshaSpace.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attachment.fileName,
                              style: t.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              attachment.readableSize,
                              style: t.bodySmall?.copyWith(color: c.text3),
                            ),
                          ],
                        ),
                      ),
                      Icon(Symbols.chevron_right_rounded, color: c.text3),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final text = value;
    // A field the user never filled in is left out rather than shown empty:
    // the detail screen is a summary of what is known, not a form.
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    final c = context.kosha;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: KoshaSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: t.bodySmall?.copyWith(color: c.text3),
            ),
          ),
          Expanded(child: Text(text, style: t.bodyMedium)),
        ],
      ),
    );
  }
}
