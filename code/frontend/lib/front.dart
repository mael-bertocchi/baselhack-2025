// Barrel file to provide a convenient single import for commonly used frontend symbols.
// Usage:
//   import 'package:frontend/front.dart';
// Then access exported symbols directly or via a prefix:
//   final page = DetailsPage();

// Re-export localization
export 'l10n/app_localizations.dart';

// Re-export main routes and pages (add more exports here as you need them)
// Export pages (keep AppRoutes out of this barrel to avoid circular imports)
export 'src/pages/Login/LoginPage.dart';
export 'src/pages/Dashboard/DashboardPage.dart';
export 'src/pages/Unauthorized/UnauthorizedPage.dart';
export 'src/pages/NotFound/NotFoundPage.dart';

// Re-export routes now that AppRoutes doesn't import this barrel (avoids circular import)
export 'src/routes/AppRoutes.dart';

// Add further exports below to make other modules available through
// `package:frontend/front.dart`. For example:
// export 'src/widgets/my_widget.dart';
