import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/authenticated_pdfrx_document.dart';
import '../../../core/widgets/pdfrx_document_source.dart';

class PaperScanHost extends StatelessWidget {
  const PaperScanHost({
    super.key,
    required this.scanFile,
    required this.scanPages,
    this.initialPage,
  });

  final String scanFile;
  final int scanPages;
  final int? initialPage;

  static const double VIEWPORT_MIN_HEIGHT = 540;
  static const String UNAVAILABLE_MESSAGE =
      '페이퍼 원본이 연동되지 않았습니다. 성적서 번호와 검사 항목만 표시합니다.';

  @override
  Widget build(BuildContext context) {
    final path = scanFile.trim();
    if (path.isEmpty) {
      return _viewport(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(UNAVAILABLE_MESSAGE, textAlign: TextAlign.center),
          ),
        ),
      );
    }
    return _viewport(
      child: AuthenticatedPdfrxDocument(
        key: ValueKey(path),
        path: path,
        initialPage: initialPage,
        backgroundColor: AppTheme.SURFACE_RAISED,
        fallbackPageCount: scanPages,
        expandViewport: false,
        viewportHeight: VIEWPORT_MIN_HEIGHT,
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
