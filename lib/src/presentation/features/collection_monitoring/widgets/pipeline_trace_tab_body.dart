import 'package:fluent_ui/fluent_ui.dart';

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
        ],
      ),
    );
  }
}
