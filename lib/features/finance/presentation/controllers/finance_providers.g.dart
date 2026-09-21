// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(thisMonthTransactions)
final thisMonthTransactionsProvider = ThisMonthTransactionsProvider._();

final class ThisMonthTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          Stream<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $StreamProvider<List<Transaction>> {
  ThisMonthTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'thisMonthTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$thisMonthTransactionsHash();

  @$internal
  @override
  $StreamProviderElement<List<Transaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Transaction>> create(Ref ref) {
    return thisMonthTransactions(ref);
  }
}

String _$thisMonthTransactionsHash() =>
    r'44b324f0f52dc24711186469ec82c054beb49642';

@ProviderFor(recentTransactions)
final recentTransactionsProvider = RecentTransactionsProvider._();

final class RecentTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          Stream<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $StreamProvider<List<Transaction>> {
  RecentTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentTransactionsHash();

  @$internal
  @override
  $StreamProviderElement<List<Transaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Transaction>> create(Ref ref) {
    return recentTransactions(ref);
  }
}

String _$recentTransactionsHash() =>
    r'2232962b76e83adb3d24f2753e0aa7910ad8def1';

/// One transaction for the detail screen; emits null once it is deleted.

@ProviderFor(transactionById)
final transactionByIdProvider = TransactionByIdFamily._();

/// One transaction for the detail screen; emits null once it is deleted.

final class TransactionByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Transaction?>,
          Transaction?,
          Stream<Transaction?>
        >
    with $FutureModifier<Transaction?>, $StreamProvider<Transaction?> {
  /// One transaction for the detail screen; emits null once it is deleted.
  TransactionByIdProvider._({
    required TransactionByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transactionByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionByIdHash();

  @override
  String toString() {
    return r'transactionByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Transaction?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Transaction?> create(Ref ref) {
    final argument = this.argument as String;
    return transactionById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionByIdHash() => r'9c4f464e637ac34a4eb3cc44e0c242328da1dd22';

/// One transaction for the detail screen; emits null once it is deleted.

final class TransactionByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Transaction?>, String> {
  TransactionByIdFamily._()
    : super(
        retry: null,
        name: r'transactionByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One transaction for the detail screen; emits null once it is deleted.

  TransactionByIdProvider call(String id) =>
      TransactionByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'transactionByIdProvider';
}

@ProviderFor(monthlyBudgetMinor)
final monthlyBudgetMinorProvider = MonthlyBudgetMinorProvider._();

final class MonthlyBudgetMinorProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  MonthlyBudgetMinorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyBudgetMinorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyBudgetMinorHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return monthlyBudgetMinor(ref);
  }
}

String _$monthlyBudgetMinorHash() =>
    r'76cdf6d26349dfccc49fb9a5854589b8ca8af384';

/// The user's categories for one side of the ledger, in their own order.
/// Seeded with the prototype's list on first read (see
/// `TransactionCategoryRepository`).

@ProviderFor(categoriesOfKind)
final categoriesOfKindProvider = CategoriesOfKindFamily._();

/// The user's categories for one side of the ledger, in their own order.
/// Seeded with the prototype's list on first read (see
/// `TransactionCategoryRepository`).

final class CategoriesOfKindProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionCategory>>,
          List<TransactionCategory>,
          Stream<List<TransactionCategory>>
        >
    with
        $FutureModifier<List<TransactionCategory>>,
        $StreamProvider<List<TransactionCategory>> {
  /// The user's categories for one side of the ledger, in their own order.
  /// Seeded with the prototype's list on first read (see
  /// `TransactionCategoryRepository`).
  CategoriesOfKindProvider._({
    required CategoriesOfKindFamily super.from,
    required CategoryKind super.argument,
  }) : super(
         retry: null,
         name: r'categoriesOfKindProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoriesOfKindHash();

  @override
  String toString() {
    return r'categoriesOfKindProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<TransactionCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionCategory>> create(Ref ref) {
    final argument = this.argument as CategoryKind;
    return categoriesOfKind(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesOfKindProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoriesOfKindHash() => r'a0498f2b1222fd007b328f847be1c650f8057813';

/// The user's categories for one side of the ledger, in their own order.
/// Seeded with the prototype's list on first read (see
/// `TransactionCategoryRepository`).

final class CategoriesOfKindFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<TransactionCategory>>,
          CategoryKind
        > {
  CategoriesOfKindFamily._()
    : super(
        retry: null,
        name: r'categoriesOfKindProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The user's categories for one side of the ledger, in their own order.
  /// Seeded with the prototype's list on first read (see
  /// `TransactionCategoryRepository`).

  CategoriesOfKindProvider call(CategoryKind kind) =>
      CategoriesOfKindProvider._(argument: kind, from: this);

  @override
  String toString() => r'categoriesOfKindProvider';
}

/// All transactions' month and filter chips. Kept alive so stepping back into
/// the screen lands where the user left it.

@ProviderFor(TransactionFilterController)
final transactionFilterControllerProvider =
    TransactionFilterControllerProvider._();

/// All transactions' month and filter chips. Kept alive so stepping back into
/// the screen lands where the user left it.
final class TransactionFilterControllerProvider
    extends $NotifierProvider<TransactionFilterController, TransactionFilter> {
  /// All transactions' month and filter chips. Kept alive so stepping back into
  /// the screen lands where the user left it.
  TransactionFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionFilterControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionFilterControllerHash();

  @$internal
  @override
  TransactionFilterController create() => TransactionFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionFilter>(value),
    );
  }
}

String _$transactionFilterControllerHash() =>
    r'edc4944430617eba1c830a133238737fe49dbbee';

/// All transactions' month and filter chips. Kept alive so stepping back into
/// the screen lands where the user left it.

abstract class _$TransactionFilterController
    extends $Notifier<TransactionFilter> {
  TransactionFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TransactionFilter, TransactionFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionFilter, TransactionFilter>,
              TransactionFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The filtered month, newest first. The month is filtered in SQL (it is an
/// indexed range); the chips are applied in Dart, because the same stream
/// also feeds the running totals above the list and re-querying per chip
/// would make the totals and the rows disagree for a frame.

@ProviderFor(filteredTransactions)
final filteredTransactionsProvider = FilteredTransactionsProvider._();

/// The filtered month, newest first. The month is filtered in SQL (it is an
/// indexed range); the chips are applied in Dart, because the same stream
/// also feeds the running totals above the list and re-querying per chip
/// would make the totals and the rows disagree for a frame.

final class FilteredTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          Stream<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $StreamProvider<List<Transaction>> {
  /// The filtered month, newest first. The month is filtered in SQL (it is an
  /// indexed range); the chips are applied in Dart, because the same stream
  /// also feeds the running totals above the list and re-querying per chip
  /// would make the totals and the rows disagree for a frame.
  FilteredTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredTransactionsHash();

  @$internal
  @override
  $StreamProviderElement<List<Transaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Transaction>> create(Ref ref) {
    return filteredTransactions(ref);
  }
}

String _$filteredTransactionsHash() =>
    r'c5de96bb3ca267ae87c9c500cf4c1ce6eb3d91d8';
