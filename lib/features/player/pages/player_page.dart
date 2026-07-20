import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/player_provider.dart';

class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final track = player.currentTrack;

    if (track == null) return const SizedBox.shrink();

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    _PlayerHeader(),

                    const SizedBox(height: AppSpacing.lg),
                    _CoverArt(artworkUrl: track.artworkUrl),

                    const SizedBox(height: AppSpacing.lg),
                    _TrackInfo(
                      title: track.title,
                      artist: track.artistName,
                    ),

                    const SizedBox(height: AppSpacing.md),
                    const _ActionButtons(),

                    const SizedBox(height: AppSpacing.lg),
                    _ProgressBar(
                      position: player.position,
                      duration: player.duration,
                      onSeek: (val) {
                        ref.read(playerProvider.notifier).seek(val);
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    // Error message
                    if (player.error != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(
                          player.error!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Playback Controls — onPrevious and onNext:
                    _PlaybackControls(
                      isPlaying: player.isPlaying,
                      isLoading: player.isLoading,
                      onPlayPause: () => ref.read(playerProvider.notifier).togglePlayPause(),
                      onPrevious: player.hasPrevious
                          ? () => ref.read(playerProvider.notifier).previous()
                          : null,
                      onNext: player.hasNext
                          ? () => ref.read(playerProvider.notifier).next()
                          : null,
                    ),

                    const SizedBox(height: AppSpacing.xl),
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

class _PlayerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Tombol close — dismiss modal
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.gray6,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.gray2,
              size: 18,
            ),
          ),
        ),
        const Expanded(
          child: Column(
            children: [
              Text(
                'Sedang Diputar',
                style: TextStyle(
                  color: AppColors.gray1,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Antrean Kamu',
                style: TextStyle(
                  color: AppColors.green1,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Placeholder agar header simetris
        const SizedBox(width: 36),
      ],
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({this.artworkUrl});
  final String? artworkUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width - (AppSpacing.md * 2);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: artworkUrl != null
          ? Image.network(
              artworkUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(size),
            )
          : _placeholder(size),
    );
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      color: AppColors.gray6,
      child: const Icon(Icons.music_note, color: AppColors.gray4, size: 64),
    );
  }
}

class _TrackInfo extends StatelessWidget {
  const _TrackInfo({required this.title, required this.artist});
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.gray1,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.green1,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _ActionChip(
          icon: Icons.thumb_up_outlined,
          label: 'Suka',
          onTap: () {},
        ),
        const SizedBox(width: AppSpacing.sm),
        _ActionChip(
          icon: Icons.playlist_add,
          label: 'Simpan',
          onTap: () {},
        ),
        const SizedBox(width: AppSpacing.sm),
        _ActionChip(
          icon: Icons.download_outlined,
          label: 'Download',
          onTap: () {},
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.gray6,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.gray2, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.gray2,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final total = duration.inSeconds.toDouble();
    final current = position.inSeconds.toDouble().clamp(0.0, total > 0 ? total : 1.0);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.gray1,
            inactiveTrackColor: AppColors.gray5,
            thumbColor: AppColors.gray1,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: SliderComponentShape.noOverlay,
            trackHeight: 3,
          ),
          child: Slider(
            value: current,
            min: 0,
            max: total > 0 ? total : 1.0,
            onChanged: (val) => onSeek(Duration(seconds: val.toInt())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _format(position),
                style: const TextStyle(
                  color: AppColors.gray4,
                  fontSize: 12,
                ),
              ),
              Text(
                _format(duration),
                style: const TextStyle(
                  color: AppColors.gray4,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls({
    required this.isPlaying,
    required this.isLoading,
    required this.onPlayPause,
    this.onPrevious,
    this.onNext,
  });

  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPlayPause;
  final VoidCallback? onPrevious;  // null = disabled
  final VoidCallback? onNext;      // null = disabled

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: Icon(
            Icons.skip_previous_rounded,
            // Redup kalau tidak ada previous track
            color: onPrevious != null ? AppColors.gray2 : AppColors.gray5,
            size: 36,
          ),
        ),

        GestureDetector(
          onTap: isLoading ? null : onPlayPause,
          child: Container(
            width: 160,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.gray1,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isPlaying
                              ? Icons.pause
                              : Icons.play_arrow_rounded,
                          color: AppColors.gray1,
                          size: 28,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isPlaying ? 'Jeda' : 'Putar',
                          style: const TextStyle(
                            color: AppColors.gray1,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),

        IconButton(
          onPressed: onNext,
          icon: Icon(
            Icons.skip_next_rounded,
            color: onNext != null ? AppColors.gray2 : AppColors.gray5,
            size: 36,
          ),
        ),
      ],
    );
  }
}