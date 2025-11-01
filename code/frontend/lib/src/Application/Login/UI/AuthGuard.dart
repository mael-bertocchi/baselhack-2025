import 'package:flutter/material.dart';
import '../Api/AuthService.dart';

/// A wrapper widget that checks authentication before showing content
/// Redirects to login if user is not authenticated
class AuthGuard extends StatelessWidget {
  final Widget child;
  final List<Role>? requiredRoles;

  const AuthGuard({
    super.key,
    required this.child,
    this.requiredRoles,
  });

  @override
  Widget build(BuildContext context) {
    // Wait for auth service to initialize
    if (!AuthService.instance.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check if user is authenticated
    if (!AuthService.instance.isAuthenticated) {
      // Redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check if user has required roles
    if (requiredRoles != null && !AuthService.instance.hasAnyRole(requiredRoles!)) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Access Denied',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You do not have permission to access this page.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                },
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      );
    }

    // User is authenticated and has required roles
    return child;
  }
}

/// Example usage in route configuration:
/// 
/// ```dart
/// '/dashboard': (context) => const AuthGuard(
///   child: DashboardPage(),
/// ),
/// 
/// '/admin': (context) => const AuthGuard(
///   requiredRoles: [Role.administrator],
///   child: AdminPage(),
/// ),
/// 
/// '/admin-or-manager': (context) => const AuthGuard(
///   requiredRoles: [Role.administrator, Role.manager],
///   child: ManagementPage(),
/// ),
/// ```
