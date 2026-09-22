import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/clock.dart';
import '../../../../core/utils/combine_streams.dart';
import '../../../bills/data/bill_repository_impl.dart';
import '../../../documents/data/document_repository_impl.dart';
import '../../../tasks/data/task_repository_impl.dart';
import '../../data/bill_home_sources.dart';
import '../../data/dashboard_section_repository_impl.dart';
import '../../data/document_home_sources.dart';
import '../../data/task_needs_attention_source.dart';
import '../../data/task_recent_source.dart';
import '../../data/task_upcoming_source.dart';
import '../../domain/entities/dashboard_section.dart';
import '../../domain/entities/needs_attention_item.dart';
import '../../domain/entities/recent_item.dart';
import '../../domain/entities/upcoming_item.dart';
import '../../domain/needs_attention_source.dart';
import '../../domain/recent_source.dart';
import '../../domain/upcoming_source.dart';

part 'home_providers.g.dart';

/// Customize dashboard's rows, and the sections Home itself loops over.
@riverpod
Stream<List<DashboardSection>> dashboardSections(Ref ref) =>
    ref.watch(dashboardSectionRepositoryProvider).watchSections();

/// A one-line hint under each section's name, shown on both onboarding's
/// "Choose dashboard" step and Settings' Customize dashboard screen.
String dashboardSectionHint(HomeSectionKey key) => switch (key) {
      HomeSectionKey.attention => 'Bills, documents and tasks that need action',
      HomeSectionKey.today => "What's due today",
      HomeSectionKey.upcoming => "What's coming up next",
      HomeSectionKey.quickAccess => 'Shortcuts to your most-used tools',
      HomeSectionKey.recent => 'Recently added or changed items',
    };

/// How many days ahead "Upcoming" looks, after today (which "Today" already
/// covers).
const int upcomingWindowDays = 7;

/// Every feature's contribution to "Needs attention", merged. Tasks and Bills
/// today, plus Documents since Phase 3.
@riverpod
Stream<List<NeedsAttentionItem>> needsAttention(Ref ref) {
  final today = ref.watch(clockProvider).today();
  final sources = <NeedsAttentionSource>[
    TaskNeedsAttentionSource(ref.watch(taskRepositoryProvider)),
    BillNeedsAttentionSource(ref.watch(billRepositoryProvider)),
    DocumentNeedsAttentionSource(ref.watch(documentRepositoryProvider)),
  ];
  return combineLatestLists([for (final s in sources) s.watch(today: today)]);
}

/// Every feature's contribution to "Upcoming", merged and sorted by date.
@riverpod
Stream<List<UpcomingItem>> upcoming(Ref ref) {
  final today = ref.watch(clockProvider).today();
  final from = DateTime(today.year, today.month, today.day + 1);
  final to = DateTime(today.year, today.month, today.day + 1 + upcomingWindowDays);
  final sources = <UpcomingSource>[
    TaskUpcomingSource(ref.watch(taskRepositoryProvider)),
    BillUpcomingSource(ref.watch(billRepositoryProvider)),
    DocumentUpcomingSource(ref.watch(documentRepositoryProvider)),
  ];
  return combineLatestLists([for (final s in sources) s.watch(from: from, to: to)])
      .map((items) => [...items]..sort((a, b) => a.date.compareTo(b.date)));
}

/// The 10 most recently created/updated items across every source, newest
/// first.
@riverpod
Stream<List<RecentItem>> recentItems(Ref ref) {
  const limit = 10;
  final sources = <RecentSource>[
    TaskRecentSource(ref.watch(taskRepositoryProvider)),
    BillRecentSource(ref.watch(billRepositoryProvider)),
    DocumentRecentSource(ref.watch(documentRepositoryProvider)),
  ];
  return combineLatestLists([for (final s in sources) s.watch(limit: limit)]).map((items) {
    final sorted = [...items]..sort((a, b) => b.at.compareTo(a.at));
    return sorted.take(limit).toList();
  });
}
