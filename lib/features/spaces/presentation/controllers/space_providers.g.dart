// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The grid: every space the user has not archived, in their own order.

@ProviderFor(activeSpaces)
final activeSpacesProvider = ActiveSpacesProvider._();

/// The grid: every space the user has not archived, in their own order.

final class ActiveSpacesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Space>>,
          List<Space>,
          Stream<List<Space>>
        >
    with $FutureModifier<List<Space>>, $StreamProvider<List<Space>> {
  /// The grid: every space the user has not archived, in their own order.
  ActiveSpacesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSpacesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSpacesHash();

  @$internal
  @override
  $StreamProviderElement<List<Space>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Space>> create(Ref ref) {
    return activeSpaces(ref);
  }
}

String _$activeSpacesHash() => r'd88d3f309c211dfff4c5c59b2a785b1fc186660a';

/// What the Spaces screen offers to bring back, newest archive first.

@ProviderFor(archivedSpaces)
final archivedSpacesProvider = ArchivedSpacesProvider._();

/// What the Spaces screen offers to bring back, newest archive first.

final class ArchivedSpacesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Space>>,
          List<Space>,
          Stream<List<Space>>
        >
    with $FutureModifier<List<Space>>, $StreamProvider<List<Space>> {
  /// What the Spaces screen offers to bring back, newest archive first.
  ArchivedSpacesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archivedSpacesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archivedSpacesHash();

  @$internal
  @override
  $StreamProviderElement<List<Space>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Space>> create(Ref ref) {
    return archivedSpaces(ref);
  }
}

String _$archivedSpacesHash() => r'70884a7f7562487b5622a31e194603bf15945b41';

/// One space for the detail and settings screens; emits null once the space is
/// archived, which is what turns Space detail into its "this is archived"
/// state rather than leaving a stale header on screen.

@ProviderFor(spaceById)
final spaceByIdProvider = SpaceByIdFamily._();

/// One space for the detail and settings screens; emits null once the space is
/// archived, which is what turns Space detail into its "this is archived"
/// state rather than leaving a stale header on screen.

final class SpaceByIdProvider
    extends $FunctionalProvider<AsyncValue<Space?>, Space?, Stream<Space?>>
    with $FutureModifier<Space?>, $StreamProvider<Space?> {
  /// One space for the detail and settings screens; emits null once the space is
  /// archived, which is what turns Space detail into its "this is archived"
  /// state rather than leaving a stale header on screen.
  SpaceByIdProvider._({
    required SpaceByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spaceByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spaceByIdHash();

  @override
  String toString() {
    return r'spaceByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Space?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Space?> create(Ref ref) {
    final argument = this.argument as String;
    return spaceById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spaceByIdHash() => r'8a15f95b45cdf85a4f0d7c2c236e8a23e4add082';

/// One space for the detail and settings screens; emits null once the space is
/// archived, which is what turns Space detail into its "this is archived"
/// state rather than leaving a stale header on screen.

final class SpaceByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Space?>, String> {
  SpaceByIdFamily._()
    : super(
        retry: null,
        name: r'spaceByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One space for the detail and settings screens; emits null once the space is
  /// archived, which is what turns Space detail into its "this is archived"
  /// state rather than leaving a stale header on screen.

  SpaceByIdProvider call(String id) =>
      SpaceByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'spaceByIdProvider';
}

/// The spaces a picker should offer for [kind] — what makes section 6.5's
/// acceptance criterion true ("creating a space with Expenses enabled makes it
/// selectable in the New expense sheet").

@ProviderFor(spacesHolding)
final spacesHoldingProvider = SpacesHoldingFamily._();

/// The spaces a picker should offer for [kind] — what makes section 6.5's
/// acceptance criterion true ("creating a space with Expenses enabled makes it
/// selectable in the New expense sheet").

final class SpacesHoldingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Space>>,
          List<Space>,
          Stream<List<Space>>
        >
    with $FutureModifier<List<Space>>, $StreamProvider<List<Space>> {
  /// The spaces a picker should offer for [kind] — what makes section 6.5's
  /// acceptance criterion true ("creating a space with Expenses enabled makes it
  /// selectable in the New expense sheet").
  SpacesHoldingProvider._({
    required SpacesHoldingFamily super.from,
    required SpaceHolds super.argument,
  }) : super(
         retry: null,
         name: r'spacesHoldingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spacesHoldingHash();

  @override
  String toString() {
    return r'spacesHoldingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Space>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Space>> create(Ref ref) {
    final argument = this.argument as SpaceHolds;
    return spacesHolding(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpacesHoldingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spacesHoldingHash() => r'7ee4511d324ae2b0107046c20b33ee659a50daf6';

/// The spaces a picker should offer for [kind] — what makes section 6.5's
/// acceptance criterion true ("creating a space with Expenses enabled makes it
/// selectable in the New expense sheet").

final class SpacesHoldingFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Space>>, SpaceHolds> {
  SpacesHoldingFamily._()
    : super(
        retry: null,
        name: r'spacesHoldingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The spaces a picker should offer for [kind] — what makes section 6.5's
  /// acceptance criterion true ("creating a space with Expenses enabled makes it
  /// selectable in the New expense sheet").

  SpacesHoldingProvider call(SpaceHolds kind) =>
      SpacesHoldingProvider._(argument: kind, from: this);

  @override
  String toString() => r'spacesHoldingProvider';
}

/// Live per-space counts for the grid's sub-lines, keyed by space id.

@ProviderFor(spaceSummaries)
final spaceSummariesProvider = SpaceSummariesProvider._();

/// Live per-space counts for the grid's sub-lines, keyed by space id.

final class SpaceSummariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, SpaceSummary>>,
          Map<String, SpaceSummary>,
          Stream<Map<String, SpaceSummary>>
        >
    with
        $FutureModifier<Map<String, SpaceSummary>>,
        $StreamProvider<Map<String, SpaceSummary>> {
  /// Live per-space counts for the grid's sub-lines, keyed by space id.
  SpaceSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spaceSummariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spaceSummariesHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, SpaceSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, SpaceSummary>> create(Ref ref) {
    return spaceSummaries(ref);
  }
}

String _$spaceSummariesHash() => r'fc30bdda525333f44803206087666eb32342ff2b';
