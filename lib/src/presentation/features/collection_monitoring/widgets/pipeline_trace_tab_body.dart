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
          if (viewModel.doesShowQueueFront)
            _QueueFrontPanel(viewModel: viewModel),
        ],
      ),
    );
  }
}

class _QueueFrontPanel extends StatelessWidget {
  const _QueueFrontPanel({required this.viewModel});

  final PipelineTraceViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final queue = viewModel.selectedQueue;
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
            Text(
              queue == null
                  ? '대기열 앞줄'
                  : '${toolRunQueueDisplayName(queue.queue)} · '
                        '워커 ${queue.workers} · '
                        '진행 ${queue.running} · '
                        '대기 ${queue.waiting}',
              style: const TextStyle(
                color: AppTheme.INK,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (viewModel.queueError.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                viewModel.queueError,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ] else if (viewModel.queueEmptyMessage.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                viewModel.queueEmptyMessage,
                style: const TextStyle(
                  color: AppTheme.STATUS_OFF,
                  fontSize: 12,
                ),
              ),
            ] else if (queue == null || queue.runs.isEmpty) ...[
              const SizedBox(height: 4),
              const Text(
                '대기열에 run이 없습니다.',
                style: TextStyle(color: AppTheme.STATUS_OFF, fontSize: 12),
              ),
            ] else
              SizedBox(
                height: 96,
                child: ListView.builder(
                  itemCount: queue.runs.length,
                  itemBuilder: (context, index) {
                    final run = queue.runs[index];
                    final isMine =
                        selectedRunId.isNotEmpty && run.runId == selectedRunId;
                    final wait = _waitAgeLabel(run.createdAt);
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        [
                          isMine ? '●' : '○',
                          'run ${run.runId}',
                          run.status.name,
                          if (run.queueWaitLabel.isNotEmpty) run.queueWaitLabel,
                          if (wait.isNotEmpty) wait,
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
        ),
      ),
    );
  }
}

String _waitAgeLabel(DateTime? createdAt) {
  if (createdAt == null) {
    return '';
  }
  final seconds = DateTime.now().difference(createdAt).inSeconds;
  if (seconds < 0) {
    return '';
  }
  if (seconds < 60) {
    return '$seconds초 대기';
  }
  final minutes = seconds ~/ 60;
  if (minutes < 60) {
    return '$minutes분 대기';
  }
  return '${minutes ~/ 60}시간 대기';
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
