import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/kosha_colors.dart';
import '../../../core/theme/kosha_shapes.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/search_repository_impl.dart';
import '../domain/search_filter.dart';
import '../domain/search_result.dart';
import 'controllers/search_providers.dart';
import 'search_result_routing.dart';

/// Query field, 6 filter chips, grouped results — only Everything/Tasks
/// return real matches today (section 6.15, scoped to what Phase 1 indexes).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  void _useRecent(String value) {
    _controller.text = value;
    _debounce?.cancel();
    setState(() => _query = value);
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(selectedSearchFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: 'Search tasks…',
            border: InputBorder.none,
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Symbols.close_rounded),
                    onPressed: () {
                      _controller.clear();
                      _debounce?.cancel();
                      setState(() => _query = '');
                    },
                  ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              KoshaSpace.screen,
              12,
              KoshaSpace.screen,
              12,
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in SearchFilter.values)
                  KoshaChip(
                    label: option.label,
                    selected: option == filter,
                    onTap: () =>
                        ref.read(selectedSearchFilterProvider.notifier).select(option),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _query.isEmpty
                ? _RecentSearches(onSelect: _useRecent)
                : _Results(query: _query, filter: filter),
          ),
        ],
      ),
    );
  }
}

class _RecentSearches extends ConsumerWidget {
  const _RecentSearches({required this.onSelect});

  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchesProvider);
    return recent.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (queries) {
        if (queries.isEmpty) {
          return const EmptyState(
            icon: Symbols.search_rounded,
            title: 'Search your tasks',
            body: 'Start typing to find anything by title, notes or category.',
          );
        }
        final t = Theme.of(context).textTheme;
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
          children: [
            const SectionLabel('Recent searches'),
            for (final query in queries)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Symbols.schedule_rounded),
                title: Text(query, style: t.bodyMedium),
                onTap: () => onSelect(query),
              ),
          ],
        );
      },
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.query, required this.filter});

  final String query;
  final SearchFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(searchRepositoryProvider).supports(filter)) {
      return EmptyState(
        icon: Symbols.search_off_rounded,
        title: '${filter.label} search is arriving in a later phase',
        body: 'Try Everything or Tasks for now.',
      );
    }

    final results = ref.watch(searchResultsProvider(query, filter));
    return results.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: KoshaSpace.screen),
        child: SkeletonList(),
      ),
      error: (error, _) => EmptyState(
        icon: Symbols.error_rounded,
        title: "Couldn't search",
        body: 'Something went wrong reading the database.',
        actionLabel: 'Try again',
        onAction: () => ref.invalidate(searchResultsProvider(query, filter)),
      ),
      data: (list) {
        if (list.isEmpty) {
          return EmptyState(
            icon: Symbols.search_off_rounded,
            title: 'No matches for “$query”',
            body: 'Try a different word or check the spelling.',
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(
            KoshaSpace.screen,
            8,
            KoshaSpace.screen,
            24,
          ),
          children: [
            const SectionLabel('Tasks'),
            for (final result in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _ResultRow(
                  result: result,
                  onTap: () {
                    unawaited(ref.read(searchRepositoryProvider).recordSearch(query));
                    context.go(searchResultRoute(result.kind, result.id));
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result, required this.onTap});

  final SearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.kosha;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KoshaRadius.row),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.title, style: t.titleSmall),
                    const SizedBox(height: 2),
                    Text(result.subtitle, style: t.bodySmall),
                  ],
                ),
              ),
              Icon(Symbols.chevron_right_rounded, size: 18, color: c.text3),
            ],
          ),
        ),
      ),
    );
  }
}
