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

class AskException implements Exception {
  const AskException(this.message);

  final String message;

  @override
  String toString() => message;
}
