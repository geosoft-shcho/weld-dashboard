import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/collection_board_query.dart';
import '../../../../domain/entities/connection_status.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/widgets/command_bar_widget_item.dart';
import '../collection_monitoring_view_model.dart';

class CollectionCommandBar extends StatefulWidget {
  const CollectionCommandBar({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard? board;

  @override
  State<CollectionCommandBar> createState() => _CollectionCommandBarState();
}

class _CollectionCommandBarState extends State<CollectionCommandBar> {
  @override
  Widget build(BuildContext context) {
    final query = widget.viewModel.query;
    final board = widget.board;
    return CommandBarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 필터 영역 (왼쪽, 유연하게 래핑)
              Expanded(
                child: CommandBar(
                  overflowBehavior: CommandBarOverflowBehavior.wrap,
                  primaryItems: [
                    // 일자 네비게이션
                    CommandBarWidgetItem(
                      child: SizedBox(
                        width: 220,
                        child: _buildDateNavigationField(query),
                      ),
                    ),
                    // 시작 시간
                    CommandBarWidgetItem(
                      child: SizedBox(
                        width: 136,
                        child: InfoLabel(
                          label: '시작',
                          child: TimePicker(
                            hourFormat: HourFormat.HH,
                            selected: _clock(
                              query.selectedDate,
                              query.startMinutes,
                            ),
                            onChanged: widget.viewModel.didSelectStartTime,
                          ),
                        ),
                      ),
                    ),
                    // 종료 시간
                    CommandBarWidgetItem(
                      child: SizedBox(
                        width: 136,
                        child: InfoLabel(
                          label: '종료',
                          child: TimePicker(
                            hourFormat: HourFormat.HH,
                            selected: _clock(
                              query.selectedDate,
                              query.endMinutes >= 1440
                                  ? 23 * 60 + 59
                                  : query.endMinutes,
                            ),
                            onChanged: widget.viewModel.didSelectEndTime,
                          ),
                        ),
                      ),
                    ),
                    // 프로젝트
                    CommandBarWidgetItem(
                      child: SizedBox(
                        width: 130,
                        child: InfoLabel(
                          label: '프로젝트',
                          child: _buildProjectComboBox(query, board),
                        ),
                      ),
                    ),
                    // 라인
                    CommandBarWidgetItem(
                      child: SizedBox(
                        width: 130,
                        child: InfoLabel(
                          label: '라인',
                          child: _buildLineComboBox(query, board),
                        ),
                      ),
                    ),
                    // 장비
                    CommandBarWidgetItem(
                      child: SizedBox(
                        width: 150,
                        child: InfoLabel(
                          label: '장비',
                          child: _buildEquipmentComboBox(query, board),
                        ),
                      ),
                    ),
                    // 작업자
                    CommandBarWidgetItem(
                      child: SizedBox(
                        width: 130,
                        child: InfoLabel(
                          label: '작업자',
                          child: _buildWorkerComboBox(query, board),
                        ),
                      ),
                    ),
                    // 연결
                    CommandBarWidgetItem(
                      child: SizedBox(
                        width: 100,
                        child: InfoLabel(
                          label: '연결',
                          child: _buildConnectionComboBox(query),
                        ),
                      ),
                    ),
                    // 새로고침 주기
                    CommandBarWidgetItem(
                      child: SizedBox(
                        width: 120,
                        child: InfoLabel(
                          label: '새로고침 주기',
                          child: ComboBox<int>(
                            isExpanded: true,
                            value: query.refreshIntervalSeconds,
                            items: const [
                              ComboBoxItem(value: 0, child: Text('끔')),
                              ComboBoxItem(value: 5, child: Text('5초')),
                              ComboBoxItem(value: 60, child: Text('1분')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                widget.viewModel.didSelectRefreshInterval(
                                  value,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // 고정 액션 버튼 영역 (오른쪽)
              _buildActionButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 조회
        FilledButton(
          onPressed: widget.viewModel.didTapQuery,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FluentIcons.search, size: 14),
              SizedBox(width: 6),
              Text('조회'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // 초기화
        Button(
          onPressed: widget.viewModel.didTapReset,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FluentIcons.clear_filter, size: 14),
              SizedBox(width: 6),
              Text('초기화'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // 새로고침
        Button(
          onPressed: widget.viewModel.didTapReload,
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

  Widget _buildDateNavigationField(CollectionBoardQuery query) {
    return InfoLabel(
      label: '일자',
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 28,
              child: IconButton(
                icon: const Icon(FluentIcons.chevron_left, size: 12),
                onPressed: widget.viewModel.didTapPreviousDate,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: DatePicker(
                selected: query.selectedDate,
                onChanged: widget.viewModel.didSelectDate,
                startDate: DateTime(2025, 1, 1),
                endDate: DateTime(2027, 12, 31),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 28,
              child: IconButton(
                icon: const Icon(FluentIcons.chevron_right, size: 12),
                onPressed: widget.viewModel.didTapNextDate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectComboBox(
    CollectionBoardQuery query,
    CollectionBoard? board,
  ) {
    final displayValue = query.isUnassignedOnly
        ? 'unassigned'
        : (query.projectIds.isEmpty
              ? 'all'
              : (query.projectIds.length > 1
                    ? 'multiple'
                    : query.projectIds.first));

    return ComboBox<String>(
      isExpanded: true,
      value: displayValue,
      items: [
        const ComboBoxItem(value: 'all', child: Text('전체')),
        ComboBoxItem(
          value: 'unassigned',
          child: Text(query.isUnassignedOnly ? '☑ 미배정' : '☐ 미배정'),
        ),
        for (final project in board?.options.projects ?? const [])
          ComboBoxItem(
            value: project.projectId,
            child: Text(
              '${query.projectIds.contains(project.projectId) ? '☑' : '☐'} ${project.projectName}',
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null) {
          if (value == 'all') {
            widget.viewModel.didToggleUnassigned();
          } else if (value == 'unassigned') {
            widget.viewModel.didToggleUnassigned();
          } else {
            widget.viewModel.didToggleProject(value);
          }
        }
      },
    );
  }

  Widget _buildLineComboBox(
    CollectionBoardQuery query,
    CollectionBoard? board,
  ) {
    final lines = board?.options.lineNames ?? const <String>[];
    final displayValue = query.lineNames.isEmpty
        ? 'all'
        : (query.lineNames.length > 1 ? 'multiple' : query.lineNames.first);

    return ComboBox<String>(
      isExpanded: true,
      value: displayValue,
      items: [
        const ComboBoxItem(value: 'all', child: Text('전체')),
        for (final lineName in lines)
          ComboBoxItem(
            value: lineName,
            child: Text(
              '${query.lineNames.contains(lineName) ? '☑' : '☐'} $lineName',
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null && value != 'all' && value != 'multiple') {
          widget.viewModel.didToggleLine(value);
        } else if (value == 'all') {
          for (final lineName in query.lineNames) {
            widget.viewModel.didToggleLine(lineName);
          }
        }
      },
    );
  }

  Widget _buildWorkerComboBox(
    CollectionBoardQuery query,
    CollectionBoard? board,
  ) {
    final workers = board?.options.workers ?? const [];
    final displayValue = query.workerIds.isEmpty
        ? 'all'
        : (query.workerIds.length > 1 ? 'multiple' : query.workerIds.first);

    return ComboBox<String>(
      isExpanded: true,
      value: displayValue,
      items: [
        const ComboBoxItem(value: 'all', child: Text('전체')),
        for (final worker in workers)
          ComboBoxItem(
            value: worker.workerId,
            child: Text(
              '${query.workerIds.contains(worker.workerId) ? '☑' : '☐'} ${worker.workerName}',
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null && value != 'all' && value != 'multiple') {
          widget.viewModel.didToggleWorker(value);
        } else if (value == 'all') {
          for (final workerId in query.workerIds) {
            widget.viewModel.didToggleWorker(workerId);
          }
        }
      },
    );
  }

  Widget _buildEquipmentComboBox(
    CollectionBoardQuery query,
    CollectionBoard? board,
  ) {
    final equipments = board?.options.equipments ?? const [];
    final displayValue = query.equipmentIds.isEmpty
        ? 'all'
        : (query.equipmentIds.length > 1
              ? 'multiple'
              : query.equipmentIds.first);

    return ComboBox<String>(
      isExpanded: true,
      value: displayValue,
      items: [
        const ComboBoxItem(value: 'all', child: Text('전체')),
        for (final equipment in equipments)
          ComboBoxItem(
            value: equipment.equipmentId,
            child: Text(
              '${query.equipmentIds.contains(equipment.equipmentId) ? '☑' : '☐'} ${equipment.equipmentId} ${equipment.equipmentName}',
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null && value != 'all' && value != 'multiple') {
          widget.viewModel.didToggleEquipment(value);
        } else if (value == 'all') {
          for (final equipmentId in query.equipmentIds) {
            widget.viewModel.didToggleEquipment(equipmentId);
          }
        }
      },
    );
  }

  Widget _buildConnectionComboBox(CollectionBoardQuery query) {
    final displayValue = query.connectionStatuses.isEmpty
        ? null
        : query.connectionStatuses.first;

    return ComboBox<ConnectionStatus>(
      isExpanded: true,
      value: displayValue,
      items: [
        const ComboBoxItem<ConnectionStatus>(value: null, child: Text('전체')),
        for (final status in ConnectionStatus.values)
          ComboBoxItem(
            value: status,
            child: Text(
              '${query.connectionStatuses.contains(status) ? '☑' : '☐'} ${status.label}',
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null) {
          widget.viewModel.didToggleConnection(value);
        } else {
          for (final status in query.connectionStatuses) {
            widget.viewModel.didToggleConnection(status);
          }
        }
      },
    );
  }
}

class CollectionFilterChips extends StatelessWidget {
  const CollectionFilterChips({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard? board;

  @override
  Widget build(BuildContext context) {
    final query = viewModel.query;
    final chips = <Widget>[];

    // 일자
    chips.add(_chip('일자 ${DashboardFormatters.date(query.selectedDate)}'));

    // 시간 범위
    if (query.startMinutes > 0 || query.endMinutes < 1440) {
      chips.add(
        _chip(
          '시간 ${DashboardFormatters.clockMinutes(query.startMinutes)} ~ ${query.endMinutes >= 1440 ? '23:59' : DashboardFormatters.clockMinutes(query.endMinutes)}',
        ),
      );
    }

    // 프로젝트
    if (query.isUnassignedOnly) {
      chips.add(_chip('미배정'));
    } else if (query.projectIds.isNotEmpty) {
      for (final projectId in query.projectIds) {
        var label = projectId;
        for (final project in board?.options.projects ?? const []) {
          if (project.projectId == projectId) {
            label = project.projectName;
            break;
          }
        }
        chips.add(_chip('프로젝트 $label'));
      }
    }

    // 라인
    if (query.lineNames.isNotEmpty) {
      for (final lineName in query.lineNames) {
        chips.add(_chip('라인 $lineName'));
      }
    }

    // 장비
    if (query.equipmentIds.isNotEmpty) {
      for (final equipmentId in query.equipmentIds) {
        chips.add(_chip('장비 $equipmentId'));
      }
    }

    // 작업자
    if (query.workerIds.isNotEmpty) {
      for (final workerId in query.workerIds) {
        var label = workerId;
        for (final worker in board?.options.workers ?? const []) {
          if (worker.workerId == workerId) {
            label = worker.workerName;
            break;
          }
        }
        chips.add(_chip('작업자 $label'));
      }
    }

    // 연결
    if (query.connectionStatuses.isNotEmpty) {
      for (final status in query.connectionStatuses) {
        chips.add(_chip('연결 ${status.label}'));
      }
    }

    // 새로고침 주기
    if (query.refreshIntervalSeconds > 0) {
      final label = query.refreshIntervalSeconds == 5
          ? '5초'
          : query.refreshIntervalSeconds == 60
          ? '1분'
          : '${query.refreshIntervalSeconds}초';
      chips.add(_chip('자동갱신 $label'));
    }

    if (chips.isEmpty) {
      chips.add(_chip('필터 없음'));
    }

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('필터', style: TextStyle(fontSize: 12)),
              ...chips,
            ],
          ),
        ),
        Text(
          '검색 결과 ${DashboardFormatters.count(board?.rows.length ?? 0)}건',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF32363C),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
