import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/pass_waveform_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/quality_link.dart';
import 'package:weld_dashboard/src/domain/entities/weld_pass.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_item.dart';
import 'package:weld_dashboard/src/domain/use_cases/resolve_latest_pass_profile_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/resolve_latest_quality_issue_use_case.dart';

void main() {
  final snapshotAt = DateTime(2026, 9, 7, 9, 50);

  test('picks latest history with passes on or before snapshot', () {
    final target = ResolveLatestPassProfileUseCase().execute(
      catalog: _catalog(
        items: [
          _item('H-OLD', 'KEY-A', DateTime(2026, 9, 1)),
          _item('H-NEW', 'KEY-B', DateTime(2026, 9, 6)),
          _item('H-FUTURE', 'KEY-C', DateTime(2026, 9, 8)),
        ],
        passes: [
          _pass('P1', 'KEY-A'),
          _pass('P2', 'KEY-B'),
          _pass('P3', 'KEY-C'),
        ],
      ),
      snapshotAt: snapshotAt,
    );
    expect(target?.historyId, 'H-NEW');
    expect(target?.commonKey, 'KEY-B');
  });

  test('returns null when no history has passes', () {
    final target = ResolveLatestPassProfileUseCase().execute(
      catalog: _catalog(
        items: [_item('H1', 'KEY-X', DateTime(2026, 9, 6))],
        passes: [_pass('P1', 'KEY-OTHER')],
      ),
      snapshotAt: snapshotAt,
    );
    expect(target, isNull);
  });

  test('picks latest history with quality links and first link ids', () {
    final target = ResolveLatestQualityIssueUseCase().execute(
      catalog: _catalog(
        items: [
          _item('H1', 'KEY-A', DateTime(2026, 9, 5)),
          _item('H2', 'KEY-B', DateTime(2026, 9, 6)),
        ],
        links: [
          _link('L-A', 'KEY-A', 'PASS-A'),
          _link('L-B1', 'KEY-B', 'PASS-B'),
          _link('L-B2', 'KEY-B', 'PASS-B2'),
        ],
      ),
      snapshotAt: snapshotAt,
    );
    expect(target?.historyId, 'H2');
    expect(target?.commonKey, 'KEY-B');
    expect(target?.linkId, 'L-B1');
    expect(target?.passId, 'PASS-B');
  });

  test('returns null when no history has quality links', () {
    final target = ResolveLatestQualityIssueUseCase().execute(
      catalog: _catalog(
        items: [_item('H1', 'KEY-A', DateTime(2026, 9, 6))],
        links: [_link('L1', 'KEY-OTHER', 'PASS-1')],
      ),
      snapshotAt: snapshotAt,
    );
    expect(target, isNull);
  });

  test('pass and quality latest keys may differ', () {
    final catalog = _catalog(
      items: [
        _item('H-PASS', 'KEY-PASS', DateTime(2026, 9, 6, 12)),
        _item('H-QUAL', 'KEY-QUAL', DateTime(2026, 9, 6, 10)),
      ],
      passes: [_pass('P1', 'KEY-PASS')],
      links: [_link('L1', 'KEY-QUAL', 'PASS-Q')],
    );
    final pass = ResolveLatestPassProfileUseCase().execute(
      catalog: catalog,
      snapshotAt: snapshotAt,
    );
    final quality = ResolveLatestQualityIssueUseCase().execute(
      catalog: catalog,
      snapshotAt: snapshotAt,
    );
    expect(pass?.commonKey, 'KEY-PASS');
    expect(quality?.commonKey, 'KEY-QUAL');
  });
}

PassWaveformCatalog _catalog({
  required List<WorkHistoryItem> items,
  List<WeldPass> passes = const [],
  List<QualityLink> links = const [],
}) {
  return PassWaveformCatalog(
    passes: passes,
    waveformRows: const [],
    links: links,
    qualityGroups: const [],
    historyItems: items,
    workers: const [],
  );
}

WorkHistoryItem _item(String historyId, String commonKey, DateTime workedAt) {
  return WorkHistoryItem(
    historyId: historyId,
    commonKey: commonKey,
    workOrderId: 'WO',
    workOrderNo: 'WO-1',
    title: 't',
    jointId: 'J',
    jointNo: 'J1',
    jointName: 'j',
    workerId: 'W',
    workerName: 'w',
    equipmentId: 'E',
    equipmentName: 'e',
    workedAt: workedAt,
    passCount: 1,
    attachmentCount: 0,
  );
}

WeldPass _pass(String passId, String commonKey) {
  return WeldPass(
    passId: passId,
    commonKey: commonKey,
    passNo: 1,
    passName: 'root',
    masterProfileId: '',
    controlWorkerId: '',
  );
}

QualityLink _link(String linkId, String commonKey, String passId) {
  return QualityLink(
    linkId: linkId,
    commonKey: commonKey,
    qualityResultId: 'QR',
    passId: passId,
    segmentId: 'S',
    startMs: 0,
    endMs: 10,
    note: '',
  );
}
