import '../repositories/project_lookup_repository.dart';

class UpdateProjectUseCase {
  const UpdateProjectUseCase(this._repository);

  final ProjectLookupRepository _repository;

  Future<void> execute({
    required String projectId,
    required String projectName,
    required String siteName,
    required String customer,
    required List<String> changedFields,
  }) {
    return _repository.updateProject(
      projectId: projectId,
      projectName: projectName,
      siteName: siteName,
      customer: customer,
      changedFields: changedFields,
    );
  }
}
