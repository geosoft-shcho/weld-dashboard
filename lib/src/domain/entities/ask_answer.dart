class AskCitation {
  const AskCitation({required this.startSeconds, required this.endSeconds});

  final double startSeconds;
  final double endSeconds;
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

class AskException implements Exception {
  const AskException(this.message);

  final String message;

  @override
  String toString() => message;
}
