import 'package:connectrpc/connect.dart' as connect;

import 'dashboard_http_client_io.dart'
    if (dart.library.js_interop) 'dashboard_http_client_web.dart'
    as platform;

connect.HttpClient createDashboardHttpClient() =>
    platform.createDashboardHttpClient();
