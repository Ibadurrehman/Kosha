// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(spaceTasks)
final spaceTasksProvider = SpaceTasksFamily._();

final class SpaceTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  SpaceTasksProvider._({
    required SpaceTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spaceTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spaceTasksHash();

  @override
  String toString() {
    return r'spaceTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return spaceTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spaceTasksHash() => r'e73f197576f8cd8daa0a27226324e62c503447bb';

final class SpaceTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  SpaceTasksFamily._()
    : super(
        retry: null,
        name: r'spaceTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpaceTasksProvider call(String spaceId) =>
      SpaceTasksProvider._(argument: spaceId, from: this);

  @override
  String toString() => r'spaceTasksProvider';
}

@ProviderFor(spaceTransactions)
final spaceTransactionsProvider = SpaceTransactionsFamily._();

final class SpaceTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          Stream<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $StreamProvider<List<Transaction>> {
  SpaceTransactionsProvider._({
    required SpaceTransactionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spaceTransactionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spaceTransactionsHash();

  @override
  String toString() {
    return r'spaceTransactionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Transaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Transaction>> create(Ref ref) {
    final argument = this.argument as String;
    return spaceTransactions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceTransactionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spaceTransactionsHash() => r'bd4f3babe714542ad1516f9f3095219167b54a15';

final class SpaceTransactionsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Transaction>>, String> {
  SpaceTransactionsFamily._()
    : super(
        retry: null,
        name: r'spaceTransactionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpaceTransactionsProvider call(String spaceId) =>
      SpaceTransactionsProvider._(argument: spaceId, from: this);

  @override
  String toString() => r'spaceTransactionsProvider';
}

@ProviderFor(spaceDocuments)
final spaceDocumentsProvider = SpaceDocumentsFamily._();

final class SpaceDocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Document>>,
          List<Document>,
          Stream<List<Document>>
        >
    with $FutureModifier<List<Document>>, $StreamProvider<List<Document>> {
  SpaceDocumentsProvider._({
    required SpaceDocumentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spaceDocumentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spaceDocumentsHash();

  @override
  String toString() {
    return r'spaceDocumentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Document>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Document>> create(Ref ref) {
    final argument = this.argument as String;
    return spaceDocuments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceDocumentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spaceDocumentsHash() => r'a03cfdf7df8f742c3fa1de47e51cdce4178c261a';

final class SpaceDocumentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Document>>, String> {
  SpaceDocumentsFamily._()
    : super(
        retry: null,
        name: r'spaceDocumentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpaceDocumentsProvider call(String spaceId) =>
      SpaceDocumentsProvider._(argument: spaceId, from: this);

  @override
  String toString() => r'spaceDocumentsProvider';
}
