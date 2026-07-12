import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/music/mini_player.dart';
import '../../core/widgets/navigation/app_bottom_navbar.dart';
import '../../features/player/providers/player_provider.dart';
import '../router/route_names.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  int _getCurrentIndex(String location) {
    switch (location) {
      case RouteNames.search:
        return 1;
      case RouteNames.playlist:
        return 2;
      default:
        return 0;
    }
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.go(RouteNames.search);
        break;
      case 2:
        context.go(RouteNames.playlist);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final player = ref.watch(playerProvider);
    final hasTrack = player.hasTrack;
    final showMiniPlayer = hasTrack && location != RouteNames.player && location != RouteNames.profile;

    return Scaffold(
      body: Stack(
        children: [
          // Konten — beri padding bawah agar tidak tertutup mini player
          Padding(
            padding: EdgeInsets.only(
              bottom: showMiniPlayer ? 8 : 0,
            ),
            child: child,
          ),

          // Mini player floating
          if (showMiniPlayer)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: MiniPlayer(
                imageUrl: player.currentTrack!.artworkUrl,
                title: player.currentTrack!.title,
                artist: player.currentTrack!.artistName,
                isPlaying: player.isPlaying,
                onPlayPause: () {
                  ref.read(playerProvider.notifier).togglePlayPause();
                },
                onTap: () => context.push(RouteNames.player),
              ),
            ),
        ],
      ),

      bottomNavigationBar: AppBottomNavbar(
        currentIndex: _getCurrentIndex(location),
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}