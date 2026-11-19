import 'package:connectrpc/connect.dart';
import 'package:flutter/foundation.dart';

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
  Future<List<TraceSnapshot>> listTraces({
    int pageSize = 50,
    UploadTraceStatus? status,
  }) async {
    final size = pageSize < 1 ? 50 : (pageSize > 500 ? 500 : pageSize);
    try {
      // status 비움 = 전부(RUNNING·DONE·FAILED). proto ListTracesRequest 주석.
      final request = trace_pb.ListTracesRequest(pageSize: size);
      if (status != null) {
        request.status = _protoStatusOf(status);
      }
      final response = await _mediaTag.traceService.listTraces(request);
      return traceSnapshotsFromListResponse(response);
    } on ConnectException catch (error) {
      final message = error.message.trim();
      throw TraceException(
        message.isEmpty ? '파이프라인 목록을 불러오지 못했습니다.' : message,
      );
    }
  }

  trace_enum.TraceStatus _protoStatusOf(UploadTraceStatus status) {
    switch (status) {
      case UploadTraceStatus.running:
        return trace_enum.TraceStatus.TRACE_STATUS_RUNNING;
      case UploadTraceStatus.done:
        return trace_enum.TraceStatus.TRACE_STATUS_DONE;
      case UploadTraceStatus.failed:
        return trace_enum.TraceStatus.TRACE_STATUS_FAILED;
    }
  }

  @override
  Future<TraceSnapshot> getTrace({required String traceId}) async {
    final id = protoIdOrNull(traceId);
    if (id == null) {
      if (kDebugMode) {
        debugPrint('[GetTrace] reject invalid traceId=$traceId');
      }
      throw const TraceException('파이프라인을 찾지 못했습니다.');
    }
    if (kDebugMode) {
      debugPrint('[GetTrace] request TraceService/GetTrace traceId=$traceId');
    }
    try {
      final response = await _mediaTag.traceService.getTrace(
        trace_pb.GetTraceRequest(traceId: id),
      );
      final snapshot =
          traceSnapshotFrom(response.trace, events: response.events);
      if (kDebugMode) {
        final progress = snapshot.progressPercent > 0
            ? ' progress=${snapshot.progressPercent.toStringAsFixed(1)}%'
            : '';
        final events = [
          for (final event in snapshot.events)
            '${event.name}:${event.status}',
        ].join(',');
        debugPrint(
          '[GetTrace] ok id=${snapshot.traceId} '
          'status=${snapshot.status.name} last=${snapshot.lastEvent} '
          'events=${snapshot.events.length}$progress '
          '[$events]',
        );
      }
      return snapshot;
    } on ConnectException catch (error) {
      final message = error.message.trim();
      if (kDebugMode) {
        debugPrint(
          '[GetTrace] fail traceId=$traceId '
          'code=${error.code} message=${message.isEmpty ? '(empty)' : message}',
        );
      }
      throw TraceException(
        message.isEmpty ? '파이프라인 상태를 불러오지 못했습니다.' : message,
      );
    }
  }
}
