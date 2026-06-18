import 'package:flutter/material.dart';
import 'package:suarana_mobile/core/theme/app_text_styles.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
            'Playlist Page',
            style: AppTextStyles.body,
          ),
      ),
    );
  }
}