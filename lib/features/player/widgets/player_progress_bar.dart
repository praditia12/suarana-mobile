import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar({
    super.key,
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
    final current =
        position.inSeconds.toDouble().clamp(0.0, total > 0 ? total : 1.0);

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
              Text(_format(position),
                  style: const TextStyle(
                      color: AppColors.gray4, fontSize: 12)),
              Text(_format(duration),
                  style: const TextStyle(
                      color: AppColors.gray4, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}