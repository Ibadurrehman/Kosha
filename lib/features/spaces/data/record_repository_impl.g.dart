// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recordRepository)
final recordRepositoryProvider = RecordRepositoryProvider._();

final class RecordRepositoryProvider
    extends
        $FunctionalProvider<
          RecordRepository,
          RecordRepository,
          RecordRepository
        >
    with $Provider<RecordRepository> {
  RecordRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecordRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecordRepository create(Ref ref) {
    return recordRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordRepository>(value),
    );
  }
}

String _$recordRepositoryHash() => r'1fcf7e7ec8e24707939198f0ac28aaae5f622ea7';
