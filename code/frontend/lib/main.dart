import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:alignify/front.dart';
import 'package:alignify/src/Application/Login/Api/AuthService.dart';
import 'package:alignify/src/Application/Common/LocaleProvider.dart';

// Conditional import for web URL strategy
import 'main_web.dart' if (dart.library.io) 'main_non_web.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize AuthService (loads stored tokens if any)
  await AuthService.instance.init();
  
  // Remove the # from URLs on web (no-op on mobile)
  configureUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider.value(value: AuthService.instance),
      ],
      child: const MyApp(),
    ),
  );
}

/// Entrypoint app that uses the centralized [AppRoutes].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine initial route based on authentication status
    // If user is authenticated after init, go to dashboard, otherwise login
    final initialRoute = AuthService.instance.isAuthenticated 
        ? AppRoutes.dashboard 
        : AppRoutes.login;

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'Alignify',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          locale: localeProvider.locale,
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
          initialRoute: initialRoute,
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          onUnknownRoute: AppRoutes.onUnknownRoute,
        );
      },
    );
  }
}
