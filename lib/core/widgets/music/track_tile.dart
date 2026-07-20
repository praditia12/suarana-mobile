import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';

class TrackTile extends StatelessWidget {
  const TrackTile({
    super.key,
    required this.title,
    required this.artistName,
    this.artworkUrl,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String artistName;
  final String? artworkUrl;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap ?? () => context.push(RouteNames.player),
      leading: _TrackArtwork(artworkUrl: artworkUrl),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.gray1,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        artistName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.gray3, fontSize: 12),
      ),
      trailing: trailing ?? const Icon(Icons.more_vert, color: AppColors.gray4),
    );
  }
}

class _TrackArtwork extends StatelessWidget {
  const _TrackArtwork({this.artworkUrl});
  final String? artworkUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: artworkUrl != null
          ? Image.network(
              artworkUrl!,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      color: AppColors.gray6,
      child: const Icon(Icons.music_note, color: AppColors.gray4, size: 20),
    );
  }
}