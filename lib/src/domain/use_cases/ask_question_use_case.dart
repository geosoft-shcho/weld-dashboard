import '../entities/ask_answer.dart';
import '../repositories/ask_repository.dart';

class AskQuestionUseCase {
  AskQuestionUseCase(this._repository);

  final AskRepository _repository;

  Future<AskAnswer> execute({
    required String projectId,
    required String question,
    String sessionId = '',
  }) {
    final trimmed = question.trim();
    if (trimmed.isEmpty) {
      throw const AskException('질문을 입력하세요.');
    }
    if (projectId.isEmpty) {
      throw const AskException('공사 번호를 찾지 못했습니다.');
    }
    return _repository.askQuestion(
      projectId: projectId,
      question: trimmed,
      sessionId: sessionId,
    );
  }
}
