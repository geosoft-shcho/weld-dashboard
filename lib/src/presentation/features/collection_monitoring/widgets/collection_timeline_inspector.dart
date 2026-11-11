import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/collected_node.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../navigation/app_coordinator.dart';
import '../collection_monitoring_view_model.dart';

class CollectionTimelineInspector extends StatelessWidget {
  const CollectionTimelineInspector({super.key, required this.viewModel});

  final CollectionMonitoringViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final node = viewModel.selectedNode;
    if (node == null) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text('타임라인에서 항목을 선택하세요'),
      );
    }
    final fields = _fieldsOf(node);
    final detail = _detailActionOf(node);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  node.label.isEmpty ? '미지정' : node.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (detail != null)
                Tooltip(
                  message: detail.tooltip,
                  useMousePosition: false,
                  style: const TooltipThemeData(
                    verticalOffset: 6,
                    preferBelow: true,
                  ),
                  child: IconButton(
                    icon: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.red_eye),
                        SizedBox(width: 4),
                        Text('자세히', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    onPressed: () => _openDetail(context, node, detail),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          for (final field in fields) ...[
            _NodeField(label: field.$1, value: field.$2),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }

  Future<void> _openDetail(
    BuildContext context,
    CollectedNode node,
    _DetailAction detail,
  ) async {
    final coordinator = context.read<AppCoordinator>();
    switch (detail.kind) {
      case _DetailKind.equipment:
        coordinator.didTapOpenEquipmentDetail(node.path.equipmentId);
      case _DetailKind.worker:
        coordinator.didTapOpenWorkerDetail(node.path.workerId);
      case _DetailKind.project:
        final projectId = await viewModel.resolveProjectId(node.path.projectNo);
        if (!context.mounted || projectId == null || projectId.isEmpty) {
          return;
        }
        coordinator.didTapOpenProjectDetail(projectId);
      case _DetailKind.job:
        coordinator.didTapOpenWorkDetail(context, jobId: node.path.jobId);
      case _DetailKind.asset:
        coordinator.didTapOpenAssetDetail(node.assetId);
    }
  }

  _DetailAction? _detailActionOf(CollectedNode node) {
    final path = node.path;
    if (node.assetId.isNotEmpty) {
      return const _DetailAction(kind: _DetailKind.asset, tooltip: '에셋 상세');
    }
    switch (path.level) {
      case CollectedNodeLevel.equipment:
        if (path.equipmentId.isEmpty) {
          return null;
        }
        return const _DetailAction(
          kind: _DetailKind.equipment,
          tooltip: '장비 상세',
        );
      case CollectedNodeLevel.worker:
        if (path.workerId.isEmpty) {
          return null;
        }
        return const _DetailAction(kind: _DetailKind.worker, tooltip: '작업자 상세');
      case CollectedNodeLevel.project:
        if (path.projectNo.isEmpty) {
          return null;
        }
        return const _DetailAction(kind: _DetailKind.project, tooltip: '공사 상세');
      case CollectedNodeLevel.job:
        if (path.jobId.isEmpty || node.isAssetNode) {
          return null;
        }
        return const _DetailAction(kind: _DetailKind.job, tooltip: '작업 상세');
      case CollectedNodeLevel.item:
      case CollectedNodeLevel.unspecified:
        return null;
    }
  }

  List<(String, String)> _fieldsOf(CollectedNode node) {
    final path = node.path;
    return [
      ('보기', _viewLabel(path.view)),
      ('단계', _levelLabel(path.level)),
      if (path.equipmentId.isNotEmpty) ('장비', path.equipmentId),
      if (path.workerId.isNotEmpty) ('작업자', path.workerId),
      if (path.projectNo.isNotEmpty) ('공사', path.projectNo),
      if (path.jobId.isNotEmpty) ('작업', path.jobId),
      if (path.passId.isNotEmpty)
        ('패스', path.passId)
      else if (path.jobId.isNotEmpty && node.contentUrl.isNotEmpty)
        ('패스', '작업 공용'),
      ('하위', node.hasChildren ? '있음' : '없음'),
      ('시작', DashboardFormatters.dateTime(node.startedAt)),
      ('종료', DashboardFormatters.dateTime(node.endedAt)),
      if (node.assetCount != null)
        ('파일 수', DashboardFormatters.count(node.assetCount!)),
      if (node.totalSizeBytes != null) ('용량', _sizeLabel(node.totalSizeBytes!)),
      if (node.firstRecordedAt != null)
        ('처음 기록', DashboardFormatters.dateTime(node.firstRecordedAt)),
      if (node.lastRecordedAt != null)
        ('마지막 기록', DashboardFormatters.dateTime(node.lastRecordedAt)),
      if (node.lastCollectedAt != null)
        ('마지막 수집', DashboardFormatters.dateTime(node.lastCollectedAt)),
      if (node.jobCount != null)
        ('작업 수', DashboardFormatters.count(node.jobCount!)),
      if (node.workDurationSeconds != null)
        ('작업 시간', _workDurationLabel(node.workDurationSeconds!)),
      if (node.contentUrl.isNotEmpty) ('파일', node.contentUrl),
    ];
  }

  String _viewLabel(CollectedNodeView view) {
    return switch (view) {
      CollectedNodeView.equipment => '장비',
      CollectedNodeView.worker => '작업자',
    };
  }

  String _levelLabel(CollectedNodeLevel level) {
    return switch (level) {
      CollectedNodeLevel.equipment => '장비',
      CollectedNodeLevel.worker => '작업자',
      CollectedNodeLevel.project => '공사',
      CollectedNodeLevel.item => '품목',
      CollectedNodeLevel.job => '작업',
      CollectedNodeLevel.unspecified => '미지정',
    };
  }

  String _sizeLabel(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = bytes.toDouble();
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex += 1;
    }
    if (unitIndex == 0) {
      return '${DashboardFormatters.count(bytes)} B';
    }
    final digits = size >= 100 ? 0 : 1;
    return '${size.toStringAsFixed(digits)} ${units[unitIndex]}';
  }

  String _workDurationLabel(int seconds) {
    if (seconds < 60) {
      return '$seconds초';
    }
    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (days > 0) {
      return '$days일 $hours시간 $minutes분';
    }
    if (hours > 0) {
      return '$hours시간 $minutes분';
    }
    return '$minutes분';
  }
}

enum _DetailKind { equipment, worker, project, job, asset }

class _DetailAction {
  const _DetailAction({required this.kind, required this.tooltip});

  final _DetailKind kind;
  final String tooltip;
}

class _NodeField extends StatelessWidget {
  const _NodeField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label  ',
            style: const TextStyle(fontSize: 12, color: Color(0xFF8E949E)),
          ),
          TextSpan(text: value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
