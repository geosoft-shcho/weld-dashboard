import 'package:flutter/services.dart';

import 'audio_waveform_data.dart';

Future<AudioWaveformData> loadWorkDetailWaveform({
  required String audioAssetPath,
  required String waveformAssetPath,
}) async {
  final resolvedPath = waveformAssetPath.isEmpty
      ? AudioWaveformData.assetPathFor(audioAssetPath)
      : waveformAssetPath;
  final bytes = await rootBundle.load(resolvedPath);
  return AudioWaveformData.parse(bytes.buffer.asUint8List());
}
