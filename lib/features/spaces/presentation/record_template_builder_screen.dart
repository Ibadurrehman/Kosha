import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/record_repository_impl.dart';
import '../domain/entities/record_template.dart';
import '../domain/entities/space.dart';
import 'controllers/record_providers.dart';
import 'space_icons.dart';

/// The template builder (section 6.5): add, rename, retype, reorder and remove
/// the fields of a record type, and name the type itself.
///
/// One screen for both "Create a custom record" and "Edit fields", because
/// creating a type *is* choosing its fields — a separate create screen would
/// ask for a name and then send the user straight here.
class RecordTemplateBuilderScreen extends ConsumerWidget {
  const RecordTemplateBuilderScreen({super.key, this.templateId});

  /// Null when creating a new record type.
  final String? templateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = templateId;
    if (id == null) return const _Builder();

    return ref.watch(recordTemplateProvider(id)).when(
          loading: () => const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(KoshaSpace.screen),
              child: SkeletonList(),
            ),
          ),
          error: (_, _) => Scaffold(
            appBar: AppBar(),
            body: const EmptyState(
              icon: Symbols.error_rounded,
              title: "Couldn't load this record type",
              body: 'Something went wrong reading the database.',
            ),
          ),
          data: (template) => template == null
              ? Scaffold(
                  appBar: AppBar(),
                  body: const EmptyState(
                    icon: Symbols.dataset_rounded,
                    title: 'This record type is gone',
                    body: 'It was deleted while you were here.',
                  ),
                )
              : _Builder(existing: template),
        );
  }
}

class _Builder extends ConsumerStatefulWidget {
  const _Builder({this.existing});

  final RecordTemplate? existing;

  @override
  ConsumerState<_Builder> createState() => _BuilderState();
}

class _BuilderState extends ConsumerState<_Builder> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late String _iconKey = widget.existing?.iconKey ?? newSpaceIconPicks.first;

  /// The working copy. Nothing is written until Save, so a builder opened and
  /// backed out of changes nothing — including the field the user added,
  /// looked at and thought better of.
  late List<RecordField> _fields = [...?widget.existing?.fields];

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canSave => _name.text.trim().isNotEmpty;

  void _addField() {
    setState(() {
      _fields = [
        ..._fields,
        RecordField(
          key: newRecordFieldKey(),
          label: '',
          type: RecordFieldType.text,
        ),
      ];
    });
  }

  void _updateField(int index, RecordField field) {
    setState(() {
      _fields = [..._fields]..[index] = field;
    });
  }

  void _removeField(int index) {
    setState(() {
      _fields = [..._fields]..removeAt(index);
    });
  }

  /// `onReorderItem` rather than the deprecated `onReorder`: it hands back a
  /// `newIndex` already adjusted for the row having left `oldIndex`, which is
  /// the off-by-one every caller of the old callback had to fix itself.
  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      final next = [..._fields];
      next.insert(newIndex, next.removeAt(oldIndex));
      _fields = next;
    });
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final repository = ref.read(recordRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    final name = _name.text.trim();
    // A field the user added and never labelled is not a field. Dropping it
    // here rather than blocking Save keeps the "+" button cheap to press.
    final fields = [
      for (final field in _fields)
        if (field.label.trim().isNotEmpty) field.copyWith(label: field.label.trim()),
    ];

    final existing = widget.existing;
    if (existing == null) {
      final created = await repository.createTemplate(
        NewRecordTemplate(name: name, iconKey: _iconKey, fields: fields),
      );
      if (!mounted) return;
      toast.show('Created “$name”');
      // Replaces the builder in the stack: backing out of a type that now
      // exists should land on it, not on the screen that made it.
      context.pushReplacement(Routes.customRecords(created.id));
    } else {
      await repository.editTemplate(
        existing.id,
        name: name,
        iconKey: _iconKey,
        fields: fields,
      );
      if (!mounted) return;
      toast.show('Saved “$name”');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final creating = widget.existing == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(creating ? 'New record type' : 'Edit fields'),
        actions: [
          TextButton(
            onPressed: _canSave ? () => unawaited(_save()) : null,
            child: const Text('Save'),
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
            'A record type is a shape you fill in again and again — '
            '“My Insurance” with a provider, a policy number and a renewal '
            'date.',
            style: t.bodyMedium?.copyWith(color: c.text2),
          ),
          const SizedBox(height: KoshaSpace.lg),
          TextField(
            controller: _name,
            autofocus: creating,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'My Insurance',
            ),
          ),
          const SizedBox(height: KoshaSpace.xl),
          Text('Icon', style: t.labelLarge),
          const SizedBox(height: KoshaSpace.md),
          Wrap(
            spacing: KoshaSpace.md,
            runSpacing: KoshaSpace.md,
            children: [
              for (final key in _iconChoices)
                _IconPick(
                  iconKey: key,
                  selected: key == _iconKey,
                  onTap: () => setState(() => _iconKey = key),
                ),
            ],
          ),
          const SizedBox(height: KoshaSpace.xl),
          SectionLabel(
            'Fields',
            trailing: IconButton(
              tooltip: 'Add field',
              icon: const Icon(Symbols.add_rounded),
              onPressed: _addField,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Renaming a field keeps what every record already holds in it. '
            'Removing one keeps those values until that record is next saved.',
            style: t.bodySmall?.copyWith(color: c.text3),
          ),
          const SizedBox(height: KoshaSpace.md),
          if (_fields.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: KoshaSpace.lg),
              child: Text(
                'No fields yet. Records will be just a title until you add '
                'some.',
                style: t.bodySmall?.copyWith(color: c.text2),
              ),
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: _fields.length,
              onReorderItem: _reorder,
              itemBuilder: (context, index) {
                final field = _fields[index];
                return Padding(
                  // The key is the field's own, so a reorder moves the row's
                  // state with it rather than leaving a text controller
                  // pointing at the row that used to be here.
                  key: ValueKey(field.key),
                  padding: const EdgeInsets.only(bottom: KoshaSpace.sm),
                  child: _FieldRow(
                    index: index,
                    field: field,
                    onChanged: (next) => _updateField(index, next),
                    onRemove: () => _removeField(index),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  /// A type whose icon is not one of the eight keeps it offered, so editing a
  /// record type does not silently re-icon it just by opening the builder —
  /// the same courtesy the New space sheet pays a system space.
  List<String> get _iconChoices {
    final current = _iconKey;
    if (newSpaceIconPicks.contains(current)) return newSpaceIconPicks;
    return [current, ...newSpaceIconPicks];
  }
}

class _FieldRow extends StatefulWidget {
  const _FieldRow({
    required this.index,
    required this.field,
    required this.onChanged,
    required this.onRemove,
  });

  final int index;
  final RecordField field;
  final ValueChanged<RecordField> onChanged;
  final VoidCallback onRemove;

  @override
  State<_FieldRow> createState() => _FieldRowState();
}

class _FieldRowState extends State<_FieldRow> {
  late final TextEditingController _label =
      TextEditingController(text: widget.field.label);

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;

    return Container(
      padding: const EdgeInsets.all(KoshaSpace.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ReorderableDragStartListener(
                index: widget.index,
                child: Padding(
                  padding: const EdgeInsets.only(right: KoshaSpace.sm),
                  child: Icon(
                    Symbols.drag_indicator_rounded,
                    size: 20,
                    color: c.text3,
                    semanticLabel: 'Reorder ${widget.field.label}',
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _label,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Label',
                    hintText: 'Policy number',
                  ),
                  onChanged: (value) =>
                      widget.onChanged(widget.field.copyWith(label: value)),
                ),
              ),
              IconButton(
                tooltip: 'Remove ${widget.field.label}',
                icon: Icon(Symbols.close_rounded, color: c.text2),
                onPressed: widget.onRemove,
              ),
            ],
          ),
          const SizedBox(height: KoshaSpace.sm),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: KoshaSpace.sm,
                  runSpacing: KoshaSpace.sm,
                  children: [
                    for (final type in RecordFieldType.values)
                      KoshaChip(
                        label: type.label,
                        selected: type == widget.field.type,
                        onTap: () =>
                            widget.onChanged(widget.field.copyWith(type: type)),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: KoshaSpace.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Required',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              KoshaToggle(
                value: widget.field.isRequired,
                semanticLabel: 'Required: ${widget.field.label}',
                onChanged: (on) =>
                    widget.onChanged(widget.field.copyWith(isRequired: on)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconPick extends StatelessWidget {
  const _IconPick({
    required this.iconKey,
    required this.selected,
    required this.onTap,
  });

  final String iconKey;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return Semantics(
      button: true,
      selected: selected,
      label: iconKey,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KoshaRadius.tile),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: selected ? c.accentSoft : c.surface,
            borderRadius: BorderRadius.circular(KoshaRadius.tile),
            border: Border.all(color: selected ? c.accent : c.border),
          ),
          child: Icon(
            spaceIcon(iconKey),
            color: selected ? c.accent : c.text2,
          ),
        ),
      ),
    );
  }
}
