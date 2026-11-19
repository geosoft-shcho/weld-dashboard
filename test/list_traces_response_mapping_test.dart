import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/trace/v1/trace.pb.dart'
    as trace_pb;
import 'package:weld_dashboard/src/data/repositories/remote_trace_repository.dart';
import 'package:weld_dashboard/src/domain/entities/pipeline_trace_graph.dart';
import 'package:weld_dashboard/src/domain/entities/upload_trace.dart';
import 'package:weld_dashboard/src/domain/repositories/trace_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/trace_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart';

void main() {
  test('empty ListTraces JSON stays empty', () {
    final response = trace_pb.ListTracesResponse()..mergeFromProto3Json({});
    expect(traceSnapshotsFromListResponse(response), isEmpty);
  });

  test('server-shaped ListTraces JSON maps to TraceSnapshot list', () {
    final response = trace_pb.ListTracesResponse()
      ..mergeFromProto3Json({
        'traces': [
          {
            'traceId': '20',
            'source': 'upload',
            'fileName':
                '5-7.비디오_멀티모달_카메라녹화_저장_완료_타임라인뷰.png',
            'totalBytes': '2978635',
            'receivedBytes': '2978635',
            'assetId': '23715',
            'lastEvent': 'done.stored',
            'status': 'TRACE_STATUS_DONE',
            'createdAt': '2026-11-17T06:33:34.600510Z',
            'updatedAt': '2026-11-17T06:33:34.824852Z',
          },
          {
            'traceId': '7',
            'source': 'upload',
            'fileName': 'running.bin',
            'totalBytes': '100',
            'receivedBytes': '40',
            'assetId': '0',
            'lastEvent': 'receive.done',
            'status': 'TRACE_STATUS_RUNNING',
            'progressPercent': 40,
          },
          {
            'traceId': '3',
            'source': 'upload',
            'fileName': 'failed.bin',
            'lastEvent': 'postprocess.run',
            'status': 'TRACE_STATUS_FAILED',
            'errorMessage': 'boom',
          },
        ],
        'nextPageToken': '3',
      });

    final listed = traceSnapshotsFromListResponse(response);
    expect(listed, hasLength(3));

    expect(listed[0].traceId, '20');
    expect(listed[0].fileName, contains('타임라인뷰'));
    expect(listed[0].lastEvent, 'done.stored');
    expect(listed[0].status, UploadTraceStatus.done);
    expect(listed[0].stageId, 'done');

    expect(listed[1].traceId, '7');
    expect(listed[1].status, UploadTraceStatus.running);
    expect(listed[1].progressPercent, 40);
    expect(listed[1].stageId, 'receive');

    expect(listed[2].traceId, '3');
    expect(listed[2].status, UploadTraceStatus.failed);
    expect(listed[2].errorMessage, 'boom');
    expect(listed[2].stageId, 'postprocess');

    expect(pipelineStageCounts(listed)['done'], 1);
    expect(pipelineStageCounts(listed)['receive'], 1);
    expect(pipelineStageCounts(listed)['postprocess'], 1);
  });

  test('PipelineTraceViewModel keeps DONE traces in visibleTraces', () async {
    final repo = _FakeTraceRepository([
      const TraceSnapshot(
        traceId: '20',
        fileName: 'a.png',
        lastEvent: 'done.stored',
        status: UploadTraceStatus.done,
        errorMessage: '',
      ),
      const TraceSnapshot(
        traceId: '7',
        fileName: 'b.bin',
        lastEvent: 'receive.done',
        status: UploadTraceStatus.running,
        errorMessage: '',
      ),
    ]);
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(repo),
    );

    await viewModel.refresh();

    expect(viewModel.traces, hasLength(2));
    expect(viewModel.visibleTraces, hasLength(2));
    // ListTraces 순서 유지: DONE이 앞이면 RUNNING이 뒤로 남는다.
    expect(
      viewModel.visibleTraces.map((t) => t.traceId).toList(),
      ['20', '7'],
    );
    expect(viewModel.stageCounts['done'], 1);
    expect(viewModel.stageCounts['receive'], 1);
    expect(viewModel.hasError, isFalse);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.statusFilter, isNull);
    expect(repo.lastStatus, isNull);
    expect(repo.lastPageSize, PipelineTraceViewModel.recentPageSize);

    viewModel.dispose();
  });

  test('PipelineTraceViewModel passes status filter to ListTraces', () async {
    final repo = _FakeTraceRepository([
      const TraceSnapshot(
        traceId: '7',
        fileName: 'b.bin',
        lastEvent: 'receive.done',
        status: UploadTraceStatus.running,
        errorMessage: '',
      ),
    ]);
    final viewModel = PipelineTraceViewModel(
      traceUseCase: TraceUseCase(repo),
    );

    await viewModel.refresh();
    expect(repo.lastStatus, isNull);

    await viewModel.didSelectStatusFilter(UploadTraceStatus.running);
    expect(viewModel.statusFilter, UploadTraceStatus.running);
    expect(repo.lastStatus, UploadTraceStatus.running);
    expect(repo.lastPageSize, PipelineTraceViewModel.recentPageSize);

    await viewModel.didSelectStatusFilter(UploadTraceStatus.done);
    expect(repo.lastStatus, UploadTraceStatus.done);

    await viewModel.didSelectStatusFilter(null);
    expect(repo.lastStatus, isNull);

    viewModel.dispose();
  });
}

class _FakeTraceRepository implements TraceRepository {
  _FakeTraceRepository(this._traces);

  final List<TraceSnapshot> _traces;
  UploadTraceStatus? lastStatus;
  int? lastPageSize;

  @override
  Future<List<TraceSnapshot>> listTraces({
    int pageSize = 50,
    UploadTraceStatus? status,
  }) async {
    lastPageSize = pageSize;
    lastStatus = status;
    if (status == null) {
      return _traces;
    }
    return [
      for (final trace in _traces)
        if (trace.status == status) trace,
    ];
  }

  @override
  Future<TraceSnapshot> getTrace({required String traceId}) async {
    for (final trace in _traces) {
      if (trace.traceId == traceId) {
        return trace;
      }
    }
    throw const TraceException('not found');
  }
}
