import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../../work_detail/widgets/work_detail_chewie_stage.dart';

class QualityVideoHost extends StatefulWidget {
  const QualityVideoHost({
    super.key,
    required this.videoFile,
    this.seekToMs,
    this.seekToken = 0,
    this.displayName = '',
  });

  final String videoFile;
  final int? seekToMs;
  final int seekToken;
  final String displayName;

  @override
  State<QualityVideoHost> createState() => _QualityVideoHostState();
}

class _QualityVideoHostState extends State<QualityVideoHost> {
  static const double VIEWPORT_MIN_HEIGHT = 540;
  static const String UNAVAILABLE_MESSAGE = '현장 영상이 연동되지 않았습니다.';

  String? _assetPath;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void didUpdateWidget(covariant QualityVideoHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoFile != widget.videoFile) {
      _prepare();
    }
  }

  void _prepare() {
    final path = widget.videoFile.trim();
    if (path.isEmpty) {
      _assetPath = null;
      return;
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      _assetPath = path;
      return;
    }
    _assetPath = resolveQualityVideoAssetPath(path);
  }

  @override
  Widget build(BuildContext context) {
    final videoFile = widget.videoFile.trim();
    if (videoFile.isEmpty) {
      return _unavailableSlot();
    }
    final providedName = widget.displayName.trim();
    final displayName = providedName.isEmpty
        ? qualityVideoDisplayName(videoFile)
        : providedName;
    final assetPath = _assetPath;
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
                child: const Text('현장 영상'),
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
        if (assetPath == null)
          _viewport(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '연결된 영상 파일을 찾을 수 없습니다',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          _viewport(
            child: WorkDetailChewieStage(
              key: ValueKey(assetPath),
              assetPath: assetPath,
              seekToMs: widget.seekToMs,
              seekToken: widget.seekToken,
            ),
          ),
      ],
    );
  }

  Widget _unavailableSlot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          color: AppTheme.SURFACE_RAISED,
          child: const Text('현장 영상'),
        ),
        _viewport(
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(UNAVAILABLE_MESSAGE, textAlign: TextAlign.center),
            ),
          ),
        ),
      ],
    );
  }

  Widget _viewport({required Widget child}) {
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
