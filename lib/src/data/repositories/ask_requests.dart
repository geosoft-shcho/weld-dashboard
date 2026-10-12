import '../../domain/entities/ask_answer.dart';
import '../datasources/generated/tacittag/rag/v2/rag.pb.dart' as rag_pb;

rag_pb.AskQuestionRequest buildAskQuestionRequest({
  required String projectId,
  required String question,
  String sessionId = '',
}) {
  final request = rag_pb.AskQuestionRequest(
    projectId: projectId,
    question: question,
  );
  if (sessionId.isNotEmpty) {
    request.sessionId = sessionId;
  }
  return request;
}

AskAnswer askAnswerFrom(rag_pb.AskQuestionResponse response) {
  return AskAnswer(
    answer: response.answer,
    sessionId: response.sessionId,
    citations: [
      for (final citation in response.citations)
        AskCitation(
          startSeconds: citation.startSec,
          endSeconds: citation.endSec,
          text: citation.text,
          segmentId: citation.segmentId,
        ),
    ],
  );
}
