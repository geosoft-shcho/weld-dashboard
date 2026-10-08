import 'package:connectrpc/protobuf.dart' as connect_protobuf;
import 'package:connectrpc/protocol/connect.dart' as connect_protocol;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../generated/mediatag/asset/v1/asset.connect.client.dart';
import '../generated/mediatag/compose/v1/compose.connect.client.dart';
import '../generated/mediatag/report/v1/report.connect.client.dart';
import '../generated/mediatag/tool/v1/tool.connect.client.dart';
import '../generated/mediatag/work/v1/work.connect.client.dart';
import 'dashboard_http_client.dart';

class MediaTagDataSource {
  MediaTagDataSource({String? baseUrl}) : baseUrl = _resolveBaseUrl(baseUrl) {
    final transport = connect_protocol.Transport(
      baseUrl: this.baseUrl,
      codec: const connect_protobuf.JsonCodec(),
      httpClient: createDashboardHttpClient(),
    );
    workService = WorkServiceClient(transport);
    assetService = AssetServiceClient(transport);
    reportService = ReportServiceClient(transport);
    composeService = MediaComposeServiceClient(transport);
    toolService = ToolServiceClient(transport);
  }

  final String baseUrl;
  late final WorkServiceClient workService;
  late final AssetServiceClient assetService;
  late final ReportServiceClient reportService;
  late final MediaComposeServiceClient composeService;
  late final ToolServiceClient toolService;

  String resolveContentUrl(String path) {
    if (path.isEmpty) {
      return '';
    }
    final parsed = Uri.tryParse(path);
    if (parsed != null && parsed.hasScheme) {
      return path;
    }
    return Uri.parse(baseUrl).resolve(path).toString();
  }

  static String _resolveBaseUrl(String? override) {
    final configured = override ?? dotenv.env['MEDIA_TAG_BASE_URL'];
    return configured == null || configured.trim().isEmpty
        ? 'http://192.168.100.3:33210'
        : configured.trim();
  }
}
