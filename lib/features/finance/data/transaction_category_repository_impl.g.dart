// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_category_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionCategoryRepository)
final transactionCategoryRepositoryProvider =
    TransactionCategoryRepositoryProvider._();

final class TransactionCategoryRepositoryProvider
    extends
        $FunctionalProvider<
          TransactionCategoryRepository,
          TransactionCategoryRepository,
          TransactionCategoryRepository
        >
    with $Provider<TransactionCategoryRepository> {
  TransactionCategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionCategoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionCategoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransactionCategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionCategoryRepository create(Ref ref) {
    return transactionCategoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionCategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionCategoryRepository>(
        value,
      ),
    );
  }
}

String _$transactionCategoryRepositoryHash() =>
    r'7bd386ea5d2de0128468edf0ff821d4130dee7c7';
