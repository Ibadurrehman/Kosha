// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The category chip the Documents screen is filtered by; null is "All".

@ProviderFor(DocumentFilter)
final documentFilterProvider = DocumentFilterProvider._();

/// The category chip the Documents screen is filtered by; null is "All".
final class DocumentFilterProvider
    extends $NotifierProvider<DocumentFilter, DocumentCategory?> {
  /// The category chip the Documents screen is filtered by; null is "All".
  DocumentFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentFilterHash();

  @$internal
  @override
  DocumentFilter create() => DocumentFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentCategory? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentCategory?>(value),
    );
  }
}

String _$documentFilterHash() => r'db5857a812606ebce53ff15e126ea76d92d0a3a0';

/// The category chip the Documents screen is filtered by; null is "All".

abstract class _$DocumentFilter extends $Notifier<DocumentCategory?> {
  DocumentCategory? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DocumentCategory?, DocumentCategory?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DocumentCategory?, DocumentCategory?>,
              DocumentCategory?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(documents)
final documentsProvider = DocumentsProvider._();

final class DocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Document>>,
          List<Document>,
          Stream<List<Document>>
        >
    with $FutureModifier<List<Document>>, $StreamProvider<List<Document>> {
  DocumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsHash();

  @$internal
  @override
  $StreamProviderElement<List<Document>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Document>> create(Ref ref) {
    return documents(ref);
  }
}

String _$documentsHash() => r'a9702a1ef6b51b55efa6d541f97869363b6364f0';

/// Counts per chip. Unfiltered on purpose: a chip that said "0" only because
/// another chip is selected would be lying about what is in the app.

@ProviderFor(documentCategoryCounts)
final documentCategoryCountsProvider = DocumentCategoryCountsProvider._();

/// Counts per chip. Unfiltered on purpose: a chip that said "0" only because
/// another chip is selected would be lying about what is in the app.

final class DocumentCategoryCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DocumentCategory, int>>,
          Map<DocumentCategory, int>,
          Stream<Map<DocumentCategory, int>>
        >
    with
        $FutureModifier<Map<DocumentCategory, int>>,
        $StreamProvider<Map<DocumentCategory, int>> {
  /// Counts per chip. Unfiltered on purpose: a chip that said "0" only because
  /// another chip is selected would be lying about what is in the app.
  DocumentCategoryCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentCategoryCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentCategoryCountsHash();

  @$internal
  @override
  $StreamProviderElement<Map<DocumentCategory, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<DocumentCategory, int>> create(Ref ref) {
    return documentCategoryCounts(ref);
  }
}

String _$documentCategoryCountsHash() =>
    r'dfebfd0e7de0e4ca517cdac750a750565a33b7b9';

@ProviderFor(archivedDocuments)
final archivedDocumentsProvider = ArchivedDocumentsProvider._();

final class ArchivedDocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Document>>,
          List<Document>,
          Stream<List<Document>>
        >
    with $FutureModifier<List<Document>>, $StreamProvider<List<Document>> {
  ArchivedDocumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archivedDocumentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archivedDocumentsHash();

  @$internal
  @override
  $StreamProviderElement<List<Document>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Document>> create(Ref ref) {
    return archivedDocuments(ref);
  }
}

String _$archivedDocumentsHash() => r'89feec5de392683465274a3ca82942f4466fc208';

/// One document for the detail screen; emits null once it is archived, which
/// is what sends the screen back rather than leaving a stale header up.

@ProviderFor(documentById)
final documentByIdProvider = DocumentByIdFamily._();

/// One document for the detail screen; emits null once it is archived, which
/// is what sends the screen back rather than leaving a stale header up.

final class DocumentByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Document?>, Document?, Stream<Document?>>
    with $FutureModifier<Document?>, $StreamProvider<Document?> {
  /// One document for the detail screen; emits null once it is archived, which
  /// is what sends the screen back rather than leaving a stale header up.
  DocumentByIdProvider._({
    required DocumentByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentByIdHash();

  @override
  String toString() {
    return r'documentByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Document?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Document?> create(Ref ref) {
    final argument = this.argument as String;
    return documentById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentByIdHash() => r'8204b3d3abf4502d26d4558d11bf1a4ecedd7c37';

/// One document for the detail screen; emits null once it is archived, which
/// is what sends the screen back rather than leaving a stale header up.

final class DocumentByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Document?>, String> {
  DocumentByIdFamily._()
    : super(
        retry: null,
        name: r'documentByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One document for the detail screen; emits null once it is archived, which
  /// is what sends the screen back rather than leaving a stale header up.

  DocumentByIdProvider call(String id) =>
      DocumentByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'documentByIdProvider';
}

@ProviderFor(documentAttachments)
final documentAttachmentsProvider = DocumentAttachmentsFamily._();

final class DocumentAttachmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Attachment>>,
          List<Attachment>,
          Stream<List<Attachment>>
        >
    with $FutureModifier<List<Attachment>>, $StreamProvider<List<Attachment>> {
  DocumentAttachmentsProvider._({
    required DocumentAttachmentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentAttachmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentAttachmentsHash();

  @override
  String toString() {
    return r'documentAttachmentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Attachment>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Attachment>> create(Ref ref) {
    final argument = this.argument as String;
    return documentAttachments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentAttachmentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentAttachmentsHash() =>
    r'aaae18ae415a75a1e4e2e5efb1f8032c88313059';

final class DocumentAttachmentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Attachment>>, String> {
  DocumentAttachmentsFamily._()
    : super(
        retry: null,
        name: r'documentAttachmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DocumentAttachmentsProvider call(String documentId) =>
      DocumentAttachmentsProvider._(argument: documentId, from: this);

  @override
  String toString() => r'documentAttachmentsProvider';
}

/// Documents that are expired or inside their own lead time — Home's Needs
/// attention reads this through its adapter, and Documents' own list uses it
/// for the "n need attention" line.

@ProviderFor(documentsNeedingAttention)
final documentsNeedingAttentionProvider = DocumentsNeedingAttentionProvider._();

/// Documents that are expired or inside their own lead time — Home's Needs
/// attention reads this through its adapter, and Documents' own list uses it
/// for the "n need attention" line.

final class DocumentsNeedingAttentionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Document>>,
          List<Document>,
          Stream<List<Document>>
        >
    with $FutureModifier<List<Document>>, $StreamProvider<List<Document>> {
  /// Documents that are expired or inside their own lead time — Home's Needs
  /// attention reads this through its adapter, and Documents' own list uses it
  /// for the "n need attention" line.
  DocumentsNeedingAttentionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsNeedingAttentionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsNeedingAttentionHash();

  @$internal
  @override
  $StreamProviderElement<List<Document>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Document>> create(Ref ref) {
    return documentsNeedingAttention(ref);
  }
}

String _$documentsNeedingAttentionHash() =>
    r'433153b4cba40decca098552d7212f7b817ee565';
