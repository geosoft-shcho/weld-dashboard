import 'dart:typed_data';

class AudioWaveformData {
  const AudioWaveformData({
    required this.version,
    required this.flags,
    required this.sampleRate,
    required this.samplesPerPixel,
    required this.length,
    required this.data,
  });

  factory AudioWaveformData.parse(Uint8List bytes) {
    if (bytes.length < 20) {
      throw const FormatException('waveform header is too short');
    }
    final byteData = ByteData.sublistView(bytes);
    final version = byteData.getUint32(0, Endian.little);
    final flags = byteData.getUint32(4, Endian.little);
    final sampleRate = byteData.getUint32(8, Endian.little);
    final samplesPerPixel = byteData.getUint32(12, Endian.little);
    final length = byteData.getUint32(16, Endian.little);
    final sampleCount = length * 2;
    final data = <int>[];
    if (flags == 0) {
      final requiredLength = 20 + sampleCount * 2;
      if (bytes.length < requiredLength) {
        throw const FormatException('waveform 16-bit data is truncated');
      }
      for (var index = 0; index < sampleCount; index++) {
        data.add(byteData.getInt16(20 + index * 2, Endian.little));
      }
    } else {
      final requiredLength = 20 + sampleCount;
      if (bytes.length < requiredLength) {
        throw const FormatException('waveform 8-bit data is truncated');
      }
      for (var index = 0; index < sampleCount; index++) {
        data.add(byteData.getInt8(20 + index));
      }
    }
    return AudioWaveformData(
      version: version,
      flags: flags,
      sampleRate: sampleRate,
      samplesPerPixel: samplesPerPixel,
      length: length,
      data: data,
    );
  }

  static String assetPathFor(String audioAssetPath) {
    final dotIndex = audioAssetPath.lastIndexOf('.');
    if (dotIndex <= 0) {
      return '$audioAssetPath.wave';
    }
    return '${audioAssetPath.substring(0, dotIndex)}.wave';
  }

  final int version;
  final int flags;
  final int sampleRate;
  final int samplesPerPixel;
  final int length;
  final List<int> data;

  int operator [](int index) {
    if (index < 0 || index >= data.length) {
      return 0;
    }
    return data[index];
  }

  int getPixelMin(int pixelIndex) => this[2 * pixelIndex];

  int getPixelMax(int pixelIndex) => this[2 * pixelIndex + 1];

  Duration get duration {
    if (sampleRate == 0) {
      return Duration.zero;
    }
    return Duration(
      microseconds: 1000 * 1000 * length * samplesPerPixel ~/ sampleRate,
    );
  }

  double positionToPixel(Duration position) {
    if (samplesPerPixel == 0) {
      return 0;
    }
    return position.inMicroseconds * sampleRate / (samplesPerPixel * 1000000);
  }

  double amplitudeAt(Duration position) {
    if (length <= 0) {
      return 0;
    }
    final pixelIndex = positionToPixel(position).round().clamp(0, length - 1);
    final minAbs = getPixelMin(pixelIndex).abs();
    final maxAbs = getPixelMax(pixelIndex).abs();
    final peak = minAbs > maxAbs ? minAbs : maxAbs;
    final scale = flags == 0 ? 32768.0 : 128.0;
    return (peak / scale).clamp(0.0, 1.0);
  }

  List<double> sampledAmplitudes(int sampleCount) {
    if (sampleCount <= 0) {
      return const [];
    }
    if (length <= 0 || duration == Duration.zero) {
      return List<double>.filled(sampleCount, 0);
    }
    return [
      for (var index = 0; index < sampleCount; index++)
        amplitudeAt(
          Duration(microseconds: duration.inMicroseconds * index ~/ sampleCount),
        ),
    ];
  }
}
