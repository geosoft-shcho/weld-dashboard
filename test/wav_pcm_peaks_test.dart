import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/wav_pcm_peaks.dart';

void main() {
  test('pcm wav header yields data layout', () {
    final bytes = _pcmWavHeader(channels: 2, sampleRate: 44100, dataSize: 1000);
    final layout = wavPcmLayoutFromHeader(bytes);
    expect(layout, isNotNull);
    expect(layout!.channels, 2);
    expect(layout.bitsPerSample, 16);
    expect(layout.sampleRate, 44100);
    expect(layout.dataSize, 1000);
    expect(layout.bytesPerFrame, 4);
  });

  test('pcm peak amplitude uses the loudest sample', () {
    final pcm = ByteData(8);
    pcm.setInt16(0, 0, Endian.little);
    pcm.setInt16(2, 16384, Endian.little);
    pcm.setInt16(4, -100, Endian.little);
    pcm.setInt16(6, 50, Endian.little);
    expect(
      wavPcmPeakAmplitude(pcm.buffer.asUint8List(), 2),
      closeTo(0.5, 0.001),
    );
  });

  test('sample offsets stay inside the data chunk', () {
    const layout = WavPcmLayout(
      channels: 2,
      bitsPerSample: 16,
      sampleRate: 44100,
      dataOffset: 78,
      dataSize: 10000,
    );
    final offsets = wavPcmSampleOffsets(
      layout: layout,
      sampleCount: 5,
      windowBytes: 100,
    );
    expect(offsets, hasLength(5));
    expect(offsets.first, 78);
    expect(offsets.last, lessThanOrEqualTo(78 + 10000 - 100));
    for (final offset in offsets) {
      expect((offset - 78) % 4, 0);
    }
  });
}

Uint8List _pcmWavHeader({
  required int channels,
  required int sampleRate,
  required int dataSize,
}) {
  final bytes = Uint8List(44);
  final view = ByteData.sublistView(bytes);
  bytes.setRange(0, 4, 'RIFF'.codeUnits);
  view.setUint32(4, 36 + dataSize, Endian.little);
  bytes.setRange(8, 12, 'WAVE'.codeUnits);
  bytes.setRange(12, 16, 'fmt '.codeUnits);
  view.setUint32(16, 16, Endian.little);
  view.setUint16(20, 1, Endian.little);
  view.setUint16(22, channels, Endian.little);
  view.setUint32(24, sampleRate, Endian.little);
  final byteRate = sampleRate * channels * 2;
  view.setUint32(28, byteRate, Endian.little);
  view.setUint16(32, channels * 2, Endian.little);
  view.setUint16(34, 16, Endian.little);
  bytes.setRange(36, 40, 'data'.codeUnits);
  view.setUint32(40, dataSize, Endian.little);
  return bytes;
}
