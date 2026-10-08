enum ToolRunStatus { queued, running, succeeded, failed, canceled }

enum ToolRunTargetKind { job, asset, clip }

class InferenceTool {
  const InferenceTool({
    required this.toolId,
    required this.name,
    this.summary = '',
  });

  final String toolId;
  final String name;
  final String summary;
}

class ToolRunSnapshot {
  const ToolRunSnapshot({
    required this.runId,
    required this.toolId,
    required this.status,
    required this.errorMessage,
  });

  final String runId;
  final String toolId;
  final ToolRunStatus status;
  final String errorMessage;

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
