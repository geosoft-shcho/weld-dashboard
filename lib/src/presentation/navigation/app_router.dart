import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import '../features/app_shell/shell_screen.dart';
import 'app_navigation_port.dart';
import 'app_route_state.dart';

typedef AppLocationChangedHandler = void Function(AppRouteState state);

/// Hash URLs (`/#/collection`) avoid SPA path fallback requirements on static hosts.
void configureAppUrlStrategy() {
  if (kIsWeb) {
    setUrlStrategy(HashUrlStrategy());
  }
}

GoRouter createAppRouter({
  required AppLocationChangedHandler onLocationChanged,
  String initialLocation = AppRouteState.collectionPath,
}) {
  late final GoRouter router;
  router = GoRouter(
    initialLocation: initialLocation,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => AppRouteState.collectionPath,
      ),
      ShellRoute(
        builder: (context, state, child) => const ShellScreen(),
        routes: [
          GoRoute(
            path: AppRouteState.collectionPath,
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: SizedBox.shrink(),
            ),
          ),
          GoRoute(
            path: AppRouteState.historyPath,
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: SizedBox.shrink(),
            ),
            routes: [
              GoRoute(
                path: 'detail/:historyId',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SizedBox.shrink(),
                ),
              ),
              GoRoute(
                path: 'pass',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SizedBox.shrink(),
                ),
              ),
              GoRoute(
                path: 'quality',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SizedBox.shrink(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRouteState.passPath,
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: SizedBox.shrink(),
            ),
          ),
          GoRoute(
            path: AppRouteState.qualityPath,
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: SizedBox.shrink(),
            ),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (AppRouteState.tryParse(state.uri) == null) {
        return AppRouteState.collectionPath;
      }
      return null;
    },
  );

  void notifyLocation() {
    final parsed = AppRouteState.tryParse(router.state.uri) ??
        const AppRouteState(pane: AppPane.collection);
    onLocationChanged(parsed);
  }

  router.routerDelegate.addListener(notifyLocation);
  // Apply the initial location once the first frame can notify listeners safely.
  WidgetsBinding.instance.addPostFrameCallback((_) => notifyLocation());

  return router;
}

class GoRouterAppNavigation implements AppNavigationPort {
  GoRouterAppNavigation(this._router);

  final GoRouter _router;

  @override
  String get currentLocation {
    final uri = _router.state.uri;
    if (uri.hasQuery) {
      return '${uri.path}?${uri.query}';
    }
    return uri.path.isEmpty ? '/' : uri.path;
  }

  @override
  bool get canPop => _router.canPop();

  @override
  void go(String location) => _router.go(location);

  @override
  void push(String location) => _router.push(location);

  @override
  void replace(String location) => _router.replace(location);

  @override
  void pop() => _router.pop();
}
