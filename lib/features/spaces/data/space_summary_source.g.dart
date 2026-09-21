// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_summary_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(spaceSummarySource)
final spaceSummarySourceProvider = SpaceSummarySourceProvider._();

final class SpaceSummarySourceProvider
    extends
        $FunctionalProvider<
          SpaceSummarySource,
          SpaceSummarySource,
          SpaceSummarySource
        >
    with $Provider<SpaceSummarySource> {
  SpaceSummarySourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spaceSummarySourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spaceSummarySourceHash();

  @$internal
  @override
  $ProviderElement<SpaceSummarySource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpaceSummarySource create(Ref ref) {
    return spaceSummarySource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpaceSummarySource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpaceSummarySource>(value),
    );
  }
}

String _$spaceSummarySourceHash() =>
    r'0a1ece499b09b53fd7492fb5a622c04c6110f0d8';
