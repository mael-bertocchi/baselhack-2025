import 'package:flutter/material.dart';
import 'package:frontend/src/routes/AppRoutes.dart';
import 'package:frontend/src/Application/Login/Api/AuthService.dart';

/// Page displayed when user navigates to an undefined route
/// Redirects to dashboard if authenticated, login if not
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = AuthService.instance.isAuthenticated;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
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
            const Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'The page you are looking for doesn\'t exist or has been moved.',
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
              label: Text(isAuthenticated ? 'Go to Dashboard' : 'Go to Login'),
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
