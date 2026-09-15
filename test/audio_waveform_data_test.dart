import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/presentation/features/work_detail/widgets/audio_waveform_data.dart';

void main() {
  test('parses little-endian audiowaveform bytes', () {
    final bytes = Uint8List(20 + 8);
    final data = ByteData.sublistView(bytes);
    data.setUint32(0, 1, Endian.little);
    data.setUint32(4, 0, Endian.little);
    data.setUint32(8, 16000, Endian.little);
    data.setUint32(12, 320, Endian.little);
    data.setUint32(16, 2, Endian.little);
    data.setInt16(20, -1200, Endian.little);
    data.setInt16(22, 2400, Endian.little);
    data.setInt16(24, -800, Endian.little);
    data.setInt16(26, 1600, Endian.little);

    final waveform = AudioWaveformData.parse(bytes);
    expect(waveform.sampleRate, 16000);
    expect(waveform.samplesPerPixel, 320);
    expect(waveform.length, 2);
    expect(waveform.getPixelMin(0), -1200);
    expect(waveform.getPixelMax(0), 2400);
    expect(waveform.getPixelMin(1), -800);
    expect(waveform.getPixelMax(1), 1600);
    expect(waveform.duration, const Duration(milliseconds: 40));
    expect(
      waveform.amplitudeAt(Duration.zero),
      closeTo(2400 / 32768, 0.0001),
    );
    expect(
      waveform.amplitudeAt(const Duration(milliseconds: 20)),
      closeTo(1600 / 32768, 0.0001),
    );
    final samples = waveform.sampledAmplitudes(2);
    expect(samples, hasLength(2));
    expect(samples[0], closeTo(2400 / 32768, 0.0001));
    expect(samples[1], closeTo(1600 / 32768, 0.0001));
    expect(
      AudioWaveformData.assetPathFor('assets/data/attachments/stream.mp4'),
      'assets/data/attachments/stream.wave',
    );
  });
}
