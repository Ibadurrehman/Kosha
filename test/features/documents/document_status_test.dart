import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/documents/domain/document_reminder.dart';
import 'package:kosha/features/documents/domain/entities/document.dart';

import '../../helpers/test_app.dart';

void main() {
  Document doc({
    DateTime? expiresOn,
    int reminderOffsetDays = defaultDocumentReminderDays,
    DateTime? archivedAt,
  }) =>
      Document(
        id: 'd1',
        name: 'Passport',
        category: DocumentCategory.identity,
        expiresOn: expiresOn,
        reminderOffsetDays: reminderOffsetDays,
        archivedAt: archivedAt,
        createdAt: testNow,
        updatedAt: testNow,
      );

  group('documentStatus', () {
    test('a document with no expiry is its own state, not Valid', () {
      expect(documentStatus(doc(), testToday), DocumentStatus.noExpiry);
    });

    test('an expiry comfortably ahead is Valid', () {
      final status = documentStatus(
        doc(expiresOn: DateTime(2027, 9, 4)),
        testToday,
      );
      expect(status, DocumentStatus.valid);
    });

    test('inside the document\'s own lead time it is Expiring', () {
      // 30 days from 4 Sep 2026 is 4 Oct; 19 Sep is inside it.
      final status = documentStatus(
        doc(expiresOn: DateTime(2026, 9, 19)),
        testToday,
      );
      expect(status, DocumentStatus.expiring);
    });

    test('the lead time is per document, not a constant', () {
      final soon = doc(expiresOn: DateTime(2026, 9, 19), reminderOffsetDays: 7);
      expect(documentStatus(soon, testToday), DocumentStatus.valid);
    });

    test('the expiry day itself is not expired', () {
      final status = documentStatus(doc(expiresOn: testToday), testToday);
      expect(status, DocumentStatus.expiring);
    });

    test('the day after is', () {
      final status = documentStatus(
        doc(expiresOn: DateTime(2026, 9, 3)),
        testToday,
      );
      expect(status, DocumentStatus.expired);
    });

    test('only expiring and expired need attention', () {
      expect(needsAttention(DocumentStatus.expired), isTrue);
      expect(needsAttention(DocumentStatus.expiring), isTrue);
      expect(needsAttention(DocumentStatus.valid), isFalse);
      expect(needsAttention(DocumentStatus.noExpiry), isFalse);
    });
  });

  group('daysUntilExpiry', () {
    test('counts whole days ahead', () {
      expect(
        daysUntilExpiry(doc(expiresOn: DateTime(2026, 9, 19)), testNow),
        15,
      );
    });

    test('goes negative once past', () {
      expect(
        daysUntilExpiry(doc(expiresOn: DateTime(2026, 9, 1)), testNow),
        -3,
      );
    });

    test('is null when nothing expires', () {
      expect(daysUntilExpiry(doc(), testNow), isNull);
    });
  });

  group('reminderForDocument', () {
    test('fires at 9 am, the offset number of days before expiry', () {
      final reminder = reminderForDocument(
        doc(expiresOn: DateTime(2026, 10, 19)),
        now: testNow,
      );

      expect(reminder!.fireAt, DateTime(2026, 9, 19, 9));
      expect(reminder.kind.name, 'document');
      expect(reminder.title, 'Passport');
      expect(reminder.body, 'Expires in 30 days · Identity');
      expect(reminder.route, '/documents/d1');
    });

    test('a document with no expiry reminds about nothing', () {
      expect(reminderForDocument(doc(), now: testNow), isNull);
    });

    test('a moment already past is not scheduled', () {
      // Expiry is 19 Sep, so the 30-day reminder was due on 20 August.
      final reminder = reminderForDocument(
        doc(expiresOn: DateTime(2026, 9, 19)),
        now: testNow,
      );
      expect(reminder, isNull);
      // The moment itself still exists, which is what the inbox reconciles.
      expect(
        intendedDocumentFireAt(doc(expiresOn: DateTime(2026, 9, 19))),
        DateTime(2026, 8, 20, 9),
      );
    });

    test('an archived document reminds about nothing', () {
      final archived = doc(
        expiresOn: DateTime(2027, 1, 1),
        archivedAt: testNow,
      );
      expect(reminderForDocument(archived, now: testNow), isNull);
    });

    test('a zero-day offset reminds on the expiry day itself', () {
      final reminder = reminderForDocument(
        doc(expiresOn: DateTime(2026, 10, 1), reminderOffsetDays: 0),
        now: testNow,
      );
      expect(reminder!.fireAt, DateTime(2026, 10, 1, 9));
      expect(reminder.body, 'Expires today · Identity');
    });
  });
}
