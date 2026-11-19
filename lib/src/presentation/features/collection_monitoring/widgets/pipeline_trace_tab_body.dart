import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/tool_run.dart';
import '../../../../domain/entities/upload_trace.dart';
import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';
import 'pipeline_stage_chips.dart';
import 'pipeline_trace_graph_view.dart';
import 'pipeline_trace_list.dart';

/// 적재 파이프라인 탭: 칩 + 가로 스테퍼 + 파이프라인 목록.
class PipelineTraceTabBody extends StatelessWidget {
  const PipelineTraceTabBody({super.key, required this.viewModel});

  final PipelineTraceViewModel viewModel;

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
          // 스테퍼는 위쪽 가변, ListTraces는 고정 높이 로그 패널.
          Expanded(
            child: viewModel.isLoading && viewModel.traces.isEmpty
                ? const Center(child: ProgressRing())
                : SingleChildScrollView(
                    child: PipelineTraceGraphView(viewModel: viewModel),
                  ),
          ),
          const SizedBox(height: 8),
          _TraceListHeader(viewModel: viewModel),
          const SizedBox(height: 4),
          SizedBox(height: 168, child: PipelineTraceList(viewModel: viewModel)),
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

/// Trace.run 집계 큐 병목. GetQueue를 쓰지 않는다.
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
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF3E424A)),
          borderRadius: BorderRadius.circular(4),
        ),
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
                style: const TextStyle(
                  color: AppTheme.STATUS_OFF,
                  fontSize: 11,
                ),
              ),
              SizedBox(
                height: 96,
                child: ListView.builder(
                  itemCount: sameQueue.length,
                  itemBuilder: (context, index) {
                    final trace = sameQueue[index];
                    final run = trace.run!;
                    final isMine = selectedRunId.isNotEmpty &&
                        run.runId == selectedRunId;
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
                          fontWeight:
                              isMine ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
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
        SizedBox(
          width: 120,
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
        const SizedBox(width: 10),
        Text(
          '최근 ${PipelineTraceViewModel.recentPageSize}건',
          style: const TextStyle(
            color: AppTheme.STATUS_OFF,
            fontSize: 12,
          ),
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
