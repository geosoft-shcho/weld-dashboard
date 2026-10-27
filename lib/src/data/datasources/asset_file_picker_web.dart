import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/entities/camera_recording.dart';

Future<CameraRecordingFile?> pickAssetFile() async {
  final files = await pickAssetFiles(multiple: false);
  if (files.isEmpty) {
    return null;
  }
  return files.first;
}

Future<List<CameraRecordingFile>> pickAssetFiles({bool multiple = true}) async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..multiple = multiple;
  final completer = Completer<List<CameraRecordingFile>>();
  input.onchange = (web.Event _) {
    final list = input.files;
    if (list == null || list.length == 0) {
      completer.complete(const []);
      return;
    }
    final futures = <Future<CameraRecordingFile>>[];
    for (var i = 0; i < list.length; i++) {
      final file = list.item(i);
      if (file == null) {
        continue;
      }
      futures.add(
        file.arrayBuffer().toDart.then((buffer) {
          return CameraRecordingFile(
            bytes: buffer.toDart.asUint8List(),
            mimeType: file.type,
            fileName: file.name,
            lastModifiedAt: DateTime.fromMillisecondsSinceEpoch(
              file.lastModified,
            ),
          );
        }),
      );
    }
    Future.wait(futures).then(completer.complete).catchError((Object error) {
      completer.completeError(error);
    });
  }.toJS;
  input.oncancel = (web.Event _) {
    if (!completer.isCompleted) {
      completer.complete(const []);
    }
  }.toJS;
  input.click();
  return completer.future;
}
