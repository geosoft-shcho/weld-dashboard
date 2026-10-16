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

  test('ruler paints a short tick each second and a tall labeled tick each minute',
      () {
    const pixelsPerSecond = 10.0;
    const minutes = [0, 60, 120, 180, 240, 300, 360];
    final canvas = _RecordingCanvas();
    TimelineRulerPainter(
      spanSeconds: 400,
      pixelsPerSecond: pixelsPerSecond,
    ).paint(canvas, ui.Size(400 * pixelsPerSecond, 22));

    expect(canvas.majorStarts, [
      for (final second in minutes)
        ui.Offset(second * pixelsPerSecond, TimelineRulerPainter.MAJOR_TICK_TOP),
    ]);
    expect(canvas.minorStarts.length, 394);
    expect(canvas.minorStarts.first, const ui.Offset(10, TimelineRulerPainter.MINOR_TICK_TOP));
    expect(canvas.labelOffsets, [
      for (final second in minutes) ui.Offset(second * pixelsPerSecond + 3, 0),
    ]);
  });
}

class _RecordingCanvas implements ui.Canvas {
  final majorStarts = <ui.Offset>[];
  final minorStarts = <ui.Offset>[];
  final labelOffsets = <ui.Offset>[];

  @override
  void drawRect(ui.Rect rect, ui.Paint paint) {}

  @override
  void drawLine(ui.Offset start, ui.Offset end, ui.Paint paint) {
    expect(end.dy, 22);
    if (start.dy == TimelineRulerPainter.MAJOR_TICK_TOP) {
      majorStarts.add(start);
    } else {
      expect(start.dy, TimelineRulerPainter.MINOR_TICK_TOP);
      minorStarts.add(start);
    }
  }

  @override
  void drawParagraph(ui.Paragraph paragraph, ui.Offset offset) {
    labelOffsets.add(offset);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
