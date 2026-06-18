import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TrendingSongTile extends StatelessWidget {
  const TrendingSongTile({
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
    return ListTile(
      contentPadding: EdgeInsetsGeometry.all(0),
      leading: ClipRRect(
        borderRadius:
            BorderRadius.circular(8),
        child: Image.network(
          image,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),

      subtitle: Text(
        artist,
        style: const TextStyle(
          color: AppColors.gray3,
        ),
      ),

      trailing: const Icon(
        Icons.more_vert,
      ),
    );
  }
}