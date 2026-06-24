import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TrendingSongTile extends StatelessWidget {
  const TrendingSongTile({
    super.key,
    required this.title,
    required this.artist,
    this.artworkUrl,
    this.onTap,
  });

  final String title;
  final String artist;
  final String? artworkUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsetsGeometry.all(0),
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: artworkUrl != null
            ? Image.network(
                artworkUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, _, _) => _placeholder(),
              )
            : _placeholder(),
      ),

      title: Text(
        title,
        maxLines: 1,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),

      subtitle: Text(
        artist,
        maxLines: 1,
        style: const TextStyle(color: AppColors.gray3),
      ),

      trailing: const Icon(Icons.more_vert),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      color: AppColors.gray3,
      child: const Icon(Icons.music_note, color: AppColors.gray4),
    );
  }
}
