import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/timeline_view_kind.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../navigation/app_coordinator.dart';
import '../collection_monitoring_view_model.dart';

class CollectionTimelineInspector extends StatelessWidget {
  const CollectionTimelineInspector({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  Widget build(BuildContext context) {
    final timeline = board.timeline;
    final event = timeline.selectedEvent;
    final row = timeline.focusedRow;
    if (event == null && row == null) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text('타임라인 행 또는 블록을 선택하세요'),
      );
    }
    final connection = event?.connectionStatus ?? row!.connectionStatus;
    final name =
        row?.equipmentName ??
        event?.equipmentName ??
        timeline.focusedEquipmentId;
    final equipmentId = timeline.focusedEquipmentId;
    final lineName = row?.lineName ?? event?.lineName ?? '';
    final received = event?.receivedCount ?? row?.receivedCount ?? 0;
    final loss = event?.lossRatePercent ?? row?.lossRatePercent;
    final sync = event?.timeSyncStatus ?? row!.timeSyncStatus;
    final offset = event?.clockOffsetMs ?? row?.clockOffsetMs;
    final start = event == null
        ? '—'
        : DashboardFormatters.clockTime(event.eventAt);
    final end = event == null
        ? '지금'
        : DashboardFormatters.clockTime(event.endedAt);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${connection.label}  $name',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '$equipmentId · $lineName',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          if (timeline.selectedProjectName.isEmpty &&
              timeline.selectedWorkerName.isEmpty)
            const Text('배정 없음', style: TextStyle(fontSize: 12))
          else
            Wrap(
              spacing: 8,
              children: [
                if (timeline.selectedProjectName.isNotEmpty)
                  Text(
                    timeline.selectedProjectName,
                    style: const TextStyle(fontSize: 12),
                  ),
                if (timeline.selectedWorkerName.isNotEmpty)
                  Text(
                    timeline.selectedWorkerName,
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          const SizedBox(height: 8),
          Text(
            '$start ~ $end · 수신 ${DashboardFormatters.count(received)} · 유실 ${DashboardFormatters.percent(loss)} · ${sync.label}${offset == null ? '' : ' · ${offset}ms'}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          if (timeline.viewKind != TimelineViewKind.day)
            Button(
              onPressed: viewModel.didTapOpenDayView,
              child: const Text('하루 타임라인으로'),
            ),
          if (timeline.viewKind != TimelineViewKind.day)
            const SizedBox(height: 8),
          Button(
            onPressed: equipmentId.isEmpty
                ? null
                : () {
                    final workerIds = viewModel.query.workerIds;
                    context.read<AppCoordinator>().didTapOpenWorkHistory(
                      equipmentId: equipmentId,
                      workerId: workerIds.length == 1 ? workerIds.first : '',
                    );
                  },
            child: const Text('이 장비로 이력 보기'),
          ),
        ],
      ),
    );
  }
}
