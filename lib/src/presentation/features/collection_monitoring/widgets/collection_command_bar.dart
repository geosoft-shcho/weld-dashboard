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
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          // 날짜
          DateNavigationField(
            selectedDate: query.selectedDate,
            onDateChanged: viewModel.didSelectDate,
            onPreviousDate: viewModel.didTapPreviousDate,
            onNextDate: viewModel.didTapNextDate,
            width: 220,
          ),

          const SizedBox(width: 12),

          // 시작 시간
          FilterField(
            label: '시작',
            width: 128,
            child: TimePicker(
              hourFormat: HourFormat.HH,
              selected: _clock(query.selectedDate, query.startMinutes),
              onChanged: viewModel.didSelectStartTime,
            ),
          ),

          const SizedBox(width: 12),

          // 종료 시간
          FilterField(
            label: '종료',
            width: 128,
            child: TimePicker(
              hourFormat: HourFormat.HH,
              selected: _clock(
                query.selectedDate,
                query.endMinutes >= 1440 ? 23 * 60 + 59 : query.endMinutes,
              ),
              onChanged: viewModel.didSelectEndTime,
            ),
          ),

          const SizedBox(width: 12),

          // 스냅샷
          FilterField(
            label: '스냅샷',
            width: 180,
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

          const SizedBox(width: 12),

          // 프로젝트
          _buildProjectFilter(query, board),

          const SizedBox(width: 12),

          // 라인
          _buildLineFilter(query, board),

          const SizedBox(width: 12),

          // 작업자
          _buildWorkerFilter(query, board),

          const SizedBox(width: 12),

          // 장비
          _buildEquipmentFilter(query, board),

          const SizedBox(width: 12),

          // 연결
          _buildConnectionFilter(query),

          const SizedBox(width: 12),

          // 새로고침 주기
          FilterField(
            label: '새로고침 주기',
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

          const SizedBox(width: 12),

          // 조회
          FilledButton(
            onPressed: viewModel.didTapQuery,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.search, size: 14),
                SizedBox(width: 6),
                Text('조회'),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // 초기화
          Button(
            onPressed: viewModel.didTapReset,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.clear_filter, size: 14),
                SizedBox(width: 6),
                Text('초기화'),
              ],
            ),
          ),

          const SizedBox(width: 12),
          // 새로고침
          Button(
            onPressed: viewModel.didTapReload,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.refresh, size: 14),
                SizedBox(width: 6),
                Text('새로고침'),
              ],
            ),
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

  Widget _buildProjectFilter(
    CollectionBoardQuery query,
    CollectionBoard? board,
  ) {
    return FilterField(
      label: '프로젝트',
      width: 130,
      child: FilterFlyoutButton(
        title: '프로젝트',
        summary: _projectSummary(query, board),
        panelBuilder: (_) => ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            return _projectPanel(viewModel.query, viewModel.board);
          },
        ),
      ),
    );
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

  Widget _buildLineFilter(CollectionBoardQuery query, CollectionBoard? board) {
    return FilterField(
      label: '라인',
      width: 130,
      child: FilterFlyoutButton(
        title: '라인',
        summary: _lineSummary(query, board),
        panelBuilder: (_) => ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            return _linePanel(viewModel.query, viewModel.board);
          },
        ),
      ),
    );
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

  Widget _buildWorkerFilter(
    CollectionBoardQuery query,
    CollectionBoard? board,
  ) {
    return FilterField(
      label: '작업자',
      width: 130,
      child: FilterFlyoutButton(
        title: '작업자',
        summary: _workerSummary(query, board),
        panelBuilder: (_) => ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            return _workerPanel(viewModel.query, viewModel.board);
          },
        ),
      ),
    );
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

  Widget _buildEquipmentFilter(
    CollectionBoardQuery query,
    CollectionBoard? board,
  ) {
    return FilterField(
      label: '장비',
      width: 150,
      child: FilterFlyoutButton(
        title: '장비',
        summary: _equipmentSummary(query, board),
        panelBuilder: (_) => ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            return _equipmentPanel(viewModel.query, viewModel.board);
          },
        ),
      ),
    );
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

  Widget _buildConnectionFilter(CollectionBoardQuery query) {
    return FilterField(
      label: '연결',
      width: 100,
      child: FilterFlyoutButton(
        title: '연결',
        summary: _connectionSummary(query),
        panelBuilder: (_) => ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            return _connectionPanel(viewModel.query);
          },
        ),
      ),
    );
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

class FilterField extends StatelessWidget {
  const FilterField({
    super.key,
    required this.label,
    required this.child,
    this.width,
  });

  final String label;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 4),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 36, child: child),
        ],
      ),
    );
  }
}

class DateNavigationField extends StatelessWidget {
  const DateNavigationField({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onPreviousDate,
    required this.onNextDate,
    this.width = 220,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onPreviousDate;
  final VoidCallback onNextDate;
  final double width;

  @override
  Widget build(BuildContext context) {
    return FilterField(
      label: '일자',
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 36,
            child: IconButton(
              icon: const Icon(FluentIcons.chevron_left, size: 12),
              onPressed: onPreviousDate,
            ),
          ),

          Expanded(
            child: DatePicker(
              selected: selectedDate,
              onChanged: onDateChanged,
              startDate: DateTime(2025, 1, 1),
              endDate: DateTime(2027, 12, 31),
            ),
          ),

          SizedBox(
            width: 28,
            height: 36,
            child: IconButton(
              icon: const Icon(FluentIcons.chevron_right, size: 12),
              onPressed: onNextDate,
            ),
          ),
        ],
      ),
    );
  }
}
