import '../../../domain/entities/job_timeline.dart';

/// `[POSE]` — 포즈 클립 선택·본문 로드·오버레이 디버그 로그.
/// `print` 사용(debugPrint 쓰로틀에 가리지 않음).
class PosePlaybackLog {
  void begin(ClipDetail pose) {
    // ignore: avoid_print
    print(
      '[POSE] clipId=${pose.clipId} poseAssetId=${pose.assetId} '
      'hasPoseUrl=${pose.assetContentUrl.isNotEmpty}',
    );
  }

  void target(ClipDetail pose) {
    // ignore: avoid_print
    print(
      '[POSE] hasTargetClip=${pose.hasTargetClip} '
      'targetClipId=${pose.targetClipId} '
      'targetKind=${pose.targetClipKind} '
      'hasTargetAsset=${pose.hasTargetAsset} '
      'targetAssetId=${pose.targetAssetId} '
      'hasVideoUrl=${pose.targetAssetContentUrl.isNotEmpty}',
    );
  }

  void alignToVideoStart() {
    // ignore: avoid_print
    print(
      '[POSE] timeline does not overlap target video; '
      'aligning pose content to video start',
    );
  }

  void loadingContent({required String assetId}) {
    // ignore: avoid_print
    print('[POSE] loading pose content: assetId=$assetId');
  }

  void staleIgnored({required String clipId}) {
    // ignore: avoid_print
    print('[POSE] stale pose content ignored: $clipId');
  }

  void contentLoaded({required String clipId, required int frames}) {
    // ignore: avoid_print
    print('[POSE] pose content loaded: clipId=$clipId frames=$frames');
  }

  void overlayReady({
    required String clipId,
    required int mappedFrames,
    required bool alignedToVideo,
  }) {
    // ignore: avoid_print
    print(
      '[POSE] overlay ready: clipId=$clipId '
      'mappedFrames=$mappedFrames '
      'alignedToVideo=$alignedToVideo',
    );
  }

  void drawSource({
    required String clipId,
    required int boxes,
    required int points,
    required int bones,
    required String firstRangeMs,
    required int playheadLocalMs,
    required int hitsAtPlayhead,
    required bool hasVideoBar,
  }) {
    // ignore: avoid_print
    print(
      '[POSE] draw source: clipId=$clipId '
      'boxes=$boxes points=$points bones=$bones '
      'first=$firstRangeMs '
      'playheadLocalMs=$playheadLocalMs hitsAtPlayhead=$hitsAtPlayhead '
      'videoBar=$hasVideoBar',
    );
  }

  void failed({required String clipId, required Object message}) {
    // ignore: avoid_print
    print('[POSE] clipId=$clipId failed: $message');
  }
}
