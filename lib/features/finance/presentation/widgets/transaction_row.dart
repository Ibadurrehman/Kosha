import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/kosha_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../domain/entities/transaction.dart';
import '../category_icons.dart';
import '../transaction_labels.dart';

/// One transaction, shared by the Finance dashboard's "Recent" list and the
/// All transactions screen so the two can never drift apart.
class TransactionRow extends StatelessWidget {
  const TransactionRow({
    super.key,
    required this.transaction,
    required this.onTap,
    this.iconKey,
    this.showDate = true,
  });

  final Transaction transaction;
  final VoidCallback onTap;

  /// The icon of the category this transaction was filed under, when the
  /// caller already has the category list to hand. Falls back to a plain
  /// up/down arrow.
  final String? iconKey;

  /// All transactions groups by day under its own headers, so it turns the
  /// per-row date off and shows the category and method instead.
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final isIncome = transaction.type == TransactionType.income;
    final method = transaction.method;

    final subtitle = <String>[
      if (showDate) Dates.dayMonth(transaction.date),
      if (!showDate && transaction.category != null) transaction.category!,
      if (method != null) methodLabel(method),
    ].join(' · ');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: IconTile(
        iconKey != null
            ? categoryIcon(iconKey)
            : isIncome
                ? Symbols.trending_up_rounded
                : Symbols.trending_down_rounded,
        color: isIncome ? c.success : c.text2,
        background: isIncome ? c.successSoft : c.sunk,
      ),
      title: Text(
        transactionTitle(transaction),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: Text(
        '${isIncome ? '+' : '−'}${Money.inr(transaction.amountMinor)}',
        style: t.titleSmall?.copyWith(
          color: isIncome ? c.success : c.text,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
