import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../../tasks/presentation/widgets/sheet_scaffold.dart';
import '../../domain/entities/transaction_category.dart';
import '../category_icons.dart';

/// What the sheet collected. Null from [showCategoryEditorSheet] means the
/// user backed out.
class CategoryDraft {
  const CategoryDraft({required this.name, this.iconKey});

  final String name;
  final String? iconKey;
}

/// Name plus an icon from the curated set — used for both "Add category" and
/// renaming an existing one.
Future<CategoryDraft?> showCategoryEditorSheet(
  BuildContext context, {
  TransactionCategory? category,
}) {
  return showModalBottomSheet<CategoryDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _CategoryEditorSheet(category: category),
  );
}

class _CategoryEditorSheet extends StatefulWidget {
  const _CategoryEditorSheet({this.category});

  final TransactionCategory? category;

  @override
  State<_CategoryEditorSheet> createState() => _CategoryEditorSheetState();
}

class _CategoryEditorSheetState extends State<_CategoryEditorSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.category?.name ?? '');
  late String? _iconKey = widget.category?.iconKey ?? categoryIconKeys.first;

  @override
  void initState() {
    super.initState();
    // Create is disabled until the name has text, the same gate the New task
    // sheet puts on its title.
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canSave => _name.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final editing = widget.category != null;

    return SheetScaffold(
      title: editing ? 'Edit category' : 'New category',
      children: [
        TextField(
          controller: _name,
          autofocus: !editing,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(hintText: 'Name'),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Icon',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: c.text2),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final key in categoryIconKeys)
              _IconChoice(
                iconKey: key,
                selected: _iconKey == key,
                onTap: () => setState(() => _iconKey = key),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            IconButton(
              onPressed: Navigator.of(context).pop,
              tooltip: 'Cancel',
              icon: const Icon(Symbols.close_rounded),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: _canSave
                    ? () => Navigator.of(context).pop(
                          CategoryDraft(
                            name: _name.text.trim(),
                            iconKey: _iconKey,
                          ),
                        )
                    : null,
                child: Text(editing ? 'Save' : 'Create'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
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
      child: Material(
        color: selected ? c.accentSoft : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KoshaRadius.card),
          side: BorderSide(color: selected ? c.accent : c.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KoshaRadius.card),
          child: Padding(
            padding: const EdgeInsets.all(11),
            child: Icon(
              categoryIcon(iconKey),
              size: 21,
              color: selected ? c.accent : c.text2,
            ),
          ),
        ),
      ),
    );
  }
}
