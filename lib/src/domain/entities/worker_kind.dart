/// 작업자 종류. MediaTag WorkerType과 같다.
enum WorkerKind {
  unknown,
  master,
  general,
  robot,
}

extension WorkerKindLabel on WorkerKind {
  String get label {
    switch (this) {
      case WorkerKind.master:
        return '명장';
      case WorkerKind.general:
        return '일반';
      case WorkerKind.robot:
        return '로봇';
      case WorkerKind.unknown:
        return '모름';
    }
  }
}
