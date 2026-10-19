import '../entities/ask_answer.dart';
import '../repositories/ask_repository.dart';

class GetSessionHistoryUseCase {
  GetSessionHistoryUseCase(this._repository);

  final AskRepository _repository;

  Future<AskSessionHistory> execute({required String sessionId}) {
    final trimmed = sessionId.trim();
    if (trimmed.isEmpty) {
      throw const AskException('세션이 없습니다.');
    }
    return _repository.getSessionHistory(sessionId: trimmed);
  }
}
