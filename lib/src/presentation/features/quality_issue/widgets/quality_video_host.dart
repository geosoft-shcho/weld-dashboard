import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../../work_detail/widgets/work_detail_chewie_stage.dart';

class QualityVideoHost extends StatefulWidget {
  const QualityVideoHost({
    super.key,
    required this.videoFile,
    this.seekToMs,
    this.seekToken = 0,
  });

  final String videoFile;
  final int? seekToMs;
  final int seekToken;

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
    final assetPath = _assetPath;
    if (assetPath == null) {
      return _viewport(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '연결된 영상 파일을 찾을 수 없습니다',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return _viewport(
      child: WorkDetailChewieStage(
        key: ValueKey(assetPath),
        assetPath: assetPath,
        seekToMs: widget.seekToMs,
        seekToken: widget.seekToken,
      ),
    );
  }

  Widget _unavailableSlot() {
    return _viewport(
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(UNAVAILABLE_MESSAGE, textAlign: TextAlign.center),
        ),
      ),
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
