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
    final coverage = kpi.dataTypeCoverage;
    final embeddingDone = summary.embeddedClipCount +
        summary.embeddedAttachedAssetCount +
        summary.embeddedCommentCount;
    final embeddingTotal =
        summary.clipCount + summary.attachedAssetCount + summary.commentCount;
    final cards = <Widget>[
      _KpiCard(
        title: '수집량',
        primaryLabel: '파일',
        primaryValue: DashboardFormatters.count(summary.assetCount),
        secondaryLabel: const Text('용량', style: _secondaryLabelStyle),
        secondary: Text(
          DashboardFormatters.byteSize(summary.totalSizeBytes),
          style: _secondaryValueStyle,
        ),
        isSelected: viewModel.query.selectedKpiCard == KpiCardKind.collection,
        accent: AppTheme.ACCENT_STEEL,
        onPressed: () => viewModel.didTapKpiCard(KpiCardKind.collection),
      ),
      _KpiCard(
        title: '작업량',
        primaryLabel: '용접 시간',
        primaryValue: DashboardFormatters.durationParts(
          summary.weldDurationSeconds,
        ),
        secondaryLabel: const Text('작업', style: _secondaryLabelStyle),
        secondary: Text(
          '${DashboardFormatters.count(summary.jobCount)}건 · 작업시간 ${DashboardFormatters.durationParts(summary.workDurationSeconds)} · 자료 없음 ${DashboardFormatters.count(summary.jobWithoutAssetCount)}건',
          style: _secondaryValueStyle,
        ),
        isSelected: viewModel.query.selectedKpiCard == KpiCardKind.work,
        accent: AppTheme.STATUS_OK,
        onPressed: () => viewModel.didTapKpiCard(KpiCardKind.work),
      ),
      _KpiCard(
        title: '커버리지',
        primaryLabel: '종합',
        primaryValue: _coverageOverallLabel(coverage),
        secondaryLabel: const Text('유형별 손실', style: _secondaryLabelStyle),
        secondary: _DataTypeCoverageLossText(coverage: coverage),
        isSelected: viewModel.query.selectedKpiCard == KpiCardKind.coverage,
        accent: AppTheme.STATUS_WARN,
        onPressed: () => viewModel.didTapKpiCard(KpiCardKind.coverage),
      ),
      _EmbeddingKpiCard(
        primaryRatio: _ratioLabel(embeddingDone, embeddingTotal),
        sections: [
          (
            label: '클립',
            ratio: _ratioLabel(summary.embeddedClipCount, summary.clipCount),
            detail: _ratioSubtitle(
              summary.embeddedClipCount,
              summary.clipCount,
              unit: '구간',
            ),
          ),
          (
            label: '파일',
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

  /// 한 줄이 길어지지 않게 건수와 단위를 나눈다. `_EmbeddingSection` detail은 maxLines 2.
  String _ratioSubtitle(
    int numerator,
    int denominator, {
    required String unit,
  }) {
    return '${DashboardFormatters.count(numerator)} / ${DashboardFormatters.count(denominator)}\n$unit';
  }
}

const TextStyle _secondaryLabelStyle = TextStyle(fontSize: 11);

const TextStyle _secondaryValueStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
);

String _coverageOverallLabel(List<DataTypeCoverageRow> coverage) {
  if (coverage.isEmpty) {
    return '—';
  }
  var covered = 0;
  var expected = 0;
  for (final row in coverage) {
    covered += row.coveredSeconds;
    expected += row.expectedSeconds;
  }
  if (expected <= 0) {
    return '—';
  }
  final percent = (covered * 100 / expected).clamp(0.0, 100.0);
  final loss = (100.0 - percent).clamp(0.0, 100.0);
  return '${percent.toStringAsFixed(1)}% (손실 ${loss.toStringAsFixed(1)}%)';
}

class _DataTypeCoverageLossText extends StatelessWidget {
  const _DataTypeCoverageLossText({required this.coverage});

  final List<DataTypeCoverageRow> coverage;

  @override
  Widget build(BuildContext context) {
    if (coverage.isEmpty) {
      return const Text('—', style: _secondaryValueStyle);
    }
    final parts = <String>[];
    for (final item in coverage) {
      final ratio = item.coverageRatio;
      final lossLabel = ratio == null
          ? '—'
          : '${((1.0 - ratio) * 100).clamp(0.0, 100.0).toStringAsFixed(1)}%';
      parts.add('${item.dataTypeName} $lossLabel');
    }
    return Text(parts.join(' · '), style: _secondaryValueStyle);
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

/// 임베딩 종합 % + 클립·파일·코멘트 구역.
class _EmbeddingKpiCard extends StatelessWidget {
  const _EmbeddingKpiCard({
    required this.primaryRatio,
    required this.sections,
    required this.isSelected,
    required this.onPressed,
  });

  final String primaryRatio;
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
                '임베딩',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: muted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                primaryRatio,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
              const SizedBox(height: 6),
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
                      Expanded(
                        flex: 2,
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
