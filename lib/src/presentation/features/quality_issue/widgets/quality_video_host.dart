import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../../work_detail/widgets/work_detail_chewie_stage.dart';

class QualityVideoHost extends StatelessWidget {
  const QualityVideoHost({
    super.key,
    required this.videoFile,
    this.seekToMs,
    this.seekToken = 0,
  });

  final String videoFile;
  final int? seekToMs;
  final int seekToken;

  static const double VIEWPORT_MIN_HEIGHT = 320;

  @override
  Widget build(BuildContext context) {
    final path = videoFile.trim();
    if (path.isEmpty) {
      return _slot(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('현장 영상이 연동되지 않았습니다.', textAlign: TextAlign.center),
          ),
        ),
      );
    }
    final assetPath = path.startsWith('http://') || path.startsWith('https://')
        ? path
        : resolveQualityVideoAssetPath(path);
    final displayName = qualityVideoDisplayName(path);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          color: AppTheme.SURFACE_RAISED,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.ACCENT_STEEL.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text('video_player + chewie · QualityVideoHost'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _slot(
          child: assetPath == null
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '연결된 영상 파일을 찾을 수 없습니다',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : WorkDetailChewieStage(
                  key: ValueKey(assetPath),
                  assetPath: assetPath,
                  seekToMs: seekToMs,
                  seekToken: seekToken,
                ),
        ),
      ],
    );
  }

  Widget _slot({required Widget child}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: VIEWPORT_MIN_HEIGHT),
      child: SizedBox(
        height: VIEWPORT_MIN_HEIGHT,
        child: ColoredBox(color: AppTheme.SURFACE_RAISED, child: child),
      ),
    );
  }
}

String qualityVideoDisplayName(String path) {
  final base = path.split('/').last;
  return base.isEmpty ? '현장 영상' : base;
}

String? resolveQualityVideoAssetPath(String videoFile) {
  final trimmed = videoFile.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  if (trimmed.startsWith('assets/')) {
    return trimmed;
  }
  if (trimmed.startsWith('data/')) {
    return 'assets/$trimmed';
  }
  if (trimmed.startsWith('./')) {
    return 'assets/${trimmed.substring(2)}';
  }
  return 'assets/data/attachments/$trimmed';
}
