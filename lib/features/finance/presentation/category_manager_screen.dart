import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/state/toast_controller.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/transaction_category_repository_impl.dart';
import '../domain/entities/transaction_category.dart';
import 'category_icons.dart';
import 'controllers/finance_providers.dart';
import 'widgets/category_editor_sheet.dart';

/// Add, rename, re-icon, reorder and remove the categories the expense sheet
/// offers (section 6.6's Category manager).
class CategoryManagerScreen extends ConsumerStatefulWidget {
  const CategoryManagerScreen({super.key});

  @override
  ConsumerState<CategoryManagerScreen> createState() =>
      _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends ConsumerState<CategoryManagerScreen> {
  CategoryKind _kind = CategoryKind.expense;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesOfKindProvider(_kind));

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: KoshaFab(
        onPressed: () => unawaited(_add()),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                KoshaSpace.screen,
                0,
                KoshaSpace.screen,
                12,
              ),
              child: SegmentedTabs(
                labels: const ['Expense', 'Income'],
                selectedIndex: CategoryKind.values.indexOf(_kind),
                onChanged: (i) =>
                    setState(() => _kind = CategoryKind.values[i]),
              ),
            ),
            Expanded(
              child: categories.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
                  child: SkeletonList(),
                ),
                error: (error, _) => EmptyState(
                  icon: Symbols.error_rounded,
                  title: "Couldn't load categories",
                  body: 'Something went wrong reading the database.',
                  actionLabel: 'Try again',
                  onAction: () =>
                      ref.invalidate(categoriesOfKindProvider(_kind)),
                ),
                data: (list) => list.isEmpty
                    ? EmptyState(
                        icon: Symbols.folder_rounded,
                        title: 'No categories yet',
                        body: 'Add one and it will appear on the expense '
                            'sheet straight away.',
                        actionLabel: 'Add category',
                        onAction: () => unawaited(_add()),
                      )
                    : _ReorderableList(
                        categories: list,
                        onEdit: _edit,
                        onDelete: _delete,
                        onReorder: (ordered) => unawaited(
                          ref
                              .read(transactionCategoryRepositoryProvider)
                              .reorder(_kind, ordered),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _add() async {
    final result = await showCategoryEditorSheet(context);
    if (result == null || !mounted) return;
    final repository = ref.read(transactionCategoryRepositoryProvider);
    await repository.create(
      name: result.name,
      kind: _kind,
      iconKey: result.iconKey,
    );
    if (!mounted) return;
    ref.read(toastControllerProvider.notifier).show('Added “${result.name}”');
  }

  Future<void> _edit(TransactionCategory category) async {
    final result = await showCategoryEditorSheet(context, category: category);
    if (result == null || !mounted) return;

    final repository = ref.read(transactionCategoryRepositoryProvider);
    final toast = ref.read(toastControllerProvider.notifier);
    if (result.iconKey != category.iconKey) {
      await repository.setIcon(category.id, result.iconKey);
    }
    if (result.name == category.name) return;

    final relabelled = await repository.rename(category.id, result.name);
    toast.show(
      relabelled == 0
          ? 'Renamed to “${result.name}”'
          : 'Renamed to “${result.name}” · $relabelled '
              '${relabelled == 1 ? 'transaction' : 'transactions'} updated',
    );
  }

  Future<void> _delete(TransactionCategory category) async {
    final repository = ref.read(transactionCategoryRepositoryProvider);
    final used = await repository.transactionCount(category.id);
    if (!mounted) return;

    final confirmed = await _confirmDelete(category, used);
    if (!confirmed || !mounted) return;

    await repository.softDelete(category.id);
    if (!mounted) return;
    ref.read(toastControllerProvider.notifier).show(
          'Removed “${category.name}”',
          onUndo: () => unawaited(repository.restore(category.id)),
        );
  }

  Future<bool> _confirmDelete(TransactionCategory category, int used) async {
    final c = context.kosha;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Remove “${category.name}”?'),
        content: Text(
          used == 0
              ? 'It will stop being offered when you log money.'
              : 'It will stop being offered when you log money. The $used '
                  '${used == 1 ? 'transaction' : 'transactions'} already '
                  'filed under it keep the name, so past months still read '
                  'the way you entered them.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: c.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

class _ReorderableList extends StatelessWidget {
  const _ReorderableList({
    required this.categories,
    required this.onEdit,
    required this.onDelete,
    required this.onReorder,
  });

  final List<TransactionCategory> categories;
  final ValueChanged<TransactionCategory> onEdit;
  final ValueChanged<TransactionCategory> onDelete;
  final ValueChanged<List<String>> onReorder;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        0,
        KoshaSpace.screen,
        120,
      ),
      itemCount: categories.length,
      // `onReorderItem` (unlike the deprecated `onReorder`) already reports
      // the target index as it is *after* the dragged row has been taken out,
      // so no off-by-one adjustment is needed here.
      onReorderItem: (oldIndex, newIndex) {
        final ordered = [for (final category in categories) category.id];
        ordered.insert(newIndex, ordered.removeAt(oldIndex));
        onReorder(ordered);
      },
      itemBuilder: (context, index) {
        final category = categories[index];
        return Padding(
          key: ValueKey(category.id),
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: c.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KoshaRadius.card),
              side: BorderSide(color: c.border),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(KoshaRadius.card),
              ),
              onTap: () => onEdit(category),
              leading: IconTile(categoryIcon(category.iconKey)),
              title: Text(category.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Remove',
                    color: c.error,
                    icon: const Icon(Symbols.delete_rounded, size: 20),
                    onPressed: () => onDelete(category),
                  ),
                  ReorderableDragStartListener(
                    index: index,
                    child: Icon(Symbols.drag_indicator_rounded, color: c.text3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
