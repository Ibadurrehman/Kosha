import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../core/utils/clock.dart';
import '../../../shared/widgets/widgets.dart';
import '../../quick_add/presentation/quick_add_sheet.dart';
import '../domain/calendar_grid.dart';
import '../domain/entities/calendar_item.dart';
import 'controllers/calendar_providers.dart';

final DateFormat _monthYear = DateFormat('MMMM yyyy');

/// Month grid (dots by kind), Week strip (count per day) and an Agenda list
/// for whichever day is selected. All 3 share one query: the 42-day window
/// `monthGridDays` computes for the selected date's month is a superset of
/// what Week and Agenda need, so there is one provider call per build, not
/// three.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(selectedCalendarViewProvider);
    final selected = ref.watch(selectedCalendarDateProvider);
    final grid = monthGridDays(selected);
    final from = grid.first;
    final to = grid.last.add(const Duration(days: 1));
    final itemsByDay = ref.watch(calendarItemsByDayProvider(from, to));

    return Scaffold(
      appBar: AppBar(
        title: Text(_monthYear.format(selected)),
        leading: IconButton(
          tooltip: 'Previous',
          icon: const Icon(Symbols.chevron_left_rounded),
          onPressed: () => _step(ref, view, selected, -1),
        ),
        actions: [
          IconButton(
            tooltip: 'Next',
            icon: const Icon(Symbols.chevron_right_rounded),
            onPressed: () => _step(ref, view, selected, 1),
          ),
          TextButton(
            onPressed: () => ref
                .read(selectedCalendarDateProvider.notifier)
                .select(ref.read(clockProvider).today()),
            child: const Text('Today'),
          ),
        ],
      ),
      floatingActionButton:
          KoshaFab(onPressed: () => unawaited(showQuickAddSheet(context))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              KoshaSpace.screen,
              12,
              KoshaSpace.screen,
              12,
            ),
            child: SegmentedTabs(
              labels: [for (final v in CalendarView.values) v.label],
              selectedIndex: CalendarView.values.indexOf(view),
              onChanged: (i) => ref
                  .read(selectedCalendarViewProvider.notifier)
                  .select(CalendarView.values[i]),
            ),
          ),
          Expanded(
            child: itemsByDay.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
                child: SkeletonList(),
              ),
              error: (error, _) => EmptyState(
                icon: Symbols.error_rounded,
                title: "Couldn't load your calendar",
                body: 'Something went wrong reading the database.',
                actionLabel: 'Try again',
                onAction: () =>
                    ref.invalidate(calendarItemsByDayProvider(from, to)),
              ),
              data: (byDay) => switch (view) {
                CalendarView.month => _MonthGrid(month: selected, days: grid, byDay: byDay),
                CalendarView.week => _WeekStrip(selected: selected, byDay: byDay),
                CalendarView.agenda => _Agenda(day: selected, items: byDay[selected] ?? const []),
              },
            ),
          ),
          const _Legend(),
        ],
      ),
    );
  }

  void _step(WidgetRef ref, CalendarView view, DateTime selected, int direction) {
    final next = switch (view) {
      CalendarView.month =>
        DateTime(selected.year, selected.month + direction, selected.day),
      CalendarView.week => selected.add(Duration(days: 7 * direction)),
      CalendarView.agenda => selected.add(Duration(days: direction)),
    };
    ref.read(selectedCalendarDateProvider.notifier).select(next);
  }
}

/// Section 5.2's day-dot tones: task → accent, event → info, bill → warning.
/// One place, so the month dots, the agenda dots and the legend can never
/// disagree about what a colour means.
Color calendarItemColor(CalendarItemKind kind, KoshaColors c) => switch (kind) {
      CalendarItemKind.task => c.accent,
      CalendarItemKind.event => c.info,
      CalendarItemKind.bill => c.warning,
    };

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    Widget dot(Color color, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text(label, style: t.labelSmall),
          ],
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(KoshaSpace.screen, 0, KoshaSpace.screen, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dot(c.accent, 'Task'),
          const SizedBox(width: 16),
          dot(c.info, 'Event'),
          const SizedBox(width: 16),
          dot(c.warning, 'Bill'),
        ],
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({required this.month, required this.days, required this.byDay});

  final DateTime month;
  final List<DateTime> days;
  final Map<DateTime, List<CalendarItem>> byDay;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    const weekLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Consumer(
      builder: (context, ref, _) {
        final today = ref.watch(clockProvider).today();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
          child: Column(
            children: [
              Row(
                children: [
                  for (final label in weekLabels)
                    Expanded(
                      child: Center(child: Text(label, style: t.labelSmall)),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 7,
                  children: [
                    for (final day in days)
                      _DayCell(
                        day: day,
                        inMonth: day.month == month.month,
                        isToday: isSameDay(day, today),
                        items: byDay[day] ?? const [],
                        onTap: () {
                          ref.read(selectedCalendarDateProvider.notifier).select(day);
                          ref
                              .read(selectedCalendarViewProvider.notifier)
                              .select(CalendarView.agenda);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.isToday,
    required this.items,
    required this.onTap,
  });

  final DateTime day;
  final bool inMonth;
  final bool isToday;
  final List<CalendarItem> items;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday ? c.accent : null,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${day.day}',
              style: t.bodyMedium?.copyWith(
                color: isToday
                    ? Colors.white
                    : inMonth
                        ? c.text
                        : c.text3,
              ),
            ),
          ),
          const SizedBox(height: 3),
          SizedBox(
            height: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final item in items.take(3))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: calendarItemColor(item.kind, c),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends ConsumerWidget {
  const _WeekStrip({required this.selected, required this.byDay});

  final DateTime selected;
  final Map<DateTime, List<CalendarItem>> byDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final today = ref.watch(clockProvider).today();
    final days = weekDays(selected);
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
      child: Row(
        children: [
          for (final (index, day) in days.indexed)
            Expanded(
              child: InkWell(
                onTap: () {
                  ref.read(selectedCalendarDateProvider.notifier).select(day);
                  ref
                      .read(selectedCalendarViewProvider.notifier)
                      .select(CalendarView.agenda);
                },
                child: Column(
                  children: [
                    Text(dayLabels[index], style: t.labelSmall),
                    const SizedBox(height: 6),
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSameDay(day, today) ? c.accent : null,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: t.bodyMedium?.copyWith(
                          color: isSameDay(day, today) ? Colors.white : c.text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(byDay[day] ?? const []).length}',
                      style: t.labelSmall?.copyWith(color: c.text3),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Agenda extends ConsumerWidget {
  const _Agenda({required this.day, required this.items});

  final DateTime day;
  final List<CalendarItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const EmptyState(
        icon: Symbols.event_available_rounded,
        title: 'Nothing on this day',
        body: 'Tasks and events with a date show here.',
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: KoshaSpace.screen, vertical: 8),
      children: [for (final item in items) _AgendaRow(item: item)],
    );
  }
}

class _AgendaRow extends StatelessWidget {
  const _AgendaRow({required this.item});

  final CalendarItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    final minutes = item.minutes;
    final time = minutes == null
        ? 'All day'
        : TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60).format(context);

    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: switch (item.kind) {
          CalendarItemKind.task => () => context.go(Routes.taskDetail(item.id)),
          CalendarItemKind.bill => () => context.go(Routes.billDetail(item.id)),
          // Events have no detail screen of their own yet — the Calendar is
          // where an event lives.
          CalendarItemKind.event => null,
        },
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                child: Text(time, style: t.bodySmall),
              ),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: calendarItemColor(item.kind, c),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(child: Text(item.title, style: t.titleSmall)),
            ],
          ),
        ),
      ),
    );
  }
}
