import '../entities/upload_trace.dart';

abstract class TraceRepository {
  Future<List<TraceSnapshot>> listTraces({int pageSize = 50});

  Future<TraceSnapshot> getTrace({required String traceId});
}
