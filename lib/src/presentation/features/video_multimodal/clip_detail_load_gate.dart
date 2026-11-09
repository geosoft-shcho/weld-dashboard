/// GetClip 네트워크 동시 1개. 연타 시 대기 clipId는 최신만 남긴다.
class ClipDetailLoadGate {
  bool _busy = false;
  String? _pendingId;

  bool get isBusy => _busy;

  void clearPending() {
    _pendingId = null;
  }

  /// 네트워크 로드를 지금 시작해도 되면 true.
  /// 이미 busy면 [clipId]를 pending에 덮어쓰고 false.
  bool tryBegin(String clipId) {
    if (clipId.isEmpty) {
      return false;
    }
    if (_busy) {
      _pendingId = clipId;
      return false;
    }
    _busy = true;
    return true;
  }

  /// 한 건이 끝난 뒤 남아 있는 최신 pending을 꺼낸다.
  /// [selectedClipId]와 다르면 버리고 null.
  String? takePendingMatching(String selectedClipId) {
    final pending = _pendingId;
    _pendingId = null;
    if (pending == null || pending.isEmpty) {
      return null;
    }
    if (pending != selectedClipId) {
      return null;
    }
    return pending;
  }

  void end() {
    _busy = false;
  }

  /// [end] 직후 다시 쌓인 pending(경합)을 꺼낸다.
  String? takeLeftover() {
    final pending = _pendingId;
    _pendingId = null;
    if (pending == null || pending.isEmpty) {
      return null;
    }
    return pending;
  }
}
