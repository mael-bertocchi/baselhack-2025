import 'package:flutter/material.dart';

import 'package:frontend/src/pages/Login/LoginPage.dart';

class AppRoutes {
  AppRoutes._();

  static const login = '/login';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
  };
}
