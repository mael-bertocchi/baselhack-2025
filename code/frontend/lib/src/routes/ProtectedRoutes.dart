import 'package:flutter/material.dart';
import 'package:frontend/src/pages/Login/LoginPage.dart';
import 'package:frontend/src/pages/Unauthorized/UnauthorizedPage.dart';
import 'package:frontend/src/services/AuthService.dart';

/// A small widget that wraps another page and enforces authentication and roles.
///
/// If the user is not authenticated, it shows the `LoginPage`.
/// If the user is authenticated but lacks the required roles, it shows
/// an `UnauthorizedPage`.
class ProtectedRoute extends StatelessWidget {
  final WidgetBuilder builder;
  final List<Role> requiredRoles;

  const ProtectedRoute({Key? key, required this.builder, this.requiredRoles = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;

    if (!auth.isAuthenticated) {
      // Not authenticated -> show login
      return const LoginPage();
    }

    if (requiredRoles.isNotEmpty && !auth.hasAnyRole(requiredRoles)) {
      // Authenticated but not authorized
      return const UnauthorizedPage();
    }

    return builder(context);
  }
}
