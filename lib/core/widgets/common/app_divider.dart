import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.gray6,
      height: 1,
    );
  }
}