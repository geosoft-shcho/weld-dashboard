import '../entities/lookup_page.dart';
import '../entities/work_history_project_filter.dart';
import '../repositories/project_lookup_repository.dart';

class ListProjectLookupUseCase {
  ListProjectLookupUseCase(this._repository);

  final ProjectLookupRepository _repository;

  static const int defaultPageSize = 50;

  Future<LookupPage<WorkHistoryProjectFilter>> execute({
    String query = '',
    String pageToken = '',
    int pageSize = defaultPageSize,
  }) {
    return _repository.listProjects(
      query: query,
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }
}
