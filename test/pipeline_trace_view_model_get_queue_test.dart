import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/pipeline_trace_graph.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/entities/upload_trace.dart';
import 'package:weld_dashboard/src/domain/repositories/trace_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/trace_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart';

void main() {
  test('traceQueueBottlenecks counts running and waiting by queue', () {
    final bottlenecks = traceQueueBottlenecks(const [
      TraceSnapshot(
        traceId: '1',
        fileName: 'a.mp4',
        lastEvent: 'postprocess.run',
        status: UploadTraceStatus.running,
        errorMessage: '',
        run: ToolRunSnapshot(
          runId: '10',
          toolId: '',
          status: ToolRunStatus.running,
          errorMessage: '',
          stage: 'postprocess',
          queue: 'postprocess',
          progressPercent: 40,
        ),
      ),
      TraceSnapshot(
        traceId: '2',
        fileName: 'b.mp4',
        lastEvent: 'postprocess.run',
        status: UploadTraceStatus.running,
        errorMessage: '',
        run: ToolRunSnapshot(
          runId: '11',
          toolId: '',
          status: ToolRunStatus.queued,
          errorMessage: '',
          stage: 'postprocess',
          queue: 'postprocess',
          waitReason: ToolRunWaitReason.queueAhead,
          waitAhead: 1,
        ),
      ),
      TraceSnapshot(
        traceId: '3',
        fileName: 'c.bin',
        lastEvent: 'done.searchable',
        status: UploadTraceStatus.done,
        errorMessage: '',
      ),
    ]);

    expect(bottlenecks, hasLength(1));
    expect(bottlenecks.single.queue, 'postprocess');
    expect(bottlenecks.single.running, 1);
    expect(bottlenecks.single.waiting, 1);
  });

  test('tracesInSameQueueOldestFirst orders by run.createdAt', () {
    final older = DateTime.utc(2026, 11, 19, 2, 0);
    final newer = DateTime.utc(2026, 11, 19, 3, 0);
    final ordered = tracesInSameQueueOldestFirst(
      [
        TraceSnapshot(
          traceId: '104',
          fileName: 'new.mp4',
          lastEvent: 'postprocess.run',
          status: UploadTraceStatus.running,
          errorMessage: '',
          run: ToolRunSnapshot(
            runId: '2395',
            toolId: '',
            status: ToolRunStatus.running,
            errorMessage: '',
            stage: 'postprocess',
            queue: 'postprocess',
            createdAt: newer,
          ),
        ),
        TraceSnapshot(
          traceId: '100',
          fileName: 'old.mp4',
          lastEvent: 'postprocess.run',
          status: UploadTraceStatus.running,
          errorMessage: '',
          run: ToolRunSnapshot(
            runId: '2390',
            toolId: '',
            status: ToolRunStatus.running,
            errorMessage: '',
            stage: 'postprocess',
            queue: 'postprocess',
            progressPercent: 55,
            createdAt: older,
          ),
        ),
      ],
      'postprocess',
    );

    expect(ordered.map((t) => t.traceId), ['100', '104']);
  });

  test('refresh builds queue bottlenecks from Trace.run without GetQueue',
      () async {
    final listed = [
      TraceSnapshot(
        traceId: '104',
        fileName: 'actioncam.mp4',
        lastEvent: 'postprocess.run',
        status: UploadTraceStatus.running,
        errorMessage: '',
        run: ToolRunSnapshot(
          runId: '2395',
          toolId: '',
          status: ToolRunStatus.running,
          errorMessage: '',
          stage: 'postprocess',
          queue: 'postprocess',
          createdAt: DateTime.utc(2026, 11, 19, 2, 37),
        ),
      ),
      TraceSnapshot(
        traceId: '103',
        fileName: 'ahead.mp4',
        lastEvent: 'postprocess.run',
        status: UploadTraceStatus.running,
        errorMessage: '',
        run: ToolRunSnapshot(
          runId: '2394',
          toolId: '',
          status: ToolRunStatus.running,
          errorMessage: '',
          stage: 'postprocess',
          queue: 'postprocess',
          progressPercent: 55,
          createdAt: DateTime.utc(2026, 11, 19, 2, 30),
        ),
      ),
    ];
    final details = {
      for (final trace in listed)
        trace.traceId: TraceSnapshot(
          traceId: trace.traceId,
          fileName: trace.fileName,
          lastEvent: trace.lastEvent,
          status: trace.status,
          errorMessage: '',
          run: trace.run,
          events: const [
            TraceEventSnapshot(name: 'postprocess.run', status: 'running'),
          ],
        ),
    };
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(_TraceRepo(listed: listed, details: details)),
    );

    await viewModel.refresh();
    await viewModel.didSelectTrace('104');

    expect(viewModel.doesShowQueueBottleneck, isTrue);
    expect(viewModel.queueBottlenecks.single.queue, 'postprocess');
    expect(viewModel.queueBottlenecks.single.running, 2);
    expect(viewModel.sameQueueTraces.map((t) => t.traceId), ['103', '104']);
    expect(viewModel.selectedRunId, '2395');
    expect(viewModel.selected?.run?.queue, 'postprocess');

    viewModel.dispose();
  });
}

class _TraceRepo implements TraceRepository {
  _TraceRepo({required this.listed, required this.details});

  List<TraceSnapshot> listed;
  Map<String, TraceSnapshot> details;

  @override
  Future<List<TraceSnapshot>> listTraces({
    int pageSize = 50,
    UploadTraceStatus? status,
  }) async =>
      listed;

  @override
  
  @override
  Future<int> countTraces({required UploadTraceStatus status}) async => 0;

  Future<TraceSnapshot> getTrace({required String traceId}) async {
    final detail = details[traceId];
    if (detail == null) {
      throw const TraceException('not found');
    }
    return detail;
  }
}
