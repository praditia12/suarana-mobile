import 'package:flutter/material.dart';

import '../../../../core/widgets/common/app_gap.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({
    super.key,
    required this.title,
    required this.artist,
    this.artworkUrl,
    this.onTap,
  });

  final String title;
  final String artist;
  final String? artworkUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: artworkUrl != null
                ? Image.network(
                    artworkUrl!,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, _) => _placeholder(),
                  )
                : _placeholder(),
          ),

          AppGap.sm,

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(color: AppColors.gray1),
          ),

          Text(
            artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.gray3),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 110,
      height: 110,
      color: AppColors.gray3,
      child: const Icon(Icons.music_note, color: AppColors.gray4),
    );
  }
}
