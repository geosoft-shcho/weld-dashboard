import '../entities/ask_answer.dart';

abstract class AskRepository {
  Future<AskAnswer> askQuestion({
    required String projectId,
    required String question,
    String sessionId = '',
  });
}
