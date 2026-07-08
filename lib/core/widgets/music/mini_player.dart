import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:suarana_mobile/core/theme/app_text_styles.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_gradients.dart';
import '../../theme/app_spacing.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
    required this.title,
    required this.artist,
    this.imageUrl,
    required this.isPlaying,
    required this.onPlayPause,
    this.onTap,
  });

  final String title;
  final String artist;
  final String? imageUrl;

  final bool isPlaying;

  final VoidCallback onPlayPause;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 62,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                gradient: AppGradients.tertiary.withOpacity(0.35),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.green4,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: imageUrl != null ? Image.network(
                      imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _placeholder(),
                    ): _placeholder(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray1,
                          ),
                        ),
                        Text(
                          artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.gray2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onPlayPause,
                    icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: AppColors.gray1,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      color: AppColors.gray3,
      child: const Icon(Icons.music_note, color: AppColors.gray5, size: 20),
    );
  }
}