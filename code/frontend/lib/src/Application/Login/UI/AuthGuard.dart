import 'package:flutter/material.dart';
import 'package:alignify/src/routes/AppRoutes.dart';
import 'package:alignify/l10n/app_localizations.dart';
import '../Api/AuthService.dart';

/// A wrapper widget that checks authentication before showing content.
/// Redirects to login if user is not authenticated.
/// Shows access denied screen if user lacks required roles.
///
/// This widget is an alternative to ProtectedRoute and can be used
/// to wrap widgets directly in the widget tree rather than at the route level.
///
/// Security checks:
/// 1. Validates user is authenticated (valid token + user data)
/// 2. Validates user has one of the required roles (if specified)
class AuthGuard extends StatefulWidget {
  final Widget child;
  final List<Role>? requiredRoles;

  const AuthGuard({
    super.key,
    required this.child,
    this.requiredRoles,
  });

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  @override
  void initState() {
    super.initState();
    // Defer the check to after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAccessAndNavigate();
    });
  }

  Future<void> _checkAccessAndNavigate() async {
    if (!mounted) return;

    final auth = AuthService.instance;

    // Wait for initialization with timeout
    int attempts = 0;
    while (!auth.isInitialized && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
      if (!mounted) return;
    }

    // If still not initialized or not authenticated, redirect to login
    if (!auth.isInitialized || !auth.isAuthenticated) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
      return;
    }

    // If we have role requirements, check them
    if (widget.requiredRoles != null && widget.requiredRoles!.isNotEmpty) {
      final userRole = auth.currentUser?.role;
      final hasRequiredRole = userRole != null && widget.requiredRoles!.contains(userRole);
      
      if (!hasRequiredRole) {
        // Don't navigate, just show the access denied message
        if (mounted) {
          setState(() {});
        }
        return;
      }
    }

    // All checks passed
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;

    // Show loading while checking
    if (!auth.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If not authenticated, show loading while redirecting
    if (!auth.isAuthenticated) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check role authorization if specified
    if (widget.requiredRoles != null && widget.requiredRoles!.isNotEmpty) {
      final userRole = auth.currentUser?.role;
      final hasRequiredRole = userRole != null && widget.requiredRoles!.contains(userRole);
      
      if (!hasRequiredRole) {
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
                Text(
                  AppLocalizations.of(context)!.accessDenied,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.noPermission,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
                  },
                  child: Text(AppLocalizations.of(context)!.goToDashboard),
                ),
              ],
            ),
          ),
        );
      }
    }

    // User is authenticated and authorized
    return widget.child;
  }
}

/// Example usage in widget tree:
/// 
/// ```dart
/// AuthGuard(
///   requiredRoles: [Role.administrator],
///   child: AdminPanel(),
/// )
/// ```
/// 
/// For route-level protection, use ProtectedRoute in AppRoutes instead.

