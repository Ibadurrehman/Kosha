// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(allBills)
final allBillsProvider = AllBillsProvider._();

final class AllBillsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Bill>>,
          List<Bill>,
          Stream<List<Bill>>
        >
    with $FutureModifier<List<Bill>>, $StreamProvider<List<Bill>> {
  AllBillsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allBillsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allBillsHash();

  @$internal
  @override
  $StreamProviderElement<List<Bill>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Bill>> create(Ref ref) {
    return allBills(ref);
  }
}

String _$allBillsHash() => r'14c623ab2d9e478c53f395001ee471a61a012ecb';

/// One bill for the detail screen; emits null once it is deleted.

@ProviderFor(billById)
final billByIdProvider = BillByIdFamily._();

/// One bill for the detail screen; emits null once it is deleted.

final class BillByIdProvider
    extends $FunctionalProvider<AsyncValue<Bill?>, Bill?, Stream<Bill?>>
    with $FutureModifier<Bill?>, $StreamProvider<Bill?> {
  /// One bill for the detail screen; emits null once it is deleted.
  BillByIdProvider._({
    required BillByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'billByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$billByIdHash();

  @override
  String toString() {
    return r'billByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Bill?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Bill?> create(Ref ref) {
    final argument = this.argument as String;
    return billById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BillByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$billByIdHash() => r'3a9e0d92c7938dc61af35320b3d825f56f242520';

/// One bill for the detail screen; emits null once it is deleted.

final class BillByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Bill?>, String> {
  BillByIdFamily._()
    : super(
        retry: null,
        name: r'billByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One bill for the detail screen; emits null once it is deleted.

  BillByIdProvider call(String id) =>
      BillByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'billByIdProvider';
}

@ProviderFor(billPayments)
final billPaymentsProvider = BillPaymentsFamily._();

final class BillPaymentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Payment>>,
          List<Payment>,
          Stream<List<Payment>>
        >
    with $FutureModifier<List<Payment>>, $StreamProvider<List<Payment>> {
  BillPaymentsProvider._({
    required BillPaymentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'billPaymentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$billPaymentsHash();

  @override
  String toString() {
    return r'billPaymentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Payment>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Payment>> create(Ref ref) {
    final argument = this.argument as String;
    return billPayments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BillPaymentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$billPaymentsHash() => r'5f084ff5d2199962000e0b959ec572a2547e07ad';

final class BillPaymentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Payment>>, String> {
  BillPaymentsFamily._()
    : super(
        retry: null,
        name: r'billPaymentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BillPaymentsProvider call(String id) =>
      BillPaymentsProvider._(argument: id, from: this);

  @override
  String toString() => r'billPaymentsProvider';
}

/// The Bills-screen tab. Kept alive so it survives leaving the screen, like
/// the Tasks screen's own tab state.

@ProviderFor(SelectedBillTab)
final selectedBillTabProvider = SelectedBillTabProvider._();

/// The Bills-screen tab. Kept alive so it survives leaving the screen, like
/// the Tasks screen's own tab state.
final class SelectedBillTabProvider
    extends $NotifierProvider<SelectedBillTab, BillTab> {
  /// The Bills-screen tab. Kept alive so it survives leaving the screen, like
  /// the Tasks screen's own tab state.
  SelectedBillTabProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBillTabProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBillTabHash();

  @$internal
  @override
  SelectedBillTab create() => SelectedBillTab();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BillTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BillTab>(value),
    );
  }
}

String _$selectedBillTabHash() => r'64265ecf311b90df0ce3ff739551f6e88e9b8a9e';

/// The Bills-screen tab. Kept alive so it survives leaving the screen, like
/// the Tasks screen's own tab state.

abstract class _$SelectedBillTab extends $Notifier<BillTab> {
  BillTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BillTab, BillTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BillTab, BillTab>,
              BillTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The bills one tab shows, ordered the way each tab reads best: soonest
/// first everywhere except Paid, which is most-recently-paid first.
///
/// The filtering happens in Dart, not SQL, because bill status is derived
/// from `nextDue` against today and never stored (section 5.2) — a WHERE
/// clause would have to re-implement [billStatus] and could drift from it.

@ProviderFor(billsInTab)
final billsInTabProvider = BillsInTabFamily._();

/// The bills one tab shows, ordered the way each tab reads best: soonest
/// first everywhere except Paid, which is most-recently-paid first.
///
/// The filtering happens in Dart, not SQL, because bill status is derived
/// from `nextDue` against today and never stored (section 5.2) — a WHERE
/// clause would have to re-implement [billStatus] and could drift from it.

final class BillsInTabProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Bill>>,
          List<Bill>,
          Stream<List<Bill>>
        >
    with $FutureModifier<List<Bill>>, $StreamProvider<List<Bill>> {
  /// The bills one tab shows, ordered the way each tab reads best: soonest
  /// first everywhere except Paid, which is most-recently-paid first.
  ///
  /// The filtering happens in Dart, not SQL, because bill status is derived
  /// from `nextDue` against today and never stored (section 5.2) — a WHERE
  /// clause would have to re-implement [billStatus] and could drift from it.
  BillsInTabProvider._({
    required BillsInTabFamily super.from,
    required BillTab super.argument,
  }) : super(
         retry: null,
         name: r'billsInTabProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$billsInTabHash();

  @override
  String toString() {
    return r'billsInTabProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Bill>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Bill>> create(Ref ref) {
    final argument = this.argument as BillTab;
    return billsInTab(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BillsInTabProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$billsInTabHash() => r'f1bfc2170d164eaca8d1924ba829a667b2795974';

/// The bills one tab shows, ordered the way each tab reads best: soonest
/// first everywhere except Paid, which is most-recently-paid first.
///
/// The filtering happens in Dart, not SQL, because bill status is derived
/// from `nextDue` against today and never stored (section 5.2) — a WHERE
/// clause would have to re-implement [billStatus] and could drift from it.

final class BillsInTabFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Bill>>, BillTab> {
  BillsInTabFamily._()
    : super(
        retry: null,
        name: r'billsInTabProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The bills one tab shows, ordered the way each tab reads best: soonest
  /// first everywhere except Paid, which is most-recently-paid first.
  ///
  /// The filtering happens in Dart, not SQL, because bill status is derived
  /// from `nextDue` against today and never stored (section 5.2) — a WHERE
  /// clause would have to re-implement [billStatus] and could drift from it.

  BillsInTabProvider call(BillTab tab) =>
      BillsInTabProvider._(argument: tab, from: this);

  @override
  String toString() => r'billsInTabProvider';
}

/// Everything still owed across every bill — the Bills screen's header total.

@ProviderFor(outstandingBillsMinor)
final outstandingBillsMinorProvider = OutstandingBillsMinorProvider._();

/// Everything still owed across every bill — the Bills screen's header total.

final class OutstandingBillsMinorProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Everything still owed across every bill — the Bills screen's header total.
  OutstandingBillsMinorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outstandingBillsMinorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outstandingBillsMinorHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return outstandingBillsMinor(ref);
  }
}

String _$outstandingBillsMinorHash() =>
    r'edc854d0568ee4aae46c1a1353433d3f698f717e';

/// Overdue bills plus everything falling due inside
/// [upcomingBillsWindowDays]. Paid bills never appear: paying is exactly what
/// should make a bill leave this card.

@ProviderFor(upcomingBills)
final upcomingBillsProvider = UpcomingBillsProvider._();

/// Overdue bills plus everything falling due inside
/// [upcomingBillsWindowDays]. Paid bills never appear: paying is exactly what
/// should make a bill leave this card.

final class UpcomingBillsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UpcomingBills>,
          UpcomingBills,
          Stream<UpcomingBills>
        >
    with $FutureModifier<UpcomingBills>, $StreamProvider<UpcomingBills> {
  /// Overdue bills plus everything falling due inside
  /// [upcomingBillsWindowDays]. Paid bills never appear: paying is exactly what
  /// should make a bill leave this card.
  UpcomingBillsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingBillsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingBillsHash();

  @$internal
  @override
  $StreamProviderElement<UpcomingBills> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UpcomingBills> create(Ref ref) {
    return upcomingBills(ref);
  }
}

String _$upcomingBillsHash() => r'4af60d5d9291ed0c9dad86753b64a8d6cebcf143';
