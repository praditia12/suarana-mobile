import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pictureState = ref.watch(profilePictureProvider);
    final profileAsync = ref.watch(profileDataProvider);
    final client = ref.watch(supabaseClientProvider);
    final user = client.auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Profil',
          style: AppTextStyles.heading3.copyWith(color: AppColors.gray1),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto Profil
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showPhotoOptions(context, ref),
                      child: Stack(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 56,
                            backgroundColor: AppColors.gray6,
                            backgroundImage: pictureState.maybeWhen(
                              data: (path) => path != null
                                  ? FileImage(File(path))
                                  : null,
                              orElse: () => null,
                            ),
                            child: pictureState.maybeWhen(
                              data: (path) => path == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 56,
                                      color: AppColors.gray4,
                                    )
                                  : null,
                              orElse: () => const Icon(
                                Icons.person,
                                size: 56,
                                color: AppColors.gray4,
                              ),
                            ),
                          ),

                          // Badge kamera
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: AppColors.green2,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: AppColors.gray1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Username dari Supabase profiles
                    profileAsync.when(
                      data: (profile) => Text(
                        profile?['username'] ?? 'Pengguna',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.gray1,
                        ),
                      ),
                      loading: () => const SizedBox(
                        height: 20,
                        width: 100,
                        child: LinearProgressIndicator(
                          color: AppColors.green1,
                          backgroundColor: AppColors.gray6,
                        ),
                      ),
                      error: (_, _) => Text(
                        'Pengguna',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.gray1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Info Akun
              Text(
                'Informasi Akun',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.gray3,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              _InfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: user?.email ?? '-',
              ),

              _InfoTile(
                icon: Icons.lock_outline,
                label: 'Password',
                value: '••••••••',
              ),

              _InfoTile(
                icon: Icons.calendar_today_outlined,
                label: 'Bergabung',
                value: user?.createdAt != null
                    ? _formatDate(DateTime.parse(user!.createdAt))
                    : '-',
              ),

              const SizedBox(height: AppSpacing.xl),

              // Tombol Logout
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context, ref),
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text(
                    'Keluar',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom sheet pilihan sumber foto
  void _showPhotoOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.gray6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.gray1),
              title: const Text('Ambil dari Kamera',
                  style: TextStyle(color: AppColors.gray1)),
              onTap: () {
                Navigator.pop(context);
                ref.read(profilePictureProvider.notifier).pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.gray1),
              title: const Text('Pilih dari Galeri',
                  style: TextStyle(color: AppColors.gray1)),
              onTap: () {
                Navigator.pop(context);
                ref.read(profilePictureProvider.notifier).pickFromGallery();
              },
            ),
            // Hanya tampil kalau sudah ada foto
            Consumer(
              builder: (_, ref, _) {
                final hasPhoto = ref.watch(profilePictureProvider).maybeWhen(
                      data: (path) => path != null,
                      orElse: () => false,
                    );
                if (!hasPhoto) return const SizedBox.shrink();
                return ListTile(
                  leading: const Icon(Icons.delete_outline,
                      color: Colors.redAccent),
                  title: const Text('Hapus Foto',
                      style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(profilePictureProvider.notifier).removePhoto();
                  },
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Konfirmasi logout
  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.gray6,
        title: const Text(
          'Keluar',
          style: TextStyle(color: AppColors.gray1),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar?',
          style: TextStyle(color: AppColors.gray3),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.gray3)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).logout();
              // GoRouter redirect otomatis ke /login setelah logout
            },
            child: const Text('Keluar',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// Info Tile
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.gray6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gray3, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.gray4,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.gray1,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}