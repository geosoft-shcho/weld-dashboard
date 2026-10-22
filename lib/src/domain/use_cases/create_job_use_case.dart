import '../entities/job_draft.dart';
import '../repositories/work_history_repository.dart';

class CreateJobUseCase {
  const CreateJobUseCase(this._repository);

  final WorkHistoryRepository _repository;

  Future<String> execute(JobDraft draft) {
    return _repository.createJob(draft);
  }
}
