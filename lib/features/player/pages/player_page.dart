import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/player_provider.dart';
import '../widgets/player_action_buttons.dart';
import '../widgets/player_cover_art.dart';
import '../widgets/player_header.dart';
import '../widgets/player_playback_controls.dart';
import '../widgets/player_progress_bar.dart';
import '../widgets/player_track_info.dart';

class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final track = player.currentTrack;

    if (track == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                bottomInset + AppSpacing.xl,
              ),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    const PlayerHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    PlayerCoverArt(artworkUrl: track.artworkUrl),
                    const SizedBox(height: AppSpacing.lg),
                    PlayerTrackInfo(
                        title: track.title, artist: track.artistName),
                    const SizedBox(height: AppSpacing.md),
                    PlayerActionButtons(track: track),
                    const SizedBox(height: AppSpacing.lg),
                    if (player.error != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(
                          player.error!,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    PlayerProgressBar(
                      position: player.position,
                      duration: player.duration,
                      onSeek: (val) =>
                          ref.read(playerProvider.notifier).seek(val),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PlayerPlaybackControls(
                      isPlaying: player.isPlaying,
                      isLoading: player.isLoading,
                      onPlayPause: () =>
                          ref.read(playerProvider.notifier).togglePlayPause(),
                      onPrevious: player.hasPrevious
                          ? () =>
                              ref.read(playerProvider.notifier).previous()
                          : null,
                      onNext: player.hasNext
                          ? () => ref.read(playerProvider.notifier).next()
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}