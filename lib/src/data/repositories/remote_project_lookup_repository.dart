import '../../domain/entities/lookup_page.dart';
import '../../domain/entities/work_history_project_filter.dart';
import '../../domain/repositories/project_lookup_repository.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'project_filter_mapping.dart';

class RemoteProjectLookupRepository implements ProjectLookupRepository {
  RemoteProjectLookupRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<LookupPage<WorkHistoryProjectFilter>> listProjects({
    required String query,
    required int pageSize,
    required String pageToken,
  }) async {
    final request = work_pb.ListProjectsRequest(
      pageSize: pageSize,
      pageToken: pageToken,
    );
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      request.query = trimmed;
    }
    final response = await _mediaTag.workService.listProjects(request);
    return LookupPage(
      items: [
        for (final detail in response.projectDetails)
          projectFilterFromProto(detail),
      ],
      nextPageToken: response.nextPageToken,
      totalCount: response.totalCount,
    );
  }
}
