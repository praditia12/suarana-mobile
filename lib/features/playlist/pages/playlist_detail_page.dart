import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/music/track_tile.dart';
import '../../../features/player/providers/player_provider.dart';
import '../providers/playlist_providers.dart';

class PlaylistDetailPage extends ConsumerWidget {
  const PlaylistDetailPage({
    super.key,
    required this.playlistId,
    required this.playlistName,
    required this.isDefault,
  });

  final String playlistId;
  final String playlistName;
  final bool isDefault;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(playlistTracksProvider(playlistId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray1),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(playlistName, style: AppTextStyles.title),
            if (isDefault)
              const Text(
                'Playlist Favorit',
                style: TextStyle(color: AppColors.green1, fontSize: 12),
              ),
          ],
        ),
      ),
      body: tracksAsync.when(
        data: (tracks) => tracks.isEmpty
            ? const _EmptyView()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                itemCount: tracks.length,
                itemBuilder: (_, index) {
                  final track = tracks[index];
                  return TrackTile(
                    title: track.title,
                    artistName: track.artistName,
                    artworkUrl: track.artworkUrl,
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: AppColors.gray4),
                      onPressed: isDefault
                          ? null // Playlist Suka — hapus via unlike di player
                          : () => ref
                              .read(playlistActionsProvider.notifier)
                              .removeTrackFromPlaylist(
                                playlistId: playlistId,
                                trackId: track.id,
                              ),
                    ),
                    onTap: () {
                      ref.read(playerProvider.notifier).playFromQueue(
                            queue: tracks,
                            index: index,
                          );
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.green1),
        ),
        error: (_, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.gray4, size: 48),
              const SizedBox(height: 12),
              const Text('Gagal memuat lagu',
                  style: TextStyle(color: AppColors.gray3)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(playlistTracksProvider(playlistId)),
                child: const Text('Coba lagi',
                    style: TextStyle(color: AppColors.green1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_off, size: 64, color: AppColors.gray5),
          SizedBox(height: 16),
          Text('Belum ada lagu di playlist ini',
              style: TextStyle(color: AppColors.gray3)),
        ],
      ),
    );
  }
}