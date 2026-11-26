import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/collected_node.dart';
import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_timeline.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart';
import '../collection_monitoring_view_model.dart';
import 'collection_timeline_board_view.dart';
import 'collection_timeline_inspector.dart';
import 'timeline_status_style.dart';

const _kViewRootLabel = '공사별';
const _kInspectorMinWidth = 720.0;
const _kInspectorWidth = 280.0;
const _kPanelBorderColor = Color(0xFF3E424A);

const _zoomHoursOptions = <(double, String)>[
  (0.25, '15m'),
  (1.0, '1h'),
  (4.0, '4h'),
  (24.0, '24h'),
];

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChromeBar(viewModel: viewModel, board: board),
            const SizedBox(height: 8),
            Expanded(
              child: _BoardBody(
                viewModel: viewModel,
                board: board,
                maxWidth: constraints.maxWidth,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ChromeBar extends StatelessWidget {
  const _ChromeBar({required this.viewModel, required this.board});

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _DrillCrumbs(viewModel: viewModel, board: board),
          ),
          const SizedBox(width: 8),
          const _Legend(),
          const SizedBox(width: 12),
          _ZoomControl(
            zoomHours: board.query.zoomHours,
            onChanged: viewModel.didSelectZoom,
          ),
        ],
      ),
    );
  }
}

class _BoardBody extends StatelessWidget {
  const _BoardBody({
    required this.viewModel,
    required this.board,
    required this.maxWidth,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final doesShowInspector = maxWidth >= _kInspectorMinWidth;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _SurfacePanel(
            padding: const EdgeInsets.all(8),
            child: CollectionTimelineBoardView(
              viewModel: viewModel,
              board: board,
            ),
          ),
        ),
        if (doesShowInspector) ...[
          const SizedBox(width: 8),
          SizedBox(
            width: _kInspectorWidth,
            child: _SurfacePanel(
              child: CollectionTimelineInspector(viewModel: viewModel),
            ),
          ),
        ],
      ],
    );
  }
}

class _SurfacePanel extends StatelessWidget {
  const _SurfacePanel({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final content = padding == null ? child : Padding(padding: padding!, child: child);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.SURFACE_RAISED,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _kPanelBorderColor),
      ),
      child: content,
    );
  }
}

class _DrillCrumbs extends StatelessWidget {
  const _DrillCrumbs({required this.viewModel, required this.board});

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  Widget build(BuildContext context) {
    final ancestors = viewModel.ancestors;
    final rootPath = CollectedNodePath.root(viewModel.collectedView);
    final currentParent = ancestors.isEmpty ? rootPath : ancestors.last.path;
    final crumbs = <Widget>[
      _CrumbButton(
        onPressed: () => viewModel.didTapAncestor(0),
        children: [
          const Text(_kViewRootLabel),
          const SizedBox(width: 6),
          Text(
            _pathCountLabel(
              children: viewModel.cachedChildrenOf(rootPath),
              timeline: board.timeline,
              doesShowEventCount: currentParent == rootPath,
            ),
          ),
        ],
      ),
    ];
    for (var index = 0; index < ancestors.length; index++) {
      final node = ancestors[index];
      final label = node.label.isEmpty ? '미지정' : node.label;
      crumbs.add(const Text('›'));
      crumbs.add(
        _CrumbButton(
          onPressed: () => viewModel.didTapAncestor(index + 1),
          children: [
            _LevelBadge(label: _levelLabelOf(node.path.level)),
            const SizedBox(width: 6),
            Text(label),
            const SizedBox(width: 6),
            Text(
              _pathCountLabel(
                children: viewModel.cachedChildrenOf(node.path),
                timeline: board.timeline,
                doesShowEventCount: currentParent == node.path,
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.ACCENT_STEEL,
              ),
            ),
          ],
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: crumbs,
    );
  }
}

class _CrumbButton extends StatelessWidget {
  const _CrumbButton({required this.onPressed, required this.children});

  final VoidCallback onPressed;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.ACCENT_STEEL.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: _kPanelBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.ACCENT_STEEL,
          ),
        ),
      ),
    );
  }
}

class _ZoomControl extends StatelessWidget {
  const _ZoomControl({
    required this.zoomHours,
    required this.onChanged,
  });

  final double zoomHours;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = _zoomHoursOptions.any((option) => option.$1 == zoomHours)
        ? zoomHours
        : null;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('줌'),
        ComboBox<double>(
          value: selected,
          items: [
            for (final option in _zoomHoursOptions)
              ComboBoxItem<double>(
                value: option.$1,
                child: Text(option.$2),
              ),
          ],
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ],
    );
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
        _LegendItem(label: '수집', color: AppTheme.STATUS_OK),
        _LegendItem(label: '기록 없음', color: AppTheme.STATUS_WARN),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimelineStatusSwatch(color: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

String _levelLabelOf(CollectedNodeLevel level) {
  return switch (level) {
    CollectedNodeLevel.project => '공사',
    CollectedNodeLevel.item => '품목',
    CollectedNodeLevel.job => '작업',
    CollectedNodeLevel.unspecified => '전체',
  };
}

String _pathCountLabel({
  required List<CollectedNode> children,
  required CollectionTimeline timeline,
  required bool doesShowEventCount,
}) {
  final nodeCount = children.length;
  final unit = _childCountUnitOf(children);
  final nodeLabel = '${DashboardFormatters.count(nodeCount)}$unit';
  if (!doesShowEventCount || nodeCount == 0) {
    return nodeLabel;
  }
  final eventCount = timeline.eventCount;
  if (eventCount == 0 || eventCount == nodeCount) {
    return nodeLabel;
  }
  return '$nodeLabel · ${DashboardFormatters.count(eventCount)}구간';
}

String _childCountUnitOf(List<CollectedNode> children) {
  if (children.isEmpty) {
    return '건';
  }
  if (children.every((node) => node.contentUrl.isNotEmpty)) {
    return '개';
  }
  return switch (children.first.path.level) {
    CollectedNodeLevel.project ||
    CollectedNodeLevel.item ||
    CollectedNodeLevel.job ||
    CollectedNodeLevel.unspecified => '건',
  };
}
