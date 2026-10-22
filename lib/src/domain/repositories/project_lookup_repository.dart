import '../entities/lookup_page.dart';
import '../entities/project_item_draft.dart';
import '../entities/work_history_project_filter.dart';

abstract class ProjectLookupRepository {
  Future<WorkHistoryProjectFilter?> getProject({required String projectId});

  Future<LookupPage<WorkHistoryProjectFilter>> listProjects({
    required String query,
    required int pageSize,
    required String pageToken,
  });

  Future<String> createProject({
    required String projectNo,
    required String projectName,
    required String siteName,
    required String customer,
  });

  Future<void> createProjectItems({
    required String projectId,
    required List<ProjectItemDraft> items,
  });

  Future<void> updateProject({
    required String projectId,
    required String projectName,
    required String siteName,
    required String customer,
    required List<String> changedFields,
  });

  Future<void> deleteProject({required String projectId});

  Future<void> updateProjectItem({
    required String projectItemId,
    required String itemName,
  });

  Future<void> deleteProjectItem({required String projectItemId});
}
