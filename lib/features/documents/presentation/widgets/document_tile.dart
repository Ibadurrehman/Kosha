import 'package:flutter/material.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/document.dart';
import '../document_labels.dart';

/// One tile in the Documents grid: category icon, name, subtitle, status pill.
class DocumentTile extends StatelessWidget {
  const DocumentTile({
    super.key,
    required this.document,
    required this.today,
    required this.onTap,
  });

  final Document document;
  final DateTime today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final status = documentStatus(document, today);

    return Semantics(
      button: true,
      label: '${document.name}. ${documentStatusLabel(document, today)}',
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(KoshaRadius.tile),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KoshaRadius.tile),
          child: Container(
            padding: const EdgeInsets.all(KoshaSpace.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KoshaRadius.tile),
              border: Border.all(color: c.hair),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  documentCategoryIcon(document.category),
                  size: 24,
                  color: c.accent,
                ),
                const SizedBox(height: KoshaSpace.md),
                Text(
                  document.name,
                  style: t.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  documentSubtitle(document),
                  style: t.bodySmall?.copyWith(color: c.text3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StatusPill(
                    documentPillStatus(status),
                    label: documentTileStatusLabel(document, today),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
