import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/asset_lookup_row.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_item.dart';
import 'package:weld_dashboard/src/domain/use_cases/resolve_latest_pass_profile_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/resolve_latest_quality_issue_use_case.dart';

void main() {
  test('picks first job with passes from ListJobs order', () {
    final target = ResolveLatestPassProfileUseCase().execute(
      jobs: [
        _item('H-NEW', 'KEY-B', passCount: 2, passId: 'P2'),
        _item('H-OLD', 'KEY-A', passCount: 1, passId: 'P1'),
        _item('H-NONE', 'KEY-C', passCount: 0),
      ],
    );
    expect(target?.jobId, 'H-NEW');
    expect(target?.commonKey, 'KEY-B');
    expect(target?.passId, 'P2');
  });

  test('returns null when no job has passes', () {
    final target = ResolveLatestPassProfileUseCase().execute(
      jobs: [_item('H1', 'KEY-X', passCount: 0)],
    );
    expect(target, isNull);
  });

  test('picks first job with hasReport', () {
    final target = ResolveLatestQualityIssueUseCase().execute(
      jobs: [
        _item('H1', 'KEY-A', hasReport: false, passId: 'PASS-A'),
        _item('H2', 'KEY-B', hasReport: true, passId: 'PASS-B'),
      ],
    );
    expect(target?.jobId, 'H2');
    expect(target?.commonKey, 'KEY-B');
    expect(target?.passId, 'PASS-B');
    expect(target?.linkId, '');
  });

  test('returns null when no job has report', () {
    final target = ResolveLatestQualityIssueUseCase().execute(
      jobs: [_item('H1', 'KEY-A', hasReport: false)],
    );
    expect(target, isNull);
  });

  test('pass and quality latest jobs may differ', () {
    final jobs = [
      _item('H-PASS', 'KEY-PASS', passCount: 1, passId: 'P1'),
      _item('H-QUAL', 'KEY-QUAL', hasReport: true, passId: 'PQ'),
    ];
    final pass = ResolveLatestPassProfileUseCase().execute(jobs: jobs);
    final quality = ResolveLatestQualityIssueUseCase().execute(jobs: jobs);
    expect(pass?.commonKey, 'KEY-PASS');
    expect(quality?.commonKey, 'KEY-QUAL');
  });
}

WorkHistoryItem _item(
  String jobId,
  String commonKey, {
  int passCount = 0,
  bool hasReport = false,
  String passId = '',
}) {
  return WorkHistoryItem(
    jobId: jobId,
    commonKey: commonKey,
    projectNo: 'TP129',
    unitNo: '05',
    itemCode: 'LD-A',
    itemName: 't',
    hasReport: hasReport,
    workerId: 'W',
    workerName: 'w',
    equipmentId: 'E',
    equipmentName: 'e',
    workedAt: DateTime(2026, 9, 6),
    passCount: passCount,
    attachmentCount: 0,
    passes: passId.isEmpty
        ? const []
        : [JobPassOption(passId: passId, passNo: 1)],
  );
}
