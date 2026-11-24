import 'dart:math' as math;

import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/tool_run.dart';
import '../../../../domain/entities/upload_trace.dart';
import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';
import 'pipeline_stage_chips.dart';
import 'pipeline_trace_graph_view.dart';
import 'pipeline_trace_list.dart';

/// 적재 파이프라인 탭: 칩 + 가로 그래프 + 하단 목록 패널(토글).
class PipelineTraceTabBody extends StatefulWidget {
  const PipelineTraceTabBody({super.key, required this.viewModel});

  final PipelineTraceViewModel viewModel;

  @override
  State<PipelineTraceTabBody> createState() => _PipelineTraceTabBodyState();
}

class _PipelineTraceTabBodyState extends State<PipelineTraceTabBody> {
  /// 하단 목록 펼침 목표 높이. 공간이 부족하면 그래프 min을 남기고 줄어든다.
  static const double _listPanelHeight = 260;
  static const double _graphMinHeight = 160;
  static const double _toggleBarHeight = 32;
  static const double _sectionGap = 6;

  bool _listPanelVisible = true;

  PipelineTraceViewModel get viewModel => widget.viewModel;

  void _toggleListPanel() {
    setState(() {
      _listPanelVisible = !_listPanelVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.SURFACE_RAISED,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PipelineStageChips(viewModel: viewModel),
          if (viewModel.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: InfoBar(
                title: const Text('파이프라인 조회 실패'),
                content: Text(viewModel.errorMessage),
                severity: InfoBarSeverity.error,
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: viewModel.isLoading && viewModel.traces.isEmpty
                ? const Center(child: ProgressRing())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final chrome =
                          _toggleBarHeight +
                          _sectionGap +
                          (_listPanelVisible ? _sectionGap : 0);
                      final listHeight = !_listPanelVisible
                          ? 0.0
                          : math.min(
                              _listPanelHeight,
                              math.max(
                                0.0,
                                constraints.maxHeight -
                                    chrome -
                                    _graphMinHeight,
                              ),
                            );
                      const panelBorder = Color(0xFF3E424A);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: panelBorder),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              clipBehavior: Clip.antiAlias,
                              padding: const EdgeInsets.all(8),
                              child: PipelineTraceGraphView(
                                viewModel: viewModel,
                              ),
                            ),
                          ),
                          const SizedBox(height: _sectionGap),
                          _ListPanelToggleBar(
                            expanded: _listPanelVisible,
                            onToggle: _toggleListPanel,
                          ),
                          if (_listPanelVisible) ...[
                            const SizedBox(height: _sectionGap),
                            SizedBox(
                              height: listHeight,
                              child: _TraceListPanel(viewModel: viewModel),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// 그래프와 목록 사이 접힘 바. 탭하면 하단 목록을 펼치거나 접는다.
class _ListPanelToggleBar extends StatelessWidget {
  const _ListPanelToggleBar({required this.expanded, required this.onToggle});

  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.SURFACE_RAISED,
          border: Border.all(color: const Color(0xFF3E424A)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              expanded ? FluentIcons.chevron_down : FluentIcons.chevron_up,
              size: 12,
              color: AppTheme.STATUS_OFF,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                '수집 이력',
                style: TextStyle(
                  color: AppTheme.INK,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              expanded ? '접기' : '펼치기',
              style: const TextStyle(color: AppTheme.STATUS_OFF, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _TraceListPanel extends StatelessWidget {
  const _TraceListPanel({required this.viewModel});

  final PipelineTraceViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3E424A)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TraceListHeader(viewModel: viewModel),
          const SizedBox(height: 6),
          Expanded(child: PipelineTraceList(viewModel: viewModel)),
          if (viewModel.selected != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                [
                  viewModel.selected!.fileName.isEmpty
                      ? '파이프라인 ${viewModel.selected!.traceId}'
                      : viewModel.selected!.fileName,
                  viewModel.selected!.lastEvent,
                  if (viewModel.selected!.run?.queueWaitLabel.isNotEmpty ==
                      true)
                    viewModel.selected!.run!.queueWaitLabel,
                ].join(' · '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.INK, fontSize: 12),
              ),
            ),
          if (viewModel.doesShowQueueBottleneck)
            Flexible(
              child: SingleChildScrollView(
                child: _QueueBottleneckPanel(viewModel: viewModel),
              ),
            ),
        ],
      ),
    );
  }
}

/// Trace.run 집계 큐 병목. GetQueue를 치지 않는다.
class _QueueBottleneckPanel extends StatelessWidget {
  const _QueueBottleneckPanel({required this.viewModel});

  final PipelineTraceViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final bottlenecks = viewModel.queueBottlenecks;
    final sameQueue = viewModel.sameQueueTraces;
    final selectedRunId = viewModel.selectedRunId;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '큐 병목 (Trace.run)',
            style: TextStyle(
              color: AppTheme.INK,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          for (final item in bottlenecks)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${toolRunQueueDisplayName(item.queue)} · '
                '진행 ${item.running} · 대기 ${item.waiting}',
                style: const TextStyle(color: AppTheme.INK, fontSize: 12),
              ),
            ),
          if (sameQueue.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '같은 큐 · ${toolRunQueueDisplayName(sameQueue.first.run!.queue)}',
              style: const TextStyle(color: AppTheme.STATUS_OFF, fontSize: 11),
            ),
            SizedBox(
              height: 96,
              child: ListView.builder(
                itemCount: sameQueue.length,
                itemBuilder: (context, index) {
                  final trace = sameQueue[index];
                  final run = trace.run!;
                  final isMine =
                      selectedRunId.isNotEmpty && run.runId == selectedRunId;
                  final name = trace.fileName.isEmpty
                      ? '#${trace.traceId}'
                      : trace.fileName;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      [
                        isMine ? '●' : '○',
                        name,
                        'run ${run.runId}',
                        run.status.name,
                        if (run.queueWaitLabel.isNotEmpty) run.queueWaitLabel,
                      ].join(' · '),
                      style: TextStyle(
                        color: isMine ? AppTheme.ACCENT_STEEL : AppTheme.INK,
                        fontSize: 12,
                        fontWeight: isMine ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TraceListHeader extends StatelessWidget {
  const _TraceListHeader({required this.viewModel});

  final PipelineTraceViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final filterKey = _statusFilterKey(viewModel.statusFilter);
    return Row(
      children: [
        Flexible(
          child: ComboBox<String>(
            isExpanded: true,
            value: filterKey,
            items: const [
              ComboBoxItem(value: 'all', child: Text('전체')),
              ComboBoxItem(value: 'running', child: Text('진행')),
              ComboBoxItem(value: 'done', child: Text('완료')),
              ComboBoxItem(value: 'failed', child: Text('실패')),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              viewModel.didSelectStatusFilter(_statusFilterOf(value));
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '최근 ${PipelineTraceViewModel.recentPageSize}',
          style: const TextStyle(color: AppTheme.STATUS_OFF, fontSize: 11),
        ),
      ],
    );
  }
}

String _statusFilterKey(UploadTraceStatus? status) {
  switch (status) {
    case UploadTraceStatus.running:
      return 'running';
    case UploadTraceStatus.done:
      return 'done';
    case UploadTraceStatus.failed:
      return 'failed';
    case null:
      return 'all';
  }
}

UploadTraceStatus? _statusFilterOf(String key) {
  switch (key) {
    case 'running':
      return UploadTraceStatus.running;
    case 'done':
      return UploadTraceStatus.done;
    case 'failed':
      return UploadTraceStatus.failed;
    default:
      return null;
  }
}
