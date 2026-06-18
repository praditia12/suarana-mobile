import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../data/home_mock_data.dart';
import '../sections/popular_albums_section.dart';
import '../sections/popular_gendres_section.dart';
import '../sections/trending_songs_section.dart';
import '../widgets/home_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // App Bar
              const HomeAppBar(),

              // Body
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.sm, 
                  horizontal: AppSpacing.md
                ),
                child: Column(
                  spacing: AppSpacing.md,
                  children: [
                      PopularAlbumsSection(albums: demoAlbums),
                      TrendingSongsSection(tracks: demoTracks),
                      PopularGenresSection(genres: demoGenres),
                  ],
                ),
              )
            ],
          ),
        ),
      ), 
    );
  }
}