import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/features/documents/data/document_repository_impl.dart';
import 'package:kosha/features/documents/domain/entities/attachment.dart';
import 'package:kosha/features/documents/domain/entities/document.dart';
import 'package:kosha/features/tasks/domain/entities/activity_entry.dart';

import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late RecordingReminderScheduler scheduler;
  late DriftDocumentRepository repository;

  setUp(() {
    db = testDatabase();
    scheduler = RecordingReminderScheduler();
    repository = testDocumentRepository(db, scheduler: scheduler);
  });

  tearDown(() => db.close());

  Future<Document> passport({
    DateTime? expiresOn,
    DocumentCategory category = DocumentCategory.identity,
    String name = 'Passport',
  }) =>
      repository.create(
        NewDocument(
          name: name,
          category: category,
          number: 'P4471882',
          issuedOn: DateTime(2016, 8, 20),
          expiresOn: expiresOn ?? DateTime(2027, 9, 19),
        ),
      );

  Attachment file({String name = 'passport.pdf', String path = 'a1.pdf'}) =>
      Attachment(
        id: 'att-$path',
        ownerType: documentOwnerType,
        ownerId: 'unused',
        fileName: name,
        mime: 'application/pdf',
        sizeBytes: 148000,
        relativePath: path,
        createdAt: testNow,
      );

  Future<List<ActivityEvent>> events(String documentId) async {
    final rows = await (db.select(db.activityEntries)
          ..where((a) => a.ownerId.equals(documentId)))
        .get();
    return rows.map((r) => r.event).toList();
  }

  Future<List<String?>> details(String documentId) async {
    final rows = await (db.select(db.activityEntries)
          ..where((a) => a.ownerId.equals(documentId)))
        .get();
    return rows.map((r) => r.detail).toList();
  }

  group('create', () {
    test('stores the document and logs that it was created', () async {
      final document = await passport();

      expect(document.name, 'Passport');
      expect(document.reminderOffsetDays, defaultDocumentReminderDays);
      expect(document.isArchived, isFalse);
      expect(await events(document.id), [ActivityEvent.created]);
    });

    test('schedules the expiry reminder', () async {
      final document = await passport(expiresOn: DateTime(2026, 12, 15));

      expect(
        scheduler.latestFor(document.id)!.fireAt,
        DateTime(2026, 11, 15, 9),
      );
    });

    test('a document with no expiry schedules nothing', () async {
      final document = await repository.create(
        const NewDocument(
          name: 'Degree certificate',
          category: DocumentCategory.education,
        ),
      );

      expect(scheduler.latestFor(document.id), isNull);
      expect(scheduler.cancelled, contains(document.id));
    });
  });

  group('reading', () {
    test('watchAll narrows to one category chip', () async {
      await passport();
      await passport(name: 'Vehicle insurance', category: DocumentCategory.vehicle);

      final identity = await repository
          .watchAll(category: DocumentCategory.identity)
          .first;
      expect(identity.map((d) => d.name), ['Passport']);
      expect(await repository.watchAll().first, hasLength(2));
    });

    test('category counts drive the chip labels', () async {
      await passport();
      await passport(name: 'PAN card');
      await passport(name: 'Insurance', category: DocumentCategory.insurance);

      final counts = await repository.watchCategoryCounts().first;
      expect(counts[DocumentCategory.identity], 2);
      expect(counts[DocumentCategory.insurance], 1);
      expect(counts[DocumentCategory.medical], isNull);
    });

    test('needing attention is expiring-or-expired, per document offset',
        () async {
      // Inside its own 30-day lead time.
      final expiring = await passport(expiresOn: DateTime(2026, 9, 19));
      // Past.
      final expired = await passport(
        name: 'Society NOC',
        expiresOn: DateTime(2026, 8, 30),
      );
      // Far ahead.
      await passport(name: 'Aadhaar', expiresOn: DateTime(2030, 1, 1));
      // Far ahead for its own shorter lead time.
      await repository.create(
        NewDocument(
          name: 'Short lead',
          category: DocumentCategory.other,
          expiresOn: DateTime(2026, 9, 19),
          reminderOffsetDays: 3,
        ),
      );

      final urgent = await repository
          .watchNeedingAttention(today: testToday)
          .first;
      expect(urgent.map((d) => d.id), [expired.id, expiring.id]);
    });

    test('expiring between a window is what Upcoming and Calendar read',
        () async {
      await passport(expiresOn: DateTime(2026, 9, 19));
      await passport(name: 'Later', expiresOn: DateTime(2026, 11, 1));

      final window = await repository
          .watchExpiringBetween(testToday, DateTime(2026, 10, 1))
          .first;
      expect(window.map((d) => d.name), ['Passport']);
    });
  });

  group('edit', () {
    test('changes only what it is given and re-syncs the reminder', () async {
      final document = await passport(expiresOn: DateTime(2026, 12, 15));
      scheduler.clear();

      final edited = await repository.edit(
        document.id,
        name: 'Passport (renewed)',
        expiresOn: DateTime(2027, 1, 20),
      );

      expect(edited.name, 'Passport (renewed)');
      expect(edited.number, 'P4471882');
      expect(edited.category, DocumentCategory.identity);
      expect(scheduler.latestFor(document.id)!.fireAt, DateTime(2026, 12, 21, 9));
    });

    test('clearing the expiry needs the sentinel, and cancels the reminder',
        () async {
      final document = await passport(expiresOn: DateTime(2026, 12, 15));
      scheduler.clear();

      final edited = await repository.edit(document.id, clearExpiry: true);

      expect(edited.expiresOn, isNull);
      expect(scheduler.latestFor(document.id), isNull);
      expect(scheduler.cancelled, contains(document.id));
    });

    test('passing null for a nullable field leaves it alone', () async {
      final document = await passport();

      final edited = await repository.edit(document.id, name: 'Renamed');

      expect(edited.expiresOn, isNotNull);
      expect(edited.number, 'P4471882');
    });

    test('the activity line names what changed', () async {
      final document = await passport();

      await repository.edit(
        document.id,
        name: 'Renamed',
        category: DocumentCategory.other,
      );

      expect(await details(document.id), contains('renamed, moved to Other'));
    });

    test('an edit that changes nothing recognisable logs no detail', () async {
      final document = await passport();

      await repository.edit(document.id, notes: 'Kept in the blue folder');

      expect(await details(document.id), contains(null));
    });

    test('editing an unknown id throws rather than reporting success',
        () async {
      expect(() => repository.edit('nope', name: 'Ghost'), throwsStateError);
    });
  });

  group('archive', () {
    test('hides the document, cancels its reminder, and can be undone',
        () async {
      final document = await passport();
      scheduler.clear();

      await repository.archive(document.id);

      expect(await repository.watchAll().first, isEmpty);
      expect((await repository.watchArchived().first).single.id, document.id);
      expect(scheduler.cancelled, contains(document.id));

      await repository.restore(document.id);
      expect((await repository.watchAll().first).single.id, document.id);
      expect(scheduler.latestFor(document.id), isNotNull);
    });

    test('an archived document is out of the counts and the urgent list',
        () async {
      final document = await passport(expiresOn: DateTime(2026, 9, 19));
      await repository.archive(document.id);

      expect(await repository.watchCategoryCounts().first, isEmpty);
      expect(
        await repository.watchNeedingAttention(today: testToday).first,
        isEmpty,
      );
    });

    test('archiving and restoring are both in the history', () async {
      final document = await passport();

      await repository.archive(document.id);
      await repository.restore(document.id);

      expect(
        await events(document.id),
        [ActivityEvent.created, ActivityEvent.deleted, ActivityEvent.restored],
      );
    });
  });

  group('attachments', () {
    test('adding one records it against the document', () async {
      final document = await passport();

      await repository.addAttachment(
        document.id,
        file().copyWith(ownerId: document.id),
      );

      final stored = await repository.listAttachments(document.id);
      expect(stored.single.fileName, 'passport.pdf');
      expect(stored.single.readableSize, '145 KB');
      expect(await details(document.id), contains('Attached passport.pdf'));
    });

    test('replacing swaps the row and keeps the history', () async {
      final document = await passport();
      await repository.addAttachment(
        document.id,
        file().copyWith(ownerId: document.id),
      );

      final previous = await repository.replaceAttachment(
        document.id,
        file(name: 'passport-2027.pdf', path: 'b2.pdf')
            .copyWith(ownerId: document.id),
      );

      // Section 6.8's acceptance: the replacement is the only file left, and
      // the one it displaced is still named in the activity history.
      expect(previous!.fileName, 'passport.pdf');
      final stored = await repository.listAttachments(document.id);
      expect(stored.map((a) => a.fileName), ['passport-2027.pdf']);
      expect(
        await details(document.id),
        contains('Replaced passport.pdf with passport-2027.pdf'),
      );
    });

    test('replacing when there is nothing to replace just attaches', () async {
      final document = await passport();

      final previous = await repository.replaceAttachment(
        document.id,
        file().copyWith(ownerId: document.id),
      );

      expect(previous, isNull);
      expect(await repository.listAttachments(document.id), hasLength(1));
    });

    test('attachments are scoped to their own document', () async {
      final one = await passport();
      final two = await passport(name: 'PAN card');
      await repository.addAttachment(
        one.id,
        file().copyWith(ownerId: one.id),
      );

      expect(await repository.listAttachments(two.id), isEmpty);
    });
  });
}
