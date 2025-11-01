import 'package:flutter/foundation.dart';

/// Simple role enum for route protection.
enum Role { admin, manager, member }

/// Minimal user model used by the AuthService.
class User {
  final String id;
  final String email;
  final List<Role> roles;

  const User({required this.id, required this.email, required this.roles});
}

/// A tiny in-memory AuthService used by the app to check authentication and roles.
///
/// This is intentionally simple: it exposes the current user and helper methods
/// to check authentication and role membership. Replace or expand this with
/// real authentication (token storage, backend calls) when integrating.
class AuthService extends ChangeNotifier {
  User? _currentUser;

  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  /// Mock login: accepts an email and assigns roles based on simple rules.
  /// Replace with real backend auth.
  Future<void> login(String email) async {
    // Very small heuristic mapping for demo/testing purposes.
    final lower = email.toLowerCase();
    if (lower.contains('admin')) {
      _currentUser = User(id: '1', email: email, roles: [Role.admin]);
    } else if (lower.contains('manager')) {
      _currentUser = User(id: '2', email: email, roles: [Role.manager]);
    } else {
      _currentUser = User(id: '3', email: email, roles: [Role.member]);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  /// Returns true if the current user has any of the provided roles.
  bool hasAnyRole(List<Role> requiredRoles) {
    if (_currentUser == null) return false;
    for (final r in requiredRoles) {
      if (_currentUser!.roles.contains(r)) return true;
    }
    return false;
  }
}
