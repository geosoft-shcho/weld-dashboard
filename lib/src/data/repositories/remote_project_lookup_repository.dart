import 'package:connectrpc/connect.dart';

import '../../domain/entities/lookup_page.dart';
import '../../domain/entities/project_item_draft.dart';
import '../../domain/entities/work_history_project_filter.dart';
import '../../domain/repositories/project_lookup_repository.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'project_filter_mapping.dart';
import 'proto_id.dart';

class RemoteProjectLookupRepository implements ProjectLookupRepository {
  RemoteProjectLookupRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<WorkHistoryProjectFilter?> getProject({
    required String projectId,
  }) async {
    final id = protoIdOrNull(projectId);
    if (id == null) {
      return null;
    }
    try {
      final response = await _mediaTag.workService.getProject(
        work_pb.GetProjectRequest(projectId: id),
      );
      if (!response.hasProject()) {
        return null;
      }
      return projectFilterFromProto(response.project);
    } on ConnectException catch (error) {
      if (error.code == Code.notFound) {
        return null;
      }
      rethrow;
    }
  }

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

  @override
  Future<String> createProject({
    required String projectNo,
    required String projectName,
    required String siteName,
    required String customer,
  }) async {
    final response = await _mediaTag.workService.createProject(
      work_pb.CreateProjectRequest(
        project: work_pb.Project(
          projectNo: projectNo,
          projectName: projectName,
          siteName: siteName,
          customer: customer,
        ),
      ),
    );
    return idText(response.project.projectId);
  }

  @override
  Future<void> createProjectItems({
    required String projectId,
    required List<ProjectItemDraft> items,
  }) async {
    final id = protoIdOrNull(projectId);
    if (id == null) {
      throw ArgumentError('공사 번호가 없습니다.');
    }
    await _mediaTag.workService.createProjectItems(
      work_pb.CreateProjectItemsRequest(
        projectId: id,
        items: [
          for (final item in items)
            work_pb.ItemAssignment(
              projectId: id,
              unitNo: item.unitNo,
              itemCode: item.itemCode,
              itemName: item.itemName,
            ),
        ],
      ),
    );
  }

  @override
  Future<void> updateProject({
    required String projectId,
    required String projectName,
    required String siteName,
    required String customer,
    required List<String> changedFields,
  }) async {
    final id = protoIdOrNull(projectId);
    if (id == null) {
      throw ArgumentError('공사 번호가 없습니다.');
    }
    await _mediaTag.workService.updateProject(
      work_pb.UpdateProjectRequest(
        project: work_pb.Project(
          projectId: id,
          projectName: projectName,
          siteName: siteName,
          customer: customer,
        ),
        updateMask: FieldMask(paths: changedFields),
      ),
    );
  }

  @override
  Future<void> deleteProject({required String projectId}) async {
    final id = protoIdOrNull(projectId);
    if (id == null) {
      throw ArgumentError('공사 번호가 없습니다.');
    }
    await _mediaTag.workService.deleteProject(
      work_pb.DeleteProjectRequest(projectId: id),
    );
  }

  @override
  Future<void> updateProjectItem({
    required String projectItemId,
    required String itemName,
  }) async {
    final id = protoIdOrNull(projectItemId);
    if (id == null) {
      throw ArgumentError('품목 배정 번호가 없습니다.');
    }
    await _mediaTag.workService.updateProjectItem(
      work_pb.UpdateProjectItemRequest(
        item: work_pb.ItemAssignment(projectItemId: id, itemName: itemName),
      ),
    );
  }

  @override
  Future<void> deleteProjectItem({required String projectItemId}) async {
    final id = protoIdOrNull(projectItemId);
    if (id == null) {
      throw ArgumentError('품목 배정 번호가 없습니다.');
    }
    await _mediaTag.workService.deleteProjectItem(
      work_pb.DeleteProjectItemRequest(projectItemId: id),
    );
  }
}
