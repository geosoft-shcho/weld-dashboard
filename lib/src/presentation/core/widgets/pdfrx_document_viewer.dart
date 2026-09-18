import 'package:fluent_ui/fluent_ui.dart';
import 'package:pdfrx/pdfrx.dart';

import '../themes/app_theme.dart';
import 'pdfrx_document_source.dart';
import 'pdfrx_search_field.dart';
import 'waveform_material_scope.dart';

/// PaperScanHost / WorkDetailPdfViewer가 공유하는 pdfrx 뷰어 본체.
///
/// 호스트 바·파일 스트립 등 크롬은 각 기능 위젯에 두고, 여기에는
/// 쪽/줌 · 검색 · 아웃라인 · 텍스트 선택 · Grey params만 둔다.
class PdfrxDocumentViewer extends StatefulWidget {
  const PdfrxDocumentViewer({
    super.key,
    required this.source,
    this.backgroundColor = AppTheme.SURFACE_RAISED,
    this.fallbackPageCount = 0,
    this.expandViewport = true,
    this.viewportHeight,
  });

  final PdfrxDocumentSource source;
  final Color backgroundColor;
  final int fallbackPageCount;
  final bool expandViewport;
  final double? viewportHeight;

  @override
  State<PdfrxDocumentViewer> createState() => _PdfrxDocumentViewerState();
}

class _PdfrxDocumentViewerState extends State<PdfrxDocumentViewer> {
  late final PdfViewerController _controller;
  late final PdfLinkHandlerParams _linkHandlerParams;
  late final TextEditingController _pageJumpController;
  late final FocusNode _pageJumpFocusNode;
  late final GlobalKey<PdfrxSearchFieldState> _searchFieldKey;
  PdfTextSearcher? _textSearcher;

  List<PdfOutlineNode> _outlineNodes = const [];
  bool _isOutlineOpen = false;
  bool _hasLoadError = false;
  String _errorMessage = '';
  String? _searchStatusMessage;
  int? _lastKnownPageNumber;
  int? _lastKnownPageCount;
  bool _wasControllerReady = false;

  @override
  void initState() {
    super.initState();
    // PdfTextSearcher는 controller.isReady일 때만 생성 가능
    // (생성자에서 document.events를 구독한다).
    _controller = PdfViewerController()..addListener(_didChangePdf);
    _linkHandlerParams = PdfLinkHandlerParams(onLinkTap: _didTapLink);
    _pageJumpController = TextEditingController();
    _pageJumpFocusNode = FocusNode(debugLabel: 'pdfrxPageJump');
    _searchFieldKey = GlobalKey<PdfrxSearchFieldState>();
  }

  @override
  void didUpdateWidget(covariant PdfrxDocumentViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      _resetDocumentUi();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_didChangePdf);
    _disposeTextSearcher();
    _pageJumpFocusNode.dispose();
    _pageJumpController.dispose();
    super.dispose();
  }

  void _attachTextSearcher() {
    if (!_controller.isReady || _textSearcher != null) {
      return;
    }
    _textSearcher = PdfTextSearcher(_controller)..addListener(_didChangeSearch);
  }

  void _disposeTextSearcher() {
    final searcher = _textSearcher;
    if (searcher == null) {
      return;
    }
    searcher.removeListener(_didChangeSearch);
    searcher.dispose();
    _textSearcher = null;
  }

  void _resetDocumentUi() {
    _disposeTextSearcher();
    _pageJumpController.clear();
    _searchFieldKey.currentState?.clear();
    _lastKnownPageNumber = null;
    _lastKnownPageCount = null;
    _wasControllerReady = false;
    setState(() {
      _outlineNodes = const [];
      _isOutlineOpen = false;
      _hasLoadError = false;
      _errorMessage = '';
      _searchStatusMessage = null;
    });
  }

  void _didChangePdf() {
    if (!mounted) {
      return;
    }
    final isReady = _controller.isReady;
    if (isReady) {
      final didAttachSearcher = _textSearcher == null;
      _attachTextSearcher();
      final pageNumber = _controller.pageNumber ?? 1;
      final pageCount = _controller.pageCount;
      final didPageChange =
          pageNumber != _lastKnownPageNumber || pageCount != _lastKnownPageCount;
      final didReadyChange = !_wasControllerReady;
      _lastKnownPageNumber = pageNumber;
      _lastKnownPageCount = pageCount;
      _wasControllerReady = true;
      if (!_pageJumpFocusNode.hasFocus) {
        final text = pageNumber.toString();
        if (_pageJumpController.text != text) {
          _pageJumpController.text = text;
        }
      }
      if (didPageChange || didReadyChange || didAttachSearcher) {
        setState(() {});
      }
      return;
    }
    if (_wasControllerReady) {
      _wasControllerReady = false;
      _lastKnownPageNumber = null;
      _lastKnownPageCount = null;
      setState(() {});
    }
  }

  void _didChangeSearch() {
    if (!mounted) {
      return;
    }
    final searcher = _textSearcher;
    if (searcher == null) {
      return;
    }
    setState(() {
      if (!searcher.hasMatches &&
          !searcher.isSearching &&
          (searcher.pattern?.toString().isNotEmpty ?? false)) {
        _searchStatusMessage = '검색 결과 없음';
      } else if (searcher.hasMatches) {
        final current = (searcher.currentIndex ?? 0) + 1;
        _searchStatusMessage = '$current / ${searcher.matches.length}';
      } else {
        _searchStatusMessage = null;
      }
    });
  }

  Future<void> _didTapPrevious() async {
    if (!_controller.isReady) {
      return;
    }
    final pageNumber = _controller.pageNumber ?? 1;
    if (pageNumber <= 1) {
      return;
    }
    await _controller.goToPage(pageNumber: pageNumber - 1);
  }

  Future<void> _didTapNext() async {
    if (!_controller.isReady) {
      return;
    }
    final pageNumber = _controller.pageNumber ?? 1;
    if (pageNumber >= _controller.pageCount) {
      return;
    }
    await _controller.goToPage(pageNumber: pageNumber + 1);
  }

  Future<void> _didTapZoomOut() async {
    if (!_controller.isReady) {
      return;
    }
    await _controller.zoomDown();
  }

  Future<void> _didTapZoomIn() async {
    if (!_controller.isReady) {
      return;
    }
    await _controller.zoomUp();
  }

  Future<void> _didSubmitPageJump() async {
    if (!_controller.isReady) {
      return;
    }
    final pageNumber = int.tryParse(_pageJumpController.text.trim());
    if (pageNumber == null) {
      return;
    }
    final clamped = pageNumber.clamp(1, _controller.pageCount);
    await _controller.goToPage(pageNumber: clamped);
  }

  void _didSubmitSearch([String? queryOverride]) {
    final searcher = _textSearcher;
    if (searcher == null) {
      return;
    }
    final query =
        (queryOverride ?? _searchFieldKey.currentState?.query ?? '').trim();
    if (query.isEmpty) {
      searcher.resetTextSearch();
      setState(() => _searchStatusMessage = null);
      return;
    }
    searcher.startTextSearch(
      query,
      searchImmediately: true,
      goToFirstMatch: true,
    );
  }

  Future<void> _didTapSearchPrevious() async {
    final searcher = _textSearcher;
    if (searcher == null) {
      return;
    }
    if (!searcher.hasMatches) {
      _didSubmitSearch();
      return;
    }
    await searcher.goToPrevMatch();
  }

  Future<void> _didTapSearchNext() async {
    final searcher = _textSearcher;
    if (searcher == null) {
      return;
    }
    if (!searcher.hasMatches) {
      _didSubmitSearch();
      return;
    }
    await searcher.goToNextMatch();
  }

  void _didTapOutlineToggle() {
    if (_outlineNodes.isEmpty) {
      return;
    }
    setState(() => _isOutlineOpen = !_isOutlineOpen);
  }

  Future<void> _didTapOutlineNode(PdfOutlineNode node) async {
    final dest = node.dest;
    if (dest == null || !_controller.isReady) {
      return;
    }
    await _controller.goToDest(dest);
  }

  Future<void> _didTapLink(PdfLink link) async {
    final dest = link.dest;
    if (dest != null && _controller.isReady) {
      await _controller.goToDest(dest);
      return;
    }
    final url = link.url;
    if (url == null || !mounted) {
      return;
    }
    await displayInfoBar(
      context,
      builder: (context, close) {
        return InfoBar(
          title: const Text('외부 링크'),
          content: Text(url.toString()),
          severity: InfoBarSeverity.info,
          onClose: close,
        );
      },
    );
  }

  Future<void> _loadOutline(PdfDocument? document) async {
    if (document == null) {
      if (!mounted) {
        return;
      }
      setState(() {
        _outlineNodes = const [];
        _isOutlineOpen = false;
      });
      return;
    }
    final nodes = await document.loadOutline();
    if (!mounted) {
      return;
    }
    setState(() {
      _outlineNodes = nodes;
      if (nodes.isEmpty) {
        _isOutlineOpen = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageNumber =
        _controller.isReady ? (_controller.pageNumber ?? 1) : 1;
    final pageCount = _controller.isReady
        ? _controller.pageCount
        : (widget.fallbackPageCount > 0 ? widget.fallbackPageCount : 0);
    final pageLabel = pageCount == 0
        ? '불러오는 중'
        : '$pageNumber / $pageCount';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildToolbar(pageLabel),
        const SizedBox(height: 8),
        if (widget.expandViewport)
          Expanded(child: _buildViewport())
        else
          _buildViewport(),
      ],
    );
  }

  Widget _buildToolbar(String pageLabel) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Button(onPressed: _didTapPrevious, child: const Text('이전 쪽')),
        SizedBox(
          width: 56,
          child: TextBox(
            controller: _pageJumpController,
            focusNode: _pageJumpFocusNode,
            placeholder: '쪽',
            onTap: () => _pageJumpFocusNode.requestFocus(),
            onSubmitted: (_) => _didSubmitPageJump(),
          ),
        ),
        Text(pageLabel),
        Button(onPressed: _didTapNext, child: const Text('다음 쪽')),
        Button(onPressed: _didTapZoomOut, child: const Text('축소')),
        Button(onPressed: _didTapZoomIn, child: const Text('확대')),
        PdfrxSearchField(
          key: _searchFieldKey,
          onSubmit: _didSubmitSearch,
        ),
        Button(
          onPressed: () => _didSubmitSearch(),
          child: const Text('검색'),
        ),
        Button(
          onPressed: _didTapSearchPrevious,
          child: const Text('이전 히트'),
        ),
        Button(
          onPressed: _didTapSearchNext,
          child: const Text('다음 히트'),
        ),
        if (_searchStatusMessage != null)
          Text(
            _searchStatusMessage!,
            style: TextStyle(color: AppTheme.INK.withValues(alpha: 0.75)),
          ),
        if (_outlineNodes.isNotEmpty)
          Button(
            onPressed: _didTapOutlineToggle,
            child: Text(_isOutlineOpen ? '아웃라인 닫기' : '아웃라인'),
          ),
      ],
    );
  }

  Widget _buildViewport() {
    final height = widget.viewportHeight;
    final child = ColoredBox(
      color: widget.backgroundColor,
      child: WaveformMaterialScope(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isOutlineOpen && _outlineNodes.isNotEmpty)
              SizedBox(
                width: 220,
                child: ColoredBox(
                  color: AppTheme.SURFACE,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: _buildOutlineTiles(_outlineNodes, depth: 0),
                  ),
                ),
              ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildPdfViewer(),
                  if (_hasLoadError) _buildOverlay(_errorMessage),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (height == null) {
      return child;
    }
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: SizedBox(height: height, child: child),
    );
  }

  List<Widget> _buildOutlineTiles(
    List<PdfOutlineNode> nodes, {
    required int depth,
  }) {
    final tiles = <Widget>[];
    for (final node in nodes) {
      tiles.add(
        Padding(
          padding: EdgeInsets.only(left: 8.0 + depth * 12.0, right: 8),
          child: HyperlinkButton(
            onPressed: () => _didTapOutlineNode(node),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                node.title.isEmpty ? '(제목 없음)' : node.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
      if (node.children.isNotEmpty) {
        tiles.addAll(
          _buildOutlineTiles(node.children, depth: depth + 1),
        );
      }
    }
    return tiles;
  }

  /// FluentApp에는 CupertinoLocalizations가 없어 pdfrx 기본
  /// [AdaptiveTextSelectionToolbar]가 오른쪽 클릭에서 깨진다.
  ///
  /// pdfrx는 반환 위젯이 [Positioned]/[Align]이 아니면 스스로 [Positioned]로
  /// 감싼다. Stack+Positioned를 쓰면 hit-test 크기가 0이 된다.
  Widget? _buildContextMenu(
    BuildContext context,
    PdfViewerContextMenuBuilderParams params,
  ) {
    final canCopy = params.isTextSelectionEnabled &&
        params.textSelectionDelegate.isCopyAllowed &&
        params.textSelectionDelegate.hasSelectedText;
    final canSelectAll = params.isTextSelectionEnabled &&
        !params.textSelectionDelegate.isSelectingAllText;
    if (!canCopy && !canSelectAll) {
      return null;
    }

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        border: Border.all(color: const Color(0xFF3E424A)),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (canCopy)
            _contextMenuItem(
              label: '복사',
              onPressed: () {
                params.textSelectionDelegate.copyTextSelection();
                params.dismissContextMenu();
              },
            ),
          if (canSelectAll)
            _contextMenuItem(
              label: '모두 선택',
              onPressed: () {
                params.textSelectionDelegate.selectAllText();
              },
            ),
        ],
      ),
    );
  }

  Widget _contextMenuItem({
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: HoverButton(
        onPressed: onPressed,
        builder: (context, states) {
          final isHovered = states.isHovered || states.isPressed;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: isHovered
                ? AppTheme.ACCENT_STEEL.withValues(alpha: 0.2)
                : Colors.transparent,
            child: Text(label),
          );
        },
      ),
    );
  }

  Widget _buildPdfViewer() {
    final searcher = _textSearcher;
    final params = PdfViewerParams(
      backgroundColor: widget.backgroundColor,
      scrollPhysics: const ClampingScrollPhysics(),
      textSelectionParams: const PdfTextSelectionParams(enabled: true),
      matchTextColor: const Color(0x808FA4C4),
      activeMatchTextColor: const Color(0xB3E0A14A),
      linkHandlerParams: _linkHandlerParams,
      buildContextMenu: _buildContextMenu,
      // 웹에서 브라우저 기본 메뉴를 막으려면 Focus가 필요하다.
      // enabled:false 는 Focus 위젯 자체를 제거해 contextmenu가 allowed만 된다.
      keyHandlerParams: const PdfViewerKeyHandlerParams(
        enabled: true,
        canRequestFocus: true,
      ),
      // PDF 단축키(화살표/스페이스)는 막고, 쪽 이동은 툴바 버튼으로 한다.
      onKey: (params, key, isRealKeyPress) => false,
      pagePaintCallbacks: searcher == null
          ? null
          : [searcher.pageTextMatchPaintCallback],
      onDocumentChanged: (document) {
        if (document == null) {
          _disposeTextSearcher();
        } else {
          _disposeTextSearcher();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || !_controller.isReady) {
              return;
            }
            setState(_attachTextSearcher);
          });
        }
        _loadOutline(document);
      },
      errorBannerBuilder: (context, error, stackTrace, documentRef) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _hasLoadError) {
            return;
          }
          setState(() {
            _hasLoadError = true;
            _errorMessage = 'PDF 로드 실패';
          });
        });
        return const SizedBox.shrink();
      },
    );

    final source = widget.source;
    return switch (source) {
      PdfrxAssetDocumentSource(:final assetPath) => PdfViewer.asset(
          assetPath,
          controller: _controller,
          params: params,
        ),
      PdfrxFileDocumentSource(:final filePath) => PdfViewer.file(
          filePath,
          controller: _controller,
          params: params,
        ),
      PdfrxUriDocumentSource(:final uri) => PdfViewer.uri(
          uri,
          controller: _controller,
          params: params,
        ),
      PdfrxDataDocumentSource(:final bytes, :final sourceName) =>
        PdfViewer.data(
          bytes,
          sourceName: sourceName,
          controller: _controller,
          params: params,
        ),
    };
  }

  Widget _buildOverlay(String message) {
    return ColoredBox(
      color: widget.backgroundColor.withValues(alpha: 0.92),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
