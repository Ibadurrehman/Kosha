import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/document_repository_impl.dart';
import '../domain/entities/document.dart';
import 'controllers/document_providers.dart';
import 'widgets/document_form.dart';

/// Edit document (section 6.8's "Added" screen), the same fields the Add sheet
/// collects — reusing [DocumentFormFields] so the two cannot drift apart.
class DocumentEditScreen extends ConsumerWidget {
  const DocumentEditScreen({super.key, required this.documentId});

  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentByIdProvider(documentId));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit document')),
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
            // Keyed on the id so re-entering the screen for a different
            // document rebuilds the form rather than reusing the old
            // controller's text.
            : _Form(key: ValueKey(loaded.id), document: loaded),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({super.key, required this.document});

  final Document document;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late final DocumentFormController _form =
      DocumentFormController(existing: widget.document)..addListener(_onChanged);

  @override
  void dispose() {
    _form
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _save() async {
    if (!_form.isValid) return;
    final draft = _form.toDraft();
    final repository = ref.read(documentRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);

    await repository.edit(
      widget.document.id,
      name: draft.name,
      category: draft.category,
      number: draft.number,
      // The sentinels matter here: the form hands back null both for "left
      // empty" and for "cleared", and only the repository can tell them apart
      // if the screen says which it means.
      clearNumber: draft.number == null,
      issuedOn: draft.issuedOn,
      expiresOn: draft.expiresOn,
      clearExpiry: draft.expiresOn == null,
      reminderOffsetDays: draft.reminderOffsetDays,
      notes: draft.notes,
    );
    if (!mounted) return;
    context.pop();
    toast.show('Saved');
  }

  @override
  Widget build(BuildContext context) {
    final today = ref.read(clockProvider).today();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        KoshaSpace.md,
        KoshaSpace.screen,
        KoshaSpace.xxxl,
      ),
      children: [
        DocumentFormFields(controller: _form, today: today),
        const SizedBox(height: KoshaSpace.xl),
        FilledButton(
          onPressed: _form.isValid ? () => unawaited(_save()) : null,
          child: const Text('Save changes'),
        ),
      ],
    );
  }
}
