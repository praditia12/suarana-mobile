import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/genre_card.dart';
import 'home_section.dart';

class PopularGenresSection extends StatelessWidget {
  final List<dynamic> genres;

  const PopularGenresSection({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: 'Genre Populer',
      onSeeAll: () {},
      child: Center(
        child: Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: genres.map((genre) {
            return GenreCard(
              title: genre.name,
              onTap: () => context.push(RouteNames.genre, extra: genre.name)
            );
          }).toList(),
        ),
      ),
    );
  }
}