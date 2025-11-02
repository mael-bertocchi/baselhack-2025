import 'package:flutter/material.dart';
import 'package:alignify/src/routes/AppRoutes.dart';
import 'package:alignify/src/Application/Shared/Api/AuthService.dart';
import 'package:alignify/src/Application/Shared/Models/Models.dart';

/// A route wrapper that enforces authentication and role-based access control.
///
/// Security checks performed (in order):
/// 1. Waits for AuthService to initialize
/// 2. Validates user is authenticated (has valid token + user data)
/// 3. Validates user has one of the required roles (if specified)
///
/// If any check fails, redirects to the appropriate page:
/// - Not authenticated → Login page
/// - Authenticated but insufficient permissions → Unauthorized page
class ProtectedRoute extends StatefulWidget {
  final WidgetBuilder builder;
  final List<Role> requiredRoles;

  const ProtectedRoute({
    super.key,
    required this.builder,
    this.requiredRoles = const [],
  });

  @override
  State<ProtectedRoute> createState() => _ProtectedRouteState();
}

class _ProtectedRouteState extends State<ProtectedRoute> {
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

    // Wait for initialization with timeout to prevent infinite loading
    int attempts = 0;
    while (!auth.isInitialized && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
      if (!mounted) return;
    }

    // If still not initialized after 5 seconds, redirect to login
    if (!auth.isInitialized) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
      return;
    }

    // Check authentication (validates both token and user data)
    if (!auth.isAuthenticated) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
      return;
    }

    // Check authorization (role-based access control)
    if (widget.requiredRoles.isNotEmpty) {
      final userRole = auth.currentUser?.role;
      final hasRequiredRole = userRole != null && widget.requiredRoles.contains(userRole);
      
      if (!hasRequiredRole) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.unauthorized);
        }
        return;
      }
    }

    // All checks passed - setState will trigger a rebuild showing the actual content
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

    // If not authenticated or not authorized, show loading while redirecting
    if (!auth.isAuthenticated) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check role authorization
    if (widget.requiredRoles.isNotEmpty) {
      final userRole = auth.currentUser?.role;
      final hasRequiredRole = userRole != null && widget.requiredRoles.contains(userRole);
      
      if (!hasRequiredRole) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    }

    // User is authenticated and authorized - show protected content
    return widget.builder(context);
  }
}
