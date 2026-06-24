import 'package:flutter/material.dart';

import '../widgets/trending_song_tile.dart';
import 'home_section.dart';

class TrendingSongsSection extends StatelessWidget {
  final List<dynamic> tracks;

  const TrendingSongsSection({
    super.key,
    required this.tracks,
  });

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: 'Sedang Trending',
      onSeeAll: () {},
      child: Column(
        children: tracks.map((track) {
          return TrendingSongTile(
            title: track.title,
            artist: track.artistName,
            artworkUrl: track.artworkUrl,
          );
        }).toList(),
      ),
    );
  }
}