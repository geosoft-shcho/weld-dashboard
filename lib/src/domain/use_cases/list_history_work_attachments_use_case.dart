import '../entities/work_attachment.dart';
import '../repositories/work_detail_repository.dart';

/// 임시. ListWorkAttachments 전체에서 historyId 가 같은 첨부만 고른다.
class ListHistoryWorkAttachmentsUseCase {
  ListHistoryWorkAttachmentsUseCase(this._repository);

  final WorkDetailRepository _repository;

  Future<List<WorkAttachment>> execute({required String historyId}) async {
    if (historyId.isEmpty) {
      return const [];
    }
    final attachments = await _repository.listAttachments();
    return [
      for (final attachment in attachments)
        if (attachment.historyId == historyId) attachment,
    ];
  }
}
