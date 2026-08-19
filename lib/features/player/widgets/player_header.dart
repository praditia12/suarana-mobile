import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PlayerHeader extends StatelessWidget {
  const PlayerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.gray6,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.close, color: AppColors.gray2, size: 18),
          ),
        ),
        const Expanded(
          child: Column(
            children: [
              Text('Sedang Diputar',
                  style: TextStyle(
                      color: AppColors.gray1,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text('Antrean Kamu',
                  style: TextStyle(color: AppColors.green1, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(width: 36),
      ],
    );
  }
}