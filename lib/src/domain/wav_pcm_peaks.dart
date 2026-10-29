import 'dart:math' as math;
import 'dart:typed_data';

/// PCM WAV(s16le) 헤더·데이터 구간. Range 샘플용.
class WavPcmLayout {
  const WavPcmLayout({
    required this.channels,
    required this.bitsPerSample,
    required this.sampleRate,
    required this.dataOffset,
    required this.dataSize,
  });

  final int channels;
  final int bitsPerSample;
  final int sampleRate;
  final int dataOffset;
  final int dataSize;

  int get bytesPerFrame => channels * (bitsPerSample ~/ 8);

  int get frameCount => bytesPerFrame == 0 ? 0 : dataSize ~/ bytesPerFrame;
}

/// RIFF/WAVE 헤더에서 PCM 레이아웃을 읽는다.
WavPcmLayout? wavPcmLayoutFromHeader(Uint8List bytes) {
  if (bytes.length < 44) {
    return null;
  }
  if (!_fourCc(bytes, 0, 'RIFF') || !_fourCc(bytes, 8, 'WAVE')) {
    return null;
  }
  var channels = 0;
  var bitsPerSample = 0;
  var sampleRate = 0;
  var audioFormat = 0;
  var pos = 12;
  while (pos + 8 <= bytes.length) {
    final id = String.fromCharCodes(bytes.sublist(pos, pos + 4));
    final size = ByteData.sublistView(bytes).getUint32(pos + 4, Endian.little);
    final body = pos + 8;
    if (id == 'fmt ' && body + 16 <= bytes.length) {
      final view = ByteData.sublistView(bytes);
      audioFormat = view.getUint16(body, Endian.little);
      channels = view.getUint16(body + 2, Endian.little);
      sampleRate = view.getUint32(body + 4, Endian.little);
      bitsPerSample = view.getUint16(body + 14, Endian.little);
    } else if (id == 'data') {
      if (audioFormat != 1 || bitsPerSample != 16 || channels < 1) {
        return null;
      }
      return WavPcmLayout(
        channels: channels,
        bitsPerSample: bitsPerSample,
        sampleRate: sampleRate,
        dataOffset: body,
        dataSize: size,
      );
    }
    pos = body + size + (size.isOdd ? 1 : 0);
  }
  return null;
}

/// PCM 구간 바이트에서 최대 절대 진폭(0..1)을 구한다.
double wavPcmPeakAmplitude(Uint8List pcmBytes, int channels) {
  if (pcmBytes.isEmpty || channels < 1) {
    return 0;
  }
  final view = ByteData.sublistView(pcmBytes);
  final sampleCount = pcmBytes.length ~/ 2;
  var peak = 0;
  for (var index = 0; index < sampleCount; index++) {
    final value = view.getInt16(index * 2, Endian.little).abs();
    if (value > peak) {
      peak = value;
    }
  }
  return (peak / 32768.0).clamp(0.0, 1.0);
}

/// [sampleCount]개 구간의 시작 바이트 오프셋(파일 기준).
List<int> wavPcmSampleOffsets({
  required WavPcmLayout layout,
  required int sampleCount,
  required int windowBytes,
}) {
  if (sampleCount <= 0 || layout.frameCount <= 0 || layout.bytesPerFrame <= 0) {
    return const [];
  }
  final usable = math.max(layout.bytesPerFrame, windowBytes);
  final maxStart = math.max(0, layout.dataSize - usable);
  return [
    for (var index = 0; index < sampleCount; index++)
      layout.dataOffset +
          ((maxStart * index) ~/ math.max(1, sampleCount - 1)) -
          (((maxStart * index) ~/ math.max(1, sampleCount - 1)) %
              layout.bytesPerFrame),
  ];
}

bool _fourCc(Uint8List bytes, int offset, String value) {
  if (offset + 4 > bytes.length || value.length != 4) {
    return false;
  }
  return bytes[offset] == value.codeUnitAt(0) &&
      bytes[offset + 1] == value.codeUnitAt(1) &&
      bytes[offset + 2] == value.codeUnitAt(2) &&
      bytes[offset + 3] == value.codeUnitAt(3);
}
