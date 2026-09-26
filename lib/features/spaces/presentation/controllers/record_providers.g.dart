// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every record type the user has built, for the Spaces grid's card.

@ProviderFor(recordTemplates)
final recordTemplatesProvider = RecordTemplatesProvider._();

/// Every record type the user has built, for the Spaces grid's card.

final class RecordTemplatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecordTemplate>>,
          List<RecordTemplate>,
          Stream<List<RecordTemplate>>
        >
    with
        $FutureModifier<List<RecordTemplate>>,
        $StreamProvider<List<RecordTemplate>> {
  /// Every record type the user has built, for the Spaces grid's card.
  RecordTemplatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordTemplatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordTemplatesHash();

  @$internal
  @override
  $StreamProviderElement<List<RecordTemplate>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecordTemplate>> create(Ref ref) {
    return recordTemplates(ref);
  }
}

String _$recordTemplatesHash() => r'1348fad41b7825a59e0f421896ec9252a2b9d4b3';

/// One record type, null once it has been deleted — which is how the Custom
/// records screen knows to stop drawing rather than throwing on a template
/// that went away under it.

@ProviderFor(recordTemplate)
final recordTemplateProvider = RecordTemplateFamily._();

/// One record type, null once it has been deleted — which is how the Custom
/// records screen knows to stop drawing rather than throwing on a template
/// that went away under it.

final class RecordTemplateProvider
    extends
        $FunctionalProvider<
          AsyncValue<RecordTemplate?>,
          RecordTemplate?,
          Stream<RecordTemplate?>
        >
    with $FutureModifier<RecordTemplate?>, $StreamProvider<RecordTemplate?> {
  /// One record type, null once it has been deleted — which is how the Custom
  /// records screen knows to stop drawing rather than throwing on a template
  /// that went away under it.
  RecordTemplateProvider._({
    required RecordTemplateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recordTemplateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recordTemplateHash();

  @override
  String toString() {
    return r'recordTemplateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<RecordTemplate?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RecordTemplate?> create(Ref ref) {
    final argument = this.argument as String;
    return recordTemplate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordTemplateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recordTemplateHash() => r'c5a05a9e87e0fbe329336d6e23f886bb23e0d05a';

/// One record type, null once it has been deleted — which is how the Custom
/// records screen knows to stop drawing rather than throwing on a template
/// that went away under it.

final class RecordTemplateFamily extends $Family
    with $FunctionalFamilyOverride<Stream<RecordTemplate?>, String> {
  RecordTemplateFamily._()
    : super(
        retry: null,
        name: r'recordTemplateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One record type, null once it has been deleted — which is how the Custom
  /// records screen knows to stop drawing rather than throwing on a template
  /// that went away under it.

  RecordTemplateProvider call(String templateId) =>
      RecordTemplateProvider._(argument: templateId, from: this);

  @override
  String toString() => r'recordTemplateProvider';
}

@ProviderFor(recordsOfTemplate)
final recordsOfTemplateProvider = RecordsOfTemplateFamily._();

final class RecordsOfTemplateProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CustomRecord>>,
          List<CustomRecord>,
          Stream<List<CustomRecord>>
        >
    with
        $FutureModifier<List<CustomRecord>>,
        $StreamProvider<List<CustomRecord>> {
  RecordsOfTemplateProvider._({
    required RecordsOfTemplateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recordsOfTemplateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recordsOfTemplateHash();

  @override
  String toString() {
    return r'recordsOfTemplateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CustomRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CustomRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return recordsOfTemplate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordsOfTemplateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recordsOfTemplateHash() => r'e641706b6eb201e2e71f3e3e6cd3ac942993604c';

final class RecordsOfTemplateFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CustomRecord>>, String> {
  RecordsOfTemplateFamily._()
    : super(
        retry: null,
        name: r'recordsOfTemplateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RecordsOfTemplateProvider call(String templateId) =>
      RecordsOfTemplateProvider._(argument: templateId, from: this);

  @override
  String toString() => r'recordsOfTemplateProvider';
}

/// How many live records each type holds, for the grid card's sub-line.

@ProviderFor(recordCounts)
final recordCountsProvider = RecordCountsProvider._();

/// How many live records each type holds, for the grid card's sub-line.

final class RecordCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          Stream<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $StreamProvider<Map<String, int>> {
  /// How many live records each type holds, for the grid card's sub-line.
  RecordCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordCountsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, int>> create(Ref ref) {
    return recordCounts(ref);
  }
}

String _$recordCountsHash() => r'3fe181fefb0062554b0bcc076a962bd0f55198b7';
