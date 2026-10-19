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

rag_pb.GetSessionHistoryRequest buildGetSessionHistoryRequest({
  required String sessionId,
}) {
  return rag_pb.GetSessionHistoryRequest(sessionId: sessionId);
}

AskAnswer askAnswerFrom(rag_pb.AskQuestionResponse response) {
  return AskAnswer(
    answer: response.answer,
    sessionId: response.sessionId,
    citations: askCitationsFrom(response.citations),
  );
}

AskSessionHistory askSessionHistoryFrom(
  rag_pb.GetSessionHistoryResponse response,
) {
  return AskSessionHistory(
    sessionId: response.sessionId,
    messages: [
      for (final message in response.messages)
        if (message.role == 'user' || message.role == 'assistant')
          AskHistoryMessage(
            isUser: message.role == 'user',
            text: message.content,
            citations: askCitationsFrom(message.citations),
          ),
    ],
  );
}

List<AskCitation> askCitationsFrom(Iterable<rag_pb.Citation> citations) {
  return [
    for (final citation in citations)
      AskCitation(
        startSeconds: citation.startSec,
        endSeconds: citation.endSec,
        text: citation.text,
        segmentId: citation.segmentId,
      ),
  ];
}
