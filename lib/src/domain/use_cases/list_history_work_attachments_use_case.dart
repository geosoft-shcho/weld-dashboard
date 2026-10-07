import '../entities/work_attachment.dart';
import '../repositories/work_detail_repository.dart';

/// 고른 작업(`job_id`)의 첨부만 조회한다.
class ListHistoryWorkAttachmentsUseCase {
  ListHistoryWorkAttachmentsUseCase(this._repository);

  final WorkDetailRepository _repository;

  Future<List<WorkAttachment>> execute({required String jobId}) {
    if (jobId.isEmpty) {
      return Future.value(const []);
    }
    return _repository.listAttachments(jobId: jobId);
  }
}
