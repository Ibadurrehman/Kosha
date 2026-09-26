import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/state/toast_controller.dart';
import '../../../documents/domain/entities/document.dart';
import '../../../documents/presentation/controllers/document_providers.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../data/record_repository_impl.dart';
import '../../domain/entities/custom_record.dart';
import '../../domain/entities/record_template.dart';

/// Add and edit share one sheet — Appendix A names a single record editor, so
/// editing an existing record reopens the same fields rather than a second
/// screen. The same call Bills, Documents and Home management make.
Future<void> showRecordEditorSheet(
  BuildContext context, {
  required RecordTemplate template,
  CustomRecord? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => RecordEditorSheet(template: template, existing: existing),
  );
}

/// The editor is built from the template, not hard-coded: one input per field,
/// in the template's own order, with the keyboard and picker its type asks
/// for. A field added in the builder shows up here on the next open with no
/// code of its own.
class RecordEditorSheet extends ConsumerStatefulWidget {
  const RecordEditorSheet({
    super.key,
    required this.template,
    this.existing,
  });

  final RecordTemplate template;
  final CustomRecord? existing;

  @override
  ConsumerState<RecordEditorSheet> createState() => _RecordEditorSheetState();
}

class _RecordEditorSheetState extends ConsumerState<RecordEditorSheet> {
  late final TextEditingController _title =
      TextEditingController(text: widget.existing?.title ?? '');
  late final TextEditingController _statusLabel =
      TextEditingController(text: widget.existing?.statusLabel ?? '');

  /// One controller per text-like field, keyed the way the values are.
  late final Map<String, TextEditingController> _fieldControllers = {
    for (final field in widget.template.fields)
      if (_isTextLike(field.type))
        field.key: TextEditingController(
          text: widget.existing?.values[field.key] ?? '',
        ),
  };

  /// Date and document fields are not typed into, so they hold their value
  /// here rather than in a controller.
  late final Map<String, String> _pickedValues = {
    for (final field in widget.template.fields)
      if (!_isTextLike(field.type))
        field.key: ?widget.existing?.values[field.key],
  };

  late DateTime? _renewalDate = widget.existing?.renewalDate;

  static bool _isTextLike(RecordFieldType type) =>
      type != RecordFieldType.date && type != RecordFieldType.documentLink;

  @override
  void initState() {
    super.initState();
    _title.addListener(() => setState(() {}));
    for (final controller in _fieldControllers.values) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _statusLabel.dispose();
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _valueFor(String key) =>
      (_fieldControllers[key]?.text ?? _pickedValues[key] ?? '').trim();

  /// Save is gated on the title and on every field the template marks
  /// required — the builder's "Required" toggle is only a promise if this is
  /// where it is kept.
  bool get _canSave =>
      _title.text.trim().isNotEmpty &&
      widget.template.requiredFields
          .every((field) => _valueFor(field.key).isNotEmpty);

  Future<void> _pickDate(RecordField field) async {
    final today = ref.read(clockProvider).today();
    final current = DateTime.tryParse(_pickedValues[field.key] ?? '');
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? today,
      firstDate: DateTime(today.year - 30),
      lastDate: DateTime(today.year + 30),
    );
    if (picked == null || !mounted) return;
    setState(() {
      // ISO-8601 date only: the one spelling DateTime.tryParse reads back
      // whatever the device's locale shows it as.
      _pickedValues[field.key] =
          DateTime(picked.year, picked.month, picked.day)
              .toIso8601String()
              .split('T')
              .first;
    });
  }

  Future<void> _pickRenewalDate() async {
    final today = ref.read(clockProvider).today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _renewalDate ?? today,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 30),
    );
    if (picked == null || !mounted) return;
    setState(
      () => _renewalDate = DateTime(picked.year, picked.month, picked.day),
    );
  }

  Future<void> _pickDocument(RecordField field) async {
    final documents = await ref.read(documentsProvider.future);
    if (!mounted) return;

    final chosen = await showModalBottomSheet<Document>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => SheetScaffold(
        title: 'Link a document',
        subtitle: documents.isEmpty
            ? 'Nothing in Documents yet.'
            : '${field.label} points at one of your documents.',
        children: [
          for (final document in documents)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Symbols.description_rounded),
              title: Text(document.name),
              subtitle: Text(document.category.label),
              onTap: () => Navigator.of(sheetContext).pop(document),
            ),
        ],
      ),
    );
    if (chosen == null || !mounted) return;
    setState(() => _pickedValues[field.key] = chosen.id);
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final repository = ref.read(recordRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final title = _title.text.trim();
    final statusLabel = _statusLabel.text.trim();
    final values = <String, String>{
      for (final field in widget.template.fields)
        if (_valueFor(field.key) case final value when value.isNotEmpty)
          field.key: value,
    };
    // The record's own `document_id` mirrors the first document field, so a
    // reminder or a future Space section has one id to follow without parsing
    // the values blob. A template with no document field leaves it null.
    final documentKey = widget.template.fields
        .where((field) => field.type == RecordFieldType.documentLink)
        .map((field) => field.key)
        .firstOrNull;
    final documentId = documentKey == null ? null : values[documentKey];

    Navigator.of(context).pop();

    final existing = widget.existing;
    if (existing == null) {
      await repository.createRecord(
        NewCustomRecord(
          templateId: widget.template.id,
          title: title,
          values: values,
          statusLabel: statusLabel.isEmpty ? null : statusLabel,
          renewalDate: _renewalDate,
          documentId: documentId,
        ),
      );
      toast.show('Added “$title”');
    } else {
      await repository.editRecord(
        existing.id,
        title: title,
        values: values,
        statusLabel: statusLabel.isEmpty ? null : statusLabel,
        clearStatusLabel: statusLabel.isEmpty,
        renewalDate: _renewalDate,
        clearRenewalDate: _renewalDate == null,
        documentId: documentId,
        clearDocumentId: documentId == null,
      );
      toast.show('Saved “$title”');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final template = widget.template;

    return SheetScaffold(
      title: widget.existing == null
          ? 'New ${template.name} record'
          : 'Edit record',
      children: [
        TextField(
          controller: _title,
          autofocus: widget.existing == null,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'Star Health SH-2291840',
          ),
        ),
        const SizedBox(height: 16),
        for (final field in template.fields) ...[
          _FieldInput(
            field: field,
            controller: _fieldControllers[field.key],
            pickedValue: _pickedValues[field.key],
            onPickDate: () => unawaited(_pickDate(field)),
            onPickDocument: () => unawaited(_pickDocument(field)),
          ),
          const SizedBox(height: 16),
        ],
        if (template.fields.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'This record type has no fields yet. Add some with '
              '“Edit fields” and they will show up here.',
              style: t.bodySmall?.copyWith(color: c.text2),
            ),
          ),
        _RenewalRow(
          date: _renewalDate,
          onPick: () => unawaited(_pickRenewalDate()),
          onClear: () => setState(() => _renewalDate = null),
        ),
        const SizedBox(height: 16),
        if (_renewalDate == null)
          TextField(
            controller: _statusLabel,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Status (optional)',
              hintText: 'Active',
            ),
          ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _canSave ? () => unawaited(_save()) : null,
          child: Text(widget.existing == null ? 'Add record' : 'Save'),
        ),
      ],
    );
  }
}

class _FieldInput extends StatelessWidget {
  const _FieldInput({
    required this.field,
    required this.controller,
    required this.pickedValue,
    required this.onPickDate,
    required this.onPickDocument,
  });

  final RecordField field;
  final TextEditingController? controller;
  final String? pickedValue;
  final VoidCallback onPickDate;
  final VoidCallback onPickDocument;

  @override
  Widget build(BuildContext context) {
    final label = field.isRequired ? '${field.label} *' : field.label;

    switch (field.type) {
      case RecordFieldType.date:
        return _PickerRow(
          label: label,
          icon: Symbols.event_rounded,
          value: pickedValue == null
              ? null
              : Dates.dayMonthYear(DateTime.parse(pickedValue!)),
          onTap: onPickDate,
        );
      case RecordFieldType.documentLink:
        return _DocumentRow(
          label: label,
          documentId: pickedValue,
          onTap: onPickDocument,
        );
      case RecordFieldType.currency:
        return TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(labelText: label, prefixText: '₹ '),
        );
      case RecordFieldType.number:
        return TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: label),
        );
      case RecordFieldType.phone:
        return TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(labelText: label),
        );
      case RecordFieldType.text:
        return TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: label),
        );
    }
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Row(
          children: [
            Icon(icon, size: 18, color: c.text2),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value ?? 'Not set',
                style: TextStyle(color: value == null ? c.text2 : c.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A linked document reads as its name, not its id — an id on screen would be
/// the app showing its own plumbing.
class _DocumentRow extends ConsumerWidget {
  const _DocumentRow({
    required this.label,
    required this.documentId,
    required this.onTap,
  });

  final String label;
  final String? documentId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = documentId;
    final name = id == null
        ? null
        : ref.watch(documentByIdProvider(id)).value?.name ?? 'Linked document';
    return _PickerRow(
      label: label,
      icon: Symbols.description_rounded,
      value: name,
      onTap: onTap,
    );
  }
}

class _RenewalRow extends StatelessWidget {
  const _RenewalRow({
    required this.date,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? date;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Row(
      children: [
        Expanded(
          child: _PickerRow(
            label: 'Renews on (optional)',
            icon: Symbols.autorenew_rounded,
            value: date == null ? null : Dates.dayMonthYear(date!),
            onTap: onPick,
          ),
        ),
        if (date != null)
          IconButton(
            tooltip: 'Clear renewal date',
            icon: Icon(Symbols.close_rounded, color: c.text2),
            onPressed: onClear,
          ),
      ],
    );
  }
}
