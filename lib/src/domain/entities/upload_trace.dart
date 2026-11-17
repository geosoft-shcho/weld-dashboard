import 'tool_run.dart';

enum UploadTraceStatus { running, done, failed }

class TraceEventSnapshot {
  const TraceEventSnapshot({
    required this.name,
    required this.status,
    this.errorMessage = '',
    this.runId = '',
    this.at,
  });

  final String name;
  final String status;
  final String errorMessage;
  final String runId;
  final DateTime? at;
}

class TraceSnapshot {
  const TraceSnapshot({
    required this.traceId,
    required this.lastEvent,
    required this.status,
    required this.errorMessage,
    this.fileName = '',
    this.progressPercent = 0,
    this.run,
    this.events = const [],
  });

  final String traceId;
  final String fileName;
  final String lastEvent;
  final UploadTraceStatus status;
  final String errorMessage;
  final double progressPercent;
  final ToolRunSnapshot? run;
  final List<TraceEventSnapshot> events;

  bool get isTerminal {
    return status == UploadTraceStatus.done ||
        status == UploadTraceStatus.failed;
  }

  String get stageId {
    final event = lastEvent.trim();
    if (event.isEmpty) {
      return '';
    }
    final dot = event.indexOf('.');
    return dot <= 0 ? event : event.substring(0, dot);
  }

  /// 폴링 UI 갱신 여부 비교용. 바뀐 칸만 반영할 때 쓴다.
  String get pollSignature {
    final run = this.run;
    return [
      traceId,
      fileName,
      lastEvent,
      status.index,
      errorMessage,
      progressPercent.toStringAsFixed(1),
      if (run != null) run.pollSignature,
      for (final event in events)
        '${event.name}|${event.status}|${event.errorMessage}|${event.runId}',
    ].join('·');
  }
}

class TraceException implements Exception {
  const TraceException(this.message);

  final String message;

  @override
  String toString() => message;
}
