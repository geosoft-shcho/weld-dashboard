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

  test('uploadFile sends subject and situation when non-empty', () async {
    String? sentMetadata;
    final repository = RemoteAssetUploadRepository(
      MediaTagDataSource(baseUrl: 'http://media.example/api/'),
      ({
        required String url,
        required String metadata,
        required String fileName,
        required String mimeType,
        required Uint8List bytes,
      }) async {
        sentMetadata = metadata;
        return '{"asset":{"assetId":"82","fileName":"a.mp4"},"runId":"1"}';
      },
    );

    await repository.uploadFile(
      jobId: '128',
      passId: '45',
      equipmentId: '3',
      timeOrigin: DateTime.parse('2026-09-16T13:38:53+09:00'),
      subject: '  초층 비드  ',
      situation: '위보기',
      file: CameraRecordingFile(
        bytes: Uint8List.fromList([1]),
        mimeType: 'video/mp4',
        fileName: 'a.mp4',
      ),
    );

    expect(jsonDecode(sentMetadata!), {
      'jobId': '128',
      'passId': '45',
      'equipmentId': '3',
      'timeOrigin': '2026-09-16T04:38:53.000Z',
      'subject': '초층 비드',
      'situation': '위보기',
    });
  });

  test('uploadFile omits empty subject and situation', () async {
    String? sentMetadata;
    final repository = RemoteAssetUploadRepository(
      MediaTagDataSource(baseUrl: 'http://media.example/api/'),
      ({
        required String url,
        required String metadata,
        required String fileName,
        required String mimeType,
        required Uint8List bytes,
      }) async {
        sentMetadata = metadata;
        return '{"asset":{"assetId":"83","fileName":"b.mp4"},"runId":"2"}';
      },
    );

    await repository.uploadFile(
      jobId: '128',
      passId: '',
      equipmentId: '',
      timeOrigin: null,
      subject: '   ',
      situation: '',
      file: CameraRecordingFile(
        bytes: Uint8List.fromList([1]),
        mimeType: 'video/mp4',
        fileName: 'b.mp4',
      ),
    );

    expect(jsonDecode(sentMetadata!), {'jobId': '128'});
  });
}
