import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_board_query.dart';
import '../../../../domain/entities/connection_status.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/widgets/command_bar_widget_item.dart';
import '../../../core/widgets/filter_flyout_button.dart';
import '../collection_monitoring_view_model.dart';

class CollectionCommandBar extends StatelessWidget {
  const CollectionCommandBar({super.key, required this.viewModel});

  final CollectionMonitoringViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final query = viewModel.query;
    final board = viewModel.board;
    return CommandBarCard(
      child: CommandBar(
        overflowBehavior: CommandBarOverflowBehavior.wrap,
        primaryItems: [
          CommandBarButton(
            icon: const Icon(FluentIcons.chevron_left),
            label: const Text('이전'),
            onPressed: viewModel.didTapPreviousDate,
          ),
          CommandBarWidgetItem(
            child: SizedBox(
              width: 148,
              child: DatePicker(
                header: '일자',
                selected: query.selectedDate,
                startDate: DateTime(2025, 1, 1),
                endDate: DateTime(2027, 12, 31),
                onChanged: viewModel.didSelectDate,
              ),
            ),
          ),
          CommandBarButton(
            icon: const Icon(FluentIcons.chevron_right),
            label: const Text('다음'),
            onPressed: viewModel.didTapNextDate,
          ),
          CommandBarWidgetItem(
            child: SizedBox(
              width: 128,
              child: TimePicker(
                header: '시작',
                hourFormat: HourFormat.HH,
                selected: _clock(query.selectedDate, query.startMinutes),
                onChanged: viewModel.didSelectStartTime,
              ),
            ),
          ),
          CommandBarWidgetItem(
            child: SizedBox(
              width: 128,
              child: TimePicker(
                header: '종료',
                hourFormat: HourFormat.HH,
                selected: _clock(
                  query.selectedDate,
                  query.endMinutes >= 1440 ? 23 * 60 + 59 : query.endMinutes,
                ),
                onChanged: viewModel.didSelectEndTime,
              ),
            ),
          ),
          CommandBarWidgetItem(
            child: SizedBox(
              width: 200,
              child: ComboBox<DateTime>(
                value: query.snapshotAt,
                items: [
                  ComboBoxItem(
                    value: query.snapshotAt,
                    child: Text(DashboardFormatters.snapshot(query.snapshotAt)),
                  ),
                ],
                onChanged: (_) {},
              ),
            ),
          ),
          CommandBarWidgetItem(
            child: FilterFlyoutButton(
              title: '프로젝트',
              summary: _projectSummary(query, board),
              panelBuilder: (context) => ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) =>
                    _projectPanel(viewModel.query, viewModel.board),
              ),
            ),
          ),
          CommandBarWidgetItem(
            child: FilterFlyoutButton(
              title: '라인',
              summary: _lineSummary(query, board),
              panelBuilder: (context) => ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) =>
                    _linePanel(viewModel.query, viewModel.board),
              ),
            ),
          ),
          CommandBarWidgetItem(
            child: FilterFlyoutButton(
              title: '작업자',
              summary: _workerSummary(query, board),
              panelBuilder: (context) => ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) =>
                    _workerPanel(viewModel.query, viewModel.board),
              ),
            ),
          ),
          CommandBarWidgetItem(
            child: FilterFlyoutButton(
              title: '장비',
              summary: _equipmentSummary(query, board),
              panelBuilder: (context) => ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) =>
                    _equipmentPanel(viewModel.query, viewModel.board),
              ),
            ),
          ),
          CommandBarWidgetItem(
            child: FilterFlyoutButton(
              title: '연결',
              summary: _connectionSummary(query),
              panelBuilder: (context) => ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) => _connectionPanel(viewModel.query),
              ),
            ),
          ),
          CommandBarWidgetItem(
            child: SizedBox(
              width: 120,
              child: ComboBox<int>(
                value: query.refreshIntervalSeconds,
                items: const [
                  ComboBoxItem(value: 0, child: Text('끔')),
                  ComboBoxItem(value: 5, child: Text('5초')),
                  ComboBoxItem(value: 60, child: Text('1분')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    viewModel.didSelectRefreshInterval(value);
                  }
                },
              ),
            ),
          ),
          CommandBarButton(
            icon: const Icon(FluentIcons.search),
            label: const Text('조회'),
            onPressed: viewModel.didTapQuery,
          ),
          CommandBarButton(
            icon: const Icon(FluentIcons.reset),
            label: const Text('초기화'),
            onPressed: viewModel.didTapReset,
          ),
          CommandBarButton(
            icon: const Icon(FluentIcons.refresh),
            label: const Text('새로고침'),
            onPressed: viewModel.didTapReload,
          ),
        ],
      ),
    );
  }

  DateTime _clock(DateTime date, int minutes) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  String _projectSummary(CollectionBoardQuery query, CollectionBoard? board) {
    if (query.isUnassignedOnly) {
      return '미배정';
    }
    if (query.projectIds.isEmpty) {
      return '전체';
    }
    if (query.projectIds.length == 1) {
      for (final project in board?.options.projects ?? const []) {
        if (project.projectId == query.projectIds.first) {
          return project.projectName;
        }
      }
      return query.projectIds.first;
    }
    return '${query.projectIds.length}개';
  }

  String _lineSummary(CollectionBoardQuery query, CollectionBoard? board) {
    if (query.lineNames.isEmpty) {
      return '전체';
    }
    if (query.lineNames.length == 1) {
      return query.lineNames.first;
    }
    return '${query.lineNames.length}개';
  }

  String _workerSummary(CollectionBoardQuery query, CollectionBoard? board) {
    if (query.workerIds.isEmpty) {
      return '전체';
    }
    if (query.workerIds.length == 1) {
      for (final worker in board?.options.workers ?? const []) {
        if (worker.workerId == query.workerIds.first) {
          return worker.workerName;
        }
      }
      return query.workerIds.first;
    }
    return '${query.workerIds.length}개';
  }

  String _equipmentSummary(CollectionBoardQuery query, CollectionBoard? board) {
    final total = board?.options.equipments.length ?? 0;
    if (query.equipmentIds.isEmpty) {
      return '전체';
    }
    if (query.equipmentIds.length == 1) {
      return query.equipmentIds.first;
    }
    return '${query.equipmentIds.length}개 / $total';
  }

  String _connectionSummary(CollectionBoardQuery query) {
    if (query.connectionStatuses.isEmpty) {
      return '전체';
    }
    if (query.connectionStatuses.length == 1) {
      return query.connectionStatuses.first.label;
    }
    return '${query.connectionStatuses.length}개';
  }

  Widget _projectPanel(CollectionBoardQuery query, CollectionBoard? board) {
    return ListView(
      shrinkWrap: true,
      children: [
        Button(
          onPressed: viewModel.didToggleUnassigned,
          child: Text('${query.isUnassignedOnly ? '☑' : '☐'} 미배정'),
        ),
        for (final project in board?.options.projects ?? const [])
          Button(
            onPressed: () => viewModel.didToggleProject(project.projectId),
            child: Text(
              '${query.projectIds.contains(project.projectId) ? '☑' : '☐'} ${project.projectName}',
            ),
          ),
      ],
    );
  }

  Widget _linePanel(CollectionBoardQuery query, CollectionBoard? board) {
    final lines = board?.options.lineNames ?? const <String>[];
    if (lines.isEmpty) {
      return const Text('라인 없음');
    }
    return ListView(
      shrinkWrap: true,
      children: [
        for (final lineName in lines)
          Button(
            onPressed: () => viewModel.didToggleLine(lineName),
            child: Text(
              '${query.lineNames.contains(lineName) ? '☑' : '☐'} $lineName',
            ),
          ),
      ],
    );
  }

  Widget _workerPanel(CollectionBoardQuery query, CollectionBoard? board) {
    final workers = board?.options.workers ?? const [];
    if (workers.isEmpty) {
      return const Text('배정된 작업자 없음');
    }
    return ListView(
      shrinkWrap: true,
      children: [
        for (final worker in workers)
          Button(
            onPressed: () => viewModel.didToggleWorker(worker.workerId),
            child: Text(
              '${query.workerIds.contains(worker.workerId) ? '☑' : '☐'} ${worker.workerName}',
            ),
          ),
      ],
    );
  }

  Widget _equipmentPanel(CollectionBoardQuery query, CollectionBoard? board) {
    final equipments = board?.options.equipments ?? const [];
    if (equipments.isEmpty) {
      return const Text('검색 결과 없음');
    }
    return ListView(
      shrinkWrap: true,
      children: [
        for (final equipment in equipments)
          Button(
            onPressed: () =>
                viewModel.didToggleEquipment(equipment.equipmentId),
            child: Text(
              '${query.equipmentIds.contains(equipment.equipmentId) ? '☑' : '☐'} ${equipment.equipmentId} ${equipment.equipmentName}',
            ),
          ),
      ],
    );
  }

  Widget _connectionPanel(CollectionBoardQuery query) {
    return ListView(
      shrinkWrap: true,
      children: [
        for (final status in ConnectionStatus.values)
          Button(
            onPressed: () => viewModel.didToggleConnection(status),
            child: Text(
              '${query.connectionStatuses.contains(status) ? '☑' : '☐'} ${status.label}',
            ),
          ),
      ],
    );
  }
}
