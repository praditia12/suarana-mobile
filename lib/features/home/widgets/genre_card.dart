import 'package:flutter/material.dart';
import 'package:suarana_mobile/core/theme/app_text_styles.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';

class GenreCard extends StatelessWidget {
  const GenreCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 60,
      decoration: BoxDecoration(
        gradient: AppGradients.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: AppColors.gray1,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
