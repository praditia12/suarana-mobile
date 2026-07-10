import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../features/player/providers/player_provider.dart';
import '../providers/genre_provider.dart';

class GenreDetailPage extends ConsumerWidget {
  const GenreDetailPage({super.key, required this.genre});

  final String genre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(genreTracksProvider(genre));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.gray1),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background sebagai pengganti cover art
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                    ),
                  ),

                  // Gradient overlay ke bawah
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background],
                      ),
                    ),
                  ),

                  // Genre info
                  Positioned(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: AppSpacing.md,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          genre,
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.gray1,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Trending di genre ini',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.gray3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          tracksAsync.when(
            data: (tracks) => tracks.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Tidak ada lagu di genre ini',
                        style: TextStyle(color: AppColors.gray3),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _TrackTile(
                        track: tracks[index],
                        index: index,
                        onTap: () {
                          ref.read(playerProvider.notifier).playFromQueue(
                                queue: tracks,
                                index: index,
                              );
                        },
                      ),
                      childCount: tracks.length,
                    ),
                  ),
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.green1),
              ),
            ),
            error: (e, _) {
              final isNoInternet = e.toString().contains('no_internet');
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isNoInternet
                            ? Icons.wifi_off_rounded
                            : Icons.error_outline_rounded,
                        color: AppColors.gray4,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isNoInternet
                            ? 'Tidak ada koneksi'
                            : 'Gagal memuat lagu',
                        style: const TextStyle(color: AppColors.gray3),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () =>
                            ref.invalidate(genreTracksProvider(genre)),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


class _TrackTile extends StatelessWidget {
  const _TrackTile({
    required this.track,
    required this.index,
    required this.onTap,
  });

  final TrackModel track;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.gray4, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: track.artworkUrl != null
                ? Image.network(
                    track.artworkUrl!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _artPlaceholder(),
                  )
                : _artPlaceholder(),
          ),
        ],
      ),
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.gray1),
      ),
      subtitle: Text(
        track.artistName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.gray3, fontSize: 12),
      ),
      trailing: Text(
        track.formattedDuration,
        style: const TextStyle(color: AppColors.gray4, fontSize: 12),
      ),
    );
  }

  Widget _artPlaceholder() {
    return Container(
      width: 44,
      height: 44,
      color: AppColors.gray6,
      child: const Icon(Icons.music_note, color: AppColors.gray4, size: 20),
    );
  }
}