import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SearchBarField extends StatelessWidget {
  const SearchBarField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      onChanged: onChanged,
      autofocus: false,
      style: const TextStyle(color: AppColors.gray1),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Cari lagu, artis...',
        hintStyle: const TextStyle(color: AppColors.gray4),
        prefixIcon: const Icon(Icons.search, color: AppColors.gray4),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.close, color: AppColors.gray4, size: 18),
              onPressed: () {
                controller.clear();
                onClear();
              },
            );
          },
        ),
        filled: true,
        fillColor: AppColors.gray6,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}