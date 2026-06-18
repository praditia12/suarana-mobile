import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
             'Search Page',
             style: AppTextStyles.body,
          ),
      ),
    );
  }
}