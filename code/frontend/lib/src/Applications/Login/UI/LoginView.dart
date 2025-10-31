import 'package:flutter/material.dart';
import 'package:frontend/src/Applications/Shared/UI/Components.dart';
import 'package:frontend/src/theme/app_colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CustomCard.elevated(
          width: 540,
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              CustomAvatar(
                initials: 'C',
                size: 64,
                backgroundColor: AppColors.blueLight,
                textColor: Colors.white,
              ),
              const SizedBox(height: 24),

              const Text(
                'Welcome to Consensus Hub',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Sign in to your account to share your insights',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              CustomTextField(
                controller: _emailController,
                labelText: 'Email Address',
                hintText: 'you@example.com',
                helperText: 'Tip: Use admin@endress.com for admin view',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: !_isPasswordVisible,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textTertiary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),

              CustomButton.primary(
                text: 'Sign In',
                width: double.infinity,
                onPressed: () {
                  // Handle sign in
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}