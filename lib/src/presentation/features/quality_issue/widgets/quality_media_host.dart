import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/quality_media_tab.dart';
import '../../../../domain/entities/quality_result_group.dart';
import '../../../core/themes/app_theme.dart';
import 'paper_scan_host.dart';
import 'quality_paper_meta.dart';
import 'quality_video_host.dart';

class QualityMediaHost extends StatelessWidget {
  const QualityMediaHost({
    super.key,
    required this.group,
    required this.selectedTab,
    required this.onSelectTab,
  });

  final QualityResultGroup? group;
  final QualityMediaTab selectedTab;
  final ValueChanged<QualityMediaTab> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final data = group;
    if (data == null) {
      return const InfoBar(
        title: Text('이 패스에 페이퍼 품질 결과가 없습니다'),
        severity: InfoBarSeverity.warning,
      );
    }
    final hasPdf = data.doesHaveScanFile;
    final hasVideo = data.doesHaveVideoFile;
    if (!hasPdf && !hasVideo) {
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

    final showTabs = hasPdf && hasVideo;
    final tab = _effectiveTab(hasPdf: hasPdf, hasVideo: hasVideo);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTabs) ...[
          _MediaTabs(
            selectedTab: tab,
            onSelectTab: onSelectTab,
          ),
          const SizedBox(height: 12),
        ],
        if (tab == QualityMediaTab.pdf) ...[
          PaperScanHost(
            key: ValueKey('${data.qualityResultId}-pdf'),
            scanFile: data.scanFile,
            scanPages: data.scanPages,
          ),
          const SizedBox(height: 12),
          QualityPaperMeta(group: data),
        ] else
          QualityVideoHost(
            key: ValueKey('${data.qualityResultId}-video'),
            videoFile: data.videoFile,
          ),
      ],
    );
  }

  QualityMediaTab _effectiveTab({
    required bool hasPdf,
    required bool hasVideo,
  }) {
    if (hasPdf && !hasVideo) {
      return QualityMediaTab.pdf;
    }
    if (!hasPdf && hasVideo) {
      return QualityMediaTab.video;
    }
    return selectedTab;
  }
}

class _MediaTabs extends StatelessWidget {
  const _MediaTabs({
    required this.selectedTab,
    required this.onSelectTab,
  });

  final QualityMediaTab selectedTab;
  final ValueChanged<QualityMediaTab> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tab in QualityMediaTab.values)
          Button(
            onPressed: () => onSelectTab(tab),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                selectedTab == tab
                    ? AppTheme.ACCENT_STEEL.withValues(alpha: 0.45)
                    : AppTheme.SURFACE_RAISED,
              ),
            ),
            child: Text(tab.label),
          ),
      ],
    );
  }
}
