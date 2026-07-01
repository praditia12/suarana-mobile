import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/common/app_gap.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../../../core/widgets/inputs/password_field.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future <void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).login(
          email: email,
          password: password,
        );

    if (!success && mounted) {
      final error = ref.read(authNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error?.toString() ?? 'Login gagal')),
      );
    }
    // Kalau success, GoRouter redirect otomatis ke /home
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
     
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background Circle
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  width: 228,
                  height: 228,
                  child: Image.asset(
                    'assets/images/login_circle.png',
                  ),
                ),
              ),
          
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 154),
          
                    // Logo / Title
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
          
                    SizedBox(height: 110),
          
                    // Username
                    Text(
                      'Username atau Email',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.green1,
                      ),
                    ),
          
                    AppGap.sm,
          
                    AppTextField(
                      controller:
                          _emailController,
                      hintText: 'Masukkan username atau email',         
                      keyboardType: TextInputType.emailAddress,
                    ),
          
                    AppGap.lg,
          
                    // Password
                    Text(
                      'Kata Sandi',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.green1,
                      ),
                    ),
          
                    AppGap.sm,
          
                    PasswordField(
                      controller:
                          _passwordController,
                    ),
                    AppGap.sm,
                    // Forgot Password
                    Align(
                      alignment:
                          Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Lupa Kata Sandi?',
                        ),
                      ),
                    ),
          
                    AppGap.md,
          
                    // Login Button
                    PrimaryButton(
                      title: 'Masuk',
                      onPressed: isLoading ? null : _login,
                      isLoading: isLoading,
                    ),
          
                    AppGap.md,
          
                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.gray3,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push(RouteNames.register),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.only(left: 4),
                          ),
                          child: Text(
                            'Daftar disini',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.green1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}