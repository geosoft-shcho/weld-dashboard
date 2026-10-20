import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/entities/camera_recording.dart';

Future<CameraRecordingFile?> pickAssetFile() async {
  final input = web.HTMLInputElement()..type = 'file';
  final completer = Completer<CameraRecordingFile?>();
  input.onchange = (web.Event _) {
    final file = input.files?.item(0);
    if (file == null) {
      completer.complete(null);
      return;
    }
    file.arrayBuffer().toDart.then((buffer) {
      completer.complete(
        CameraRecordingFile(
          bytes: buffer.toDart.asUint8List(),
          mimeType: file.type,
          fileName: file.name,
          lastModifiedAt: DateTime.fromMillisecondsSinceEpoch(
            file.lastModified,
          ),
        ),
      );
    }).catchError((Object error) {
      completer.completeError(error);
    });
  }.toJS;
  input.oncancel = (web.Event _) {
    if (!completer.isCompleted) {
      completer.complete(null);
    }
  }.toJS;
  input.click();
  return completer.future;
}
