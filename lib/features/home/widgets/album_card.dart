import 'package:flutter/material.dart';

import '../../../../core/widgets/common/app_gap.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({
    super.key,
    required this.image,
    required this.title,
    required this.artist,
  });

  final String image;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(12),
            child: Image.network(
              image,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),

          AppGap.sm,

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.gray1
            )
          ),

          Text(
            artist,
            maxLines: 1,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.gray3,
            )
          ),
        ],
      ),
    );
  }
}