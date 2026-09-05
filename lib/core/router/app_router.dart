import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/calendar_screen.dart';
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
import '../../features/spaces/presentation/spaces_screen.dart';
import '../../features/states_gallery/presentation/states_gallery_screen.dart';
import '../../features/tasks/presentation/task_detail_screen.dart';
import '../../features/tasks/presentation/task_edit_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
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

  /// Task detail lives under the Tasks tab, so the bottom bar keeps Tasks lit
  /// even when the task was opened from Home.
  static String taskDetail(String id) => '$tasks/$id';

  static String taskEdit(String id) => '$tasks/$id/edit';
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
              GoRoute(path: Routes.spaces, builder: (_, _) => const SpacesScreen()),
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
