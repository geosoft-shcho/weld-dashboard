import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_playback_rate.dart';

void main() {
  test('keeps playback rates supported by web video', () {
    expect(browserPlaybackRate(0.5), 0.5);
    expect(browserPlaybackRate(1), 1);
    expect(browserPlaybackRate(2), 2);
    expect(doesRequireStepSeek(0.5), isFalse);
  });

  test('marks unsupported rates for step seek instead of forcing 1', () {
    expect(browserPlaybackRate(0.00738248), isNull);
    expect(browserPlaybackRate(0), isNull);
    expect(browserPlaybackRate(double.nan), isNull);
    expect(browserPlaybackRate(double.infinity), isNull);
    expect(browserPlaybackRate(17), isNull);
    expect(doesRequireStepSeek(0), isTrue);
    expect(doesRequireStepSeek(17), isTrue);
  });

  test('cycles timeline playback rates', () {
    expect(nextTimelinePlaybackRate(1), 1.5);
    expect(nextTimelinePlaybackRate(2), 0.5);
    expect(formatTimelinePlaybackRateLabel(1), '×1');
    expect(formatTimelinePlaybackRateLabel(1.5), '×1.5');
  });
}
