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
