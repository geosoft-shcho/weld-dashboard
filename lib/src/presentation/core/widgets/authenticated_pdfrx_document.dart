import 'package:fluent_ui/fluent_ui.dart';

import '../authenticated_media.dart';
import '../themes/app_theme.dart';
import 'pdfrx_document_source.dart';
import 'pdfrx_document_viewer.dart';

/// http(s) PDF는 Bearer `readBytes` 후 [PdfrxDocumentSource.data].
/// asset·file은 [resolvePdfrxDocumentSource]를 그대로 쓴다.
class AuthenticatedPdfrxDocument extends StatefulWidget {
  const AuthenticatedPdfrxDocument({
    super.key,
    required this.path,
    this.backgroundColor = AppTheme.SURFACE_RAISED,
    this.fallbackPageCount = 0,
    this.expandViewport = true,
    this.viewportHeight,
    this.initialPage,
  });

  final String path;
  final Color backgroundColor;
  final int fallbackPageCount;
  final bool expandViewport;
  final double? viewportHeight;
  final int? initialPage;

  @override
  State<AuthenticatedPdfrxDocument> createState() =>
      _AuthenticatedPdfrxDocumentState();
}

class _AuthenticatedPdfrxDocumentState extends State<AuthenticatedPdfrxDocument> {
  PdfrxDocumentSource? _source;
  String? _errorMessage;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant AuthenticatedPdfrxDocument oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _load();
    }
  }

  Future<void> _load() async {
    final generation = ++_loadGeneration;
    final path = widget.path.trim();
    setState(() {
      _source = null;
      _errorMessage = null;
    });
    if (path.isEmpty) {
      setState(() {
        _errorMessage = 'PDF 주소가 없습니다';
      });
      return;
    }
    final lower = path.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      try {
        final bytes = await readAuthenticatedMediaBytes(path);
        if (!mounted || generation != _loadGeneration) {
          return;
        }
        setState(() {
          _source = PdfrxDocumentSource.data(bytes, sourceName: path);
        });
      } catch (error) {
        if (!mounted || generation != _loadGeneration) {
          return;
        }
        setState(() {
          _errorMessage = error.toString();
        });
      }
      return;
    }
    String? unsupported;
    final source = resolvePdfrxDocumentSource(
      path,
      onUnsupported: (reason) => unsupported = reason,
    );
    if (!mounted || generation != _loadGeneration) {
      return;
    }
    if (source == null) {
      setState(() {
        _errorMessage = unsupported ?? 'PDF를 열 수 없습니다';
      });
      return;
    }
    setState(() {
      _source = source;
    });
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = _errorMessage;
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(errorMessage, textAlign: TextAlign.center),
        ),
      );
    }
    final source = _source;
    if (source == null) {
      return const Center(child: ProgressRing());
    }
    return PdfrxDocumentViewer(
      key: ValueKey(widget.path),
      source: source,
      backgroundColor: widget.backgroundColor,
      fallbackPageCount: widget.fallbackPageCount,
      expandViewport: widget.expandViewport,
      viewportHeight: widget.viewportHeight,
      initialPage: widget.initialPage,
    );
  }
}
