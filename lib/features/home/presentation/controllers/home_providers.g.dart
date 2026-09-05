// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Customize dashboard's rows, and the sections Home itself loops over.

@ProviderFor(dashboardSections)
final dashboardSectionsProvider = DashboardSectionsProvider._();

/// Customize dashboard's rows, and the sections Home itself loops over.

final class DashboardSectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DashboardSection>>,
          List<DashboardSection>,
          Stream<List<DashboardSection>>
        >
    with
        $FutureModifier<List<DashboardSection>>,
        $StreamProvider<List<DashboardSection>> {
  /// Customize dashboard's rows, and the sections Home itself loops over.
  DashboardSectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSectionsHash();

  @$internal
  @override
  $StreamProviderElement<List<DashboardSection>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DashboardSection>> create(Ref ref) {
    return dashboardSections(ref);
  }
}

String _$dashboardSectionsHash() => r'87e841f48f831e4a149019846df07f5b9584d699';
