// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profile)
final profileProvider = ProfileProvider._();

final class ProfileProvider
    extends $FunctionalProvider<AsyncValue<Profile>, Profile, Stream<Profile>>
    with $FutureModifier<Profile>, $StreamProvider<Profile> {
  ProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileHash();

  @$internal
  @override
  $StreamProviderElement<Profile> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Profile> create(Ref ref) {
    return profile(ref);
  }
}

String _$profileHash() => r'871853486f6665b62e89cb6f38bbd47766d6a7ae';

/// Resolves once the profile's first value has loaded.
///
/// `app.dart` gates the whole router build on this, so a returning user can
/// never flash the onboarding screen for one frame — the router's own
/// redirect only has to react to *changes* after that first value is in.

@ProviderFor(profileReady)
final profileReadyProvider = ProfileReadyProvider._();

/// Resolves once the profile's first value has loaded.
///
/// `app.dart` gates the whole router build on this, so a returning user can
/// never flash the onboarding screen for one frame — the router's own
/// redirect only has to react to *changes* after that first value is in.

final class ProfileReadyProvider
    extends $FunctionalProvider<AsyncValue<Profile>, Profile, FutureOr<Profile>>
    with $FutureModifier<Profile>, $FutureProvider<Profile> {
  /// Resolves once the profile's first value has loaded.
  ///
  /// `app.dart` gates the whole router build on this, so a returning user can
  /// never flash the onboarding screen for one frame — the router's own
  /// redirect only has to react to *changes* after that first value is in.
  ProfileReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileReadyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileReadyHash();

  @$internal
  @override
  $FutureProviderElement<Profile> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Profile> create(Ref ref) {
    return profileReady(ref);
  }
}

String _$profileReadyHash() => r'7e6e5e80cb97fdeec13a07f4284b5595e62b9c71';

/// In-progress selection for "Pick areas" — not persisted until the user taps
/// Continue, so backing out of onboarding never half-writes a choice.

@ProviderFor(SelectedAreas)
final selectedAreasProvider = SelectedAreasProvider._();

/// In-progress selection for "Pick areas" — not persisted until the user taps
/// Continue, so backing out of onboarding never half-writes a choice.
final class SelectedAreasProvider
    extends $NotifierProvider<SelectedAreas, Set<OnboardingArea>> {
  /// In-progress selection for "Pick areas" — not persisted until the user taps
  /// Continue, so backing out of onboarding never half-writes a choice.
  SelectedAreasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedAreasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedAreasHash();

  @$internal
  @override
  SelectedAreas create() => SelectedAreas();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<OnboardingArea> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<OnboardingArea>>(value),
    );
  }
}

String _$selectedAreasHash() => r'4ed48d56ec6a95dc4f1b13f1a725db16f2d1a7a3';

/// In-progress selection for "Pick areas" — not persisted until the user taps
/// Continue, so backing out of onboarding never half-writes a choice.

abstract class _$SelectedAreas extends $Notifier<Set<OnboardingArea>> {
  Set<OnboardingArea> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<OnboardingArea>, Set<OnboardingArea>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<OnboardingArea>, Set<OnboardingArea>>,
              Set<OnboardingArea>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
