import 'package:flutter_web_plugins/url_strategy.dart';

/// Configure URL strategy for web - removes the # from URLs
void configureUrlStrategy() {
  // Use path-based URLs instead of hash-based URLs
  usePathUrlStrategy();
}
