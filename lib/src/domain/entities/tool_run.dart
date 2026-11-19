enum ToolRunStatus { queued, running, succeeded, failed, canceled }

enum ToolRunTargetKind { job, asset, clip }

enum ToolRunWaitReason {
  unspecified,
  queueAhead,
  workersBusy,
  retry,
  dispatchOff,
}

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
    this.stage = '',
    this.progressPercent = 0,
    this.estimatedRemainingSeconds = 0,
    this.queue = '',
    this.queuePosition = 0,
    this.queueLength = 0,
    this.waitReason = ToolRunWaitReason.unspecified,
    this.waitAhead = 0,
    this.waitRunning = 0,
    this.waitWorkers = 0,
    this.createdAt,
  });

  final String runId;
  final String toolId;
  final String stage;
  final ToolRunStatus status;
  final String errorMessage;
  final double progressPercent;
  final int estimatedRemainingSeconds;
  final String queue;
  final int queuePosition;
  final int queueLength;
  final ToolRunWaitReason waitReason;
  final int waitAhead;
  final int waitRunning;
  final int waitWorkers;
  final DateTime? createdAt;

  bool get isInProgress {
    return status == ToolRunStatus.queued || status == ToolRunStatus.running;
  }

  String get pollSignature {
    return [
      runId,
      toolId,
      stage,
      status.index,
      errorMessage,
      progressPercent.toStringAsFixed(1),
      estimatedRemainingSeconds,
      queue,
      queuePosition,
      queueLength,
      waitReason.index,
      waitAhead,
      waitRunning,
      waitWorkers,
    ].join('·');
  }

  /// 대기열 표시용. 예: `후처리 · 앞 2건` 또는 `후처리 · 1/3`
  String get queueWaitLabel {
    final name = switch (queue.trim()) {
      'postprocess' => '후처리',
      'work' => '작업',
      '' => stage.trim() == 'postprocess' ? '후처리' : '',
      final value => value,
    };
    final parts = <String>[];
    if (name.isNotEmpty) {
      parts.add(name);
    }
    final waitDetail = _waitDetail;
    if (waitDetail.isNotEmpty) {
      parts.add(waitDetail);
    } else if (queuePosition > 0) {
      if (queueLength > 0) {
        parts.add('$queuePosition/$queueLength');
      } else {
        parts.add('$queuePosition');
      }
    }
    return parts.join(' · ');
  }

  String get _waitDetail {
    switch (waitReason) {
      case ToolRunWaitReason.queueAhead:
        return waitAhead > 0 ? '앞 $waitAhead건' : '대기열';
      case ToolRunWaitReason.workersBusy:
        return '자리 없음';
      case ToolRunWaitReason.retry:
        return '재시도 대기';
      case ToolRunWaitReason.dispatchOff:
        return '디스패치 꺼짐';
      case ToolRunWaitReason.unspecified:
        return '';
    }
  }
}

class ToolRunQueue {
  const ToolRunQueue({
    required this.queue,
    required this.workers,
    required this.running,
    required this.waiting,
    this.runs = const [],
  });

  final String queue;
  final int workers;
  final int running;
  final int waiting;
  final List<ToolRunSnapshot> runs;
}

/// GetQueue `queues[]`에서 Trace/Run의 queue 이름과 같은 항목을 고른다.
ToolRunQueue? toolRunQueueMatching(
  Iterable<ToolRunQueue> queues,
  String queueName,
) {
  final name = queueName.trim();
  if (name.isEmpty) {
    return null;
  }
  for (final queue in queues) {
    if (queue.queue == name) {
      return queue;
    }
  }
  return null;
}

String toolRunQueueDisplayName(String queue) {
  switch (queue.trim()) {
    case 'postprocess':
      return '후처리';
    case 'work':
      return '작업';
    case '':
      return '';
    default:
      return queue.trim();
  }
}

class ToolRunException implements Exception {
  const ToolRunException(this.message);

  final String message;

  @override
  String toString() => message;
}
