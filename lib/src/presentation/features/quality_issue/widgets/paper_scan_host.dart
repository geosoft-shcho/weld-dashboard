import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/pdfrx_document_source.dart';
import '../../../core/widgets/pdfrx_document_viewer.dart';

class PaperScanHost extends StatefulWidget {
  const PaperScanHost({
    super.key,
    required this.scanFile,
    required this.scanPages,
  });

  final String scanFile;
  final int scanPages;

  @override
  State<PaperScanHost> createState() => _PaperScanHostState();
}

class _PaperScanHostState extends State<PaperScanHost> {
  static const double VIEWPORT_MIN_HEIGHT = 320;
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
    final displayName = paperScanDisplayName(scanFile);
    final source = _source;
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
                child: const Text('pdfrx · PaperScanHost'),
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
        if (source == null)
          _viewport(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _unsupportedReason ?? '연결된 스캔 파일을 찾을 수 없습니다',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          PdfrxDocumentViewer(
            key: ValueKey(scanFile),
            source: source,
            backgroundColor: AppTheme.SURFACE_RAISED,
            fallbackPageCount: widget.scanPages,
            expandViewport: false,
            viewportHeight: VIEWPORT_MIN_HEIGHT,
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
          child: const Text('pdfrx · PaperScanHost'),
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

String paperScanDisplayName(String path) {
  final base = path.split('/').last;
  if (base == 'connection-beam-ndt.pdf' || base == 'connection_beam_ndt.pdf') {
    return 'CONNECTION BEAM 검사 및 NDT리포트.pdf';
  }
  return base;
}

/// 기존 호출부 호환용. 새 코드는 [resolvePdfrxDocumentSource]를 쓴다.
String? resolveScanAssetPath(String scanFile) => resolvePdfrxAssetPath(scanFile);
