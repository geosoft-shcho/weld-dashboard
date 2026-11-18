import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/asset_lookup_kind.dart';
import '../../../domain/entities/asset_lookup_row.dart';
import '../../core/widgets/lookup_search_field.dart';

typedef AssetAttachPageLoader =
    Future<AssetLookupPage> Function({
      required String query,
      required String kindCode,
      required bool unattachedOnly,
      required String pageToken,
    });

class AssetAttachDialogResult {
  const AssetAttachDialogResult({required this.assetIds, required this.passId});

  final List<String> assetIds;
  final String passId;
}

class AssetAttachPassOption {
  const AssetAttachPassOption({required this.passId, required this.passNo});

  final String passId;
  final int passNo;
}

/// 종류를 먼저 고른 뒤, 필요하면 검색어로 좁혀 파일을 첨부한다.
///
/// 멀티모달 사이드 패널처럼 [WorkDetailMaterialScope] 안에서는 Fluent
/// Localizations가 가려지므로, Fluent 조상 컨텍스트로 다이얼로그를 연다.
Future<AssetAttachDialogResult?> showAssetAttachDialog({
  required BuildContext context,
  required AssetAttachPageLoader loadPage,
  required List<AssetAttachPassOption> passes,
  Set<String> excludedAssetIds = const {},
}) {
  return showDialog<AssetAttachDialogResult>(
    context: _contextWithFluentLocalizations(context),
    useRootNavigator: true,
    builder: (_) => _AssetAttachDialog(
      loadPage: loadPage,
      passes: passes,
      excludedAssetIds: excludedAssetIds,
    ),
  );
}

BuildContext _contextWithFluentLocalizations(BuildContext context) {
  if (Localizations.of<FluentLocalizations>(context, FluentLocalizations) !=
      null) {
    return context;
  }
  final rootNavigator = Navigator.maybeOf(context, rootNavigator: true);
  if (rootNavigator != null &&
      Localizations.of<FluentLocalizations>(
            rootNavigator.context,
            FluentLocalizations,
          ) !=
          null) {
    return rootNavigator.context;
  }
  return context;
}

class _AssetAttachDialog extends StatefulWidget {
  const _AssetAttachDialog({
    required this.loadPage,
    required this.passes,
    required this.excludedAssetIds,
  });

  final AssetAttachPageLoader loadPage;
  final List<AssetAttachPassOption> passes;
  final Set<String> excludedAssetIds;

  @override
  State<_AssetAttachDialog> createState() => _AssetAttachDialogState();
}

class _AssetAttachDialogState extends State<_AssetAttachDialog> {
  static const double _minContentWidth = 480;
  static const double _rowChromeWidth = 40;
  static const TextStyle _rowTextStyle = TextStyle(fontSize: 12);

  final TextEditingController _queryController = TextEditingController();
  String _kindCode = '';
  bool _unattachedOnly = false;
  String _passId = '';
  final Set<String> _selectedAssetIds = <String>{};
  List<AssetLookupRow> _rows = const [];
  String _nextPageToken = '';
  int _totalCount = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _errorMessage = '';
  bool _didLoad = false;
  int _loadEpoch = 0;

  bool get _canLoad =>
      _kindCode.isNotEmpty || _queryController.text.trim().isNotEmpty;

  String _rowLabel(AssetLookupRow row) {
    final fileName = row.fileName.isEmpty ? '—' : row.fileName;
    return '${row.assetId} · $fileName';
  }

  double _longestRowTextWidth() {
    var longest = 0.0;
    for (final row in _rows) {
      final painter = TextPainter(
        text: TextSpan(text: _rowLabel(row), style: _rowTextStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      if (painter.width > longest) {
        longest = painter.width;
      }
    }
    return longest;
  }

  double _contentWidthOf(BuildContext context, double needed) {
    final screenCap = MediaQuery.sizeOf(context).width * 0.92;
    if (needed <= _minContentWidth) {
      return _minContentWidth;
    }
    if (needed > screenCap) {
      return screenCap;
    }
    return needed;
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _clearList() {
    _didLoad = false;
    _rows = const [];
    _nextPageToken = '';
    _totalCount = 0;
    _selectedAssetIds.clear();
    _errorMessage = '';
    _isLoading = false;
    _isLoadingMore = false;
  }

  bool _onListScroll(ScrollNotification notification) {
    if (notification.metrics.extentAfter >= 80) return false;
    if (_nextPageToken.isEmpty || _isLoadingMore || _isLoading) return false;
    _load(reset: false);
    return false;
  }

  void _toggleSelected(String assetId, bool? checked) {
    setState(() {
      if (checked == true) {
        _selectedAssetIds.add(assetId);
      } else {
        _selectedAssetIds.remove(assetId);
      }
    });
  }

  Future<void> _load({bool reset = true}) async {
    if (!_canLoad) {
      setState(_clearList);
      return;
    }
    final epoch = ++_loadEpoch;
    setState(() {
      _didLoad = true;
      _isLoading = reset;
      _isLoadingMore = !reset;
      _errorMessage = '';
      if (reset) {
        _rows = const [];
        _nextPageToken = '';
        _totalCount = 0;
        _selectedAssetIds.clear();
      }
    });
    try {
      final page = await widget.loadPage(
        query: _queryController.text.trim(),
        kindCode: _kindCode,
        unattachedOnly: _unattachedOnly,
        pageToken: reset ? '' : _nextPageToken,
      );
      if (!mounted || epoch != _loadEpoch) return;
      final excluded = widget.excludedAssetIds;
      final nextRows = [
        for (final row in page.rows)
          if (!excluded.contains(row.assetId)) row,
      ];
      setState(() {
        if (reset) {
          _rows = nextRows;
        } else {
          final existing = {for (final row in _rows) row.assetId};
          _rows = [
            ..._rows,
            for (final row in nextRows)
              if (!existing.contains(row.assetId)) row,
          ];
        }
        _nextPageToken = page.nextPageToken;
        if (page.totalCount > 0) {
          _totalCount = page.totalCount;
        }
      });
    } catch (error) {
      if (!mounted || epoch != _loadEpoch) return;
      setState(() {
        _errorMessage = error.toString();
        if (reset) {
          _rows = const [];
          _nextPageToken = '';
          _totalCount = 0;
        }
      });
    } finally {
      if (mounted && epoch == _loadEpoch) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  void _confirm() {
    if (_selectedAssetIds.isEmpty) return;
    Navigator.of(context).pop(
      AssetAttachDialogResult(
        assetIds: _selectedAssetIds.toList(growable: false),
        passId: _passId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final needed = _longestRowTextWidth() + _rowChromeWidth;
    final contentWidth = _contentWidthOf(context, needed);
    final doesClipRowText = needed > contentWidth;
    return ContentDialog(
      title: const Text('파일 첨부'),
      constraints: BoxConstraints(
        maxWidth: contentWidth + 40,
        maxHeight: 560,
      ),
      content: SizedBox(
        width: contentWidth,
        height: 420,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '종류를 먼저 고른 뒤 목록에서 고르세요. 필요하면 번호·이름으로 더 좁힐 수 있습니다.\n'
              '문서 PDF를 첨부하면 첨부만 됩니다. 성적서 세트에는 이어지지 않습니다.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: InfoLabel(
                    label: '종류',
                    child: ComboBox<String>(
                      isExpanded: true,
                      value: _kindCode,
                      items: [
                        for (final kind in AssetLookupKindOption.kinds)
                          ComboBoxItem(
                            value: kind.code,
                            child: Text(kind.label),
                          ),
                      ],
                      onChanged: _isLoading
                          ? null
                          : (value) {
                              setState(() => _kindCode = value ?? '');
                              _load();
                            },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Checkbox(
                    checked: _unattachedOnly,
                    content: const Text('미첨부만'),
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() => _unattachedOnly = value ?? false);
                            if (_canLoad) {
                              _load();
                            }
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '검색 (선택)',
              child: Row(
                children: [
                  Expanded(
                    child: LookupSearchField(
                      controller: _queryController,
                      value: _queryController.text,
                      hintText: '번호 · 파일 이름 · 원본 위치',
                      onChanged: (_) {},
                      onSubmitted: (_) => _load(),
                      enabled: !_isLoading,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Button(
                    onPressed: _isLoading ? null : () => _load(),
                    child: const Text('검색'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _listBody(doesClipRowText: doesClipRowText)),
            const SizedBox(height: 8),
            InfoLabel(
              label: '패스',
              child: ComboBox<String>(
                isExpanded: true,
                value: _passId,
                items: [
                  const ComboBoxItem(value: '', child: Text('작업 공용')),
                  for (final pass in widget.passes)
                    ComboBoxItem(
                      value: pass.passId,
                      child: Text('${pass.passNo}패스'),
                    ),
                ],
                onChanged: (value) => setState(() => _passId = value ?? ''),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Button(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _selectedAssetIds.isEmpty ? null : _confirm,
          child: Text(
            _selectedAssetIds.isEmpty
                ? '첨부'
                : '${_selectedAssetIds.length}개 첨부',
          ),
        ),
      ],
    );
  }

  Widget _listBody({required bool doesClipRowText}) {
    if (_isLoading) {
      return const Center(child: ProgressRing());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(_errorMessage, style: const TextStyle(fontSize: 12)),
      );
    }
    if (!_didLoad) {
      return const Center(
        child: Text('종류를 먼저 고르세요.', style: TextStyle(fontSize: 12)),
      );
    }
    if (_rows.isEmpty) {
      return const Center(
        child: Text('조건에 맞는 파일이 없습니다.', style: TextStyle(fontSize: 12)),
      );
    }
    final visibleIds = [for (final row in _rows) row.assetId];
    final selectedVisibleCount = visibleIds
        .where(_selectedAssetIds.contains)
        .length;
    final bool? allVisibleChecked = selectedVisibleCount == 0
        ? false
        : selectedVisibleCount == visibleIds.length
        ? true
        : null;
    final countLabel = _totalCount > 0
        ? '${_rows.length} / $_totalCount건'
        : '${_rows.length}건';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Checkbox(
                  checked: allVisibleChecked,
                  content: Text(
                    _selectedAssetIds.isEmpty
                        ? '전체 선택'
                        : '${_selectedAssetIds.length}개 선택',
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedAssetIds.addAll(visibleIds);
                      } else {
                        _selectedAssetIds.removeAll(visibleIds);
                      }
                    });
                  },
                ),
              ),
              Text(
                countLabel,
                style: TextStyle(
                  fontSize: 11,
                  color: FluentTheme.of(
                    context,
                  ).resources.textFillColorSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: _onListScroll,
            child: ListView.builder(
              itemCount: _rows.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _rows.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: ProgressRing(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                final row = _rows[index];
                final selected = _selectedAssetIds.contains(row.assetId);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Checkbox(
                        checked: selected,
                        onChanged: (value) =>
                            _toggleSelected(row.assetId, value),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () =>
                              _toggleSelected(row.assetId, !selected),
                          child: Text(
                            _rowLabel(row),
                            style: _rowTextStyle,
                            maxLines: 1,
                            softWrap: false,
                            overflow: doesClipRowText
                                ? TextOverflow.ellipsis
                                : TextOverflow.visible,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
