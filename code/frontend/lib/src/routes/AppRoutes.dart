import 'package:flutter/material.dart';
import 'package:frontend/src/pages/Dashboard/DashboardPage.dart';
import 'package:frontend/src/pages/Login/LoginPage.dart';
import 'package:frontend/src/pages/Unauthorized/UnauthorizedPage.dart';
import 'package:frontend/src/pages/NotFound/NotFoundPage.dart';
import 'package:frontend/src/pages/CreateTopic/CreateTopicPage.dart';
import 'package:frontend/src/routes/ProtectedRoutes.dart';
import 'package:frontend/src/Application/Login/Api/AuthService.dart';

/// Centralized application routes for navigation
/// All routes should be defined here for security and maintainability
class AppRoutes {
  AppRoutes._();

  // Route paths - use these constants throughout the app
  static const String unauthorized = '/unauthorized';
  static const String notFound = '/404';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String createTopic = '/create-topic';

  /// Main route map for MaterialApp
  static Map<String, WidgetBuilder> routes = {
    unauthorized: (context) => const UnauthorizedPage(),
    notFound: (context) => const NotFoundPage(),
    login: (context) => const LoginPage(),
    dashboard: (context) => ProtectedRoute(
          builder: (ctx) => const DashboardPage(),
          requiredRoles: [Role.user, Role.manager, Role.administrator],
        ),
    createTopic: (context) => ProtectedRoute(
          builder: (ctx) => const CreateTopicPage(),
          requiredRoles: [Role.manager, Role.administrator],
        ),
  };

  /// Handler for undefined routes - returns 404 page
  /// This ensures users can't access arbitrary paths
  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const NotFoundPage(),
      settings: settings,
    );
  }
}
