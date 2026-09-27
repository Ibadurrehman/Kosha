import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/record_repository_impl.dart';
import '../../domain/entities/custom_record.dart';
import '../../domain/entities/record_template.dart';

part 'record_providers.g.dart';

/// Every record type the user has built, for the Spaces grid's card.
@riverpod
Stream<List<RecordTemplate>> recordTemplates(Ref ref) =>
    ref.watch(recordRepositoryProvider).watchTemplates();

/// One record type, null once it has been deleted — which is how the Custom
/// records screen knows to stop drawing rather than throwing on a template
/// that went away under it.
@riverpod
Stream<RecordTemplate?> recordTemplate(Ref ref, String templateId) =>
    ref.watch(recordRepositoryProvider).watchTemplateById(templateId);

@riverpod
Stream<List<CustomRecord>> recordsOfTemplate(Ref ref, String templateId) =>
    ref.watch(recordRepositoryProvider).watchRecords(templateId);

/// How many live records each type holds, for the grid card's sub-line.
@riverpod
Stream<Map<String, int>> recordCounts(Ref ref) =>
    ref.watch(recordRepositoryProvider).watchRecordCounts();
