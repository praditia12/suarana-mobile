import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  static const primary =
      LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.green1,
          AppColors.green4,
        ],
      );

  static const secondary =
      LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.bottomLeft,
        colors: [
          AppColors.green1,
          AppColors.green4,
        ],
      );

  static const tertiary =
      LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          Color(0x98104828),
          Color(0x9827AE60),
        ],
      );
}