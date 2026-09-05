import 'package:flutter/material.dart';

import '../../core/theme/kosha_colors.dart';

/// Semantic status used by bills, documents, tasks, renewals and jobs.
enum KoshaStatus {
  overdue('Overdue'),
  expired('Expired'),
  dueSoon('Due Soon'),
  expiring('Expiring'),
  paid('Paid'),
  valid('Valid'),
  done('Done'),
  upcoming('Upcoming'),
  active('Active'),
  today('Today');

  const KoshaStatus(this.label);
  final String label;
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.status, {super.key, this.label, this.icon});

  final KoshaStatus status;

  /// Overrides the default label, e.g. "Expires in 15 days".
  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final (Color bg, Color fg) = switch (status) {
      KoshaStatus.overdue || KoshaStatus.expired => (c.errorSoft, c.error),
      KoshaStatus.dueSoon || KoshaStatus.expiring => (c.warningSoft, c.warning),
      KoshaStatus.paid || KoshaStatus.valid || KoshaStatus.done => (c.successSoft, c.success),
      KoshaStatus.upcoming || KoshaStatus.active || KoshaStatus.today => (c.infoSoft, c.info),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(7)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label ?? status.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
