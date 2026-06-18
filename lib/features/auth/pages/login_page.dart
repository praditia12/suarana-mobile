import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/common/app_gap.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../../../core/widgets/inputs/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Username dan password tidak boleh kosong',
              style: TextStyle(
                color: Colors.red,
              ),
          ),    
        ),
      );
      return;
    }
    debugPrint('Login clicked');
    context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              /// Background Circle
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
          
              /// Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 154),
          
                    /// Logo / Title
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
          
                    /// Username
                    Text(
                      'Username atau Email',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.green1,
                      ),
                    ),
          
                    AppGap.sm,
          
                    AppTextField(
                      controller:
                          usernameController,
                      hintText: 'Masukkan username atau email',
          
                    ),
          
                    AppGap.lg,
          
                    /// Password
                    Text(
                      'Kata Sandi',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.green1,
                      ),
                    ),
          
                    AppGap.sm,
          
                    PasswordField(
                      controller:
                          passwordController,
                    ),
                    AppGap.sm,
                    /// Forgot Password
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
          
                    /// Login Button
                    PrimaryButton(
                      title: 'Masuk',
                      onPressed: _login,
                    ),
          
                    AppGap.xl,
          
                    /// Footer
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Belum punya akun? ',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.gray3,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Daftar disini',
                              style:
                                  const TextStyle(
                                color: AppColors
                                    .green1,
                              ),
                            ),
                          ],
                        ),
                      ),
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