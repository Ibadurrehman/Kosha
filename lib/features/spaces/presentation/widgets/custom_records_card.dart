import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/theme/kosha_shapes.dart';
import '../controllers/record_providers.dart';
import '../space_icons.dart';

/// The Spaces grid's Custom records card (Appendix A): the record types the
/// user has built, and the row that makes another.
///
/// This *is* the list of record types — there is no separate screen for one,
/// because a list of at most a handful of rows does not need a screen of its
/// own to live on.
class CustomRecordsCard extends ConsumerWidget {
  const CustomRecordsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(recordTemplatesProvider);
    final counts = ref.watch(recordCountsProvider).value ?? const {};
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final list = templates.value ?? const [];

    return Container(
      margin: const EdgeInsets.fromLTRB(
        KoshaSpace.screen,
        KoshaSpace.xxl,
        KoshaSpace.screen,
        0,
      ),
      padding: const EdgeInsets.all(KoshaSpace.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(KoshaRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Custom records', style: t.titleSmall),
          const SizedBox(height: 4),
          Text(
            'Your own record types — a shape you fill in again and again.',
            style: t.bodySmall?.copyWith(color: c.text2),
          ),
          const SizedBox(height: KoshaSpace.md),
          for (final template in list)
            _TemplateRow(
              name: template.name,
              iconKey: template.iconKey,
              count: counts[template.id] ?? 0,
              onTap: () => context.push(Routes.customRecords(template.id)),
            ),
          _TemplateRow(
            name: 'Create a custom record',
            icon: Symbols.add_rounded,
            onTap: () => context.push(Routes.newRecordTemplate),
          ),
        ],
      ),
    );
  }
}

class _TemplateRow extends StatelessWidget {
  const _TemplateRow({
    required this.name,
    required this.onTap,
    this.iconKey,
    this.icon,
    this.count,
  });

  final String name;
  final VoidCallback onTap;
  final String? iconKey;
  final IconData? icon;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final records = count;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(KoshaRadius.row),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: KoshaSpace.sm),
        child: Row(
          children: [
            Icon(icon ?? spaceIcon(iconKey), size: 20, color: c.text2),
            const SizedBox(width: KoshaSpace.md),
            Expanded(child: Text(name, style: t.bodyMedium)),
            if (records != null)
              Text(
                records == 0
                    ? 'None yet'
                    : '$records ${records == 1 ? 'record' : 'records'}',
                style: t.bodySmall?.copyWith(color: c.text3),
              ),
            const SizedBox(width: KoshaSpace.xs),
            Icon(Symbols.chevron_right_rounded, size: 18, color: c.text3),
          ],
        ),
      ),
    );
  }
}
