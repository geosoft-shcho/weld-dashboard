import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_summary.dart';
import '../../../../domain/entities/kpi_card_kind.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart';
import '../collection_monitoring_view_model.dart';

class CollectionKpiCards extends StatelessWidget {
  const CollectionKpiCards({
    super.key,
    required this.viewModel,
    required this.kpi,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionKpi kpi;

  static const double _gap = 8;
  static const double _cardHeight = 168;

  @override
  Widget build(BuildContext context) {
    final summary = kpi.summary;
    final cards = <Widget>[
      _KpiCard(
        title: '파일',
        primaryLabel: '개수',
        primaryValue: DashboardFormatters.count(summary.assetCount),
        secondaryLabel: const Text('용량', style: _secondaryLabelStyle),
        secondary: Text(
          DashboardFormatters.byteSize(summary.totalSizeBytes),
          style: _secondaryValueStyle,
        ),
        isSelected: viewModel.query.selectedKpiCard == KpiCardKind.files,
        accent: AppTheme.ACCENT_STEEL,
        onPressed: () => viewModel.didTapKpiCard(KpiCardKind.files),
      ),
      _KpiCard(
        title: '작업',
        primaryLabel: '개수',
        primaryValue: DashboardFormatters.count(summary.jobCount),
        secondaryLabel: const Text('작업시간', style: _secondaryLabelStyle),
        secondary: Text(
          '${DashboardFormatters.durationParts(summary.workDurationSeconds)} · 자료 없는 작업 ${DashboardFormatters.count(summary.jobWithoutAssetCount)}건',
          style: _secondaryValueStyle,
        ),
        isSelected: viewModel.query.selectedKpiCard == KpiCardKind.jobs,
        accent: AppTheme.STATUS_OK,
        onPressed: () => viewModel.didTapKpiCard(KpiCardKind.jobs),
      ),
      _KpiCard(
        title: '용접',
        primaryLabel: '시간',
        primaryValue: DashboardFormatters.durationParts(
          summary.weldDurationSeconds,
        ),
        secondaryLabel: const _CoverageLossLegend(),
        secondary: _CoverageLossRichText(summary: summary),
        isSelected: viewModel.query.selectedKpiCard == KpiCardKind.weld,
        accent: AppTheme.STATUS_WARN,
        onPressed: () => viewModel.didTapKpiCard(KpiCardKind.weld),
      ),
      _KpiCard(
        title: '적재',
        primaryLabel: '진행',
        primaryValue: DashboardFormatters.count(kpi.runningTraceCount),
        secondaryLabel: const Text('실패', style: _secondaryLabelStyle),
        secondary: Text(
          DashboardFormatters.count(kpi.failedTraceCount),
          style: _secondaryValueStyle,
        ),
        isSelected: viewModel.query.selectedKpiCard == KpiCardKind.traces,
        accent: kpi.failedTraceCount > 0
            ? AppTheme.STATUS_ERROR
            : AppTheme.STATUS_OK,
        onPressed: () => viewModel.didTapKpiCard(KpiCardKind.traces),
      ),
      _EmbeddingKpiCard(
        sections: [
          (
            label: '기록 (클립)',
            ratio: _ratioLabel(summary.embeddedClipCount, summary.clipCount),
            detail: _ratioSubtitle(
              summary.embeddedClipCount,
              summary.clipCount,
              unit: '구간',
            ),
          ),
          (
            label: '파일·작업 (메타)',
            ratio: _ratioLabel(
              summary.embeddedAttachedAssetCount,
              summary.attachedAssetCount,
            ),
            detail: _ratioSubtitle(
              summary.embeddedAttachedAssetCount,
              summary.attachedAssetCount,
              unit: '연결',
            ),
          ),
          (
            label: '코멘트',
            ratio: _ratioLabel(
              summary.embeddedCommentCount,
              summary.commentCount,
            ),
            detail: _ratioSubtitle(
              summary.embeddedCommentCount,
              summary.commentCount,
              unit: '건',
            ),
          ),
        ],
        isSelected: viewModel.query.selectedKpiCard == KpiCardKind.embedding,
        onPressed: () => viewModel.didTapKpiCard(KpiCardKind.embedding),
      ),
    ];

    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    // 카드 개수로 가로를 균등 분할 — 끝 여백·320 clamp 없음.
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = cards.length;
        final minWidthForOneRow = 128.0 * count + _gap * (count - 1);
        if (constraints.maxWidth >= minWidthForOneRow || count <= 1) {
          return SizedBox(
            height: _cardHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < count; i++) ...[
                  if (i > 0) const SizedBox(width: _gap),
                  Expanded(child: cards[i]),
                ],
              ],
            ),
          );
        }
        final columns = (count / 2).ceil().clamp(1, count);
        final cardWidth =
            (constraints.maxWidth - _gap * (columns - 1)) / columns;
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (final card in cards)
              SizedBox(width: cardWidth, height: _cardHeight, child: card),
          ],
        );
      },
    );
  }

  String _ratioLabel(int numerator, int denominator) {
    if (denominator <= 0) {
      return '—';
    }
    final percent = numerator * 100 / denominator;
    return '${percent.toStringAsFixed(1)}%';
  }

  String _ratioSubtitle(
    int numerator,
    int denominator, {
    required String unit,
  }) {
    return '${DashboardFormatters.count(numerator)} / ${DashboardFormatters.count(denominator)} $unit';
  }
}

const TextStyle _secondaryLabelStyle = TextStyle(fontSize: 11);

const TextStyle _secondaryValueStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
);

String _kindLabel(CollectionAssetKind kind) {
  return switch (kind) {
    CollectionAssetKind.video => '영상',
    CollectionAssetKind.audio => '음성',
    CollectionAssetKind.timeseries => '센서',
    CollectionAssetKind.pose => '포즈',
    CollectionAssetKind.pointcloud => '깊이',
    CollectionAssetKind.image => '이미지',
    CollectionAssetKind.document => '문서',
    CollectionAssetKind.subtitle => '자막',
    CollectionAssetKind.ocrJson => 'OCR',
    CollectionAssetKind.region => '영역',
    CollectionAssetKind.unspecified => '기타',
  };
}

/// 커버리지(초록) · 손실률(빨강) 점 아이콘 + 레이블.
class _CoverageLossLegend extends StatelessWidget {
  const _CoverageLossLegend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _LegendSwatch(color: AppTheme.STATUS_OK, label: '커버리지'),
        Text(' / ', style: _secondaryLabelStyle),
        _LegendSwatch(color: AppTheme.STATUS_ERROR, label: '손실률'),
      ],
    );
  }
}

class _LegendSwatch extends StatelessWidget {
  const _LegendSwatch({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: _secondaryLabelStyle),
        const SizedBox(width: 4),
        Icon(FluentIcons.circle_fill, size: 8, color: color),
      ],
    );
  }
}

/// 한 줄 나열. 커버리지=초록, 손실률=빨강으로 구분.
class _CoverageLossRichText extends StatelessWidget {
  const _CoverageLossRichText({required this.summary});

  final CollectionSummary summary;

  @override
  Widget build(BuildContext context) {
    final weld = summary.weldDurationSeconds;
    if (summary.coverage.isEmpty || weld <= 0) {
      return const Text('—', style: _secondaryValueStyle);
    }
    final spans = <InlineSpan>[];
    for (var i = 0; i < summary.coverage.length; i++) {
      if (i > 0) {
        spans.add(
          const TextSpan(
            text: ' · ',
            style: TextStyle(color: AppTheme.STATUS_OFF),
          ),
        );
      }
      final item = summary.coverage[i];
      final coverageRatio = item.coveredSeconds / weld;
      final coveragePercent = (coverageRatio * 100).clamp(0.0, 100.0);
      // 손실률 UI 임시 비활성
      // final lossPercent = ((1 - coverageRatio) * 100).clamp(0.0, 100.0);
      spans.addAll([
        TextSpan(
          text: '${_kindLabel(item.kind)} ',
          style: const TextStyle(color: AppTheme.INK),
        ),
        TextSpan(
          text: '${coveragePercent.toStringAsFixed(1)}%',
          style: const TextStyle(
            color: AppTheme.STATUS_OK,
            fontWeight: FontWeight.w600,
          ),
        ),
        // const TextSpan(
        //   text: ' / ',
        //   style: TextStyle(color: AppTheme.STATUS_OFF),
        // ),
        // TextSpan(
        //   text: '${lossPercent.toStringAsFixed(1)}%',
        //   style: const TextStyle(
        //     color: AppTheme.STATUS_ERROR,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
      ]);
    }
    return Text.rich(TextSpan(style: _secondaryValueStyle, children: spans));
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.primaryLabel,
    required this.primaryValue,
    required this.secondaryLabel,
    required this.secondary,
    required this.isSelected,
    required this.accent,
    required this.onPressed,
  });

  final String title;
  final String primaryLabel;
  final String primaryValue;
  final Widget secondaryLabel;
  final Widget secondary;
  final bool isSelected;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final muted = _kpiMutedColor(context);

    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        return _KpiCardShell(
          isSelected: isSelected,
          accent: accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: muted,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                primaryLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: muted),
              ),
              const SizedBox(height: 2),
              Text(
                primaryValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
              const SizedBox(height: 8),
              DefaultTextStyle.merge(
                style: TextStyle(fontSize: 11, color: muted),
                child: secondaryLabel,
              ),
              const SizedBox(height: 2),
              Expanded(
                child: Align(alignment: Alignment.topLeft, child: secondary),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 검색 준비(기록·파일·작업·코멘트) 진행률을 한 카드에 구역으로 표시.
class _EmbeddingKpiCard extends StatelessWidget {
  const _EmbeddingKpiCard({
    required this.sections,
    required this.isSelected,
    required this.onPressed,
  });

  final List<({String label, String ratio, String detail})> sections;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final muted = _kpiMutedColor(context);
    final accent = AppTheme.ACCENT_STEEL;

    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        return _KpiCardShell(
          isSelected: isSelected,
          accent: accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '검색 준비',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: muted,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < 3; i++) ...[
                      if (i > 0)
                        Container(
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: accent.withValues(alpha: 0.28),
                        ),
                      // 기록(클립)만 1.5배 — flex 3 : 2 : 2
                      Expanded(
                        flex: i == 0 ? 3 : 2,
                        child: i < sections.length
                            ? _EmbeddingSection(
                                label: sections[i].label,
                                ratio: sections[i].ratio,
                                detail: sections[i].detail,
                                muted: muted,
                                accent: accent,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmbeddingSection extends StatelessWidget {
  const _EmbeddingSection({
    required this.label,
    required this.ratio,
    required this.detail,
    required this.muted,
    required this.accent,
  });

  final String label;
  final String ratio;
  final String detail;
  final Color muted;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: TextStyle(fontSize: 11, color: muted),
        ),
        const SizedBox(height: 2),
        Text(
          ratio,
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: accent,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              detail,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

class _KpiCardShell extends StatelessWidget {
  const _KpiCardShell({
    required this.isSelected,
    required this.accent,
    required this.child,
  });

  final bool isSelected;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? AppTheme.CTA : accent.withValues(alpha: 0.45),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: child,
    );
  }
}

Color _kpiMutedColor(BuildContext context) {
  return DefaultTextStyle.of(context).style.color?.withValues(alpha: 0.72) ??
      AppTheme.STATUS_OFF;
}
