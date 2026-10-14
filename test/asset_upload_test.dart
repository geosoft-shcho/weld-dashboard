import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/remote/media_tag_data_source.dart';
import 'package:weld_dashboard/src/data/repositories/remote_asset_upload_repository.dart';
import 'package:weld_dashboard/src/domain/entities/camera_recording.dart';

void main() {
  test('camera file upload sends job, UTC origin, and original file', () async {
    String? sentUrl;
    String? sentMetadata;
    String? sentFileName;
    String? sentMimeType;
    Uint8List? sentBytes;
    final repository = RemoteAssetUploadRepository(
      MediaTagDataSource(baseUrl: 'http://media.example/api/'),
      ({
        required String url,
        required String metadata,
        required String fileName,
        required String mimeType,
        required Uint8List bytes,
      }) async {
        sentUrl = url;
        sentMetadata = metadata;
        sentFileName = fileName;
        sentMimeType = mimeType;
        sentBytes = bytes;
        return '''
{"asset":{"assetId":"81","fileName":"camera-video.webm"},
 "runId":"96","warnings":["확인"]}
''';
      },
    );

    final result = await repository.upload(
      jobId: '128',
      timeOrigin: DateTime.parse('2026-10-14T17:20:26+09:00'),
      file: CameraRecordingFile(
        bytes: Uint8List.fromList([1, 2, 3]),
        mimeType: 'video/webm',
        fileName: 'camera-video.webm',
      ),
    );

    expect(sentUrl, 'http://media.example/api/assets');
    expect(jsonDecode(sentMetadata!), {
      'jobId': '128',
      'timeOrigin': '2026-10-14T08:20:26.000Z',
    });
    expect(sentFileName, 'camera-video.webm');
    expect(sentMimeType, 'video/webm');
    expect(sentBytes, [1, 2, 3]);
    expect(result.assetId, '81');
    expect(result.runId, '96');
    expect(result.warnings, ['확인']);
  });
}
