import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_playback_rate.dart';

void main() {
  test('keeps playback rates supported by web video', () {
    expect(supportedVideoPlaybackRate(0.5), 0.5);
    expect(supportedVideoPlaybackRate(1), 1);
    expect(supportedVideoPlaybackRate(2), 2);
  });

  test('uses normal speed for unsupported playback rates', () {
    expect(supportedVideoPlaybackRate(0.00738248), 1);
    expect(supportedVideoPlaybackRate(0), 1);
    expect(supportedVideoPlaybackRate(double.nan), 1);
    expect(supportedVideoPlaybackRate(double.infinity), 1);
    expect(supportedVideoPlaybackRate(17), 1);
  });
}
