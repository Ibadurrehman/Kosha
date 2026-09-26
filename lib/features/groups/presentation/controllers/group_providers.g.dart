// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The groups filed under one space — what the space detail's trip card reads.
/// A space with none shows the card's "start one" state instead.

@ProviderFor(groupsInSpace)
final groupsInSpaceProvider = GroupsInSpaceFamily._();

/// The groups filed under one space — what the space detail's trip card reads.
/// A space with none shows the card's "start one" state instead.

final class GroupsInSpaceProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Group>>,
          List<Group>,
          Stream<List<Group>>
        >
    with $FutureModifier<List<Group>>, $StreamProvider<List<Group>> {
  /// The groups filed under one space — what the space detail's trip card reads.
  /// A space with none shows the card's "start one" state instead.
  GroupsInSpaceProvider._({
    required GroupsInSpaceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupsInSpaceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupsInSpaceHash();

  @override
  String toString() {
    return r'groupsInSpaceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Group>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Group>> create(Ref ref) {
    final argument = this.argument as String;
    return groupsInSpace(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupsInSpaceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupsInSpaceHash() => r'856897b7bc41e2c2fc160dcc5f61b29d09e844e8';

/// The groups filed under one space — what the space detail's trip card reads.
/// A space with none shows the card's "start one" state instead.

final class GroupsInSpaceFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Group>>, String> {
  GroupsInSpaceFamily._()
    : super(
        retry: null,
        name: r'groupsInSpaceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The groups filed under one space — what the space detail's trip card reads.
  /// A space with none shows the card's "start one" state instead.

  GroupsInSpaceProvider call(String spaceId) =>
      GroupsInSpaceProvider._(argument: spaceId, from: this);

  @override
  String toString() => r'groupsInSpaceProvider';
}

@ProviderFor(groupById)
final groupByIdProvider = GroupByIdFamily._();

final class GroupByIdProvider
    extends $FunctionalProvider<AsyncValue<Group?>, Group?, Stream<Group?>>
    with $FutureModifier<Group?>, $StreamProvider<Group?> {
  GroupByIdProvider._({
    required GroupByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupByIdHash();

  @override
  String toString() {
    return r'groupByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Group?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Group?> create(Ref ref) {
    final argument = this.argument as String;
    return groupById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupByIdHash() => r'cebcf487300ff3534a9b838a85d9ef6db23d5c42';

final class GroupByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Group?>, String> {
  GroupByIdFamily._()
    : super(
        retry: null,
        name: r'groupByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupByIdProvider call(String groupId) =>
      GroupByIdProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupByIdProvider';
}

/// Members in their stored order, which is the order the ledger walks.

@ProviderFor(groupMembers)
final groupMembersProvider = GroupMembersFamily._();

/// Members in their stored order, which is the order the ledger walks.

final class GroupMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroupMember>>,
          List<GroupMember>,
          Stream<List<GroupMember>>
        >
    with
        $FutureModifier<List<GroupMember>>,
        $StreamProvider<List<GroupMember>> {
  /// Members in their stored order, which is the order the ledger walks.
  GroupMembersProvider._({
    required GroupMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupMembersHash();

  @override
  String toString() {
    return r'groupMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<GroupMember>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GroupMember>> create(Ref ref) {
    final argument = this.argument as String;
    return groupMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupMembersHash() => r'730c09e032dc4e1d6f3babd6f7b63d3713de0c49';

/// Members in their stored order, which is the order the ledger walks.

final class GroupMembersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<GroupMember>>, String> {
  GroupMembersFamily._()
    : super(
        retry: null,
        name: r'groupMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Members in their stored order, which is the order the ledger walks.

  GroupMembersProvider call(String groupId) =>
      GroupMembersProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupMembersProvider';
}

@ProviderFor(groupExpenses)
final groupExpensesProvider = GroupExpensesFamily._();

final class GroupExpensesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SharedExpense>>,
          List<SharedExpense>,
          Stream<List<SharedExpense>>
        >
    with
        $FutureModifier<List<SharedExpense>>,
        $StreamProvider<List<SharedExpense>> {
  GroupExpensesProvider._({
    required GroupExpensesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupExpensesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupExpensesHash();

  @override
  String toString() {
    return r'groupExpensesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SharedExpense>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SharedExpense>> create(Ref ref) {
    final argument = this.argument as String;
    return groupExpenses(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupExpensesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupExpensesHash() => r'6f826a01ce6ec77d6d03569c9d872d1afbcd9882';

final class GroupExpensesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SharedExpense>>, String> {
  GroupExpensesFamily._()
    : super(
        retry: null,
        name: r'groupExpensesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupExpensesProvider call(String groupId) =>
      GroupExpensesProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupExpensesProvider';
}

@ProviderFor(groupSettlements)
final groupSettlementsProvider = GroupSettlementsFamily._();

final class GroupSettlementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Settlement>>,
          List<Settlement>,
          Stream<List<Settlement>>
        >
    with $FutureModifier<List<Settlement>>, $StreamProvider<List<Settlement>> {
  GroupSettlementsProvider._({
    required GroupSettlementsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupSettlementsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupSettlementsHash();

  @override
  String toString() {
    return r'groupSettlementsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Settlement>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Settlement>> create(Ref ref) {
    final argument = this.argument as String;
    return groupSettlements(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupSettlementsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupSettlementsHash() => r'df29123e6c54aa45097ca887d48401e362ade0e6';

final class GroupSettlementsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Settlement>>, String> {
  GroupSettlementsFamily._()
    : super(
        retry: null,
        name: r'groupSettlementsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupSettlementsProvider call(String groupId) =>
      GroupSettlementsProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupSettlementsProvider';
}

/// Where everyone stands, recomputed on any write that could move it.

@ProviderFor(groupLedger)
final groupLedgerProvider = GroupLedgerFamily._();

/// Where everyone stands, recomputed on any write that could move it.

final class GroupLedgerProvider
    extends $FunctionalProvider<AsyncValue<Ledger>, Ledger, Stream<Ledger>>
    with $FutureModifier<Ledger>, $StreamProvider<Ledger> {
  /// Where everyone stands, recomputed on any write that could move it.
  GroupLedgerProvider._({
    required GroupLedgerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupLedgerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupLedgerHash();

  @override
  String toString() {
    return r'groupLedgerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Ledger> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Ledger> create(Ref ref) {
    final argument = this.argument as String;
    return groupLedger(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupLedgerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupLedgerHash() => r'24db7192b2bf84ca5c11207c2a905e5f74e3ac2d';

/// Where everyone stands, recomputed on any write that could move it.

final class GroupLedgerFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Ledger>, String> {
  GroupLedgerFamily._()
    : super(
        retry: null,
        name: r'groupLedgerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Where everyone stands, recomputed on any write that could move it.

  GroupLedgerProvider call(String groupId) =>
      GroupLedgerProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupLedgerProvider';
}
