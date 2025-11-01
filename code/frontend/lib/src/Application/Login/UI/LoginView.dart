import 'package:flutter/material.dart';
import 'package:frontend/src/Application/Shared/UI/Components.dart';
import 'package:frontend/src/theme/AppColors.dart';
import 'package:frontend/src/services/AuthService.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SelectionArea(
        child: Center(
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

              const SelectableText(
                'Welcome to Consensus Hub',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              const SelectableText(
                'Sign in to your account to share your insights',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              CustomTextField(
                controller: emailController,
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
                controller: passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: !isPasswordVisible,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textTertiary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),

              CustomButton.primary(
                text: 'Sign In',
                width: double.infinity,
                onPressed: () async {
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    // simple client-side feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your email')),
                    );
                    return;
                  }

                  // Call the mock AuthService. Replace with your real auth flow as needed.
                  await AuthService.instance.login(email);

                  // After login, navigate to dashboard (replace current route).
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/dashboard');
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        ),
      ),
    );
  }
}