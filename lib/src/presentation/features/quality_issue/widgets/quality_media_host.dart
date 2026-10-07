import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/quality_job_media.dart';
import '../../../../domain/entities/quality_media_tab.dart';
import '../../../../domain/entities/quality_media.dart';
import '../../../../domain/entities/quality_result_group.dart';
import '../../../../domain/entities/quality_result_report.dart';
import '../../../core/themes/app_theme.dart';
import 'paper_scan_host.dart';
import 'quality_paper_meta.dart';
import 'quality_video_host.dart';

class QualityMediaHost extends StatelessWidget {
  const QualityMediaHost({
    super.key,
    required this.group,
    required this.selectedTab,
    required this.selectedMediaIndex,
    required this.onSelectTab,
    required this.onSelectMediaIndex,
    this.reportPdfs = const [],
    this.selectedReportSetId,
    this.reportPdfPage = 1,
    this.jobMedia = const [],
    this.selectedJobMediaId = '',
    this.focusedMediaId = '',
    this.onSelectFocusedMedia,
    this.seekToMs,
    this.seekToken = 0,
    this.videoSeekMs,
    this.videoSeekAssetId = '',
    this.videoSeekNotice = '',
  });

  final QualityResultGroup? group;
  final QualityMediaTab selectedTab;
  final int selectedMediaIndex;
  final ValueChanged<QualityMediaTab> onSelectTab;
  final ValueChanged<int> onSelectMediaIndex;
  final List<QualityScanPdf> reportPdfs;
  final String? selectedReportSetId;
  final int reportPdfPage;
  final List<QualityJobMedia> jobMedia;
  final String selectedJobMediaId;
  final String focusedMediaId;
  final ValueChanged<String>? onSelectFocusedMedia;
  final int? seekToMs;
  final int seekToken;
  final int? videoSeekMs;
  final String videoSeekAssetId;
  final String videoSeekNotice;

  @override
  Widget build(BuildContext context) {
    final data = group;
    final reportPdfs = this.reportPdfs;
    if (reportPdfs.isNotEmpty || jobMedia.isNotEmpty) {
      final entries = _mediaEntries();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MediaStrip(
            entries: entries,
            selectedId: _selectedEntryId(entries),
            onSelect: (id) => onSelectFocusedMedia?.call(id),
            seekToken: seekToken,
            videoSeekMs: videoSeekMs,
            videoSeekAssetId: videoSeekAssetId,
            videoSeekNotice: videoSeekNotice,
          ),
          if (data != null) ...[
            const SizedBox(height: 12),
            QualityPaperMeta(group: data),
          ],
        ],
      );
    }
    if (data == null) {
      return const InfoBar(
        title: Text('이 패스에 페이퍼 품질 결과가 없습니다'),
        severity: InfoBarSeverity.warning,
      );
    }
    final availableTabs = [
      if (data.media.any((item) => item.type == QualityMediaTab.pdf))
        QualityMediaTab.pdf,
      if (data.media.any((item) => item.type == QualityMediaTab.video))
        QualityMediaTab.video,
    ];
    if (availableTabs.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaperScanHost(
            key: ValueKey('${data.qualityResultId}-empty'),
            scanFile: '',
            scanPages: 0,
          ),
          const SizedBox(height: 12),
          QualityPaperMeta(group: data),
        ],
      );
    }

    final tab = availableTabs.contains(selectedTab)
        ? selectedTab
        : availableTabs.first;
    final files = tab == QualityMediaTab.pdf && reportPdfs.isNotEmpty
        ? [
            for (final pdf in reportPdfs)
              QualityMedia(
                type: QualityMediaTab.pdf,
                url: pdf.url,
                filePath: pdf.reportSetId,
                pageCount: 0,
              ),
          ]
        : data.media.where((item) => item.type == tab).toList();
    if (files.isEmpty) {
      return PaperScanHost(
        key: ValueKey('${data.qualityResultId}-empty'),
        scanFile: '',
        scanPages: 0,
      );
    }
    final activeIndex =
        selectedMediaIndex >= 0 && selectedMediaIndex < files.length
        ? selectedMediaIndex
        : 0;
    final selectedFile = files[activeIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MediaTabs(
          tabs: availableTabs,
          selectedTab: tab,
          onSelectTab: onSelectTab,
        ),
        const SizedBox(height: 12),
        if (files.length > 1) ...[
          _MediaFiles(
            files: files,
            selectedIndex: activeIndex,
            onSelectIndex: onSelectMediaIndex,
          ),
          const SizedBox(height: 12),
        ],
        if (tab == QualityMediaTab.pdf && reportPdfs.isNotEmpty) ...[
          _ReportPdfView(
            pdfs: reportPdfs,
            selectedReportSetId: selectedReportSetId,
            page: reportPdfPage,
          ),
          const SizedBox(height: 12),
          QualityPaperMeta(group: data),
        ] else if (tab == QualityMediaTab.pdf) ...[
          PaperScanHost(
            key: ValueKey('${data.qualityResultId}-pdf-$activeIndex'),
            scanFile: selectedFile.url,
            scanPages: selectedFile.pageCount,
          ),
          const SizedBox(height: 12),
          QualityPaperMeta(group: data),
        ] else
          QualityVideoHost(
            key: ValueKey('${data.qualityResultId}-video-$activeIndex'),
            videoFile: selectedFile.url,
            seekToMs: seekToMs,
            seekToken: seekToken,
          ),
      ],
    );
  }

  List<_MediaEntry> _mediaEntries() {
    return [
      for (final pdf in reportPdfs)
        _MediaEntry(
          id: 'report:${pdf.reportSetId}',
          label: _fileLabel(pdf.url, '성적서'),
          url: pdf.url,
          isVideo: false,
          initialPage: pdf.reportSetId == selectedReportSetId
              ? reportPdfPage
              : 1,
        ),
      for (final item in jobMedia)
        _MediaEntry(
          id: 'asset:${item.assetId}',
          label: item.label,
          url: item.url,
          isVideo: item.isVideo,
        ),
    ];
  }

  String _selectedEntryId(List<_MediaEntry> entries) {
    for (final entry in entries) {
      if (entry.id == focusedMediaId) {
        return entry.id;
      }
    }
    if (selectedJobMediaId.isNotEmpty) {
      final assetId = 'asset:$selectedJobMediaId';
      for (final entry in entries) {
        if (entry.id == assetId) {
          return entry.id;
        }
      }
    }
    return entries.isEmpty ? '' : entries.first.id;
  }

  static String _fileLabel(String url, String fallback) {
    final name = Uri.tryParse(url)?.pathSegments.lastOrNull ?? '';
    if (name.isEmpty) {
      return fallback;
    }
    return name;
  }
}

class _MediaEntry {
  const _MediaEntry({
    required this.id,
    required this.label,
    required this.url,
    required this.isVideo,
    this.initialPage = 1,
  });

  final String id;
  final String label;
  final String url;
  final bool isVideo;
  final int initialPage;
}

class _MediaStrip extends StatelessWidget {
  const _MediaStrip({
    required this.entries,
    required this.selectedId,
    required this.onSelect,
    required this.seekToken,
    required this.videoSeekMs,
    required this.videoSeekAssetId,
    required this.videoSeekNotice,
  });

  final List<_MediaEntry> entries;
  final String selectedId;
  final ValueChanged<String> onSelect;
  final int seekToken;
  final int? videoSeekMs;
  final String videoSeekAssetId;
  final String videoSeekNotice;

  @override
  Widget build(BuildContext context) {
    _MediaEntry? selected;
    for (final entry in entries) {
      if (entry.id == selectedId) {
        selected = entry;
        break;
      }
    }
    selected ??= entries.isEmpty ? null : entries.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.STATUS_OFF.withValues(alpha: 0.45),
              ),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12, bottom: 6),
                  child: Text(
                    '미디어',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.STATUS_OFF,
                    ),
                  ),
                ),
                for (final entry in entries)
                  _JobMediaTab(
                    label: entry.label,
                    isVideo: entry.isVideo,
                    isSelected: entry.id == selected?.id,
                    onPressed: () => onSelect(entry.id),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (videoSeekNotice.isNotEmpty) ...[
          InfoBar(title: Text(videoSeekNotice), severity: InfoBarSeverity.info),
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
            seekToMs: selected.id == 'asset:$videoSeekAssetId'
                ? videoSeekMs
                : null,
            seekToken: selected.id == 'asset:$videoSeekAssetId' ? seekToken : 0,
          )
        else
          PaperScanHost(
            key: ValueKey(selected.id),
            scanFile: selected.url,
            scanPages: 0,
            initialPage: selected.initialPage,
          ),
      ],
    );
  }
}

class _JobMediaTab extends StatelessWidget {
  const _JobMediaTab({
    required this.label,
    required this.isVideo,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isVideo;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: HoverButton(
        onPressed: onPressed,
        builder: (context, states) {
          final color = isSelected || states.isHovered
              ? AppTheme.INK
              : AppTheme.STATUS_OFF;
          return DecoratedBox(
            decoration: BoxDecoration(
              border: isSelected
                  ? const Border(
                      bottom: BorderSide(color: AppTheme.INK, width: 2),
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isVideo ? FluentIcons.video : FluentIcons.pdf,
                    size: 14,
                    color: color,
                  ),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReportPdfView extends StatelessWidget {
  const _ReportPdfView({
    required this.pdfs,
    required this.selectedReportSetId,
    required this.page,
  });

  final List<QualityScanPdf> pdfs;
  final String? selectedReportSetId;
  final int page;

  @override
  Widget build(BuildContext context) {
    final reportSetId = selectedReportSetId;
    QualityScanPdf? matched;
    if (reportSetId != null && reportSetId.isNotEmpty) {
      for (final pdf in pdfs) {
        if (pdf.reportSetId == reportSetId) {
          matched = pdf;
          break;
        }
      }
    }
    final pdf = matched ?? (pdfs.isEmpty ? null : pdfs.first);
    if (pdf == null || pdf.url.isEmpty) {
      return const InfoBar(
        title: Text('잘라 낸 PDF는 아직 없습니다'),
        severity: InfoBarSeverity.info,
      );
    }
    return PaperScanHost(
      key: ValueKey('${pdf.reportSetId}-pdf'),
      scanFile: pdf.url,
      scanPages: 0,
      initialPage: page,
    );
  }
}

class _MediaFiles extends StatelessWidget {
  const _MediaFiles({
    required this.files,
    required this.selectedIndex,
    required this.onSelectIndex,
  });

  final List<QualityMedia> files;
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < files.length; index++)
          Button(
            onPressed: () => onSelectIndex(index),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                selectedIndex == index
                    ? AppTheme.ACCENT_STEEL.withValues(alpha: 0.45)
                    : AppTheme.SURFACE_RAISED,
              ),
            ),
            child: Text(
              files[index].displayName.isEmpty
                  ? '파일 ${index + 1}'
                  : files[index].displayName,
            ),
          ),
      ],
    );
  }
}

class _MediaTabs extends StatelessWidget {
  const _MediaTabs({
    required this.tabs,
    required this.selectedTab,
    required this.onSelectTab,
  });

  final List<QualityMediaTab> tabs;
  final QualityMediaTab selectedTab;
  final ValueChanged<QualityMediaTab> onSelectTab;

  static final Color _LINE = AppTheme.STATUS_OFF.withValues(alpha: 0.45);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _LINE, width: 1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 12, bottom: 6),
              child: Text(
                '미디어',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.04 * 11,
                  color: AppTheme.STATUS_OFF,
                  height: 1.25,
                ),
              ),
            ),
            for (final tab in tabs)
              Transform.translate(
                offset: const Offset(0, 1),
                child: _MediaTab(
                  tab: tab,
                  isSelected: tab == selectedTab,
                  onPressed: () => onSelectTab(tab),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MediaTab extends StatelessWidget {
  const _MediaTab({
    required this.tab,
    required this.isSelected,
    required this.onPressed,
  });

  final QualityMediaTab tab;
  final bool isSelected;
  final VoidCallback onPressed;

  IconData get _icon {
    switch (tab) {
      case QualityMediaTab.pdf:
        return FluentIcons.pdf;
      case QualityMediaTab.video:
        return FluentIcons.video;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        final isHovered = states.isHovered;
        final color = isSelected || isHovered
            ? AppTheme.INK
            : AppTheme.STATUS_OFF;
        return DecoratedBox(
          decoration: BoxDecoration(
            border: isSelected
                ? const Border(
                    bottom: BorderSide(color: AppTheme.INK, width: 2),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_icon, size: 14, color: color),
                const SizedBox(width: 6),
                Text(
                  tab.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
