import '../repositories/project_lookup_repository.dart';

class DeleteProjectUseCase {
  const DeleteProjectUseCase(this._repository);

  final ProjectLookupRepository _repository;

  Future<void> execute({required String projectId}) {
    return _repository.deleteProject(projectId: projectId);
  }
}
