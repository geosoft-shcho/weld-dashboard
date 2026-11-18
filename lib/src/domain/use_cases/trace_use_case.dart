import '../entities/upload_trace.dart';
import '../repositories/trace_repository.dart';

class TraceUseCase {
  const TraceUseCase(this._repository);

  final TraceRepository _repository;

  Future<List<TraceSnapshot>> listTraces({
    int pageSize = 50,
    UploadTraceStatus? status,
  }) {
    return _repository.listTraces(pageSize: pageSize, status: status);
  }

  Future<TraceSnapshot> getTrace({required String traceId}) {
    return _repository.getTrace(traceId: traceId);
  }
}
