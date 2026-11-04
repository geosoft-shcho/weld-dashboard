import 'package:flutter/foundation.dart';

/// 멀티모달 `openTimeline` 구간의 논리 API 디버그 로그.
/// `print` 사용(debugPrint 쓰로틀에 가리지 않음).
class MultimodalLoadApiLog {
  DateTime? _begunAt;
  DateTime? _blockingDoneAt;
  final Map<String, DateTime> _stepStartedAt = {};

  void begin(String jobId) {
    if (!kDebugMode) {
      return;
    }
    _begunAt = DateTime.now();
    _blockingDoneAt = null;
    _stepStartedAt.clear();
    // ignore: avoid_print
    print('[MM-LOAD] begin jobId=$jobId');
  }

  void step(String name, {String detail = '', String phase = ''}) {
    if (!kDebugMode) {
      return;
    }
    _stepStartedAt[name] = DateTime.now();
    final phasePart = phase.isEmpty ? '' : ' phase=$phase';
    final suffix = detail.isEmpty ? '' : ' $detail';
    // ignore: avoid_print
    print('[MM-LOAD] → $name$phasePart$suffix');
  }

  void stepDone(String name, {String detail = '', Object? error}) {
    if (!kDebugMode) {
      return;
    }
    final started = _stepStartedAt.remove(name);
    final ms = started == null
        ? '?'
        : DateTime.now().difference(started).inMilliseconds.toString();
    final parts = <String>['[MM-LOAD] ← $name ${ms}ms'];
    if (detail.isNotEmpty) {
      parts.add(detail);
    }
    if (error != null) {
      parts.add('error=$error');
    }
    // ignore: avoid_print
    print(parts.join(' '));
  }

  void blockingDone() {
    if (!kDebugMode) {
      return;
    }
    final begun = _begunAt;
    final ms = begun == null
        ? '?'
        : DateTime.now().difference(begun).inMilliseconds.toString();
    _blockingDoneAt = DateTime.now();
    // ignore: avoid_print
    print('[MM-LOAD] blocking_done ${ms}ms');
  }

  void backgroundDone() {
    if (!kDebugMode) {
      return;
    }
    final blocking = _blockingDoneAt;
    final begun = _begunAt;
    final bgMs = blocking == null
        ? '?'
        : DateTime.now().difference(blocking).inMilliseconds.toString();
    final totalMs = begun == null
        ? '?'
        : DateTime.now().difference(begun).inMilliseconds.toString();
    _begunAt = null;
    _blockingDoneAt = null;
    _stepStartedAt.clear();
    // ignore: avoid_print
    print('[MM-LOAD] background_done ${bgMs}ms total=${totalMs}ms');
  }

  void end() {
    if (!kDebugMode) {
      return;
    }
    final begun = _begunAt;
    final ms = begun == null
        ? '?'
        : DateTime.now().difference(begun).inMilliseconds.toString();
    _begunAt = null;
    _blockingDoneAt = null;
    _stepStartedAt.clear();
    // ignore: avoid_print
    print('[MM-LOAD] end total=${ms}ms');
  }
}
