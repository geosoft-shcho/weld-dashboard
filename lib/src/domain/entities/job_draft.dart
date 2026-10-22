class JobPassDraft {
  const JobPassDraft({required this.passNo, this.startedAt, this.endedAt});

  final int passNo;
  final DateTime? startedAt;
  final DateTime? endedAt;
}

class JobDraft {
  const JobDraft({
    required this.projectId,
    required this.projectNo,
    required this.unitNo,
    required this.itemCode,
    required this.itemName,
    required this.jointNo,
    required this.workerId,
    required this.startedAt,
    required this.endedAt,
    required this.passes,
  });

  final String projectId;
  final String projectNo;
  final String unitNo;
  final String itemCode;

  /// 새 배정일 때만 값이 있다. 이미 배정된 품목이면 빈 값.
  final String itemName;
  final String jointNo;
  final String workerId;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final List<JobPassDraft> passes;

  /// 문제가 없으면 빈 문자열, 있으면 처음 걸린 이유 하나.
  String validate() {
    if (projectNo.isEmpty && projectId.isEmpty) return '공사를 고르세요.';
    if (unitNo.isEmpty || itemCode.isEmpty) return '호기 · 품목을 고르세요.';
    if (jointNo.isEmpty) return '이음부를 넣으세요.';
    final startedAt = this.startedAt;
    if (startedAt == null) return '시작을 넣으세요.';
    final endedAt = this.endedAt;
    if (endedAt != null && endedAt.isBefore(startedAt)) {
      return '종료가 시작보다 앞섭니다.';
    }
    final passNos = <int>{};
    for (final pass in passes) {
      if (pass.passNo < 1) return '패스 번호는 1 이상입니다.';
      if (!passNos.add(pass.passNo)) return '패스 번호가 겹칩니다.';
      final passStartedAt = pass.startedAt;
      final passEndedAt = pass.endedAt;
      if (passStartedAt != null &&
          passEndedAt != null &&
          passEndedAt.isBefore(passStartedAt)) {
        return '${pass.passNo}패스: 종료가 시작보다 앞섭니다.';
      }
      if (passStartedAt != null && passStartedAt.isBefore(startedAt)) {
        return '${pass.passNo}패스가 작업 구간 밖입니다.';
      }
      if (passEndedAt != null && passEndedAt.isBefore(startedAt)) {
        return '${pass.passNo}패스가 작업 구간 밖입니다.';
      }
      if (endedAt != null) {
        if (passStartedAt != null && passStartedAt.isAfter(endedAt)) {
          return '${pass.passNo}패스가 작업 구간 밖입니다.';
        }
        if (passEndedAt != null && passEndedAt.isAfter(endedAt)) {
          return '${pass.passNo}패스가 작업 구간 밖입니다.';
        }
      }
    }
    for (final pass in passes) {
      for (final other in passes) {
        if (identical(pass, other)) continue;
        final a = pass.startedAt;
        final b = pass.endedAt;
        final c = other.startedAt;
        final d = other.endedAt;
        if (a != null &&
            b != null &&
            c != null &&
            d != null &&
            a.isBefore(d) &&
            c.isBefore(b)) {
          return '${pass.passNo}패스와 ${other.passNo}패스의 시간이 겹칩니다.';
        }
      }
    }
    return '';
  }
}

String normalizeUnitNo(String value) {
  final trimmed = value.trim();
  return RegExp(r'^\d$').hasMatch(trimmed) ? '0$trimmed' : trimmed;
}

String normalizeCode(String value) {
  return value.replaceAll(RegExp(r'\s+'), '').toUpperCase();
}
