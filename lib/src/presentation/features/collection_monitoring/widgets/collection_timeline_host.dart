import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_timeline.dart';
import '../../../../domain/entities/timeline_view_kind.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart';
import '../collection_monitoring_view_model.dart';
import 'collection_day_timeline_view.dart';
import 'collection_resource_timeline_view.dart';
import 'collection_roadmap_view.dart';
import 'collection_timeline_inspector.dart';
import 'timeline_status_style.dart';

class CollectionTimelineHost extends StatelessWidget {
  const CollectionTimelineHost({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final inspectorWidth = constraints.maxWidth < 720 ? 0.0 : 280.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Toolbar(viewModel: viewModel, board: board),
            const SizedBox(height: 8),
            const _Legend(),
            const SizedBox(height: 4),
            Text(_badge(board), style: const TextStyle(fontSize: 12)),
            if (_doesShowSectionButtons) ...[
              const SizedBox(height: 8),
              _SectionButtons(viewModel: viewModel, board: board),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppTheme.SURFACE_RAISED,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF3E424A)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _BoardView(viewModel: viewModel, board: board),
                      ),
                    ),
                  ),
                  if (inspectorWidth > 0) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: inspectorWidth,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppTheme.SURFACE_RAISED,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF3E424A)),
                        ),
                        child: CollectionTimelineInspector(
                          viewModel: viewModel,
                          board: board,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  bool get _doesShowSectionButtons {
    switch (board.timeline.viewKind) {
      case TimelineViewKind.resource:
      case TimelineViewKind.auto:
        return board.timeline.sections.isNotEmpty;
      case TimelineViewKind.day:
      case TimelineViewKind.roadmap:
        return false;
    }
  }

  String _badge(CollectionBoard board) {
    final timeline = board.timeline;
    switch (timeline.viewKind) {
      case TimelineViewKind.day:
        final row = timeline.focusedRow;
        return '하루 타임라인 · 1대만 · ${timeline.focusedEquipmentId} · ${row?.equipmentName ?? ''} · ${row?.lineName ?? ''}';
      case TimelineViewKind.roadmap:
        return '로드맵 · 이정표 카드, 길이는 안 그림';
      case TimelineViewKind.resource:
      case TimelineViewKind.auto:
        return '리소스 · X=시간, 빈 장비 행 유지, 막대=지속시간';
    }
  }
}

class _BoardView extends StatelessWidget {
  const _BoardView({required this.viewModel, required this.board});

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  Widget build(BuildContext context) {
    switch (board.timeline.viewKind) {
      case TimelineViewKind.day:
        return CollectionDayTimelineView(viewModel: viewModel, board: board);
      case TimelineViewKind.roadmap:
        return CollectionRoadmapView(viewModel: viewModel, board: board);
      case TimelineViewKind.resource:
      case TimelineViewKind.auto:
        return CollectionResourceTimelineView(
          viewModel: viewModel,
          board: board,
        );
    }
  }
}

class _SectionButtons extends StatelessWidget {
  const _SectionButtons({required this.viewModel, required this.board});

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final section in board.timeline.sections)
          Button(
            onPressed: _onPressed(section),
            child: Text('${section.label} · ${section.rows.length}대'),
          ),
      ],
    );
  }

  VoidCallback? _onPressed(TimelineSection section) {
    if (section.isProject) {
      return () => viewModel.didTapProjectSection(section.sectionKey);
    }
    if (board.timeline.isLineSectionLocked) {
      return null;
    }
    return () => viewModel.didTapLineSection(section.sectionKey);
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.viewModel, required this.board});

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  Widget build(BuildContext context) {
    final query = board.query;
    final timeline = board.timeline;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _ViewButton(
          label: '리소스',
          isSelected:
              timeline.viewKind == TimelineViewKind.resource ||
              timeline.viewKind == TimelineViewKind.auto,
          onPressed: () =>
              viewModel.didSelectTimelineView(TimelineViewKind.resource),
        ),
        if (timeline.canShowDayView)
          _ViewButton(
            label: '하루 타임라인',
            isSelected: timeline.viewKind == TimelineViewKind.day,
            onPressed: () =>
                viewModel.didSelectTimelineView(TimelineViewKind.day),
          ),
        _ViewButton(
          label: '로드맵',
          isSelected: timeline.viewKind == TimelineViewKind.roadmap,
          onPressed: () =>
              viewModel.didSelectTimelineView(TimelineViewKind.roadmap),
        ),
        const Text('줌'),
        for (final option in const [
          (0.25, '15m'),
          (1.0, '1h'),
          (4.0, '4h'),
          (24.0, '24h'),
        ])
          _ViewButton(
            label: option.$2,
            isSelected: query.zoomHours == option.$1,
            onPressed: () => viewModel.didSelectZoom(option.$1),
          ),
        Text(
          timeline.eventCount == 0
              ? '0건'
              : '${DashboardFormatters.count(timeline.eventCount)}건 · ${timeline.equipmentCount}대',
        ),
      ],
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return FilledButton(onPressed: onPressed, child: Text(label));
    }
    return Button(onPressed: onPressed, child: Text(label));
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: const [
        _LegendItem(label: '연결(정상)', color: AppTheme.STATUS_OK),
        _LegendItem(label: '단절', color: AppTheme.STATUS_OFF),
        _LegendItem(label: '오류', color: AppTheme.STATUS_ERROR),
        _LegendItem(label: '유실≥10%', color: AppTheme.STATUS_WARN),
        _LegendItem(
          label: '지연·미동기',
          color: AppTheme.STATUS_DESYNC,
          isDashed: true,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.color,
    this.isDashed = false,
  });

  final String label;
  final Color color;
  final bool isDashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimelineStatusSwatch(color: color, isDashed: isDashed),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
