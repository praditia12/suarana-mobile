import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../features/playlist/providers/playlist_providers.dart';
import '../../../features/playlist/widgets/add_to_playlist_sheet.dart';

class PlayerActionButtons extends ConsumerWidget {
  const PlayerActionButtons({super.key, required this.track});
  final TrackModel track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likeAsync = ref.watch(likeProvider(track.id));
    final isLiked = likeAsync.value ?? false;

    return Row(
      children: [
        // Suka
        _ActionChip(
          icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
          label: 'Suka',
          isActive: isLiked,
          onTap: () =>
              ref.read(likeProvider(track.id).notifier).toggle(track),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Simpan ke playlist
        _ActionChip(
          icon: Icons.playlist_add,
          label: 'Simpan',
          onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => AddToPlaylistSheet(track: track),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Download — TODO
        _ActionChip(
          icon: Icons.download_outlined,
          label: 'Download',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur download akan segera hadir'),
                backgroundColor: AppColors.gray5,
              ),
            );
          },
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
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

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
          color: isActive ? AppColors.green4 : AppColors.gray6,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isActive ? AppColors.green1 : AppColors.gray2,
                size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.green1 : AppColors.gray2,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}