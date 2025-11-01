import 'package:flutter/material.dart';
import 'package:alignify/src/Application/Shared/UI/Components.dart';
import 'package:alignify/src/theme/AppColors.dart';
import 'package:alignify/src/Application/Login/Api/AuthService.dart';
import 'package:alignify/src/routes/AppRoutes.dart';
import 'package:alignify/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SelectionArea(
        child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 0,
          ),
          child: CustomCard.elevated(
            width: isMobile ? double.infinity : 540,
            padding: EdgeInsets.all(isMobile ? 24 : 48),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/alignify_logo_icon.png',
                  width: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              SelectableText(
                l10n.welcomeToConsensusHub,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              SelectableText(
                l10n.signInToAccount,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              CustomTextField(
                controller: emailController,
                labelText: l10n.emailAddress,
                hintText: l10n.emailPlaceholder,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: passwordController,
                labelText: l10n.password,
                hintText: l10n.passwordPlaceholder,
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
                text: l10n.signIn,
                width: double.infinity,
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  if (email.isEmpty) {
                    // simple client-side feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.pleaseEnterEmail)),
                    );
                    return;
                  }
                  
                  if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.pleaseEnterPassword)),
                    );
                    return;
                  }

                  try {
                    // Call the real AuthService with email and password
                    await AuthService.instance.login(email, password);

                    // After login, navigate to dashboard (replace current route).
                    if (mounted) {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
                    }
                  } catch (e) {
                    // Show error message to user
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.loginFailed(e.toString())),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
          ),
        ),
      ),
    );
  }
}