import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/timeline_board_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('timecode uses padded hours, minutes, seconds and 30fps frames', () {
    expect(formatTimelineTimecode(0), '00:00:00:00');
    expect(formatTimelineTimecode(300), '00:05:00:00');
    expect(formatTimelineTimecode(2700), '00:45:00:00');
    expect(formatTimelineTimecode(1.5), '00:00:01:15');
    expect(formatTimelineTimecode(1.97), '00:00:01:29');
    expect(formatTimelineTimecode(59.99), '00:01:00:00');
    expect(formatTimelineTimecode(3599.99), '01:00:00:00');
  });

  test('400 second ruler paints minute ticks and only two labels at any zoom', () {
    for (final pixelsPerSecond in [50 / 60, 1.0, 80.0]) {
      final canvas = _RecordingCanvas();
      TimelineRulerPainter(
        spanSeconds: 400,
        pixelsPerSecond: pixelsPerSecond,
      ).paint(canvas, ui.Size(400 * pixelsPerSecond, 22));

      expect(canvas.tickStarts, [
        for (final second in [0, 60, 120, 180, 240, 300, 360])
          ui.Offset(second * pixelsPerSecond, 12),
      ]);
      expect(canvas.labelOffsets, [
        const ui.Offset(3, 0),
        ui.Offset(300 * pixelsPerSecond + 3, 0),
      ]);
    }
  });
}

class _RecordingCanvas implements ui.Canvas {
  final List<ui.Offset> tickStarts = [];
  final List<ui.Offset> labelOffsets = [];

  @override
  void drawRect(ui.Rect rect, ui.Paint paint) {}

  @override
  void drawLine(ui.Offset start, ui.Offset end, ui.Paint paint) {
    tickStarts.add(start);
    expect(end.dy, 22);
  }

  @override
  void drawParagraph(ui.Paragraph paragraph, ui.Offset offset) {
    labelOffsets.add(offset);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
