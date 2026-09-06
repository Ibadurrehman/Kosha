import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/notifications/domain/notification_grouping.dart';

void main() {
  final today = DateTime(2026, 9, 4);

  test('today stays in its own group', () {
    expect(
      notificationGroupFor(DateTime(2026, 9, 4, 8), today),
      NotificationGroup.today,
    );
  });

  test('the 6 days before today are "earlier this week"', () {
    expect(
      notificationGroupFor(DateTime(2026, 8, 29), today),
      NotificationGroup.earlierThisWeek,
    );
  });

  test('exactly 7 days ago is "earlier", not "this week"', () {
    expect(
      notificationGroupFor(DateTime(2026, 8, 28), today),
      NotificationGroup.earlier,
    );
  });

  test('anything older is "earlier"', () {
    expect(
      notificationGroupFor(DateTime(2026, 1, 1), today),
      NotificationGroup.earlier,
    );
  });
}
