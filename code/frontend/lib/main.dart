import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:frontend/front.dart';

// Conditional import for web URL strategy
import 'main_web.dart' if (dart.library.io) 'main_non_web.dart';

void main() {
  // Remove the # from URLs on web (no-op on mobile)
  configureUrlStrategy();
  runApp(const MyApp());
}

/// Entrypoint app that uses the centralized [AppRoutes].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BaselHack Frontend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('de'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Prefer exact match, otherwise default to English
        if (locale != null) {
          for (final supported in supportedLocales) {
            if (supported.languageCode == locale.languageCode) {
              return supported;
            }
          }
        }
        return const Locale('en');
      },
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
