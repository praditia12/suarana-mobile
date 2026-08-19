import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    super.key,
    required this.name,
    required this.trackCount,
    required this.isDefault,
    required this.onTap,
    this.onDelete,
  });

  final String name;
  final int trackCount;
  final bool isDefault;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      onTap: onTap,
      leading: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isDefault ? AppColors.green4 : AppColors.gray6,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isDefault ? Icons.favorite : Icons.queue_music_rounded,
          color: isDefault ? AppColors.green1 : AppColors.gray3,
        ),
      ),
      title: Text(
        name,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '$trackCount lagu',
        style: AppTextStyles.caption.copyWith(color: AppColors.gray4),
      ),
      // Default playlist tidak bisa dihapus
      trailing: !isDefault && onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.gray4),
              onPressed: onDelete,
            )
          : null,
    );
  }
}