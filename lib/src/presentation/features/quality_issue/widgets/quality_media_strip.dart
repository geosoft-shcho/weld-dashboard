import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/themes/app_theme.dart';
import 'paper_scan_host.dart';
import 'quality_video_host.dart';

class QualityMediaEntry {
  const QualityMediaEntry({
    required this.id,
    required this.label,
    required this.url,
    required this.isVideo,
    this.initialPage = 1,
    this.pageCount = 0,
  });

  final String id;
  final String label;
  final String url;
  final bool isVideo;
  final int initialPage;
  final int pageCount;
}

class _MediaFlyoutSnapshot {
  const _MediaFlyoutSnapshot({
    required this.entries,
    required this.selectedId,
    required this.hasMoreJobMedia,
    required this.isLoadingMoreJobMedia,
  });

  final List<QualityMediaEntry> entries;
  final String selectedId;
  final bool hasMoreJobMedia;
  final bool isLoadingMoreJobMedia;

  bool matches(_MediaFlyoutSnapshot other) {
    if (selectedId != other.selectedId ||
        hasMoreJobMedia != other.hasMoreJobMedia ||
        isLoadingMoreJobMedia != other.isLoadingMoreJobMedia ||
        entries.length != other.entries.length) {
      return false;
    }
    for (var i = 0; i < entries.length; i++) {
      final a = entries[i];
      final b = other.entries[i];
      if (a.id != b.id ||
          a.label != b.label ||
          a.url != b.url ||
          a.isVideo != b.isVideo ||
          a.initialPage != b.initialPage ||
          a.pageCount != b.pageCount) {
        return false;
      }
    }
    return true;
  }
}

class QualityMediaStrip extends StatefulWidget {
  const QualityMediaStrip({
    super.key,
    required this.entries,
    required this.selectedId,
    required this.onSelect,
    required this.hasMoreJobMedia,
    required this.isLoadingMoreJobMedia,
    required this.onLoadMoreJobMedia,
    required this.seekToken,
    required this.videoSeekMs,
    required this.videoSeekAssetId,
    required this.videoSeekNotice,
  });

  final List<QualityMediaEntry> entries;
  final String selectedId;
  final ValueChanged<String> onSelect;
  final bool hasMoreJobMedia;
  final bool isLoadingMoreJobMedia;
  final VoidCallback? onLoadMoreJobMedia;
  final int seekToken;
  final int? videoSeekMs;
  final String videoSeekAssetId;
  final String videoSeekNotice;

  @override
  State<QualityMediaStrip> createState() => _QualityMediaStripState();
}

class _QualityMediaStripState extends State<QualityMediaStrip> {
  final FlyoutController _flyoutController = FlyoutController();
  late final ValueNotifier<_MediaFlyoutSnapshot> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = ValueNotifier(_currentSnapshot());
  }

  @override
  void didUpdateWidget(covariant QualityMediaStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _currentSnapshot();
    if (_snapshot.value.matches(next)) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_snapshot.value.matches(next)) {
        return;
      }
      _snapshot.value = next;
    });
  }

  @override
  void dispose() {
    _snapshot.dispose();
    _flyoutController.dispose();
    super.dispose();
  }

  _MediaFlyoutSnapshot _currentSnapshot() {
    return _MediaFlyoutSnapshot(
      entries: widget.entries,
      selectedId: widget.selectedId,
      hasMoreJobMedia: widget.hasMoreJobMedia,
      isLoadingMoreJobMedia: widget.isLoadingMoreJobMedia,
    );
  }

  QualityMediaEntry? _resolveSelected(
    List<QualityMediaEntry> entries,
    String selectedId,
  ) {
    for (final entry in entries) {
      if (entry.id == selectedId) {
        return entry;
      }
    }
    return entries.isEmpty ? null : entries.first;
  }

  String _entryLabel(QualityMediaEntry entry) {
    return entry.isVideo ? '영상 · ${entry.label}' : '페이퍼 · ${entry.label}';
  }

  void _openFlyout() {
    _flyoutController.showFlyout(
      builder: (flyoutContext) {
        return FlyoutContent(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360, maxHeight: 320),
            child: ValueListenableBuilder<_MediaFlyoutSnapshot>(
              valueListenable: _snapshot,
              builder: (context, snapshot, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: snapshot.entries.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                '이 패스에 페이퍼·영상 없음',
                                style: TextStyle(color: AppTheme.STATUS_OFF),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.entries.length,
                              itemBuilder: (context, index) {
                                final entry = snapshot.entries[index];
                                final selected =
                                    entry.id == snapshot.selectedId;
                                return Button(
                                  onPressed: () {
                                    widget.onSelect(entry.id);
                                    Flyout.of(context).close();
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _entryLabel(entry),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: selected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (selected)
                                        const Icon(
                                          FluentIcons.check_mark,
                                          size: 12,
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    if (snapshot.hasMoreJobMedia) ...[
                      const SizedBox(height: 8),
                      Button(
                        onPressed: snapshot.isLoadingMoreJobMedia
                            ? null
                            : widget.onLoadMoreJobMedia,
                        child: snapshot.isLoadingMoreJobMedia
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: ProgressRing(strokeWidth: 2),
                                  ),
                                  SizedBox(width: 8),
                                  Text('불러오는 중…'),
                                ],
                              )
                            : const Text('더보기'),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _resolveSelected(widget.entries, widget.selectedId);
    final showPicker = widget.entries.isNotEmpty || widget.hasMoreJobMedia;
    final summary = selected == null
        ? (widget.hasMoreJobMedia ? '페이퍼·영상 선택' : '페이퍼·영상 없음')
        : _entryLabel(selected);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              '페이퍼·영상',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.STATUS_OFF,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: showPicker
                  ? FlyoutTarget(
                      controller: _flyoutController,
                      child: Button(
                        onPressed: _openFlyout,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                summary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(FluentIcons.chevron_down, size: 10),
                          ],
                        ),
                      ),
                    )
                  : const Text(
                      '페이퍼·영상 없음',
                      style: TextStyle(color: AppTheme.STATUS_OFF),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.videoSeekNotice.isNotEmpty) ...[
          InfoBar(
            title: Text(widget.videoSeekNotice),
            severity: InfoBarSeverity.info,
          ),
          const SizedBox(height: 12),
        ],
        if (selected == null)
          const SizedBox.shrink()
        else if (selected.url.isEmpty)
          const InfoBar(
            title: Text('파일을 아직 열 수 없습니다'),
            severity: InfoBarSeverity.info,
          )
        else if (selected.isVideo)
          QualityVideoHost(
            key: ValueKey(selected.id),
            videoFile: selected.url,
            seekToMs: selected.id == 'asset:${widget.videoSeekAssetId}'
                ? widget.videoSeekMs
                : null,
            seekToken: selected.id == 'asset:${widget.videoSeekAssetId}'
                ? widget.seekToken
                : 0,
          )
        else
          PaperScanHost(
            key: ValueKey(selected.id),
            scanFile: selected.url,
            scanPages: selected.pageCount,
            initialPage: selected.initialPage,
          ),
      ],
    );
  }
}
