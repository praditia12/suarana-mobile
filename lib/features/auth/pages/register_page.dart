import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/common/app_gap.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../../../core/widgets/inputs/password_field.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter')),
      );
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).register(
          email: email,
          password: password,
        );

    if (!success && mounted) {
      final error = ref.read(authNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error?.toString() ?? 'Registrasi gagal')),
      );
      return;
    }

    // Register Supabase default kirim email konfirmasi.
    // Tampilkan info ke user, lalu kembali ke login.
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cek email kamu untuk konfirmasi akun'),
          duration: Duration(seconds: 4),
        ),
      );
      context.go(RouteNames.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'Suarana',
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.gray1,
                      ),
                    ),
                    AppGap.sm,
                    Text(
                      'Music for every moment.',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.green1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 90),
              Text(
                'Daftar',
                style: AppTextStyles.heading3.copyWith(
                        color: AppColors.green1,
                        fontWeight: FontWeight.w500,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                'Buat akun baru',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.gray3),
              ),
              const SizedBox(height: 32),
              AppTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              PasswordField(
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              PasswordField(
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                onPressed: isLoading ? null : _register,
                isLoading: isLoading,
                title: 'Daftar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}