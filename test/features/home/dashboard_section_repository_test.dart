import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/core/db/app_database.dart';
import 'package:kosha/core/utils/clock.dart';
import 'package:kosha/features/home/data/dashboard_section_repository_impl.dart';
import 'package:kosha/features/home/domain/dashboard_section_repository.dart';
import 'package:kosha/features/home/domain/entities/dashboard_section.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase db;
  late DashboardSectionRepository repository;

  setUp(() {
    db = testDatabase();
    repository = DriftDashboardSectionRepository(db, FixedClock(testNow));
  });

  tearDown(() => db.close());

  test('seeds the 5 default sections, enabled, in Appendix A order', () async {
    final sections = await repository.watchSections().first;
    expect(
      [for (final s in sections) s.key],
      defaultSectionOrder,
    );
    expect(sections.every((s) => s.enabled), isTrue);
  });

  test('seeding is idempotent', () async {
    await repository.watchSections().first;
    await repository.watchSections().first;
    expect(await db.select(db.dashboardSections).get(), hasLength(5));
  });

  test('setEnabled flips one section without touching the others', () async {
    await repository.setEnabled(HomeSectionKey.attention, enabled: false);
    final sections = await repository.watchSections().first;
    final attention =
        sections.firstWhere((s) => s.key == HomeSectionKey.attention);
    expect(attention.enabled, isFalse);
    expect(
      sections.where((s) => s.key != HomeSectionKey.attention),
      everyElement(predicate<DashboardSection>((s) => s.enabled)),
    );
  });

  test('reorder rewrites sortOrder to match the given order', () async {
    await repository.reorder([
      HomeSectionKey.recent,
      HomeSectionKey.today,
      HomeSectionKey.attention,
      HomeSectionKey.upcoming,
      HomeSectionKey.quickAccess,
    ]);
    final sections = await repository.watchSections().first;
    expect(
      [for (final s in sections) s.key],
      [
        HomeSectionKey.recent,
        HomeSectionKey.today,
        HomeSectionKey.attention,
        HomeSectionKey.upcoming,
        HomeSectionKey.quickAccess,
      ],
    );
  });
}
