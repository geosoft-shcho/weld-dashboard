import 'package:connectrpc/connect.dart';

import '../../domain/entities/upload_trace.dart';
import '../../domain/repositories/trace_repository.dart';
import '../datasources/generated/mediatag/trace/v1/trace.pb.dart' as trace_pb;
import '../datasources/generated/mediatag/trace/v1/trace.pbenum.dart'
    as trace_enum;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';
import 'tool_run_requests.dart';

/// Connect JsonCodec이 파싱한 `ListTracesResponse`를 도메인 목록으로 옮긴다.
List<TraceSnapshot> traceSnapshotsFromListResponse(
  trace_pb.ListTracesResponse response,
) {
  return [
    for (final trace in response.traces) traceSnapshotFrom(trace),
  ];
}

TraceSnapshot traceSnapshotFrom(
  trace_pb.Trace trace, {
  List<trace_pb.TraceEvent> events = const [],
}) {
  return TraceSnapshot(
    traceId: idText(trace.traceId),
    fileName: trace.fileName.trim(),
    lastEvent: trace.lastEvent.trim(),
    status: traceStatusFrom(trace.status),
    errorMessage: trace.errorMessage.trim(),
    progressPercent: trace.hasProgressPercent() ? trace.progressPercent : 0,
    run: trace.hasRun() ? toolRunSnapshotFrom(trace.run) : null,
    events: [
      for (final event in events)
        TraceEventSnapshot(
          name: event.name.trim(),
          status: event.status.trim(),
          errorMessage: event.errorMessage.trim(),
          runId: idText(event.runId),
          at: event.hasAt() ? event.at.toDateTime() : null,
        ),
    ],
  );
}

UploadTraceStatus traceStatusFrom(trace_enum.TraceStatus status) {
  if (status == trace_enum.TraceStatus.TRACE_STATUS_DONE) {
    return UploadTraceStatus.done;
  }
  if (status == trace_enum.TraceStatus.TRACE_STATUS_FAILED) {
    return UploadTraceStatus.failed;
  }
  return UploadTraceStatus.running;
}

class RemoteTraceRepository implements TraceRepository {
  RemoteTraceRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<List<TraceSnapshot>> listTraces({int pageSize = 50}) async {
    final size = pageSize < 1 ? 50 : (pageSize > 500 ? 500 : pageSize);
    try {
      // status 비움 = 전부(RUNNING·DONE·FAILED). proto ListTracesRequest 주석.
      final response = await _mediaTag.traceService.listTraces(
        trace_pb.ListTracesRequest(pageSize: size),
      );
      return traceSnapshotsFromListResponse(response);
    } on ConnectException catch (error) {
      final message = error.message.trim();
      throw TraceException(
        message.isEmpty ? '파이프라인 목록을 불러오지 못했습니다.' : message,
      );
    }
  }

  @override
  Future<TraceSnapshot> getTrace({required String traceId}) async {
    final id = protoIdOrNull(traceId);
    if (id == null) {
      throw const TraceException('파이프라인을 찾지 못했습니다.');
    }
    try {
      final response = await _mediaTag.traceService.getTrace(
        trace_pb.GetTraceRequest(traceId: id),
      );
      return traceSnapshotFrom(response.trace, events: response.events);
    } on ConnectException catch (error) {
      final message = error.message.trim();
      throw TraceException(
        message.isEmpty ? '파이프라인 상태를 불러오지 못했습니다.' : message,
      );
    }
  }
}
