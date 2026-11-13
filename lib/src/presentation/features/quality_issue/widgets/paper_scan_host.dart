import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/pdfrx_document_source.dart';
import '../../../core/widgets/pdfrx_document_viewer.dart';

class PaperScanHost extends StatefulWidget {
  const PaperScanHost({
    super.key,
    required this.scanFile,
    required this.scanPages,
    this.initialPage,
  });

  final String scanFile;
  final int scanPages;
  final int? initialPage;

  @override
  State<PaperScanHost> createState() => _PaperScanHostState();
}

class _PaperScanHostState extends State<PaperScanHost> {
  static const double VIEWPORT_MIN_HEIGHT = 540;
  static const String UNAVAILABLE_MESSAGE =
      '페이퍼 원본이 연동되지 않았습니다. 성적서 번호와 검사 항목만 표시합니다.';

  PdfrxDocumentSource? _source;
  String? _unsupportedReason;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void didUpdateWidget(covariant PaperScanHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scanFile != widget.scanFile) {
      _prepare();
    }
  }

  void _prepare() {
    final path = widget.scanFile.trim();
    _unsupportedReason = null;
    if (path.isEmpty) {
      _source = null;
      return;
    }
    _source = resolvePdfrxDocumentSource(
      path,
      onUnsupported: (reason) => _unsupportedReason = reason,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanFile = widget.scanFile.trim();
    if (scanFile.isEmpty) {
      return _unavailableSlot();
    }
    final source = _source;
    if (source == null) {
      return _viewport(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _unsupportedReason ?? '연결된 스캔 파일을 찾을 수 없습니다',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return PdfrxDocumentViewer(
      key: ValueKey(scanFile),
      source: source,
      initialPage: widget.initialPage,
      backgroundColor: AppTheme.SURFACE_RAISED,
      fallbackPageCount: widget.scanPages,
      expandViewport: false,
      viewportHeight: VIEWPORT_MIN_HEIGHT,
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

/// 기존 호출부 호환용. 새 코드는 [resolvePdfrxDocumentSource]를 쓴다.
String? resolveScanAssetPath(String scanFile) =>
    resolvePdfrxAssetPath(scanFile);
