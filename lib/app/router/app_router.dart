import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suarana_mobile/features/auth/pages/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/models/album_model.dart';
import '../../features/album/pages/album_detail_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/genre/pages/genre_detail_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/player/pages/player_page.dart';
import '../../features/playlist/pages/playlist_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/search/pages/search_page.dart';
import '../shell/app_shell.dart';
import 'route_names.dart';


final appRouterProvider = Provider<GoRouter>((ref) {
  // Watch authStateProvider agar router rebuild saat login/logout
  ref.watch(authStateProvider);

    return GoRouter(
      initialLocation: RouteNames.home,
      redirect: (context, state) {
        final isLoggedIn =
            Supabase.instance.client.auth.currentUser != null;
        final isAuthRoute =
            state.matchedLocation == RouteNames.auth ||
            state.matchedLocation == RouteNames.register;

        if (!isLoggedIn && !isAuthRoute) return RouteNames.auth;
        if (isLoggedIn && isAuthRoute) return RouteNames.home;
        return null;
      },

    routes: [
      GoRoute(
        path: RouteNames.auth,
        builder: (context, state) {
          return const LoginPage();
        },
      ),

      GoRoute(
        path: RouteNames.register,
        builder: (context, state) {
          return const RegisterPage();
        },
      ),

      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) {
          return const ProfilePage();
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
          GoRoute(
            path: RouteNames.player,
            builder: (context, state) {
              return const PlayerPage();
            },
          ),
          GoRoute(
            path: RouteNames.genre,
            builder: (context, state) {
              return GenreDetailPage(genre: state.extra as String);
            },
          ),
          GoRoute(
            path: RouteNames.album,
            builder: (context, state) {
              return AlbumDetailPage(album: state.extra as AlbumModel);
            },
          ),
        ],
      ),
    ]
  );
});