import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/entities/asset_upload.dart';
import '../../domain/entities/camera_recording.dart';

Future<CameraRecordingFile?> pickAssetFile() async {
  final result = await pickAssetFiles(multiple: false);
  if (result.files.isEmpty) {
    if (result.warnings.isNotEmpty) {
      throw AssetUploadException(result.warnings.join('\n'));
    }
    return null;
  }
  return result.files.first;
}

Future<AssetPickResult> pickAssetFiles({bool multiple = true}) async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..multiple = multiple;
  final completer = Completer<AssetPickResult>();
  input.onchange = (web.Event _) {
    unawaited(_readSelectedFiles(input.files).then((result) {
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    }));
  }.toJS;
  input.oncancel = (web.Event _) {
    if (!completer.isCompleted) {
      completer.complete(const AssetPickResult());
    }
  }.toJS;
  input.click();
  return completer.future;
}

Future<AssetPickResult> _readSelectedFiles(web.FileList? list) async {
  if (list == null || list.length == 0) {
    return const AssetPickResult();
  }
  final files = <CameraRecordingFile>[];
  final warnings = <String>[];
  for (var i = 0; i < list.length; i++) {
    final file = list.item(i);
    if (file == null) {
      continue;
    }
    final name = file.name.trim().isEmpty ? '파일' : file.name;
    try {
      final buffer = await file.arrayBuffer().toDart;
      files.add(
        CameraRecordingFile(
          bytes: buffer.toDart.asUint8List(),
          mimeType: file.type,
          fileName: file.name,
          lastModifiedAt: DateTime.fromMillisecondsSinceEpoch(
            file.lastModified,
          ),
        ),
      );
    } catch (error) {
      warnings.add(_readFailureMessage(name, error));
    }
  }
  return AssetPickResult(files: files, warnings: warnings);
}

String _readFailureMessage(String fileName, Object error) {
  final text = '$error'.toLowerCase();
  if (text.contains('notreadable') || text.contains('could not be read')) {
    return '$fileName: 파일을 읽지 못했습니다. '
        '클라우드(미다운로드)·다른 앱 사용 중·권한을 확인한 뒤 '
        '로컬에 복사해 다시 고르세요.';
  }
  return '$fileName: 파일을 열지 못했습니다.';
}
