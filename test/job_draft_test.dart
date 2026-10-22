import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/job_draft.dart';

JobDraft draft({
  DateTime? startedAt,
  DateTime? endedAt,
  List<JobPassDraft> passes = const [],
}) {
  return JobDraft(
    projectId: '7',
    projectNo: 'TP129',
    unitNo: '05',
    itemCode: 'TFPB',
    itemName: '',
    jointNo: 'DGT-ELA-01',
    workerId: '',
    startedAt: startedAt ?? DateTime(2026, 10, 30, 8),
    endedAt: endedAt,
    passes: passes,
  );
}

void main() {
  test('문제없는 작업은 통과한다', () {
    final job = draft(
      endedAt: DateTime(2026, 10, 30, 9),
      passes: [
        JobPassDraft(
          passNo: 1,
          startedAt: DateTime(2026, 10, 30, 8),
          endedAt: DateTime(2026, 10, 30, 9),
        ),
      ],
    );
    expect(job.validate(), '');
    expect(normalizeUnitNo('5'), '05');
    expect(normalizeCode(' tf pb '), 'TFPB');
  });

  test('겹치는 패스와 구간 밖 패스를 막는다', () {
    final overlapped = draft(
      passes: [
        JobPassDraft(
          passNo: 1,
          startedAt: DateTime(2026, 10, 30, 8),
          endedAt: DateTime(2026, 10, 30, 8, 30),
        ),
        JobPassDraft(
          passNo: 2,
          startedAt: DateTime(2026, 10, 30, 8, 15),
          endedAt: DateTime(2026, 10, 30, 9),
        ),
      ],
    );
    expect(overlapped.validate(), contains('겹칩니다'));

    final outside = draft(
      endedAt: DateTime(2026, 10, 30, 9),
      passes: [JobPassDraft(passNo: 1, startedAt: DateTime(2026, 10, 30, 10))],
    );
    expect(outside.validate(), contains('구간 밖'));
  });
}
