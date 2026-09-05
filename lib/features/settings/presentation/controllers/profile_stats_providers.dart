import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/clock.dart';
import '../../../tasks/data/task_repository_impl.dart';

part 'profile_stats_providers.g.dart';

/// The two "this month" stats Profile can show honestly — the prototype's
/// other three (expenses/goals/documents) are omitted until those features
/// exist, rather than shown as fabricated zeros.
@riverpod
Future<int> tasksCompletedThisMonth(Ref ref) {
  final today = ref.watch(clockProvider).today();
  return ref.watch(taskRepositoryProvider).countCompleted(
        from: DateTime(today.year, today.month, 1),
        to: DateTime(today.year, today.month + 1, 1),
      );
}

@riverpod
Future<int> tasksAddedThisMonth(Ref ref) {
  final today = ref.watch(clockProvider).today();
  return ref.watch(taskRepositoryProvider).countCreated(
        from: DateTime(today.year, today.month, 1),
        to: DateTime(today.year, today.month + 1, 1),
      );
}
