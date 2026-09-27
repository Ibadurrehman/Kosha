import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../documents/data/document_repository_impl.dart';
import '../../../documents/domain/entities/document.dart';
import '../../../finance/data/transaction_repository_impl.dart';
import '../../../finance/domain/entities/transaction.dart';
import '../../../tasks/data/task_repository_impl.dart';
import '../../../tasks/domain/entities/task.dart';

part 'space_detail_providers.g.dart';

/// How many rows each Space detail section shows before it stops. The sections
/// are a summary of the space, not its archive — the prototype's space detail
/// shows a handful and links onward.
const int spaceSectionLimit = 5;

@riverpod
Stream<List<Task>> spaceTasks(Ref ref, String spaceId) => ref
    .watch(taskRepositoryProvider)
    .watchInSpace(spaceId, limit: spaceSectionLimit);

@riverpod
Stream<List<Transaction>> spaceTransactions(Ref ref, String spaceId) => ref
    .watch(transactionRepositoryProvider)
    .watchInSpace(spaceId, limit: spaceSectionLimit);

@riverpod
Stream<List<Document>> spaceDocuments(Ref ref, String spaceId) => ref
    .watch(documentRepositoryProvider)
    .watchInSpace(spaceId, limit: spaceSectionLimit);
