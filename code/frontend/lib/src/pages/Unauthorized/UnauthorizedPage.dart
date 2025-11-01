import 'package:flutter/material.dart';
import 'package:frontend/src/routes/AppRoutes.dart';
import 'package:frontend/src/Application/Login/Api/AuthService.dart';
import 'package:frontend/l10n/app_localizations.dart';

/// Page displayed when user has insufficient permissions
/// Redirects to dashboard if authenticated, login if not
class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAuthenticated = AuthService.instance.isAuthenticated;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accessDenied),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.accessDenied,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                l10n.noPermission,
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
    );
  }
}
