import 'package:http/http.dart' as http;

import 'http_client_stub.dart'
    if (dart.library.html) 'http_client_web.dart';

http.Client? _sharedClient;

http.Client get httpClient {
  _sharedClient ??= createPlatformHttpClient();
  return _sharedClient!;
}

void closeSharedHttpClient() {
  _sharedClient?.close();
  _sharedClient = null;
}
