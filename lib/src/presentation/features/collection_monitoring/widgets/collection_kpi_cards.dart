import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/collection_board.dart';
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            title: '연결 상태',
            value: kpi.equipmentCount == 0
                ? '—'
                : '${DashboardFormatters.count(kpi.connectedCount)} / ${DashboardFormatters.count(kpi.equipmentCount)}',
            subtitle:
                '단절 ${DashboardFormatters.count(kpi.disconnectedCount)} · 오류 ${DashboardFormatters.count(kpi.errorCount)}',
            isSelected:
                viewModel.query.selectedKpiCard == KpiCardKind.connection,
            accent: kpi.disconnectedCount + kpi.errorCount > 0
                ? AppTheme.STATUS_ERROR
                : AppTheme.STATUS_OK,
            onPressed: () => viewModel.didTapKpiCard(KpiCardKind.connection),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _KpiCard(
            title: '수신 건수',
            value: kpi.equipmentCount == 0
                ? '—'
                : DashboardFormatters.count(kpi.receivedCount),
            subtitle: kpi.windowLabel.isEmpty ? '—' : kpi.windowLabel,
            isSelected:
                viewModel.query.selectedKpiCard == KpiCardKind.reception,
            accent: AppTheme.ACCENT_STEEL,
            onPressed: () => viewModel.didTapKpiCard(KpiCardKind.reception),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _KpiCard(
            title: '유실률',
            value: DashboardFormatters.percent(kpi.lossRateAverage),
            subtitle:
                '이상(≥10%) ${DashboardFormatters.count(kpi.lossWarningCount)}건',
            isSelected: viewModel.query.selectedKpiCard == KpiCardKind.loss,
            accent: kpi.lossRateAverage != null && kpi.lossRateAverage! >= 10
                ? AppTheme.STATUS_WARN
                : AppTheme.STATUS_OK,
            onPressed: () => viewModel.didTapKpiCard(KpiCardKind.loss),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _KpiCard(
            title: '시각 동기',
            value: kpi.equipmentCount == 0
                ? '—'
                : '${DashboardFormatters.count(kpi.syncedCount)} / ${DashboardFormatters.count(kpi.equipmentCount)}',
            subtitle:
                '지연 ${DashboardFormatters.count(kpi.delayedCount)} · 미동기 ${DashboardFormatters.count(kpi.unsyncedCount)}',
            isSelected: viewModel.query.selectedKpiCard == KpiCardKind.sync,
            accent: AppTheme.STATUS_DESYNC,
            onPressed: () => viewModel.didTapKpiCard(KpiCardKind.sync),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.isSelected,
    required this.accent,
    required this.onPressed,
  });

  final String title;
  final String value;
  final String subtitle;
  final bool isSelected;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.SURFACE_RAISED,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? AppTheme.CTA : accent.withValues(alpha: 0.45),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }
}
