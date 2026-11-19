import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/entities/upload_trace.dart';
import 'package:weld_dashboard/src/domain/repositories/tool_run_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/trace_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/tool_run_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/trace_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart';

void main() {
  test('toolRunQueueMatching finds same queue name', () {
    const queues = [
      ToolRunQueue(queue: 'work', workers: 1, running: 0, waiting: 0),
      ToolRunQueue(
        queue: 'postprocess',
        workers: 2,
        running: 1,
        waiting: 1,
        runs: [
          ToolRunSnapshot(
            runId: '9',
            toolId: '',
            status: ToolRunStatus.queued,
            errorMessage: '',
            stage: 'postprocess',
            queue: 'postprocess',
          ),
        ],
      ),
    ];
    final matched = toolRunQueueMatching(queues, 'postprocess');
    expect(matched?.queue, 'postprocess');
    expect(matched?.runs.single.runId, '9');
    expect(toolRunQueueMatching(queues, 'missing'), isNull);
  });

  test('select with run.queue loads matching GetQueue front line', () async {
    final traceRepo = _TraceRepo(
      listed: const [
        TraceSnapshot(
          traceId: '7',
          fileName: 'a.bin',
          lastEvent: 'postprocess.run',
          status: UploadTraceStatus.running,
          errorMessage: '',
          run: ToolRunSnapshot(
            runId: '91',
            toolId: '',
            status: ToolRunStatus.queued,
            errorMessage: '',
            stage: 'postprocess',
            queue: 'postprocess',
            waitReason: ToolRunWaitReason.queueAhead,
            waitAhead: 1,
          ),
        ),
      ],
      details: {
        '7': const TraceSnapshot(
          traceId: '7',
          fileName: 'a.bin',
          lastEvent: 'postprocess.run',
          status: UploadTraceStatus.running,
          errorMessage: '',
          run: ToolRunSnapshot(
            runId: '91',
            toolId: '',
            status: ToolRunStatus.queued,
            errorMessage: '',
            stage: 'postprocess',
            queue: 'postprocess',
            waitReason: ToolRunWaitReason.queueAhead,
            waitAhead: 1,
          ),
          events: [
            TraceEventSnapshot(name: 'postprocess.run', status: 'queued'),
          ],
        ),
      },
    );
    final toolRepo = _ToolRepo(
      queues: const [
        ToolRunQueue(
          queue: 'postprocess',
          workers: 2,
          running: 0,
          waiting: 2,
          runs: [
            ToolRunSnapshot(
              runId: '90',
              toolId: '',
              status: ToolRunStatus.queued,
              errorMessage: '',
              queue: 'postprocess',
            ),
            ToolRunSnapshot(
              runId: '91',
              toolId: '',
              status: ToolRunStatus.queued,
              errorMessage: '',
              queue: 'postprocess',
            ),
          ],
        ),
        ToolRunQueue(queue: 'work', workers: 2, running: 0, waiting: 0),
      ],
    );
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(traceRepo),
      toolRunUseCase: ToolRunUseCase(toolRepo),
    );

    await viewModel.didSelectTrace('7');

    expect(toolRepo.getQueueCount, 1);
    expect(viewModel.doesShowQueueFront, isTrue);
    expect(viewModel.selectedQueue?.queue, 'postprocess');
    expect(viewModel.queueFrontRuns.map((r) => r.runId), ['90', '91']);
    expect(viewModel.selectedRunId, '91');
    expect(viewModel.queueError, isEmpty);
    expect(viewModel.selected?.run?.queueWaitLabel, contains('앞 1건'));

    viewModel.dispose();
  });

  test('GetQueue failure keeps wait label and sets queueError', () async {
    final traceRepo = _TraceRepo(
      listed: const [],
      details: {
        '7': const TraceSnapshot(
          traceId: '7',
          fileName: 'a.bin',
          lastEvent: 'postprocess.run',
          status: UploadTraceStatus.running,
          errorMessage: '',
          run: ToolRunSnapshot(
            runId: '91',
            toolId: '',
            status: ToolRunStatus.queued,
            errorMessage: '',
            stage: 'postprocess',
            queue: 'postprocess',
            waitReason: ToolRunWaitReason.queueAhead,
            waitAhead: 2,
          ),
        ),
      },
    );
    final toolRepo = _ToolRepo(failQueue: true);
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(traceRepo),
      toolRunUseCase: ToolRunUseCase(toolRepo),
    );

    await viewModel.didSelectTrace('7');

    expect(viewModel.selected?.run?.queueWaitLabel, isNotEmpty);
    expect(viewModel.selectedQueue, isNull);
    expect(viewModel.queueError, '대기열을 불러오지 못했습니다.');

    viewModel.dispose();
  });

  test('missing queue name leaves empty message', () async {
    final traceRepo = _TraceRepo(
      listed: const [],
      details: {
        '7': const TraceSnapshot(
          traceId: '7',
          fileName: 'a.bin',
          lastEvent: 'postprocess.run',
          status: UploadTraceStatus.running,
          errorMessage: '',
          run: ToolRunSnapshot(
            runId: '91',
            toolId: '',
            status: ToolRunStatus.queued,
            errorMessage: '',
            queue: 'postprocess',
          ),
        ),
      },
    );
    final toolRepo = _ToolRepo(
      queues: const [
        ToolRunQueue(queue: 'work', workers: 1, running: 0, waiting: 0),
      ],
    );
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(traceRepo),
      toolRunUseCase: ToolRunUseCase(toolRepo),
    );

    await viewModel.didSelectTrace('7');

    expect(viewModel.selectedQueue, isNull);
    expect(viewModel.queueEmptyMessage, '같은 이름의 대기열이 없습니다.');
    expect(viewModel.queueError, isEmpty);

    viewModel.dispose();
  });

  test('refresh without select loads GetQueue for RUNNING+queue', () async {
    final listed = const [
      TraceSnapshot(
        traceId: '7',
        fileName: 'a.bin',
        lastEvent: 'postprocess.run',
        status: UploadTraceStatus.running,
        errorMessage: '',
        run: ToolRunSnapshot(
          runId: '91',
          toolId: '',
          status: ToolRunStatus.queued,
          errorMessage: '',
          stage: 'postprocess',
          queue: 'postprocess',
          waitReason: ToolRunWaitReason.queueAhead,
          waitAhead: 1,
        ),
      ),
    ];
    final traceRepo = _TraceRepo(
      listed: listed,
      details: {
        '7': TraceSnapshot(
          traceId: '7',
          fileName: 'a.bin',
          lastEvent: 'postprocess.run',
          status: UploadTraceStatus.running,
          errorMessage: '',
          run: listed.single.run,
          events: const [
            TraceEventSnapshot(name: 'postprocess.run', status: 'queued'),
          ],
        ),
      },
    );
    final toolRepo = _ToolRepo(
      queues: const [
        ToolRunQueue(
          queue: 'postprocess',
          workers: 2,
          running: 0,
          waiting: 2,
          runs: [
            ToolRunSnapshot(
              runId: '90',
              toolId: '',
              status: ToolRunStatus.queued,
              errorMessage: '',
              queue: 'postprocess',
            ),
            ToolRunSnapshot(
              runId: '91',
              toolId: '',
              status: ToolRunStatus.queued,
              errorMessage: '',
              queue: 'postprocess',
            ),
          ],
        ),
      ],
    );
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(traceRepo),
      toolRunUseCase: ToolRunUseCase(toolRepo),
    );

    await viewModel.refresh();

    expect(viewModel.selected, isNull);
    expect(toolRepo.getQueueCount, 1);
    expect(viewModel.doesShowQueueFront, isTrue);
    expect(viewModel.selectedQueue?.queue, 'postprocess');
    expect(viewModel.selectedRunId, '91');
    expect(viewModel.traces.single.run?.queueWaitLabel, contains('앞 1건'));

    viewModel.dispose();
  });

  test('refresh without RUNNING+queue still loads default postprocess',
      () async {
    final traceRepo = _TraceRepo(
      listed: const [
        TraceSnapshot(
          traceId: '1',
          fileName: 'done.bin',
          lastEvent: 'done.searchable',
          status: UploadTraceStatus.done,
          errorMessage: '',
        ),
      ],
      details: const {},
    );
    final toolRepo = _ToolRepo(
      queues: const [
        ToolRunQueue(queue: 'postprocess', workers: 2, running: 0, waiting: 0),
        ToolRunQueue(queue: 'work', workers: 2, running: 0, waiting: 0),
      ],
    );
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(traceRepo),
      toolRunUseCase: ToolRunUseCase(toolRepo),
    );

    await viewModel.refresh();

    expect(viewModel.selected, isNull);
    expect(toolRepo.getQueueCount, 1);
    expect(viewModel.doesShowQueueFront, isTrue);
    expect(viewModel.selectedQueue?.queue, 'postprocess');
    expect(viewModel.selectedQueue?.workers, 2);
    expect(viewModel.selectedRunId, isEmpty);
    expect(viewModel.queueFrontRuns, isEmpty);

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
  Future<TraceSnapshot> getTrace({required String traceId}) async {
    final detail = details[traceId];
    if (detail == null) {
      throw const TraceException('not found');
    }
    return detail;
  }
}

class _ToolRepo implements ToolRunRepository {
  _ToolRepo({this.queues = const [], this.failQueue = false});

  final List<ToolRunQueue> queues;
  final bool failQueue;
  int getQueueCount = 0;

  @override
  Future<List<ToolRunQueue>> getQueue() async {
    getQueueCount++;
    if (failQueue) {
      throw const ToolRunException('대기열을 불러오지 못했습니다.');
    }
    return queues;
  }

  @override
  Future<ToolRunSnapshot> cancelRun({required String runId}) {
    throw UnimplementedError();
  }

  @override
  Future<ToolRunSnapshot> getRun({required String runId}) {
    throw UnimplementedError();
  }

  @override
  Future<List<InferenceTool>> listEnabledTools({bool includeDisabled = false}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ToolRunSnapshot>> listJobRuns({required String jobId}) {
    throw UnimplementedError();
  }

  @override
  Future<ToolRunSnapshot> startRun({
    required String toolId,
    required ToolRunTargetKind kind,
    required String targetId,
  }) {
    throw UnimplementedError();
  }
}
