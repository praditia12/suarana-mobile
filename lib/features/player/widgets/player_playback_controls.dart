import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';

class PlayerPlaybackControls extends StatelessWidget {
  const PlayerPlaybackControls({
    super.key,
    required this.isPlaying,
    required this.isLoading,
    required this.onPlayPause,
    this.onPrevious,
    this.onNext,
  });

  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPlayPause;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: Icon(Icons.skip_previous_rounded,
              color: onPrevious != null ? AppColors.gray2 : AppColors.gray5,
              size: 36),
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
                          color: AppColors.gray1, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                          color: AppColors.gray1,
                          size: 28,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isPlaying ? 'Jeda' : 'Putar',
                          style: const TextStyle(
                              color: AppColors.gray1,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: Icon(Icons.skip_next_rounded,
              color: onNext != null ? AppColors.gray2 : AppColors.gray5,
              size: 36),
        ),
      ],
    );
  }
}