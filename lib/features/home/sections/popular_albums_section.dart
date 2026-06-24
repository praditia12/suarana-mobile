import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/models/album_model.dart';
import '../widgets/album_card.dart';
import 'home_section.dart';

class PopularAlbumsSection extends StatelessWidget {
  final List<AlbumModel> albums;

  const PopularAlbumsSection({
    super.key,
    required this.albums,
  });

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: 'Album Populer',
      onSeeAll: () {},
      child: SizedBox(
        height: 168,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: albums.length,
          separatorBuilder: (_, _) =>
              const SizedBox(width: AppSpacing.md),
          itemBuilder: (_, index) {
            final album = albums[index];

            return AlbumCard(
              title: album.title,
              artist: album.artistName,
              artworkUrl: album.artworkUrl,
            );
          },
        ),
      ),
    );
  }
}