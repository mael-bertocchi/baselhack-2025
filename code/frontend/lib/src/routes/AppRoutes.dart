import 'package:flutter/material.dart';
import 'package:frontend/src/pages/Dashboard/DashboardPage.dart';
import 'package:frontend/src/pages/Login/LoginPage.dart';
import 'package:frontend/src/pages/Unauthorized/UnauthorizedPage.dart';
import 'package:frontend/src/routes/ProtectedRoutes.dart';
import 'package:frontend/src/services/AuthService.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String unauthorized = '/unauthorized';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    unauthorized: (context) => const UnauthorizedPage(),
    dashboard: (context) => ProtectedRoute(
          builder: (ctx) => const DashboardPage(),
          requiredRoles: [Role.manager, Role.admin],
        ),
  };

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const LoginPage(),
      settings: settings,
    );
  }
}
