import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/upload_trace.dart';
import 'package:weld_dashboard/src/domain/repositories/trace_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/trace_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart';

void main() {
  test('refresh calls GetTrace for RUNNING and merges events into traces',
      () async {
    final repo = _RecordingTraceRepository(
      listed: const [
        TraceSnapshot(
          traceId: '20',
          fileName: 'done.png',
          lastEvent: 'done.stored',
          status: UploadTraceStatus.done,
          errorMessage: '',
        ),
        TraceSnapshot(
          traceId: '7',
          fileName: 'run.bin',
          lastEvent: 'receive.done',
          status: UploadTraceStatus.running,
          errorMessage: '',
        ),
      ],
      details: {
        '7': const TraceSnapshot(
          traceId: '7',
          fileName: 'run.bin',
          lastEvent: 'register.stored',
          status: UploadTraceStatus.running,
          errorMessage: '',
          events: [
            TraceEventSnapshot(name: 'receive.started', status: 'ok'),
            TraceEventSnapshot(name: 'receive.done', status: 'ok'),
            TraceEventSnapshot(name: 'register.stored', status: 'ok'),
          ],
        ),
      },
    );
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(repo),
    );

    await viewModel.refresh();

    expect(repo.listCallCount, 1);
    expect(repo.getTraceIds, ['7']);
    final running = viewModel.traces.firstWhere((t) => t.traceId == '7');
    expect(running.events, hasLength(3));
    expect(running.lastEvent, 'register.stored');
    expect(
      viewModel.traces.firstWhere((t) => t.traceId == '20').events,
      isEmpty,
    );

    viewModel.dispose();
  });

  test('selected DONE also gets GetTrace on refresh', () async {
    final repo = _RecordingTraceRepository(
      listed: const [
        TraceSnapshot(
          traceId: '20',
          fileName: 'done.png',
          lastEvent: 'done.stored',
          status: UploadTraceStatus.done,
          errorMessage: '',
        ),
      ],
      details: {
        '20': const TraceSnapshot(
          traceId: '20',
          fileName: 'done.png',
          lastEvent: 'done.stored',
          status: UploadTraceStatus.done,
          errorMessage: '',
          events: [
            TraceEventSnapshot(name: 'receive.done', status: 'ok'),
            TraceEventSnapshot(name: 'done.stored', status: 'ok'),
          ],
        ),
      },
    );
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(repo),
    );

    await viewModel.didSelectTrace('20');
    repo.getTraceIds.clear();
    await viewModel.refresh();

    expect(repo.getTraceIds, ['20']);
    expect(viewModel.selected?.events, hasLength(2));
    expect(viewModel.traces.single.events, hasLength(2));

    viewModel.dispose();
  });

  test('keeps prior events when DONE is no longer GetTrace-enriched', () async {
    final repo = _RecordingTraceRepository(
      listed: const [
        TraceSnapshot(
          traceId: '7',
          fileName: 'run.bin',
          lastEvent: 'receive.done',
          status: UploadTraceStatus.running,
          errorMessage: '',
        ),
      ],
      details: {
        '7': const TraceSnapshot(
          traceId: '7',
          fileName: 'run.bin',
          lastEvent: 'receive.done',
          status: UploadTraceStatus.running,
          errorMessage: '',
          events: [
            TraceEventSnapshot(name: 'receive.started', status: 'ok'),
            TraceEventSnapshot(name: 'receive.done', status: 'ok'),
          ],
        ),
      },
    );
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(repo),
    );

    await viewModel.refresh();
    expect(viewModel.traces.single.events, hasLength(2));

    repo.listed = const [
      TraceSnapshot(
        traceId: '7',
        fileName: 'run.bin',
        lastEvent: 'done.stored',
        status: UploadTraceStatus.done,
        errorMessage: '',
      ),
    ];
    repo.details = {};
    repo.getTraceIds.clear();
    await viewModel.refresh();

    expect(repo.getTraceIds, isEmpty);
    expect(viewModel.traces.single.status, UploadTraceStatus.done);
    expect(viewModel.traces.single.events, hasLength(2));

    viewModel.dispose();
  });
}

class _RecordingTraceRepository implements TraceRepository {
  _RecordingTraceRepository({
    required this.listed,
    required this.details,
  });

  List<TraceSnapshot> listed;
  Map<String, TraceSnapshot> details;
  int listCallCount = 0;
  final List<String> getTraceIds = [];

  @override
  Future<List<TraceSnapshot>> listTraces({
    int pageSize = 50,
    UploadTraceStatus? status,
  }) async {
    listCallCount++;
    if (status == null) {
      return listed;
    }
    return [
      for (final trace in listed)
        if (trace.status == status) trace,
    ];
  }

  @override
  Future<TraceSnapshot> getTrace({required String traceId}) async {
    getTraceIds.add(traceId);
    final detail = details[traceId];
    if (detail == null) {
      throw const TraceException('not found');
    }
    return detail;
  }
}
