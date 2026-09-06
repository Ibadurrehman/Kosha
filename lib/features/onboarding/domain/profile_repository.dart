import 'area.dart';
import 'entities/profile.dart';

/// Reads and writes the single local profile row, and the onboarding choices
/// that live alongside it.
abstract interface class ProfileRepository {
  /// Seeds the row on first call, then streams it.
  Stream<Profile> watchProfile();

  Future<Profile> current();

  Future<void> completeOnboarding();

  /// The areas picked on "Pick areas", or [defaultVisibleAreas] before the
  /// user has ever chosen.
  Future<Set<OnboardingArea>> visibleAreas();

  Future<void> setVisibleAreas(Set<OnboardingArea> areas);
}
