class AskCitation {
  const AskCitation({
    required this.startSeconds,
    required this.endSeconds,
    this.text = '',
    this.segmentId = '',
  });

  final double startSeconds;
  final double endSeconds;
  final String text;
  final String segmentId;
}

class AskAnswer {
  const AskAnswer({
    required this.answer,
    required this.sessionId,
    this.citations = const [],
  });

  final String answer;
  final String sessionId;
  final List<AskCitation> citations;
}

class AskHistoryMessage {
  const AskHistoryMessage({
    required this.isUser,
    required this.text,
    this.citations = const [],
  });

  final bool isUser;
  final String text;
  final List<AskCitation> citations;
}

class AskSessionHistory {
  const AskSessionHistory({
    required this.sessionId,
    this.messages = const [],
  });

  final String sessionId;
  final List<AskHistoryMessage> messages;
}

class AskException implements Exception {
  const AskException(this.message);

  final String message;

  @override
  String toString() => message;
}
