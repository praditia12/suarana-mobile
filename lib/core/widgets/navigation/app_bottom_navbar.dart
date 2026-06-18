import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppBottomNavbar extends StatelessWidget {
  const AppBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      indicatorColor: AppColors.background,
      shadowColor: AppColors.green1,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home, 
            color: AppColors.green1,
          ),
          label: 'Beranda',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(
            Icons.search,
            color: AppColors.green1,
          ),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_music_outlined),
          selectedIcon: Icon(
            Icons.library_music,
            color: AppColors.green1
          ),
          label: 'Playlist',
        ),
      ],
    );
  }
}