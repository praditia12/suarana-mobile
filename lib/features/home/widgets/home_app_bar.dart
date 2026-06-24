import 'package:flutter/material.dart';
import 'package:suarana_mobile/core/theme/app_spacing.dart';
import 'package:suarana_mobile/core/theme/app_text_styles.dart';

import '../../../core/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
              horizontal: AppSpacing.md,
            ),
            child: Row(
              children: [
                Text(
                  'Suarana',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.gray1,
                  ),
                ),

                const Spacer(),

                IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.account_circle_outlined,
                    size: 28,
                    color: AppColors.gray1,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.green1, thickness: 2.0),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
