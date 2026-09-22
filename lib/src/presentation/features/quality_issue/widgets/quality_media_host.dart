import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/quality_media_tab.dart';
import '../../../../domain/entities/quality_media.dart';
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
    required this.selectedMediaIndex,
    required this.onSelectTab,
    required this.onSelectMediaIndex,
  });

  final QualityResultGroup? group;
  final QualityMediaTab selectedTab;
  final int selectedMediaIndex;
  final ValueChanged<QualityMediaTab> onSelectTab;
  final ValueChanged<int> onSelectMediaIndex;

  @override
  Widget build(BuildContext context) {
    final data = group;
    if (data == null) {
      return const InfoBar(
        title: Text('이 패스에 페이퍼 품질 결과가 없습니다'),
        severity: InfoBarSeverity.warning,
      );
    }
    final availableTabs = QualityMediaTab.values
        .where(
          (tab) => data.media.any((item) => item.type == tab),
        )
        .toList();
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
    final files = data.media.where((item) => item.type == tab).toList();
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
        if (tab == QualityMediaTab.pdf) ...[
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
          ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tab in tabs)
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
