// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Customize dashboard's rows, and the sections Home itself loops over.

@ProviderFor(dashboardSections)
final dashboardSectionsProvider = DashboardSectionsProvider._();

/// Customize dashboard's rows, and the sections Home itself loops over.

final class DashboardSectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DashboardSection>>,
          List<DashboardSection>,
          Stream<List<DashboardSection>>
        >
    with
        $FutureModifier<List<DashboardSection>>,
        $StreamProvider<List<DashboardSection>> {
  /// Customize dashboard's rows, and the sections Home itself loops over.
  DashboardSectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSectionsHash();

  @$internal
  @override
  $StreamProviderElement<List<DashboardSection>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DashboardSection>> create(Ref ref) {
    return dashboardSections(ref);
  }
}

String _$dashboardSectionsHash() => r'87e841f48f831e4a149019846df07f5b9584d699';

/// Every feature's contribution to "Needs attention", merged. Tasks and Bills
/// today, plus Documents since Phase 3.

@ProviderFor(needsAttention)
final needsAttentionProvider = NeedsAttentionProvider._();

/// Every feature's contribution to "Needs attention", merged. Tasks and Bills
/// today, plus Documents since Phase 3.

final class NeedsAttentionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NeedsAttentionItem>>,
          List<NeedsAttentionItem>,
          Stream<List<NeedsAttentionItem>>
        >
    with
        $FutureModifier<List<NeedsAttentionItem>>,
        $StreamProvider<List<NeedsAttentionItem>> {
  /// Every feature's contribution to "Needs attention", merged. Tasks and Bills
  /// today, plus Documents since Phase 3.
  NeedsAttentionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'needsAttentionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$needsAttentionHash();

  @$internal
  @override
  $StreamProviderElement<List<NeedsAttentionItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NeedsAttentionItem>> create(Ref ref) {
    return needsAttention(ref);
  }
}

String _$needsAttentionHash() => r'6f30ce409c46ae2ffe2e2ba15db78e8cec330eff';

/// Every feature's contribution to "Upcoming", merged and sorted by date.

@ProviderFor(upcoming)
final upcomingProvider = UpcomingProvider._();

/// Every feature's contribution to "Upcoming", merged and sorted by date.

final class UpcomingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UpcomingItem>>,
          List<UpcomingItem>,
          Stream<List<UpcomingItem>>
        >
    with
        $FutureModifier<List<UpcomingItem>>,
        $StreamProvider<List<UpcomingItem>> {
  /// Every feature's contribution to "Upcoming", merged and sorted by date.
  UpcomingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingHash();

  @$internal
  @override
  $StreamProviderElement<List<UpcomingItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<UpcomingItem>> create(Ref ref) {
    return upcoming(ref);
  }
}

String _$upcomingHash() => r'f7c2dec9e89db358d4ff7479381a0baae73bd93e';

/// The 10 most recently created/updated items across every source, newest
/// first.

@ProviderFor(recentItems)
final recentItemsProvider = RecentItemsProvider._();

/// The 10 most recently created/updated items across every source, newest
/// first.

final class RecentItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecentItem>>,
          List<RecentItem>,
          Stream<List<RecentItem>>
        >
    with $FutureModifier<List<RecentItem>>, $StreamProvider<List<RecentItem>> {
  /// The 10 most recently created/updated items across every source, newest
  /// first.
  RecentItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<RecentItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecentItem>> create(Ref ref) {
    return recentItems(ref);
  }
}

String _$recentItemsHash() => r'46a53ca92741b630306cfab099b696768f8672bb';
