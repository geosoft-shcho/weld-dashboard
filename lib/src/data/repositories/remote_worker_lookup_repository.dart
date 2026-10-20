import '../../domain/entities/lookup_page.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/worker_lookup_repository.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';
import 'worker_kind_mapper.dart';

class RemoteWorkerLookupRepository implements WorkerLookupRepository {
  RemoteWorkerLookupRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

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
}
