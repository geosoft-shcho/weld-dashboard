import 'dart:math' as math;

import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/upload_trace.dart';
import '../../../core/themes/app_theme.dart';
import '../pipeline_trace_view_model.dart';

/// ListTraces 파이프라인 로그. 터미널처럼 조밀한 한 줄.
class PipelineTraceList extends StatefulWidget {
  const PipelineTraceList({super.key, required this.viewModel});

  final PipelineTraceViewModel viewModel;

  @override
  State<PipelineTraceList> createState() => _PipelineTraceListState();
}

class _PipelineTraceListState extends State<PipelineTraceList>
    with SingleTickerProviderStateMixin {
  static const _mono = TextStyle(
    fontFamily: 'Menlo',
    fontFamilyFallback: ['Consolas', 'Courier New', 'monospace'],
    fontSize: 11,
    height: 1.25,
    color: AppTheme.INK,
  );

  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final traces = widget.viewModel.visibleTraces;
    if (traces.isEmpty) {
      return const ColoredBox(
        color: AppTheme.SURFACE,
        child: Center(
          child: Text(
            '표시할 파이프라인이 없습니다.',
            style: TextStyle(
              fontFamily: 'Menlo',
              fontFamilyFallback: ['Consolas', 'Courier New', 'monospace'],
              fontSize: 11,
              color: AppTheme.STATUS_OFF,
            ),
          ),
        ),
      );
    }
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemExtent: 22,
            itemCount: traces.length,
            itemBuilder: (context, index) {
              final trace = traces[index];
              final selected =
                  widget.viewModel.selected?.traceId == trace.traceId;
              final live = trace.status == UploadTraceStatus.running;
              final pulse =
                  live ? 0.45 + 0.55 * math.sin(_pulse.value * math.pi * 2) : 0.0;
              final statusColor = _statusColor(trace.status);
              final name = trace.fileName.isEmpty
                  ? '파이프라인 ${trace.traceId}'
                  : trace.fileName;
              final wait = trace.run?.queueWaitLabel.trim() ?? '';
              final event = [
                if (trace.lastEvent.trim().isNotEmpty) trace.lastEvent.trim(),
                if (wait.isNotEmpty) wait,
              ].join(' · ');
              final progressLabel = _progressLabel(trace.progressPercent);
              return HoverButton(
                onPressed: () =>
                    widget.viewModel.didSelectTrace(trace.traceId),
                builder: (context, states) {
                  final hovered = states.isHovered;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    color: selected
                        ? AppTheme.ACCENT_STEEL.withValues(alpha: 0.2)
                        : hovered
                            ? AppTheme.SURFACE_RAISED.withValues(alpha: 0.55)
                            : index.isOdd
                                ? AppTheme.ROW_STRIPE
                                : const Color(0x00000000),
                    child: Row(
                      children: [
                        Text(
                          '›',
                          style: _mono.copyWith(
                            color: selected
                                ? AppTheme.ACCENT_STEEL
                                : AppTheme.STATUS_OFF.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor.withValues(
                              alpha: live ? 0.55 + 0.45 * pulse : 1,
                            ),
                            boxShadow: live
                                ? [
                                    BoxShadow(
                                      color: statusColor.withValues(
                                        alpha: 0.35 + 0.4 * pulse,
                                      ),
                                      blurRadius: 3,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 36,
                          child: Text(
                            _statusTag(trace.status),
                            style: _mono.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 52,
                          child: Text(
                            '#${trace.traceId}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _mono.copyWith(
                              color: AppTheme.STATUS_OFF,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _mono.copyWith(
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            progressLabel,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: _mono.copyWith(
                              color: progressLabel == '—'
                                  ? AppTheme.STATUS_OFF.withValues(alpha: 0.55)
                                  : AppTheme.ACCENT_STEEL,
                              fontWeight: progressLabel == '—'
                                  ? FontWeight.w400
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Text(
                            event.isEmpty ? '—' : event,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: _mono.copyWith(
                              color: AppTheme.INK.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Trace.progressPercent. 수신 중 등 >0일 때만 `N%`.
  String _progressLabel(double progressPercent) {
    if (progressPercent <= 0) {
      return '—';
    }
    final clamped = progressPercent > 100 ? 100.0 : progressPercent;
    return '${clamped.round()}%';
  }

  String _statusTag(UploadTraceStatus status) {
    switch (status) {
      case UploadTraceStatus.running:
        return 'RUN';
      case UploadTraceStatus.done:
        return 'OK';
      case UploadTraceStatus.failed:
        return 'ERR';
    }
  }

  Color _statusColor(UploadTraceStatus status) {
    switch (status) {
      case UploadTraceStatus.running:
        return AppTheme.ACCENT_STEEL;
      case UploadTraceStatus.done:
        return AppTheme.STATUS_OK;
      case UploadTraceStatus.failed:
        return AppTheme.STATUS_ERROR;
    }
  }
}
