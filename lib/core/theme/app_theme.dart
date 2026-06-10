import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark = ThemeData(
    textTheme: GoogleFonts.interTextTheme(),
    
    useMaterial3: true,

    fontFamily: 'Inter',

    brightness: Brightness.dark,

    scaffoldBackgroundColor:
        AppColors.background,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.green2,
      surface: AppColors.background,
    ),

    inputDecorationTheme:
        const InputDecorationTheme(
      border: UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.gray3,
        ),
      ),
    ),
  );
}