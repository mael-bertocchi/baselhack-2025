import 'package:flutter/material.dart';
import 'package:alignify/src/routes/AppRoutes.dart';
import 'package:alignify/src/Application/Login/Api/AuthService.dart';
import 'package:alignify/l10n/app_localizations.dart';

/// Page displayed when user navigates to an undefined route
/// Redirects to dashboard if authenticated, login if not
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAuthenticated = AuthService.instance.isAuthenticated;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageNotFound),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              '404',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.pageNotFound,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                l10n.pageNotFoundMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  isAuthenticated ? AppRoutes.dashboard : AppRoutes.login,
                  (route) => false,
                );
              },
              icon: Icon(isAuthenticated ? Icons.home : Icons.login),
              label: Text(isAuthenticated ? l10n.goToDashboard : l10n.goToLogin),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
