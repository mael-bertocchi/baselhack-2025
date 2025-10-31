import 'package:flutter/material.dart';

import 'package:frontend/src/pages/Home/HomePage.dart';
import 'package:frontend/src/pages/Details/DetailsPage.dart';

class AppRoutes {
  AppRoutes._();

  static const initial = '/';
  static const details = '/details';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomePage(),
    details: (context) => const DetailsPage(),
  };
}
