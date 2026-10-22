import 'job_draft.dart';

enum PassKind { unknown, root, hot, fill, cap }

extension PassKindLabel on PassKind {
  String get label {
    switch (this) {
      case PassKind.root:
        return '초층 (Root)';
      case PassKind.hot:
        return 'Hot';
      case PassKind.fill:
        return '채움 (Fill)';
      case PassKind.cap:
        return '덮개 (Cap)';
      case PassKind.unknown:
        return '모름';
    }
  }
}

class JobPassDetail {
  const JobPassDetail({
    required this.passId,
    required this.passNo,
    required this.kind,
    this.startedAt,
    this.endedAt,
  });

  final String passId;
  final int passNo;
  final PassKind kind;
  final DateTime? startedAt;
  final DateTime? endedAt;
}

class JobDetail {
  const JobDetail({
    required this.jobId,
    required this.jobKey,
    required this.commonKey,
    required this.projectId,
    required this.projectNo,
    required this.unitNo,
    required this.itemCode,
    required this.itemName,
    required this.jointNo,
    required this.jobName,
    required this.itemNo,
    required this.operationNo,
    required this.material,
    required this.outerDiameterMm,
    required this.thicknessMm,
    required this.workerId,
    required this.workerName,
    required this.startedAt,
    required this.endedAt,
    required this.hasReport,
    required this.attachmentCount,
    required this.passes,
  });

  final String jobId;
  final String jobKey;
  final String commonKey;
  final String projectId;
  final String projectNo;
  final String unitNo;
  final String itemCode;
  final String itemName;
  final String jointNo;
  final String jobName;
  final String itemNo;
  final String operationNo;
  final String material;
  final double? outerDiameterMm;
  final double? thicknessMm;
  final String workerId;
  final String workerName;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final bool hasReport;
  final int attachmentCount;
  final List<JobPassDetail> passes;
}

/// 수정 폼 값. 원래 값과 비교해 바뀐 칸만 서버에 보낸다.
class JobEditDraft {
  const JobEditDraft({
    required this.projectId,
    required this.projectNo,
    required this.unitNo,
    required this.itemCode,
    required this.jointNo,
    required this.jobName,
    required this.itemNo,
    required this.operationNo,
    required this.material,
    required this.outerDiameterMm,
    required this.thicknessMm,
    required this.workerId,
    required this.startedAt,
    required this.endedAt,
  });

  final String projectId;
  final String projectNo;
  final String unitNo;
  final String itemCode;
  final String jointNo;
  final String jobName;
  final String itemNo;
  final String operationNo;
  final String material;
  final double? outerDiameterMm;
  final double? thicknessMm;
  final String workerId;
  final DateTime? startedAt;
  final DateTime? endedAt;

  List<String> changedFields(JobDetail original) {
    return [
      if (projectId != original.projectId || projectNo != original.projectNo)
        'project_id',
      if (unitNo != original.unitNo) 'unit_no',
      if (itemCode != original.itemCode) 'item_code',
      if (jointNo != original.jointNo) 'joint_no',
      if (jobName != original.jobName) 'job_name',
      if (itemNo != original.itemNo) 'item_no',
      if (operationNo != original.operationNo) 'operation_no',
      if (material != original.material) 'material',
      if (outerDiameterMm != original.outerDiameterMm) 'outer_diameter_mm',
      if (thicknessMm != original.thicknessMm) 'thickness_mm',
      if (workerId != original.workerId) 'worker_id',
      if (startedAt != original.startedAt) 'started_at',
      if (endedAt != original.endedAt) 'ended_at',
    ];
  }

  bool doesChangeKeyFields(JobDetail original) {
    final fields = changedFields(original);
    return fields.contains('project_id') ||
        fields.contains('unit_no') ||
        fields.contains('item_code') ||
        fields.contains('joint_no') ||
        fields.contains('started_at');
  }

  /// 새 작업 검증(JobDraft)에 기존 패스를 넣어서 함께 검사한다.
  String validate(JobDetail original) {
    final error = JobDraft(
      projectId: projectId,
      projectNo: projectNo,
      unitNo: unitNo,
      itemCode: itemCode,
      itemName: '',
      jointNo: jointNo,
      workerId: workerId,
      startedAt: startedAt,
      endedAt: endedAt,
      passes: [
        for (final pass in original.passes)
          JobPassDraft(
            passNo: pass.passNo,
            startedAt: pass.startedAt,
            endedAt: pass.endedAt,
          ),
      ],
    ).validate();
    if (error.contains('구간 밖')) {
      return '작업 구간을 줄이면 패스가 밖으로 나갑니다. 패스를 먼저 고치세요. ($error)';
    }
    return error;
  }
}

/// 패스 추가·수정 폼 값.
class PassEditDraft {
  const PassEditDraft({
    required this.passNo,
    required this.kind,
    this.startedAt,
    this.endedAt,
  });

  final int passNo;
  final PassKind kind;
  final DateTime? startedAt;
  final DateTime? endedAt;

  List<String> changedFields(JobPassDetail original) {
    return [
      if (passNo != original.passNo) 'pass_no',
      if (kind != original.kind) 'pass_type',
      if (startedAt != original.startedAt) 'started_at',
      if (endedAt != original.endedAt) 'ended_at',
    ];
  }
}

/// 작업·패스 시각 범위를 검사한다. 문제가 없으면 빈 문자열.
String validatePassRange({
  required int passNo,
  required DateTime? startedAt,
  required DateTime? endedAt,
  required DateTime? jobStartedAt,
  required DateTime? jobEndedAt,
  required List<JobPassDetail> passes,
  String skipPassId = '',
}) {
  if (passNo < 1) return '패스 번호는 1 이상입니다.';
  for (final pass in passes) {
    if (pass.passId != skipPassId && pass.passNo == passNo) {
      return '$passNo패스가 이미 있습니다.';
    }
  }
  if (startedAt != null && endedAt != null && endedAt.isBefore(startedAt)) {
    return '종료가 시작보다 앞섭니다.';
  }
  if (jobStartedAt != null) {
    if (startedAt != null && startedAt.isBefore(jobStartedAt)) {
      return '패스는 작업 구간 안에 있어야 합니다.';
    }
    if (endedAt != null && endedAt.isBefore(jobStartedAt)) {
      return '패스는 작업 구간 안에 있어야 합니다.';
    }
  }
  if (jobEndedAt != null) {
    if (startedAt != null && startedAt.isAfter(jobEndedAt)) {
      return '패스는 작업 구간 안에 있어야 합니다.';
    }
    if (endedAt != null && endedAt.isAfter(jobEndedAt)) {
      return '패스는 작업 구간 안에 있어야 합니다.';
    }
  }
  if (startedAt != null && endedAt != null) {
    for (final pass in passes) {
      if (pass.passId == skipPassId) continue;
      final otherStart = pass.startedAt;
      final otherEnd = pass.endedAt;
      if (otherStart != null &&
          otherEnd != null &&
          startedAt.isBefore(otherEnd) &&
          otherStart.isBefore(endedAt)) {
        return '${pass.passNo}패스와 시간이 겹칩니다.';
      }
    }
  }
  return '';
}
