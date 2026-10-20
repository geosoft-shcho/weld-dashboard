import '../repositories/project_lookup_repository.dart';

class CreateProjectUseCase {
  const CreateProjectUseCase(this._repository);

  final ProjectLookupRepository _repository;

  Future<String> execute({
    required String projectNo,
    required String projectName,
    required String siteName,
    required String customer,
  }) {
    return _repository.createProject(
      projectNo: projectNo,
      projectName: projectName,
      siteName: siteName,
      customer: customer,
    );
  }
}
