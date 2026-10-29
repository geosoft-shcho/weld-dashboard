import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../domain/entities/asset_lookup_row.dart';
import '../../../core/browser_open_url.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/pdfrx_document_source.dart';
import '../../../core/widgets/pdfrx_document_viewer.dart';
import '../../../core/widgets/waveform_material_scope.dart';
import '../../work_detail/widgets/work_detail_chewie_stage.dart';
import '../../work_detail/widgets/work_detail_material_scope.dart';
import 'asset_just_audio_stage.dart';

typedef AssetContentReader = Future<String> Function({required String url});

enum _AssetPreviewKind {
  video,
  audio,
  image,
  pdf,
  text,
  csv,
  json,
  unsupported,
  missing,
}

class AssetPreviewPane extends StatelessWidget {
  const AssetPreviewPane({
    super.key,
    required this.asset,
    required this.readContent,
  });

  final AssetLookupRow asset;
  final AssetContentReader readContent;

  @override
  Widget build(BuildContext context) {
    final kind = _previewKindOf(asset);
    final url = asset.contentUrl;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF3E424A)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          height: _heightOf(kind),
          width: double.infinity,
          child: switch (kind) {
            _AssetPreviewKind.missing => const _PreviewMessage(
              '미리 볼 주소가 없습니다',
            ),
            _AssetPreviewKind.unsupported => _UnsupportedPreview(asset: asset),
            _AssetPreviewKind.video => WorkDetailMaterialScope(
              child: WorkDetailChewieStage(assetPath: url),
            ),
            _AssetPreviewKind.audio => WorkDetailMaterialScope(
              child: AssetJustAudioStage(contentUrl: url),
            ),
            _AssetPreviewKind.image => _ImagePreview(url: url),
            _AssetPreviewKind.pdf => WaveformMaterialScope(
              child: PdfrxDocumentViewer(
                source: PdfrxDocumentSource.uri(Uri.parse(url)),
              ),
            ),
            _AssetPreviewKind.text => _TextPreview(
              url: url,
              readContent: readContent,
            ),
            _AssetPreviewKind.csv => _CsvPreview(
              url: url,
              readContent: readContent,
            ),
            _AssetPreviewKind.json => _JsonPreview(
              url: url,
              readContent: readContent,
            ),
          },
        ),
      ),
    );
  }
}

double _heightOf(_AssetPreviewKind kind) {
  switch (kind) {
    case _AssetPreviewKind.video:
    case _AssetPreviewKind.pdf:
      return 360;
    case _AssetPreviewKind.image:
      return 280;
    case _AssetPreviewKind.audio:
      return 220;
    case _AssetPreviewKind.text:
    case _AssetPreviewKind.csv:
      return 240;
    case _AssetPreviewKind.json:
      return 280;
    case _AssetPreviewKind.unsupported:
    case _AssetPreviewKind.missing:
      return 120;
  }
}

_AssetPreviewKind _previewKindOf(AssetLookupRow asset) {
  if (asset.contentUrl.isEmpty) {
    return _AssetPreviewKind.missing;
  }
  final ext = _extensionOf(asset.fileName);
  if (ext == 'txt') {
    return _AssetPreviewKind.text;
  }
  if (ext == 'pdf' || _isPdfMime(asset.mimeType)) {
    return _AssetPreviewKind.pdf;
  }
  if (ext == 'csv') {
    return _AssetPreviewKind.csv;
  }
  if (ext == 'json') {
    return _AssetPreviewKind.json;
  }
  if (ext == 'xlsx' || ext == 'xls') {
    return _AssetPreviewKind.unsupported;
  }
  switch (asset.kindCode) {
    case 'video':
      return _AssetPreviewKind.video;
    case 'audio':
      return _AssetPreviewKind.audio;
    case 'image':
      return _AssetPreviewKind.image;
    case 'document':
      return _AssetPreviewKind.unsupported;
    case 'timeseries':
    case 'pose':
      return _AssetPreviewKind.unsupported;
    case 'pointCloud':
      return _AssetPreviewKind.unsupported;
    case 'subtitle':
      return _AssetPreviewKind.json;
    default:
      if (_videoExtensions.contains(ext)) {
        return _AssetPreviewKind.video;
      }
      if (_audioExtensions.contains(ext)) {
        return _AssetPreviewKind.audio;
      }
      if (_imageExtensions.contains(ext)) {
        return _AssetPreviewKind.image;
      }
      return _AssetPreviewKind.unsupported;
  }
}

bool _isPdfMime(String mimeType) {
  if (mimeType.isEmpty) {
    return false;
  }
  final base = mimeType.split(';').first.trim().toLowerCase();
  return base == 'application/pdf';
}

String _unsupportedMessage(AssetLookupRow asset) {
  final ext = _extensionOf(asset.fileName);
  if (asset.kindCode == 'pointCloud') {
    return '깊이 — 브라우저 재생 불가';
  }
  if (ext == 'xlsx' || ext == 'xls') {
    return '엑셀 미리보기는 아직 없습니다. 파일을 내려받아 여세요.';
  }
  if (asset.kindCode == 'timeseries' || asset.kindCode == 'pose') {
    return 'CSV가 아니면 표 미리보기를 지원하지 않습니다.';
  }
  if (asset.kindCode == 'document') {
    return '브라우저 미리 보기 없음';
  }
  return '이 형식은 미리보기를 지원하지 않습니다';
}

bool _canOpenUnsupported(AssetLookupRow asset) {
  return asset.kindCode == 'document' && asset.contentUrl.isNotEmpty;
}

String _extensionOf(String fileName) {
  final index = fileName.lastIndexOf('.');
  if (index < 0 || index == fileName.length - 1) {
    return '';
  }
  return fileName.substring(index + 1).toLowerCase();
}

const _videoExtensions = {'mp4', 'webm', 'mkv', 'mov', 'm4v'};
const _audioExtensions = {'wav', 'mp3', 'm4a', 'aac', 'ogg'};
const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'};

class _PreviewMessage extends StatelessWidget {
  const _PreviewMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppTheme.STATUS_OFF, fontSize: 13),
        ),
      ),
    );
  }
}

class _UnsupportedPreview extends StatelessWidget {
  const _UnsupportedPreview({required this.asset});

  final AssetLookupRow asset;

  @override
  Widget build(BuildContext context) {
    final canOpen = _canOpenUnsupported(asset);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _unsupportedMessage(asset),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.STATUS_OFF, fontSize: 13),
            ),
            if (canOpen) ...[
              const SizedBox(height: 12),
              Button(
                onPressed: () => openBrowserUrl(asset.contentUrl),
                child: const Text('내려받아 열기'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return WorkDetailMaterialScope(
      child: PhotoView(
        backgroundDecoration: const BoxDecoration(
          color: AppTheme.SURFACE_RAISED,
        ),
        imageProvider: CachedNetworkImageProvider(url),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.5,
        errorBuilder: (context, error, stackTrace) {
          return const _PreviewMessage('이미지를 불러오지 못했습니다');
        },
        loadingBuilder: (context, event) {
          return const Center(child: ProgressRing());
        },
      ),
    );
  }
}

class _TextPreview extends StatefulWidget {
  const _TextPreview({required this.url, required this.readContent});

  final String url;
  final AssetContentReader readContent;

  @override
  State<_TextPreview> createState() => _TextPreviewState();
}

class _TextPreviewState extends State<_TextPreview> {
  static const int MAX_CHARS = 50000;

  bool _isLoading = true;
  String _error = '';
  String _text = '';
  bool _isTruncated = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _TextPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _text = '';
      _isTruncated = false;
    });
    try {
      final body = await widget.readContent(url: widget.url);
      if (!mounted) {
        return;
      }
      final truncated = body.length > MAX_CHARS;
      setState(() {
        _isLoading = false;
        _isTruncated = truncated;
        _text = truncated ? body.substring(0, MAX_CHARS) : body;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: ProgressRing());
    }
    if (_error.isNotEmpty) {
      return _PreviewMessage(_error);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isTruncated)
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text(
              '앞부분만 표시합니다',
              style: TextStyle(fontSize: 12, color: AppTheme.STATUS_OFF),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              _text.isEmpty ? '—' : _text,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
        ),
      ],
    );
  }
}

class _JsonPreview extends StatefulWidget {
  const _JsonPreview({required this.url, required this.readContent});

  final String url;
  final AssetContentReader readContent;

  @override
  State<_JsonPreview> createState() => _JsonPreviewState();
}

class _JsonPreviewState extends State<_JsonPreview> {
  static const int MAX_CHARS = 50000;

  bool _isLoading = true;
  String _error = '';
  String _text = '';
  bool _isTruncated = false;
  bool _isRawFallback = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _JsonPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _text = '';
      _isTruncated = false;
      _isRawFallback = false;
    });
    try {
      final body = await widget.readContent(url: widget.url);
      if (!mounted) {
        return;
      }
      var truncated = false;
      var rawFallback = false;
      var display = body;
      try {
        final decoded = jsonDecode(body);
        display = const JsonEncoder.withIndent('  ').convert(decoded);
      } on FormatException {
        rawFallback = true;
      }
      if (display.length > MAX_CHARS) {
        display = display.substring(0, MAX_CHARS);
        truncated = true;
      }
      setState(() {
        _isLoading = false;
        _isTruncated = truncated;
        _isRawFallback = rawFallback;
        _text = display;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: ProgressRing());
    }
    if (_error.isNotEmpty) {
      return _PreviewMessage(_error);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isTruncated || _isRawFallback)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text(
              [
                if (_isTruncated) '앞부분만 표시합니다',
                if (_isRawFallback) 'JSON 형식이 아니라 원문으로 표시합니다',
              ].join(' · '),
              style: const TextStyle(fontSize: 12, color: AppTheme.STATUS_OFF),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              _text.isEmpty ? '—' : _text,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
        ),
      ],
    );
  }
}

class _CsvPreview extends StatefulWidget {
  const _CsvPreview({required this.url, required this.readContent});

  final String url;
  final AssetContentReader readContent;

  @override
  State<_CsvPreview> createState() => _CsvPreviewState();
}

class _CsvPreviewState extends State<_CsvPreview> {
  static const int MAX_ROWS = 200;
  static const int MAX_COLUMNS = 30;
  static const int MAX_CHARS = 200000;

  bool _isLoading = true;
  String _error = '';
  List<List<String>> _rows = const [];
  bool _isTruncated = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _CsvPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _rows = const [];
      _isTruncated = false;
    });
    try {
      var body = await widget.readContent(url: widget.url);
      if (!mounted) {
        return;
      }
      var truncated = false;
      if (body.length > MAX_CHARS) {
        body = body.substring(0, MAX_CHARS);
        truncated = true;
      }
      final parsed = _parseCsv(body);
      if (parsed.length > MAX_ROWS ||
          parsed.any((row) => row.length > MAX_COLUMNS)) {
        truncated = true;
      }
      setState(() {
        _isLoading = false;
        _isTruncated = truncated;
        _rows = [
          for (final row in parsed.take(MAX_ROWS))
            [
              for (final cell in row.take(MAX_COLUMNS)) cell,
            ],
        ];
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: ProgressRing());
    }
    if (_error.isNotEmpty) {
      return _PreviewMessage(_error);
    }
    if (_rows.isEmpty) {
      return const _PreviewMessage('표시할 CSV 행이 없습니다');
    }
    final columnCount = _rows
        .map((row) => row.length)
        .fold<int>(0, (max, length) => length > max ? length : max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isTruncated)
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text(
              '일부만 표시합니다',
              style: TextStyle(fontSize: 12, color: AppTheme.STATUS_OFF),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                border: TableBorder.all(color: const Color(0xFF3E424A)),
                children: [
                  for (var rowIndex = 0; rowIndex < _rows.length; rowIndex++)
                    TableRow(
                      decoration: BoxDecoration(
                        color: rowIndex == 0
                            ? const Color(0xFF32363C)
                            : AppTheme.tableRowColor(index: rowIndex - 1),
                      ),
                      children: [
                        for (var column = 0; column < columnCount; column++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              column < _rows[rowIndex].length
                                  ? _rows[rowIndex][column]
                                  : '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: rowIndex == 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

List<List<String>> _parseCsv(String body) {
  final rows = <List<String>>[];
  final cells = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  for (var index = 0; index < body.length; index++) {
    final char = body[index];
    if (inQuotes) {
      if (char == '"') {
        final hasNext = index + 1 < body.length && body[index + 1] == '"';
        if (hasNext) {
          buffer.write('"');
          index++;
        } else {
          inQuotes = false;
        }
      } else {
        buffer.write(char);
      }
      continue;
    }
    if (char == '"') {
      inQuotes = true;
      continue;
    }
    if (char == ',') {
      cells.add(buffer.toString());
      buffer.clear();
      continue;
    }
    if (char == '\n') {
      cells.add(buffer.toString());
      buffer.clear();
      rows.add(List<String>.from(cells));
      cells.clear();
      continue;
    }
    if (char == '\r') {
      continue;
    }
    buffer.write(char);
  }
  if (buffer.isNotEmpty || cells.isNotEmpty) {
    cells.add(buffer.toString());
    rows.add(List<String>.from(cells));
  }
  return rows;
}
