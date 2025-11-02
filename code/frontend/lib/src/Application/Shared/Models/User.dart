/// Role enum matching backend UserRole type
enum Role { administrator, manager, user }

/// Extension to convert backend role strings to Role enum
extension RoleExtension on String {
  Role toRole() {
    switch (toLowerCase()) {
      case 'administrator':
        return Role.administrator;
      case 'manager':
        return Role.manager;
      case 'user':
      default:
        return Role.user;
    }
  }
}

/// User model matching backend response
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final Role role;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle both 'id' (from auth endpoints) and '_id' (from MongoDB documents)
    final String userId;
    if (json.containsKey('id')) {
      userId = json['id'] as String;
    } else if (json.containsKey('_id')) {
      // MongoDB _id can be either a string or an object with $oid
      final idValue = json['_id'];
      if (idValue is String) {
        userId = idValue;
      } else if (idValue is Map && idValue.containsKey('\$oid')) {
        userId = idValue['\$oid'] as String;
      } else {
        userId = idValue.toString();
      }
    } else {
      throw ArgumentError('User JSON must contain either "id" or "_id"');
    }
    
    return User(
      id: userId,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      role: (json['role'] as String? ?? 'User').toRole(),
    );
  }
}

/// Model pour un utilisateur dans la liste de gestion
class UserAccount {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final Role role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAccount({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      role: _parseRole(json['role'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static Role _parseRole(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'administrator':
        return Role.administrator;
      case 'manager':
        return Role.manager;
      case 'user':
        return Role.user;
      default:
        return Role.user;
    }
  }

  String get fullName => '$firstName $lastName';
}
