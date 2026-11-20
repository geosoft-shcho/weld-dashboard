import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/tool_run.dart';
import '../../../../domain/entities/upload_trace.dart';
import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';
import 'pipeline_stage_chips.dart';
import 'pipeline_trace_graph_o3d_view.dart';
import 'pipeline_trace_graph_view.dart';
import 'pipeline_trace_list.dart';

enum _PipelineGraphMode { twoD, o3d }

/// 적재 파이프라인 탭: 칩 + 그래프(2D|O3D) + 우측 목록 패널(토글).
class PipelineTraceTabBody extends StatefulWidget {
  const PipelineTraceTabBody({super.key, required this.viewModel});

  final PipelineTraceViewModel viewModel;

  @override
  State<PipelineTraceTabBody> createState() => _PipelineTraceTabBodyState();
}

class _PipelineTraceTabBodyState extends State<PipelineTraceTabBody> {
  static const double _listPanelWidth = 380;

  bool _listPanelVisible = true;
  _PipelineGraphMode _graphMode = _PipelineGraphMode.twoD;

  PipelineTraceViewModel get viewModel => widget.viewModel;

  Widget _graphBody() {
    switch (_graphMode) {
      case _PipelineGraphMode.o3d:
        return PipelineTraceGraphO3dView(viewModel: viewModel);
      case _PipelineGraphMode.twoD:
        return PipelineTraceGraphView(viewModel: viewModel);
    }
  }

  void _cycleGraphMode() {
    setState(() {
      _graphMode = switch (_graphMode) {
        _PipelineGraphMode.twoD => _PipelineGraphMode.o3d,
        _PipelineGraphMode.o3d => _PipelineGraphMode.twoD,
      };
    });
  }

  String get _graphModeLabel => switch (_graphMode) {
        _PipelineGraphMode.twoD => '2D',
        _PipelineGraphMode.o3d => 'O3D',
      };

  String get _graphModeTooltip => switch (_graphMode) {
        _PipelineGraphMode.twoD => '다음: O3D',
        _PipelineGraphMode.o3d => '다음: 2D 그래프',
      };

  IconData get _graphModeIcon => switch (_graphMode) {
        _PipelineGraphMode.twoD => FluentIcons.chart,
        _PipelineGraphMode.o3d => FluentIcons.product,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.SURFACE_RAISED,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: PipelineStageChips(viewModel: viewModel)),
              const SizedBox(width: 8),
              Tooltip(
                message: _graphModeTooltip,
                child: IconButton(
                  icon: Icon(_graphModeIcon, size: 16),
                  onPressed: _cycleGraphMode,
                ),
              ),
              Text(
                _graphModeLabel,
                style: const TextStyle(
                  color: AppTheme.STATUS_OFF,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: _listPanelVisible ? '목록 숨기기' : '목록 보이기',
                child: IconButton(
                  icon: Icon(
                    _listPanelVisible
                        ? FluentIcons.chrome_back_mirrored
                        : FluentIcons.bulleted_list2,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _listPanelVisible = !_listPanelVisible;
                    });
                  },
                ),
              ),
            ],
          ),
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
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _graphBody()),
                      if (_listPanelVisible) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: _listPanelWidth,
                          child: _TraceListPanel(viewModel: viewModel),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
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
            _QueueBottleneckPanel(viewModel: viewModel),
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
        Expanded(
          child: ComboBox<String>(
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
