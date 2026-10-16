import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/saved/presentation/saved_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/presentation/home_shell.dart';
import '../../features/trends/presentation/feed_screen.dart';
import '../../features/trends/presentation/trend_detail_screen.dart';

// Separate navigator keys keep tab stacks isolated from the root (where the
// detail route is pushed above the shell).
final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _feedKey = GlobalKey<NavigatorState>(debugLabel: 'feed');
final _searchKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _savedKey = GlobalKey<NavigatorState>(debugLabel: 'saved');
final _settingsKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

/// Central route table.
///
/// Deep-link ready: `/trend/:id` maps directly to a shareable trend, which is
/// what Universal Links / App Links will resolve to (fallback web page handled
/// on the marketing site).
GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/feed',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _feedKey,
            routes: [
              GoRoute(
                path: '/feed',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: FeedScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _searchKey,
            routes: [
              GoRoute(
                path: '/search',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SearchScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _savedKey,
            routes: [
              GoRoute(
                path: '/saved',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SavedScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingsScreen()),
              ),
            ],
          ),
        ],
      ),
      // Pushed above the shell (full-screen, with its own back button).
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/trend/:id',
        builder: (context, state) => TrendDetailScreen(
          trendId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}
