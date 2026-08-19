import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class PlayerCoverArt extends StatelessWidget {
  const PlayerCoverArt({super.key, this.artworkUrl});
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