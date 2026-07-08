import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/models/track_model.dart';
import '../../player/providers/player_provider.dart';
import '../widgets/trending_song_tile.dart';
import 'home_section.dart';

class TrendingSongsSection extends ConsumerWidget {
  final List<TrackModel> tracks;

  const TrendingSongsSection({
    super.key,
    required this.tracks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeSection(
      title: 'Sedang Trending',
      onSeeAll: () {},
      child: Column(
        children: List.generate(tracks.length, (index) {
          final track = tracks[index];
          return TrendingSongTile(
            title: track.title,
            artist: track.artistName,
            artworkUrl: track.artworkUrl,
            onTap: () {
              context.push(RouteNames.player);
              ref.read(playerProvider.notifier).playFromQueue(
                queue: tracks,
                index: index,
              ); // Navigate to the player page
            },
          );
        }).toList(),
      ),
    );
  }
}