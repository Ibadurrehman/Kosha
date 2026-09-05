import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/profile_repository_impl.dart';
import '../../domain/area.dart';
import '../../domain/entities/profile.dart';

part 'onboarding_providers.g.dart';

@riverpod
Stream<Profile> profile(Ref ref) =>
    ref.watch(profileRepositoryProvider).watchProfile();

/// Resolves once the profile's first value has loaded.
///
/// `app.dart` gates the whole router build on this, so a returning user can
/// never flash the onboarding screen for one frame — the router's own
/// redirect only has to react to *changes* after that first value is in.
@riverpod
Future<Profile> profileReady(Ref ref) => ref.watch(profileProvider.future);

/// In-progress selection for "Pick areas" — not persisted until the user taps
/// Continue, so backing out of onboarding never half-writes a choice.
@riverpod
class SelectedAreas extends _$SelectedAreas {
  @override
  Set<OnboardingArea> build() => defaultVisibleAreas;

  void toggle(OnboardingArea area) {
    state = state.contains(area)
        ? ({...state}..remove(area))
        : {...state, area};
  }
}
