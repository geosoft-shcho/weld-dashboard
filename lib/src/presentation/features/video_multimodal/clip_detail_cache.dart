import '../../../domain/entities/job_timeline.dart';

/// GetClip 결과 메모리 캐시. clipId당 inflight를 하나로 합친다.
class ClipDetailCache {
  final Map<String, ClipDetail> _byId = {};
  final Map<String, Future<ClipDetail>> _inflight = {};

  ClipDetail? get(String clipId) => _byId[clipId];

  void put(String clipId, ClipDetail detail) {
    if (clipId.isEmpty) {
      return;
    }
    _byId[clipId] = detail;
  }

  void clear() {
    _byId.clear();
    _inflight.clear();
  }

  Future<ClipDetail> getOrLoad(
    String clipId,
    Future<ClipDetail> Function() loader,
  ) {
    final cached = _byId[clipId];
    if (cached != null) {
      return Future<ClipDetail>.value(cached);
    }
    final pending = _inflight[clipId];
    if (pending != null) {
      return pending;
    }
    final future = loader()
        .then((detail) {
          _byId[clipId] = detail;
          return detail;
        })
        .whenComplete(() {
          _inflight.remove(clipId);
        });
    _inflight[clipId] = future;
    return future;
  }
}
