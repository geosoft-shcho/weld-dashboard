import '../entities/work_history_project_filter.dart';
import '../repositories/project_lookup_repository.dart';

class GetProjectLookupUseCase {
  GetProjectLookupUseCase(this._repository);

  final ProjectLookupRepository _repository;

  Future<WorkHistoryProjectFilter?> execute({required String projectId}) {
    return _repository.getProject(projectId: projectId);
  }
}
