import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/services/settings/settings_store.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/search/data/search_repository_impl.dart';
import 'package:kosha/features/search/domain/search_filter.dart';
import 'package:kosha/features/search/domain/search_result.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftSearchRepository search;

  setUp(() {
    db = testDatabase();
    search = DriftSearchRepository(db, SettingsStore(db, FixedClock(testNow)));
  });

  tearDown(() => db.close());

  group('supports', () {
    test('only Everything and Tasks are backed by a real index', () {
      expect(search.supports(SearchFilter.everything), isTrue);
      expect(search.supports(SearchFilter.tasks), isTrue);
      expect(search.supports(SearchFilter.notes), isFalse);
      expect(search.supports(SearchFilter.documents), isFalse);
      expect(search.supports(SearchFilter.finance), isFalse);
      expect(search.supports(SearchFilter.spaces), isFalse);
    });
  });

  group('search', () {
    test('matches by title, description or category, case-insensitively',
        () async {
      final repository = testRepository(db);
      final task = await repository.create(
        const NewTask(
          title: 'Renew Passport',
          description: 'Check the expiry date first',
          category: 'Documents',
        ),
      );

      for (final query in ['passport', 'PASSPORT', 'expiry', 'documents']) {
        final results =
            await search.search(query, filter: SearchFilter.everything).first;
        expect(results.map((r) => r.id), [task.id], reason: 'query: $query');
      }
    });

    test('matches by prefix', () async {
      final repository = testRepository(db);
      final task = await repository.create(const NewTask(title: 'Groceries'));
      final results = await search.search('groc', filter: SearchFilter.tasks).first;
      expect(results.single.id, task.id);
    });

    test('is diacritics-insensitive', () async {
      final repository = testRepository(db);
      final task = await repository.create(const NewTask(title: 'Café budget'));
      final results = await search.search('cafe', filter: SearchFilter.tasks).first;
      expect(results.single.id, task.id);
    });

    test('excludes soft-deleted tasks', () async {
      final repository = testRepository(db);
      final task = await repository.create(const NewTask(title: 'Old idea'));
      await repository.softDelete(task.id);
      final results = await search.search('idea', filter: SearchFilter.everything).first;
      expect(results, isEmpty);
    });

    test('returns empty results for an unsupported filter without erroring',
        () async {
      final repository = testRepository(db);
      await repository.create(const NewTask(title: 'Groceries'));
      final results = await search.search('groceries', filter: SearchFilter.notes).first;
      expect(results, isEmpty);
    });

    test('a blank query returns no results', () async {
      final repository = testRepository(db);
      await repository.create(const NewTask(title: 'Groceries'));
      expect(await search.search('', filter: SearchFilter.everything).first, isEmpty);
    });

    test('malformed input (operators, quotes, parentheses) does not throw',
        () async {
      final repository = testRepository(db);
      await repository.create(const NewTask(title: 'Groceries'));
      for (final query in ['AND OR', '((', '"unterminated', 'a-b-c', '***']) {
        await expectLater(
          search.search(query, filter: SearchFilter.everything).first,
          completes,
        );
      }
    });

    test('results carry the right kind and a due-date subtitle', () async {
      final repository = testRepository(db);
      await repository.create(
        NewTask(title: 'Renew passport', dueDate: DateTime(2026, 9, 20)),
      );
      final result =
          (await search.search('passport', filter: SearchFilter.everything).first)
              .single;
      expect(result.kind, SearchResultKind.task);
      expect(result.subtitle, 'Due 20 Sep');
    });
  });

  group('recent searches', () {
    test('starts empty', () async {
      expect(await search.recentSearches(), isEmpty);
    });

    test('records the most recent 5, newest first, de-duplicated', () async {
      for (final query in ['a', 'b', 'c', 'd', 'e', 'f']) {
        await search.recordSearch(query);
      }
      await search.recordSearch('c'); // re-search moves it to the front

      expect(await search.recentSearches(), ['c', 'f', 'e', 'd', 'b']);
    });

    test('a blank query is not recorded', () async {
      await search.recordSearch('   ');
      expect(await search.recentSearches(), isEmpty);
    });
  });
}
