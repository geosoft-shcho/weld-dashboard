import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/job_detail.dart';

JobDetail detail({
  DateTime? startedAt,
  DateTime? endedAt,
  List<JobPassDetail> passes = const [],
}) {
  return JobDetail(
    jobId: '10',
    jobKey: 'JOB-1',
    commonKey: 'TP129_05-TFPB',
    projectId: '7',
    projectNo: 'TP129',
    unitNo: '05',
    itemCode: 'TFPB',
    itemName: '품목',
    jointNo: 'DGT-ELA-01',
    jobName: '',
    itemNo: '',
    operationNo: '',
    material: '',
    outerDiameterMm: null,
    thicknessMm: null,
    workerId: '3',
    workerName: '김작업',
    startedAt: startedAt ?? DateTime(2026, 10, 30, 8),
    endedAt: endedAt ?? DateTime(2026, 10, 30, 10),
    reportSetId: '',
    activeReportSetId: '',
    hasReport: false,
    attachmentCount: 0,
    passes: passes,
  );
}

JobEditDraft edit(
  JobDetail original, {
  DateTime? startedAt,
  DateTime? endedAt,
}) {
  return JobEditDraft(
    projectId: original.projectId,
    projectNo: original.projectNo,
    unitNo: original.unitNo,
    itemCode: original.itemCode,
    jointNo: original.jointNo,
    jobName: original.jobName,
    itemNo: original.itemNo,
    operationNo: original.operationNo,
    material: original.material,
    outerDiameterMm: original.outerDiameterMm,
    thicknessMm: original.thicknessMm,
    workerId: original.workerId,
    startedAt: startedAt ?? original.startedAt,
    endedAt: endedAt ?? original.endedAt,
  );
}

JobPassDetail pass(int no, int startHour, int endHour, {String id = ''}) {
  return JobPassDetail(
    passId: id.isEmpty ? '$no' : id,
    passNo: no,
    kind: PassKind.unknown,
    startedAt: DateTime(2026, 10, 30, startHour),
    endedAt: DateTime(2026, 10, 30, endHour),
  );
}

void main() {
  test('1단계: 바뀐 칸만 update_mask에 들어간다', () {
    final original = detail();
    expect(edit(original).changedFields(original), isEmpty);
    final changed = JobEditDraft(
      projectId: original.projectId,
      projectNo: original.projectNo,
      unitNo: original.unitNo,
      itemCode: original.itemCode,
      jointNo: 'DGT-ELA-02',
      jobName: '새 이름',
      itemNo: '',
      operationNo: '',
      material: '',
      outerDiameterMm: null,
      thicknessMm: null,
      workerId: original.workerId,
      startedAt: original.startedAt,
      endedAt: original.endedAt,
    );
    expect(changed.changedFields(original), ['joint_no', 'job_name']);
    expect(changed.doesChangeKeyFields(original), isTrue);
  });

  test('1단계: 구간을 줄여 패스가 밖으로 나가면 막는다', () {
    final original = detail(passes: [pass(1, 8, 10)]);
    final shrunk = edit(original, endedAt: DateTime(2026, 10, 30, 9));
    expect(shrunk.validate(original), contains('패스를 먼저 고치세요'));
  });

  test('2단계: 패스 중복·겹침·구간 밖을 막고 맞닿음은 허용한다', () {
    final passes = [pass(1, 8, 9), pass(2, 9, 10)];
    expect(
      validatePassRange(
        passNo: 2,
        startedAt: DateTime(2026, 10, 30, 9),
        endedAt: DateTime(2026, 10, 30, 10),
        jobStartedAt: DateTime(2026, 10, 30, 8),
        jobEndedAt: DateTime(2026, 10, 30, 10),
        passes: passes,
      ),
      contains('이미 있습니다'),
    );
    expect(
      validatePassRange(
        passNo: 3,
        startedAt: DateTime(2026, 10, 30, 8, 30),
        endedAt: DateTime(2026, 10, 30, 9),
        jobStartedAt: DateTime(2026, 10, 30, 8),
        jobEndedAt: DateTime(2026, 10, 30, 10),
        passes: passes,
      ),
      contains('겹칩니다'),
    );
    // 2패스 시작(9시)에 맞닿는 3패스는 겹침이 아니다. 단 구간 검사를 위해 작업 종료를 넓힌다.
    expect(
      validatePassRange(
        passNo: 3,
        startedAt: DateTime(2026, 10, 30, 10),
        endedAt: DateTime(2026, 10, 30, 11),
        jobStartedAt: DateTime(2026, 10, 30, 8),
        jobEndedAt: DateTime(2026, 10, 30, 11),
        passes: passes,
      ),
      '',
    );
    final draft = PassEditDraft(
      passNo: 1,
      kind: PassKind.root,
      startedAt: DateTime(2026, 10, 30, 8),
      endedAt: DateTime(2026, 10, 30, 9),
    );
    expect(draft.changedFields(pass(1, 8, 9)), ['pass_type']);
  });
}
