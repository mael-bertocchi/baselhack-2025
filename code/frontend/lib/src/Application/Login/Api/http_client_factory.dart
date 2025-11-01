import 'package:http/http.dart' as http;

import 'http_client_stub.dart'
    if (dart.library.html) 'http_client_web.dart';

http.Client createHttpClient() => createPlatformHttpClient();
