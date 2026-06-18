import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/music/mini_player.dart';
import '../../core/widgets/navigation/app_bottom_navbar.dart';
import '../router/route_names.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
  });

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

  void _onTap(
    BuildContext context,
    int index,
  ) {
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
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return Scaffold(
      body: child,

      bottomNavigationBar:Stack(
    clipBehavior: Clip.none,
    children: [
      AppBottomNavbar(
        currentIndex:
            _getCurrentIndex(location),
        onTap: (index) =>
            _onTap(context, index),
      ),

      Positioned(
        left: 16,
        right: 16,
        top: -80,
        child: MiniPlayer(
          imageUrl:
              'https://picsum.photos/200',
          title: 'Film Favorit',
          artist: 'Sheila on 7',
          isPlaying: false,
          onPlayPause: () {},
          onTap: () {},
        ),
      ),
    ],
  ),
    );
  }
}