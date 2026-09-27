import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/finance/domain/entities/transaction.dart';
import 'package:kosha/features/onboarding/domain/area.dart';
import 'package:kosha/features/spaces/data/space_repository_impl.dart';
import 'package:kosha/features/spaces/domain/entities/space.dart';
import 'package:kosha/features/tasks/domain/entities/task.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DriftSpaceRepository repository;

  setUp(() {
    db = testDatabase();
    repository = testSpaceRepository(db);
  });

  tearDown(() => db.close());

  group('seeding', () {
    test('a first read seeds the ten system spaces in prototype order',
        () async {
      final spaces = await repository.listActive();
      final systemKeys = spaces.map((s) => s.systemKey).toList();

      // defaultVisibleAreas is tasks/finance/bills/documents/shopping, so
      // four of the seven gated spaces — Home among them — start folded away.
      expect(spaces.every((s) => s.isSystem), isTrue);
      expect(spaces, hasLength(6));
      expect(
        systemKeys,
        containsAll([
          SystemSpace.finance,
          SystemSpace.documents,
          SystemSpace.shopping,
        ]),
      );
      expect(systemKeys, isNot(contains(SystemSpace.home)));
      expect(spaces.first.systemKey, SystemSpace.finance);
      expect(spaces.first.createdAt, testNow);
    });

    test('every system space exists, including the ones starting archived',
        () async {
      await repository.listActive();
      final all = [
        ...await repository.listActive(),
        ...await repository.watchArchived().first,
      ];
      expect(
        all.map((s) => s.systemKey).toSet(),
        SystemSpace.values.toSet(),
      );
    });

    test('an area the user did not pick seeds its space archived', () async {
      // defaultVisibleAreas covers tasks, finance, bills, documents and
      // shopping — so Home, Vehicle, Goals and Notes start folded away.
      // Tasks is picked but gates nothing: tasks live in their own tab.
      final archived = await repository.watchArchived().first;
      expect(
        archived.map((s) => s.systemKey),
        containsAll([
          SystemSpace.home,
          SystemSpace.vehicle,
          SystemSpace.goals,
          SystemSpace.notes,
        ]),
      );
      expect(archived.every((s) => s.archivedAt == testNow), isTrue);
    });

    test('a space the user was never asked about starts visible', () async {
      final active = await repository.listActive();
      expect(
        active.map((s) => s.systemKey),
        containsAll([
          SystemSpace.ideas,
          SystemSpace.health,
          SystemSpace.travel,
        ]),
      );
    });

    test('picking Vehicle at onboarding makes its space visible', () async {
      await testProfileRepository(db).setVisibleAreas({
        OnboardingArea.vehicle,
        OnboardingArea.notes,
      });

      final active = await repository.listActive();
      expect(
        active.map((s) => s.systemKey),
        containsAll([SystemSpace.vehicle, SystemSpace.notes]),
      );
      final archived = await repository.watchArchived().first;
      expect(archived.map((s) => s.systemKey), contains(SystemSpace.finance));
    });

    test('picking Bills alone still brings Finance, which owns bills',
        () async {
      await testProfileRepository(db).setVisibleAreas({OnboardingArea.bills});

      final active = await repository.listActive();
      expect(active.map((s) => s.systemKey), contains(SystemSpace.finance));
    });

    test('reading twice does not seed twice', () async {
      await repository.listActive();
      final second = await repository.listActive();
      final archived = await repository.watchArchived().first;
      expect(second.length + archived.length, SystemSpace.values.length);
    });

    test('archiving every space does not bring the defaults back', () async {
      for (final space in await repository.listActive()) {
        await repository.archive(space.id);
      }
      expect(await repository.listActive(), isEmpty);
    });

    test('the unique index keeps a system space from being seeded twice',
        () async {
      await repository.listActive();
      // A second repository over the same database is a fresh object with no
      // memory of having seeded — only the row count stops it.
      final other = testSpaceRepository(db);
      await other.listActive();

      final finance = await repository.findBySystemKey(SystemSpace.finance);
      expect(finance, isNotNull);
      expect(
        () => db.into(db.spaces).insert(
              SpacesCompanion.insert(
                id: 'duplicate',
                name: 'Finance again',
                kind: SpaceKind.system,
                systemKey: const Value(SystemSpace.finance),
                holds: const {SpaceHolds.expenses},
                sortOrder: 99,
                createdAt: testNow,
                updatedAt: testNow,
              ),
            ),
        throwsA(anything),
      );
    });
  });

  group('holds', () {
    test('round-trips through the converter in enum order', () async {
      final space = await repository.create(
        const NewSpace(
          name: 'Studio',
          holds: {SpaceHolds.expenses, SpaceHolds.tasks},
        ),
      );

      final reloaded = await repository.findById(space.id);
      expect(reloaded!.holds, {SpaceHolds.tasks, SpaceHolds.expenses});
      expect(reloaded.holdsKind(SpaceHolds.notes), isFalse);
    });

    test('an empty set survives the round trip', () async {
      final space = await repository.create(
        const NewSpace(name: 'Empty', holds: {}),
      );
      expect((await repository.findById(space.id))!.holds, isEmpty);
    });

    test('watchHolding offers only active spaces that accept the kind',
        () async {
      await repository.create(
        const NewSpace(name: 'Studio', holds: {SpaceHolds.expenses}),
      );
      await repository.create(
        const NewSpace(name: 'Reading', holds: {SpaceHolds.notes}),
      );

      final holders = await repository.watchHolding(SpaceHolds.expenses).first;
      final names = holders.map((s) => s.name);
      expect(names, contains('Studio'));
      expect(names, isNot(contains('Reading')));
      // Section 6.5's acceptance: a space that holds expenses is selectable
      // in the New expense sheet, which reads exactly this.
      expect(names, contains('Finance'));
    });

    test('an archived space drops out of the pickers', () async {
      final space = await repository.create(
        const NewSpace(name: 'Studio', holds: {SpaceHolds.expenses}),
      );
      await repository.archive(space.id);

      final holders = await repository.watchHolding(SpaceHolds.expenses).first;
      expect(holders.map((s) => s.name), isNot(contains('Studio')));
    });
  });

  group('create and edit', () {
    test('a new space lands at the end of the grid as a custom space',
        () async {
      final space = await repository.create(
        const NewSpace(name: 'Studio', holds: defaultNewSpaceHolds),
      );

      expect(space.kind, SpaceKind.custom);
      expect(space.systemKey, isNull);
      expect(space.sortOrder, SystemSpace.values.length);
      expect((await repository.listActive()).last.name, 'Studio');
    });

    test('edit changes only what it is given', () async {
      final space = await repository.create(
        const NewSpace(
          name: 'Studio',
          holds: {SpaceHolds.tasks},
          iconKey: 'flag',
        ),
      );

      final renamed = await repository.edit(space.id, name: 'Workshop');
      expect(renamed.name, 'Workshop');
      expect(renamed.iconKey, 'flag');
      expect(renamed.holds, {SpaceHolds.tasks});

      final rescoped = await repository.edit(
        space.id,
        holds: {SpaceHolds.notes, SpaceHolds.lists},
      );
      expect(rescoped.name, 'Workshop');
      expect(rescoped.holds, {SpaceHolds.notes, SpaceHolds.lists});
    });

    test('editing an unknown id throws rather than reporting success',
        () async {
      expect(
        () => repository.edit('nope', name: 'Ghost'),
        throwsStateError,
      );
    });

    test('reorder persists the grid order', () async {
      final active = await repository.listActive();
      final reversed = active.reversed.map((s) => s.id).toList();

      await repository.reorder(reversed);

      expect((await repository.listActive()).map((s) => s.id), reversed);
    });
  });

  group('archive and restore', () {
    test('archiving hides a space and restoring brings it back', () async {
      final space = await repository.create(
        const NewSpace(name: 'Studio', holds: {SpaceHolds.tasks}),
      );

      await repository.archive(space.id);
      expect(
        (await repository.listActive()).map((s) => s.name),
        isNot(contains('Studio')),
      );
      expect(
        (await repository.watchArchived().first).map((s) => s.name),
        contains('Studio'),
      );

      await repository.restore(space.id);
      expect(
        (await repository.listActive()).map((s) => s.name),
        contains('Studio'),
      );
    });

    test('items keep their link, so a restore brings the space back intact',
        () async {
      // ADR 0008: archiving is not an unlink. The task below still points at
      // the space while it is hidden, which is what makes the restore whole.
      final space = await repository.create(
        const NewSpace(name: 'Studio', holds: {SpaceHolds.tasks}),
      );
      final tasks = testRepository(db);
      await tasks.create(NewTask(title: 'Wire the bench', spaceId: space.id));

      await repository.archive(space.id);

      expect(await repository.linkedItemCount(space.id), 1);
      await repository.restore(space.id);
      expect(await repository.linkedItemCount(space.id), 1);
    });
  });

  group('linkedItemCount', () {
    test('counts live items across every table that carries a space',
        () async {
      final space = await repository.create(
        const NewSpace(
          name: 'Studio',
          holds: {SpaceHolds.tasks, SpaceHolds.expenses},
        ),
      );

      final tasks = testRepository(db);
      final task = await tasks.create(
        NewTask(title: 'Wire the bench', spaceId: space.id),
      );
      await testTransactionRepository(db).create(
        NewTransaction(
          amountMinor: 45000,
          type: TransactionType.expense,
          date: testToday,
          category: 'Shopping',
          spaceId: space.id,
        ),
      );

      expect(await repository.linkedItemCount(space.id), 2);

      // A deleted task is not something to warn the user about.
      await tasks.softDelete(task.id);
      expect(await repository.linkedItemCount(space.id), 1);
    });

    test('a space nothing points at counts zero', () async {
      final space = await repository.create(
        const NewSpace(name: 'Studio', holds: {SpaceHolds.tasks}),
      );
      expect(await repository.linkedItemCount(space.id), 0);
    });
  });
}
