import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/bills/presentation/bill_detail_screen.dart';
import '../../features/bills/presentation/bill_edit_screen.dart';
import '../../features/bills/presentation/bills_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/documents/presentation/document_archive_screen.dart';
import '../../features/documents/presentation/document_detail_screen.dart';
import '../../features/documents/presentation/document_edit_screen.dart';
import '../../features/documents/presentation/documents_screen.dart';
import '../../features/finance/presentation/all_transactions_screen.dart';
import '../../features/finance/presentation/category_manager_screen.dart';
import '../../features/finance/presentation/finance_screen.dart';
import '../../features/finance/presentation/transaction_detail_screen.dart';
import '../../features/finance/presentation/transaction_edit_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/data/profile_repository_impl.dart';
import '../../features/onboarding/presentation/controllers/onboarding_providers.dart';
import '../../features/onboarding/presentation/onboarding_dashboard_screen.dart';
import '../../features/onboarding/presentation/onboarding_first_item_screen.dart';
import '../../features/onboarding/presentation/onboarding_pick_areas_screen.dart';
import '../../features/onboarding/presentation/onboarding_welcome_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/spaces/presentation/space_detail_screen.dart';
import '../../features/spaces/presentation/spaces_screen.dart';
import '../../features/states_gallery/presentation/states_gallery_screen.dart';
import '../../features/tasks/presentation/task_detail_screen.dart';
import '../../features/tasks/presentation/task_edit_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/vehicle/presentation/vehicle_edit_screen.dart';
import '../../features/vehicle/presentation/vehicle_renewals_screen.dart';
import '../../features/vehicle/presentation/vehicle_screen.dart';
import '../config/app_config.dart';
import 'go_router_refresh_stream.dart';
import 'kosha_shell.dart';

/// Route paths. Sub-screens live under the tab that "owns" them so the bottom
/// bar keeps the right item highlighted (section 4.4 of the plan).
abstract final class Routes {
  static const home = '/home';
  static const tasks = '/tasks';
  static const spaces = '/spaces';
  static const calendar = '/calendar';
  static const more = '/more';
  static const statesGallery = '/more/states';
  static const onboarding1 = '/onboarding/1';
  static const onboarding2 = '/onboarding/2';
  static const onboarding3 = '/onboarding/3';
  static const onboarding4 = '/onboarding/4';
  static const search = '/home/search';
  static const notifications = '/home/notifications';
  static const finance = '/home/finance';
  static const transactions = '$finance/transactions';
  static const categories = '$finance/categories';
  static const bills = '$finance/bills';
  /// Documents sit in the Spaces branch rather than under `/spaces/<id>`:
  /// the grid's Documents tile is a space like any other, but a document's
  /// own screens are not that space's detail, and a literal segment competing
  /// with `/spaces/:id` would be matched by route order rather than by intent.
  static const documents = '/documents';
  static const documentsArchive = '/documents/archive';
  /// Vehicle sits in the Spaces branch for the same reason Documents does —
  /// see [documents]'s doc comment. v1 manages exactly one vehicle, so
  /// nothing here carries an id (`VehicleScreen` and its two sub-screens all
  /// read `primaryVehicleProvider` themselves).
  static const vehicle = '/vehicle';
  static const vehicleEdit = '/vehicle/edit';
  static const vehicleRenewals = '/vehicle/renewals';
  static const profile = '/more/profile';
  static const settings = '/more/settings';

  /// Task detail lives under the Tasks tab, so the bottom bar keeps Tasks lit
  /// even when the task was opened from Home.
  static String taskDetail(String id) => '$tasks/$id';

  static String taskEdit(String id) => '$tasks/$id/edit';

  /// Finance's own sub-screens live under the Home tab, the tab Finance
  /// itself hangs off, so the bottom bar keeps Home lit throughout.
  static String transactionDetail(String id) => '$finance/tx/$id';

  static String transactionEdit(String id) => '$finance/tx/$id/edit';

  static String billDetail(String id) => '$bills/$id';

  static String billEdit(String id) => '$bills/$id/edit';

  /// Space detail lives under the Spaces tab, so the bottom bar keeps Spaces
  /// lit however the space was reached.
  static String spaceDetail(String id) => '$spaces/$id';

  static String documentDetail(String id) => '$documents/$id';

  static String documentEdit(String id) => '$documents/$id/edit';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  // `app.dart` gates the whole router build on `profileReadyProvider`, so by
  // the time this runs, `profileProvider` already holds a cached first value
  // — reading it (not watching) seeds the redirect gate's first check without
  // an extra async gap, and without this provider rebuilding (and recreating
  // the whole GoRouter, discarding navigation state) on every later profile
  // change.
  final onboardingGate = GoRouterRefreshStream(
    ref.watch(profileRepositoryProvider).watchProfile(),
    initial: ref.read(profileProvider).value,
  );
  ref.onDispose(onboardingGate.dispose);

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.home,
    debugLogDiagnostics: AppConfig.isDev,
    refreshListenable: onboardingGate,
    redirect: (context, state) {
      final completed = onboardingGate.value?.onboardingCompleted;
      // Not resolved yet — shouldn't happen once past the app-level splash
      // gate, but don't redirect on a guess if it somehow does.
      if (completed == null) return null;
      final atOnboarding = state.matchedLocation.startsWith('/onboarding');
      if (!completed && !atOnboarding) return Routes.onboarding1;
      if (completed && atOnboarding) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onboarding1,
        builder: (_, _) => const OnboardingWelcomeScreen(),
      ),
      GoRoute(
        path: Routes.onboarding2,
        builder: (_, _) => const OnboardingPickAreasScreen(),
      ),
      GoRoute(
        path: Routes.onboarding3,
        builder: (_, _) => const OnboardingDashboardScreen(),
      ),
      GoRoute(
        path: Routes.onboarding4,
        builder: (_, _) => const OnboardingFirstItemScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            KoshaShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (_, _) => const HomeScreen(),
                routes: [
                  GoRoute(path: 'search', builder: (_, _) => const SearchScreen()),
                  GoRoute(
                    path: 'notifications',
                    builder: (_, _) => const NotificationsScreen(),
                  ),
                  GoRoute(
                    path: 'finance',
                    builder: (_, _) => const FinanceScreen(),
                    routes: [
                      GoRoute(
                        path: 'transactions',
                        builder: (_, _) => const AllTransactionsScreen(),
                      ),
                      GoRoute(
                        path: 'categories',
                        builder: (_, _) => const CategoryManagerScreen(),
                      ),
                      GoRoute(
                        path: 'tx/:id',
                        builder: (_, state) => TransactionDetailScreen(
                          transactionId: state.pathParameters['id']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (_, state) => TransactionEditScreen(
                              transactionId: state.pathParameters['id']!,
                            ),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'bills',
                        builder: (_, _) => const BillsScreen(),
                        routes: [
                          GoRoute(
                            path: ':id',
                            builder: (_, state) => BillDetailScreen(
                              billId: state.pathParameters['id']!,
                            ),
                            routes: [
                              GoRoute(
                                path: 'edit',
                                builder: (_, state) => BillEditScreen(
                                  billId: state.pathParameters['id']!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.tasks,
                builder: (_, _) => const TasksScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => TaskDetailScreen(
                      taskId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (_, state) => TaskEditScreen(
                          taskId: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.documents,
                builder: (_, _) => const DocumentsScreen(),
                routes: [
                  // Before ':id', so the literal wins: go_router matches in
                  // order, and "archive" is a screen, not a document.
                  GoRoute(
                    path: 'archive',
                    builder: (_, _) => const DocumentArchiveScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => DocumentDetailScreen(
                      documentId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (_, state) => DocumentEditScreen(
                          documentId: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: Routes.spaces,
                builder: (_, _) => const SpacesScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => SpaceDetailScreen(
                      spaceId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: Routes.vehicle,
                builder: (_, _) => const VehicleScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, _) => const VehicleEditScreen(),
                  ),
                  GoRoute(
                    path: 'renewals',
                    builder: (_, _) => const VehicleRenewalsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.calendar, builder: (_, _) => const CalendarScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.more,
                builder: (_, _) => const MoreScreen(),
                routes: [
                  GoRoute(path: 'profile', builder: (_, _) => const ProfileScreen()),
                  GoRoute(path: 'settings', builder: (_, _) => const SettingsScreen()),
                  if (AppConfig.showDebugTools)
                    GoRoute(
                      path: 'states',
                      builder: (_, _) => const StatesGalleryScreen(),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
