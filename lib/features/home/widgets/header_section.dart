import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  final String title;
  final VoidCallback? onSeeAll;

  final String seeAllText = 'Lihat Semua';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.gray1,
              fontWeight: FontWeight.w600
            )
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'Lihat Semua',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.gray3
            )
          ),
        ),
      ],
    );
  }
}