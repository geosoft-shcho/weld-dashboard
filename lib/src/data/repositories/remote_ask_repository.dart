import 'package:connectrpc/connect.dart';

import '../../domain/entities/ask_answer.dart';
import '../../domain/repositories/ask_repository.dart';
import '../datasources/remote/media_tag_data_source.dart';
import 'ask_requests.dart';

class RemoteAskRepository implements AskRepository {
  RemoteAskRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<AskAnswer> askQuestion({
    required String projectId,
    required String question,
    String sessionId = '',
  }) {
    return _call(() async {
      final response = await _mediaTag.ragService.askQuestion(
        buildAskQuestionRequest(
          projectId: projectId,
          question: question,
          sessionId: sessionId,
        ),
      );
      return askAnswerFrom(response);
    });
  }

  Future<T> _call<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ConnectException catch (error) {
      final message = error.message.trim();
      throw AskException(message.isEmpty ? '질의에 답하지 못했습니다.' : message);
    } on AskException {
      rethrow;
    }
  }
}
