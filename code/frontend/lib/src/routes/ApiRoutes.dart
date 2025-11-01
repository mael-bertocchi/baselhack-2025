/// Centralized API routes for the application
/// 
/// This enum provides type-safe access to all API endpoints used in the app.
/// Each route includes the full path relative to the base URL.
enum ApiRoutes {
  // Auth endpoints
  signin('/v1/auth/signin'),
  signup('/v1/auth/signup'),
  refreshToken('/v1/auth/refresh'),
  
  // User endpoints
  userMe('/v1/users/me'),
  users('/v1/users'),
  changePassword('/v1/users/changePassword'),
  
  // Topic endpoints
  topics('/v1/topics'),

  // Health endpoints
  health('/v1/health');

  final String path;
  
  const ApiRoutes(this.path);
  
  @override
  String toString() => path;
}
