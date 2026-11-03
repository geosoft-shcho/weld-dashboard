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
    this.queue = '',
    this.queuePosition = 0,
    this.queueLength = 0,
  });

  final String runId;
  final String toolId;
  final ToolRunStatus status;
  final String errorMessage;
  final double progressPercent;
  final int estimatedRemainingSeconds;
  final String queue;
  final int queuePosition;
  final int queueLength;

  bool get isInProgress {
    return status == ToolRunStatus.queued || status == ToolRunStatus.running;
  }

  /// 대기열 표시용. 예: `후처리 · 1/3`
  String get queueWaitLabel {
    final name = switch (queue.trim()) {
      'postprocess' => '후처리',
      'work' => '작업',
      '' => '',
      final value => value,
    };
    final parts = <String>[];
    if (name.isNotEmpty) {
      parts.add(name);
    }
    if (queuePosition > 0) {
      if (queueLength > 0) {
        parts.add('$queuePosition/$queueLength');
      } else {
        parts.add('$queuePosition');
      }
    }
    return parts.join(' · ');
  }
}

class ToolRunException implements Exception {
  const ToolRunException(this.message);

  final String message;

  @override
  String toString() => message;
}
