import '../entities/upload_trace.dart';

abstract class TraceRepository {
  Future<List<TraceSnapshot>> listTraces({
    int pageSize = 50,
    UploadTraceStatus? status,
  });

  Future<TraceSnapshot> getTrace({required String traceId});
}
