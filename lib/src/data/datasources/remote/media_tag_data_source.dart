import 'dart:convert';
import 'dart:typed_data';

import 'package:connectrpc/connect.dart' as connect;
import 'package:connectrpc/protobuf.dart' as connect_protobuf;
import 'package:connectrpc/protocol/connect.dart' as connect_protocol;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../generated/mediatag/asset/v1/asset.connect.client.dart';
import '../generated/mediatag/compose/v1/compose.connect.client.dart';
import '../generated/mediatag/report/v1/report.connect.client.dart';
import '../generated/mediatag/tool/v1/tool.connect.client.dart';
import '../generated/mediatag/work/v1/work.connect.client.dart';
import '../generated/tacittag/rag/v2/rag.connect.client.dart';
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
    labelService = LabelServiceClient(transport);
    toolService = ToolServiceClient(transport);
    ragService = RagServiceClient(transport);
  }

  final String baseUrl;
  late final WorkServiceClient workService;
  late final AssetServiceClient assetService;
  late final ReportServiceClient reportService;
  late final MediaComposeServiceClient composeService;
  late final LabelServiceClient labelService;
  late final ToolServiceClient toolService;
  late final RagServiceClient ragService;

  Future<String> readContent(String url) async {
    final bytes = await readBytes(url);
    return utf8.decode(bytes, allowMalformed: true);
  }

  Future<Uint8List> readBytes(
    String url, {
    int? startByte,
    int? endByte,
  }) async {
    final headers = connect.Headers();
    if (startByte != null) {
      final end = endByte == null ? '' : '$endByte';
      headers.add('range', 'bytes=$startByte-$end');
    }
    final response = await createDashboardHttpClient()(
      connect.HttpRequest(url, 'GET', headers, null, null),
    );
    if (response.status != 200 && response.status != 206) {
      throw StateError('content ${response.status}');
    }
    final chunks = await response.body.toList();
    final length = chunks.fold<int>(0, (sum, chunk) => sum + chunk.length);
    final bytes = Uint8List(length);
    var offset = 0;
    for (final chunk in chunks) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return bytes;
  }

  String resolveContentUrl(String path) {
    if (path.isEmpty) {
      return '';
    }
    final parsed = Uri.tryParse(path);
    if (parsed != null && parsed.hasScheme) {
      return path;
    }
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final relative = path.startsWith('/') ? path : '/$path';
    return '$base$relative';
  }

  static const _DEFAULT_MEDIA_TAG_BASE_URL = 'https://tks.faivv.ai/api';

  static String _resolveBaseUrl(String? override) {
    final configured = override ?? dotenv.env['MEDIA_TAG_BASE_URL'];
    return configured == null || configured.trim().isEmpty
        ? _DEFAULT_MEDIA_TAG_BASE_URL
        : configured.trim();
  }
}
