enum ToolRunStatus { queued, running, succeeded, failed, canceled }

enum ToolRunTargetKind { job, asset, clip }

class InferenceTool {
  const InferenceTool({
    required this.toolId,
    required this.name,
    this.summary = '',
    this.description = '',
    this.isSpeechToText = false,
  });

  final String toolId;
  final String name;
  final String summary;
  final String description;
  final bool isSpeechToText;
}

class ToolRunSnapshot {
  const ToolRunSnapshot({
    required this.runId,
    required this.toolId,
    required this.status,
    required this.errorMessage,
    this.progressPercent = 0,
    this.estimatedRemainingSeconds = 0,
  });

  final String runId;
  final String toolId;
  final ToolRunStatus status;
  final String errorMessage;
  final double progressPercent;
  final int estimatedRemainingSeconds;

  bool get isInProgress {
    return status == ToolRunStatus.queued || status == ToolRunStatus.running;
  }
}

class ToolRunException implements Exception {
  const ToolRunException(this.message);

  final String message;

  @override
  String toString() => message;
}
