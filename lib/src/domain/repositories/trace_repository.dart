import '../entities/upload_trace.dart';

abstract class TraceRepository {
  Future<List<TraceSnapshot>> listTraces({
    int pageSize = 50,
    UploadTraceStatus? status,
  });

  /// KPI용 — page_size=1로 조건에 맞는 전체 건수만 본다.
  Future<int> countTraces({required UploadTraceStatus status});

  Future<TraceSnapshot> getTrace({required String traceId});
}
