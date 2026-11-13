import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/quality_job_media.dart';
import '../../../../domain/entities/quality_media.dart';
import '../../../../domain/entities/quality_media_tab.dart';
import '../../../../domain/entities/quality_result_group.dart';
import '../../../../domain/entities/quality_result_report.dart';
import 'quality_media_strip.dart';
import 'quality_paper_meta.dart';

class QualityMediaHost extends StatelessWidget {
  const QualityMediaHost({
    super.key,
    required this.group,
    this.reportPdfs = const [],
    this.selectedReportSetId,
    this.reportPdfPage = 1,
    this.jobMedia = const [],
    this.selectedJobMediaId = '',
    this.focusedMediaId = '',
    this.onSelectFocusedMedia,
    this.hasMoreJobMedia = false,
    this.isLoadingMoreJobMedia = false,
    this.onLoadMoreJobMedia,
    this.seekToken = 0,
    this.videoSeekMs,
    this.videoSeekAssetId = '',
    this.videoSeekNotice = '',
  });

  final QualityResultGroup? group;
  final List<QualityScanPdf> reportPdfs;
  final String? selectedReportSetId;
  final int reportPdfPage;
  final List<QualityJobMedia> jobMedia;
  final String selectedJobMediaId;
  final String focusedMediaId;
  final ValueChanged<String>? onSelectFocusedMedia;
  final bool hasMoreJobMedia;
  final bool isLoadingMoreJobMedia;
  final VoidCallback? onLoadMoreJobMedia;
  final int seekToken;
  final int? videoSeekMs;
  final String videoSeekAssetId;
  final String videoSeekNotice;

  @override
  Widget build(BuildContext context) {
    final data = group;
    final entries = _mediaEntries();
    if (entries.isEmpty && !hasMoreJobMedia) {
      if (data == null) {
        return const InfoBar(
          title: Text('이 패스에 페이퍼 품질 결과가 없습니다'),
          severity: InfoBarSeverity.warning,
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QualityMediaStrip(
            entries: const [],
            selectedId: '',
            onSelect: (_) {},
            hasMoreJobMedia: false,
            isLoadingMoreJobMedia: false,
            onLoadMoreJobMedia: null,
            seekToken: seekToken,
            videoSeekMs: videoSeekMs,
            videoSeekAssetId: videoSeekAssetId,
            videoSeekNotice: videoSeekNotice,
          ),
          const SizedBox(height: 12),
          QualityPaperMeta(group: data),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QualityMediaStrip(
          entries: entries,
          selectedId: _selectedEntryId(entries),
          onSelect: (id) => onSelectFocusedMedia?.call(id),
          hasMoreJobMedia: hasMoreJobMedia,
          isLoadingMoreJobMedia: isLoadingMoreJobMedia,
          onLoadMoreJobMedia: onLoadMoreJobMedia,
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

  List<QualityMediaEntry> _mediaEntries() {
    final data = group;
    return [
      for (final pdf in reportPdfs)
        QualityMediaEntry(
          id: 'report:${pdf.reportSetId}',
          label: pdf.fileName.trim().isEmpty ? '성적서' : pdf.fileName.trim(),
          url: pdf.url,
          isVideo: false,
          initialPage: pdf.reportSetId == selectedReportSetId
              ? reportPdfPage
              : 1,
        ),
      for (final item in jobMedia)
        QualityMediaEntry(
          id: 'asset:${item.assetId}',
          label: item.label,
          url: item.url,
          isVideo: item.isVideo,
        ),
      if (reportPdfs.isEmpty && jobMedia.isEmpty && data != null)
        for (var i = 0; i < data.media.length; i++)
          QualityMediaEntry(
            id: 'group:$i',
            label: _groupMediaLabel(data.media[i]),
            url: data.media[i].url,
            isVideo: data.media[i].type == QualityMediaTab.video,
            pageCount: data.media[i].pageCount,
          ),
    ];
  }

  String _groupMediaLabel(QualityMedia media) {
    final name = media.displayName;
    if (name.isNotEmpty) {
      return name;
    }
    return media.type == QualityMediaTab.video ? '현장 영상' : '페이퍼 원본';
  }

  String _selectedEntryId(List<QualityMediaEntry> entries) {
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
}
