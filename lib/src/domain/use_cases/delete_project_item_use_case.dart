import '../repositories/project_lookup_repository.dart';

class DeleteProjectItemUseCase {
  const DeleteProjectItemUseCase(this._repository);

  final ProjectLookupRepository _repository;

  Future<void> execute({required String projectItemId}) {
    return _repository.deleteProjectItem(projectItemId: projectItemId);
  }
}
