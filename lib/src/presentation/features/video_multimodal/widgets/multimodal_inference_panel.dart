import 'package:flutter/material.dart';

import '../../work_detail/widgets/work_detail_material_scope.dart';
import '../video_multimodal_view_model.dart';

class MultimodalInferencePanel extends StatelessWidget {
  const MultimodalInferencePanel({super.key, required this.viewModel});

  static const double PANEL_WIDTH = 340;

  final VideoMultimodalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (!viewModel.isInferenceVisible) {
      return const SizedBox.shrink();
    }
    return Positioned(
      left: viewModel.inferenceOffsetX,
      top: viewModel.inferenceOffsetY,
      child: WorkDetailMaterialScope(
        child: Builder(
          builder: (context) {
            final phase = viewModel.inferencePhase;
            final accent = phase == InferencePanelPhase.failed
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary;
            return Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: PANEL_WIDTH,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onPanUpdate: (details) => viewModel.didMoveInference(
                  details.delta.dx,
                  details.delta.dy,
                ),
                child: Container(
                  height: 40,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.drag_indicator, size: 18),
                      const SizedBox(width: 4),
                      if (phase == InferencePanelPhase.running)
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: accent,
                          ),
                        )
                      else
                        Icon(
                          phase == InferencePanelPhase.failed
                              ? Icons.error_outline
                              : Icons.check_circle_outline,
                          size: 16,
                          color: accent,
                        ),
                      const SizedBox(width: 6),
                      const Expanded(child: Text('추론 진행')),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: viewModel.didToggleInferenceMinimized,
                        icon: Icon(
                          viewModel.isInferenceMinimized
                              ? Icons.unfold_more
                              : Icons.unfold_less,
                          size: 18,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: viewModel.didCloseInference,
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
              if (!viewModel.isInferenceMinimized)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(viewModel.inferenceModelName),
                      const SizedBox(height: 8),
                      Text(_phaseLabel(phase)),
                      if (phase == InferencePanelPhase.running) ...[
                        const SizedBox(height: 8),
                        const LinearProgressIndicator(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: viewModel.didCancelInference,
                            child: const Text('취소'),
                          ),
                        ),
                      ],
                      if (phase == InferencePanelPhase.done)
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton(
                            onPressed: viewModel.didApplyInference,
                            child: const Text('적용'),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
          );
          },
        ),
      ),
    );
  }

  String _phaseLabel(InferencePanelPhase phase) {
    switch (phase) {
      case InferencePanelPhase.running:
        return '실행 중';
      case InferencePanelPhase.done:
        return '완료';
      case InferencePanelPhase.failed:
        return '실패';
      case InferencePanelPhase.hidden:
        return '';
    }
  }
}
