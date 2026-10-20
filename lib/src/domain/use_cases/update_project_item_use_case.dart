import '../repositories/project_lookup_repository.dart';

class UpdateProjectItemUseCase {
  const UpdateProjectItemUseCase(this._repository);

  final ProjectLookupRepository _repository;

  Future<void> execute({
    required String projectItemId,
    required String itemName,
  }) {
    return _repository.updateProjectItem(
      projectItemId: projectItemId,
      itemName: itemName,
    );
  }
}
