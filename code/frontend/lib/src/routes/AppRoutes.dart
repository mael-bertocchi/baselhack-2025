import 'package:flutter/material.dart';
import 'package:alignify/src/pages/Dashboard/DashboardPage.dart';
import 'package:alignify/src/pages/Login/LoginPage.dart';
import 'package:alignify/src/pages/Unauthorized/UnauthorizedPage.dart';
import 'package:alignify/src/pages/NotFound/NotFoundPage.dart';
import 'package:alignify/src/pages/CreateTopic/CreateTopicPage.dart';
import 'package:alignify/src/pages/TopicDetails/TopicDetailsPage.dart';
import 'package:alignify/src/pages/UpdateTopic/UpdateTopicPage.dart';
import 'package:alignify/src/pages/ManageAccounts/ManageAccountsPage.dart';
import 'package:alignify/src/routes/ProtectedRoutes.dart';
import 'package:alignify/src/Application/Login/Api/AuthService.dart';

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
  static const String topicDetails = '/topics'; // Base path for /topics/:id
  static const String updateTopic = '/topics/edit'; // Base path for /topics/:id/edit
  static const String manageAccounts = '/manage-accounts';

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
    manageAccounts: (context) => ProtectedRoute(
          builder: (ctx) => const ManageAccountsPage(),
          requiredRoles: [Role.administrator],
        ),
  };
  
  /// Generate routes for dynamic paths with parameters
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Handle /topics/:id route
    if (settings.name?.startsWith('/topics/') == true) {
      final uri = Uri.parse(settings.name!);
      final segments = uri.pathSegments;
      
      // /topics/:id/edit - Update topic page
      if (segments.length == 3 && segments[2] == 'edit') {
        final topicId = segments[1];
        return MaterialPageRoute(
          builder: (context) => ProtectedRoute(
            builder: (ctx) => const UpdateTopicPage(),
            requiredRoles: [Role.manager, Role.administrator],
          ),
          settings: RouteSettings(
            name: settings.name,
            arguments: topicId,
          ),
        );
      }
      
      // /topics/:id - Topic details page (open to all authenticated users)
      if (segments.length == 2) {
        final topicId = segments[1];
        return MaterialPageRoute(
          builder: (context) => ProtectedRoute(
            builder: (ctx) => const TopicDetailsPage(),
            requiredRoles: [Role.user, Role.manager, Role.administrator],
          ),
          settings: RouteSettings(
            name: settings.name,
            arguments: topicId,
          ),
        );
      }
    }
    
    return null;
  }

  /// Handler for undefined routes - returns 404 page
  /// This ensures users can't access arbitrary paths
  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    // First try onGenerateRoute for dynamic paths
    final route = onGenerateRoute(settings);
    if (route != null) {
      return route;
    }
    
    // If no match, return 404
    return MaterialPageRoute(
      builder: (context) => const NotFoundPage(),
      settings: settings,
    );
  }
}
