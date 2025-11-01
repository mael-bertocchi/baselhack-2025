// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Configure URL strategy for web - removes the # from URLs
void configureUrlStrategy() {
  // Simple way to remove hash without flutter_web_plugins
  // This tells the browser to use path-based routing
  html.window.history.pushState(null, '', html.window.location.pathname);
}
