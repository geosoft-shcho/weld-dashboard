import '../repositories/work_detail_repository.dart';

class LoadJobProjectIdUseCase {
  LoadJobProjectIdUseCase(this._repository);

  final WorkDetailRepository _repository;

  Future<String> execute({required String jobId}) {
    if (jobId.isEmpty) {
      return Future.value('');
    }
    return _repository.loadProjectId(jobId: jobId);
  }
}
