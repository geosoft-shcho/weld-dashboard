import '../entities/lookup_page.dart';
import '../entities/work_history_project_filter.dart';

abstract class ProjectLookupRepository {
  Future<LookupPage<WorkHistoryProjectFilter>> listProjects({
    required String query,
    required int pageSize,
    required String pageToken,
  });
}
