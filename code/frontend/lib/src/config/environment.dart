/// Environment configuration for the application
/// 
/// IMPORTANT: Do NOT store sensitive secrets here. This file is compiled
/// into your app and can be reverse-engineered. Only store public
/// configuration that's safe to expose to end users.
/// 
/// For different environments (dev, staging, prod), use build flavors
/// or different configuration classes.
class Environment {
  Environment._();

  /// API base URL - The backend endpoint for API requests
  /// 
  /// For production builds, this should point to your production backend.
  /// For development, point to your local or development backend.
  /// 
  /// You can override this during build time using:
  /// flutter build web --dart-define=API_URL=https://api.production.com
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://127.0.0.1:8080/api',
  );

  /// Whether the app is in debug mode
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;

  /// Get the full API endpoint URL with path
  static String getApiEndpoint(String path) {
    // Ensure path starts with /
    final cleanPath = path.startsWith('/') ? path : '/$path';
    // Remove trailing slash from apiUrl if present
    final baseUrl = apiUrl.endsWith('/') ? apiUrl.substring(0, apiUrl.length - 1) : apiUrl;
    return '$baseUrl$cleanPath';
  }
}
