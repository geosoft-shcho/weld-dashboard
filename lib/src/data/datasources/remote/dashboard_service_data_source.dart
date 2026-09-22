import 'package:connectrpc/protobuf.dart' as connect_protobuf;
import 'package:connectrpc/protocol/connect.dart' as connect_protocol;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../generated/dashboard_service.connect.client.dart';
import 'dashboard_http_client.dart';

class DashboardServiceDataSource {
  DashboardServiceDataSource({String? baseUrl})
    : baseUrl = _resolveBaseUrl(baseUrl) {
    client = DashboardServiceClient(
      connect_protocol.Transport(
        baseUrl: this.baseUrl,
        codec: const connect_protobuf.JsonCodec(),
        httpClient: createDashboardHttpClient(),
      ),
    );
  }

  final String baseUrl;
  late final DashboardServiceClient client;

  static String _resolveBaseUrl(String? override) {
    final configured = override ?? dotenv.env['DASHBOARD_BASE_URL'];
    return configured == null || configured.trim().isEmpty
        ? 'http://192.168.100.3:33201'
        : configured.trim();
  }

  String resolveFileUrl(String path) {
    if (path.isEmpty) return '';
    return Uri.parse(baseUrl).resolve(path).toString();
  }
}
