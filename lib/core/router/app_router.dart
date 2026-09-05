import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../features/spaces/presentation/spaces_screen.dart';
import '../../features/states_gallery/presentation/states_gallery_screen.dart';
import '../../features/tasks/presentation/task_detail_screen.dart';
import '../../features/tasks/presentation/task_edit_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../config/app_config.dart';
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

  /// Task detail lives under the Tasks tab, so the bottom bar keeps Tasks lit
  /// even when the task was opened from Home.
  static String taskDetail(String id) => '$tasks/$id';

  static String taskEdit(String id) => '$tasks/$id/edit';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.home,
    debugLogDiagnostics: AppConfig.isDev,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            KoshaShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
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
