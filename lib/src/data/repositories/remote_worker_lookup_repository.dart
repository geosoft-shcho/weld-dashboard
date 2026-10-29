import 'package:connectrpc/connect.dart';

import '../../domain/entities/lookup_page.dart';
import '../../domain/entities/worker.dart';
import '../../domain/entities/worker_kind.dart';
import '../../domain/repositories/worker_lookup_repository.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';
import 'worker_kind_mapper.dart';

class RemoteWorkerLookupRepository implements WorkerLookupRepository {
  RemoteWorkerLookupRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<Worker?> getWorker({required String workerId}) async {
    final id = protoIdOrNull(workerId);
    if (id == null) {
      return null;
    }
    try {
      final response = await _mediaTag.workService.getWorker(
        work_pb.GetWorkerRequest(workerId: id),
      );
      if (!response.hasWorker()) {
        return null;
      }
      final item = response.worker;
      return Worker(
        workerId: idText(item.workerId),
        workerName: item.workerName,
        workerKind: workerKindFromProto(item.workerType),
        employeeNo: item.employeeNo,
        description: item.description,
        isInactive: item.inactive,
        jobCount: response.jobCount,
      );
    } on ConnectException catch (error) {
      if (error.code == Code.notFound) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<LookupPage<Worker>> listWorkers({
    required bool includeInactive,
    required String query,
    required int pageSize,
    required String pageToken,
  }) async {
    final request = work_pb.ListWorkersRequest(
      includeInactive: includeInactive,
      pageSize: pageSize,
      pageToken: pageToken,
    );
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      request.query = trimmed;
    }
    final response = await _mediaTag.workService.listWorkers(request);
    return LookupPage(
      items: [
        for (final item in response.workers)
          Worker(
            workerId: idText(item.workerId),
            workerName: item.workerName,
            workerKind: workerKindFromProto(item.workerType),
            employeeNo: item.employeeNo,
            description: item.description,
            isInactive: item.inactive,
            jobCount: response.jobCounts[item.workerId] ?? 0,
          ),
      ],
      nextPageToken: response.nextPageToken,
      totalCount: response.totalCount,
    );
  }

  @override
  Future<String> createWorker({
    required String workerName,
    required WorkerKind workerKind,
    required String employeeNo,
    required String description,
    required bool isInactive,
  }) async {
    try {
      final response = await _mediaTag.workService.createWorker(
        work_pb.CreateWorkerRequest(
          worker: work_pb.Worker(
            workerName: workerName,
            workerType: workerKindToProto(workerKind),
            employeeNo: employeeNo,
            description: description,
            inactive: isInactive,
          ),
        ),
      );
      return idText(response.worker.workerId);
    } on ConnectException catch (error) {
      throw _workerWriteFailure(error);
    }
  }

  @override
  Future<void> updateWorker({
    required String workerId,
    required String workerName,
    required WorkerKind workerKind,
    required String employeeNo,
    required String description,
    required bool isInactive,
    required List<String> changedFields,
  }) async {
    final id = protoIdOrNull(workerId);
    if (id == null) {
      throw ArgumentError('작업자 번호가 없습니다.');
    }
    try {
      await _mediaTag.workService.updateWorker(
        work_pb.UpdateWorkerRequest(
          worker: work_pb.Worker(
            workerId: id,
            workerName: workerName,
            workerType: workerKindToProto(workerKind),
            employeeNo: employeeNo,
            description: description,
            inactive: isInactive,
          ),
          updateMask: FieldMask(paths: changedFields),
        ),
      );
    } on ConnectException catch (error) {
      throw _workerWriteFailure(error);
    }
  }

  @override
  Future<void> deleteWorker({required String workerId}) async {
    final id = protoIdOrNull(workerId);
    if (id == null) {
      throw ArgumentError('작업자 번호가 없습니다.');
    }
    try {
      await _mediaTag.workService.deleteWorker(
        work_pb.DeleteWorkerRequest(workerId: id),
      );
    } on ConnectException catch (error) {
      throw _workerWriteFailure(error);
    }
  }
}

Exception _workerWriteFailure(ConnectException error) {
  switch (error.code) {
    case Code.alreadyExists:
      return _WriteFailure('같은 사번이 이미 있습니다.');
    case Code.failedPrecondition:
      return _WriteFailure('맡은 작업이 있어 지울 수 없습니다. 그만둔 사람은 숨김으로 두세요.');
    default:
      return error;
  }
}

class _WriteFailure implements Exception {
  _WriteFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
