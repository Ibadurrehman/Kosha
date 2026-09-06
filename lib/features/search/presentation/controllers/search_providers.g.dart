// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The database layer stays fully reactive; the screen debounces keystrokes
/// (~250 ms) before updating [query] so a live-typed search doesn't requery
/// on every character.

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsFamily._();

/// The database layer stays fully reactive; the screen debounces keystrokes
/// (~250 ms) before updating [query] so a live-typed search doesn't requery
/// on every character.

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SearchResult>>,
          List<SearchResult>,
          Stream<List<SearchResult>>
        >
    with
        $FutureModifier<List<SearchResult>>,
        $StreamProvider<List<SearchResult>> {
  /// The database layer stays fully reactive; the screen debounces keystrokes
  /// (~250 ms) before updating [query] so a live-typed search doesn't requery
  /// on every character.
  SearchResultsProvider._({
    required SearchResultsFamily super.from,
    required (String, SearchFilter) super.argument,
  }) : super(
         retry: null,
         name: r'searchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @override
  String toString() {
    return r'searchResultsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<SearchResult>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SearchResult>> create(Ref ref) {
    final argument = this.argument as (String, SearchFilter);
    return searchResults(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchResultsHash() => r'ef022a034751a73badd5d9a9e81647973cb19393';

/// The database layer stays fully reactive; the screen debounces keystrokes
/// (~250 ms) before updating [query] so a live-typed search doesn't requery
/// on every character.

final class SearchResultsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<SearchResult>>,
          (String, SearchFilter)
        > {
  SearchResultsFamily._()
    : super(
        retry: null,
        name: r'searchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The database layer stays fully reactive; the screen debounces keystrokes
  /// (~250 ms) before updating [query] so a live-typed search doesn't requery
  /// on every character.

  SearchResultsProvider call(String query, SearchFilter filter) =>
      SearchResultsProvider._(argument: (query, filter), from: this);

  @override
  String toString() => r'searchResultsProvider';
}

@ProviderFor(recentSearches)
final recentSearchesProvider = RecentSearchesProvider._();

final class RecentSearchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  RecentSearchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return recentSearches(ref);
  }
}

String _$recentSearchesHash() => r'f61aaac1d9b5f603718d05918ff1df4eb3a97a98';

@ProviderFor(SelectedSearchFilter)
final selectedSearchFilterProvider = SelectedSearchFilterProvider._();

final class SelectedSearchFilterProvider
    extends $NotifierProvider<SelectedSearchFilter, SearchFilter> {
  SelectedSearchFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedSearchFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedSearchFilterHash();

  @$internal
  @override
  SelectedSearchFilter create() => SelectedSearchFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFilter>(value),
    );
  }
}

String _$selectedSearchFilterHash() =>
    r'86d24ffb5ad628cc891f3b86393b9b4aa5162612';

abstract class _$SelectedSearchFilter extends $Notifier<SearchFilter> {
  SearchFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SearchFilter, SearchFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchFilter, SearchFilter>,
              SearchFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
