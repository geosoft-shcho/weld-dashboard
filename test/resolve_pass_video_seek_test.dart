import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/use_cases/resolve_pass_video_seek.dart';

void main() {
  final passStartedAt = DateTime.utc(2026, 10, 29, 23, 8, 48);
  final earlier = PassVideoSpan(
    assetId: 'earlier',
    recordedAt: passStartedAt.add(const Duration(seconds: 2)),
    durationNs: 10000000000,
  );
  final later = PassVideoSpan(
    assetId: 'later',
    recordedAt: passStartedAt.add(const Duration(seconds: 5)),
    durationNs: 10000000000,
  );

  PassVideoSeek? seek({
    required int seconds,
    String focusedAssetId = '',
    List<PassVideoSpan>? videos,
  }) {
    return resolvePassVideoSeek(
      passOffsetNs: seconds * 1000000000,
      passStartedAt: passStartedAt,
      focusedAssetId: focusedAssetId,
      videos: videos ?? [earlier, later],
    );
  }

  test('keeps the focused video when it covers the tapped time', () {
    final result = seek(seconds: 6, focusedAssetId: 'later');
    expect(result?.assetId, 'later');
    expect(result?.seekMs, 1000);
  });

  test('picks the earliest covering video when the focused one does not', () {
    final result = seek(seconds: 6);
    expect(result?.assetId, 'earlier');
    expect(result?.seekMs, 4000);
  });

  test('uses the later video once the earlier window has ended', () {
    final result = seek(seconds: 13);
    expect(result?.assetId, 'later');
    expect(result?.seekMs, 8000);
  });

  test('returns null when no video covers the tapped time', () {
    expect(seek(seconds: 0), isNull);
    expect(seek(seconds: 12, videos: [earlier]), isNull);
  });
}
