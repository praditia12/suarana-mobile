import 'package:go_router/go_router.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/playlist/pages/playlist_page.dart';
import '../../features/search/pages/search_page.dart';
import '../shell/app_shell.dart';
import 'route_names.dart';


final appRouter = GoRouter(
  initialLocation: RouteNames.auth,

  routes: [
    GoRoute(
      path: RouteNames.auth,
      builder: (context, state) {
        return const LoginPage();
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: RouteNames.search,
          builder: (context, state) {
            return const SearchPage();
          },
        ),
        GoRoute(
          path: RouteNames.playlist,
          builder: (context, state) {
            return const PlaylistPage();
          },
        ),
      ],
    ),
  ],
);