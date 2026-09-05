import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dashboard_section_repository_impl.dart';
import '../../domain/entities/dashboard_section.dart';

part 'home_providers.g.dart';

/// Customize dashboard's rows, and the sections Home itself loops over.
@riverpod
Stream<List<DashboardSection>> dashboardSections(Ref ref) =>
    ref.watch(dashboardSectionRepositoryProvider).watchSections();

/// A one-line hint under each section's name, shown on both onboarding's
/// "Choose dashboard" step and Settings' Customize dashboard screen.
String dashboardSectionHint(HomeSectionKey key) => switch (key) {
      HomeSectionKey.attention => 'Bills, documents and tasks that need action',
      HomeSectionKey.today => "What's due today",
      HomeSectionKey.upcoming => "What's coming up next",
      HomeSectionKey.quickAccess => 'Shortcuts to your most-used tools',
      HomeSectionKey.recent => 'Recently added or changed items',
    };
