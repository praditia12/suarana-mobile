import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../widgets/header_section.dart';

class HomeSection extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onSeeAll;

  const HomeSection({
    super.key,
    required this.title,
    required this.child,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onSeeAll: onSeeAll,
        ),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}