import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField;

import '../../../../domain/entities/work_history_board.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/command_bar_widget_item.dart';
import '../../../core/widgets/waveform_material_scope.dart';
import '../work_history_view_model.dart';

class WorkHistoryCommandBar extends StatefulWidget {
  const WorkHistoryCommandBar({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final WorkHistoryViewModel viewModel;
  final WorkHistoryBoard board;

  @override
  State<WorkHistoryCommandBar> createState() => _WorkHistoryCommandBarState();
}

class _WorkHistoryCommandBarState extends State<WorkHistoryCommandBar> {
  late final TextEditingController _commonKeyController;

  @override
  void initState() {
    super.initState();
    _commonKeyController = TextEditingController(
      text: widget.viewModel.query.commonKey,
    );
  }

  @override
  void didUpdateWidget(WorkHistoryCommandBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final commonKey = widget.viewModel.query.commonKey;
    if (_commonKeyController.text != commonKey) {
      _commonKeyController.value = TextEditingValue(
        text: commonKey,
        selection: TextSelection.collapsed(offset: commonKey.length),
      );
    }
  }

  @override
  void dispose() {
    _commonKeyController.dispose();
    super.dispose();
  }

  void _didSubmitCommonKey() {
    widget.viewModel.didChangeCommonKey(_commonKeyController.text);
    widget.viewModel.didTapQuery();
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.viewModel.query;
    final board = widget.board;
    return CommandBarCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CommandBar(
              overflowBehavior: CommandBarOverflowBehavior.wrap,
              crossAxisAlignment: CrossAxisAlignment.center,
              primaryItems: [
                CommandBarWidgetItem(
                  child: SizedBox(
                    width: 200,
                    child: InfoLabel(
                      label: '공통키',
                      child: SizedBox(
                        child: WaveformMaterialScope(
                          child: TextField(
                            controller: _commonKeyController,
                            style: const TextStyle(
                              color: AppTheme.INK,
                              fontSize: 13,
                            ),
                            cursorColor: AppTheme.ACCENT_STEEL,
                            textInputAction: TextInputAction.search,
                            onChanged: widget.viewModel.didChangeCommonKey,
                            onSubmitted: (_) => _didSubmitCommonKey(),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'WO-…|J-…',
                              hintStyle: TextStyle(
                                color: AppTheme.INK.withValues(alpha: 0.45),
                                fontSize: 13,
                              ),
                              filled: true,
                              fillColor: AppTheme.SURFACE,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFF3E424A),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFF3E424A),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                CommandBarWidgetItem(
                  child: SizedBox(
                    width: 220,
                    child: InfoLabel(
                      label: '작업지시',
                      child: ComboBox<String>(
                        isExpanded: true,
                        value: query.workOrderId,
                        items: [
                          const ComboBoxItem(value: '', child: Text('전체')),
                          for (final workOrder in board.workOrders)
                            ComboBoxItem(
                              value: workOrder.workOrderId,
                              child: Text(
                                '${workOrder.workOrderNo} ${workOrder.title}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            widget.viewModel.didSelectWorkOrder(value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                CommandBarWidgetItem(
                  child: SizedBox(
                    width: 180,
                    child: InfoLabel(
                      label: '조인트',
                      child: ComboBox<String>(
                        isExpanded: true,
                        value: query.jointId,
                        items: [
                          const ComboBoxItem(value: '', child: Text('전체')),
                          for (final joint in widget.viewModel.jointOptions)
                            ComboBoxItem(
                              value: joint.jointId,
                              child: Text(
                                '${joint.jointNo} ${joint.jointName}',
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            widget.viewModel.didSelectJoint(value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                CommandBarWidgetItem(
                  child: SizedBox(
                    width: 140,
                    child: InfoLabel(
                      label: '작업자',
                      child: ComboBox<String>(
                        isExpanded: true,
                        value: query.workerId,
                        items: [
                          const ComboBoxItem(value: '', child: Text('전체')),
                          for (final worker in board.workers)
                            ComboBoxItem(
                              value: worker.workerId,
                              child: Text(worker.workerName),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            widget.viewModel.didSelectWorker(value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                CommandBarWidgetItem(
                  child: SizedBox(
                    width: 160,
                    child: InfoLabel(
                      label: '장비',
                      child: ComboBox<String>(
                        isExpanded: true,
                        value: query.equipmentId,
                        items: [
                          const ComboBoxItem(value: '', child: Text('전체')),
                          for (final equipment in board.equipments)
                            ComboBoxItem(
                              value: equipment.equipmentId,
                              child: Text(equipment.equipmentName),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            widget.viewModel.didSelectEquipment(value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                CommandBarWidgetItem(
                  child: SizedBox(
                    width: 148,
                    child: InfoLabel(
                      label: '시작일',
                      child: DatePicker(
                        selected: query.fromDate,
                        startDate: DateTime(2025, 1, 1),
                        endDate: DateTime(2027, 12, 31),
                        onChanged: widget.viewModel.didSelectFromDate,
                      ),
                    ),
                  ),
                ),
                CommandBarWidgetItem(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Button(
                      onPressed: query.fromDate == null
                          ? null
                          : () => widget.viewModel.didSelectFromDate(null),
                      child: const Text('시작 해제'),
                    ),
                  ),
                ),
                CommandBarWidgetItem(
                  child: SizedBox(
                    width: 148,
                    child: InfoLabel(
                      label: '종료일',
                      child: DatePicker(
                        selected: query.toDate,
                        startDate: DateTime(2025, 1, 1),
                        endDate: DateTime(2027, 12, 31),
                        onChanged: widget.viewModel.didSelectToDate,
                      ),
                    ),
                  ),
                ),
                CommandBarWidgetItem(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Button(
                      onPressed: query.toDate == null
                          ? null
                          : () => widget.viewModel.didSelectToDate(null),
                      child: const Text('종료 해제'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: _didSubmitCommonKey,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FluentIcons.search, size: 14),
                const SizedBox(width: 6),
                Text(
                  widget.viewModel.doesHavePendingFilters ? '조회 · 미적용' : '조회',
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Button(
            onPressed: () {
              _commonKeyController.clear();
              widget.viewModel.didTapReset();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.clear_filter, size: 14),
                SizedBox(width: 6),
                Text('초기화'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkHistoryFilterChips extends StatelessWidget {
  const WorkHistoryFilterChips({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final WorkHistoryViewModel viewModel;
  final WorkHistoryBoard board;

  @override
  Widget build(BuildContext context) {
    final query = viewModel.query;
    final chips = <Widget>[];
    if (query.commonKey.trim().isNotEmpty) {
      chips.add(_chip('공통키 ${query.commonKey.trim()}'));
    }
    if (query.workOrderId.isNotEmpty) {
      var label = query.workOrderId;
      for (final workOrder in board.workOrders) {
        if (workOrder.workOrderId == query.workOrderId) {
          label = workOrder.workOrderNo;
        }
      }
      chips.add(_chip('작업지시 $label'));
    }
    if (query.jointId.isNotEmpty) {
      var label = query.jointId;
      for (final joint in viewModel.jointOptions) {
        if (joint.jointId == query.jointId) {
          label = joint.jointNo;
        }
      }
      chips.add(_chip('조인트 $label'));
    }
    if (query.workerId.isNotEmpty) {
      var label = query.workerId;
      for (final worker in board.workers) {
        if (worker.workerId == query.workerId) {
          label = worker.workerName;
        }
      }
      chips.add(_chip('작업자 $label'));
    }
    if (query.equipmentId.isNotEmpty) {
      var label = query.equipmentId;
      for (final equipment in board.equipments) {
        if (equipment.equipmentId == query.equipmentId) {
          label = equipment.equipmentName;
        }
      }
      chips.add(
        Button(
          onPressed: viewModel.didClearEquipment,
          child: Text('장비 $label  해제'),
        ),
      );
    }
    if (query.fromDate != null || query.toDate != null) {
      chips.add(
        _chip(
          '기간 ${DashboardFormatters.date(query.fromDate)} ~ ${DashboardFormatters.date(query.toDate)}',
        ),
      );
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
          '검색 결과 ${DashboardFormatters.count(board.totalCount)}건',
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
