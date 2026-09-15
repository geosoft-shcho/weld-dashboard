import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/collection_assignment.dart';
import 'package:weld_dashboard/src/domain/entities/collection_board_query.dart';
import 'package:weld_dashboard/src/domain/entities/collection_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/collection_event.dart';
import 'package:weld_dashboard/src/domain/entities/collection_status.dart';
import 'package:weld_dashboard/src/domain/entities/connection_status.dart';
import 'package:weld_dashboard/src/domain/entities/equipment.dart';
import 'package:weld_dashboard/src/domain/entities/project.dart';
import 'package:weld_dashboard/src/domain/entities/time_sync_status.dart';
import 'package:weld_dashboard/src/domain/entities/timeline_view_kind.dart';
import 'package:weld_dashboard/src/domain/entities/worker.dart';
import 'package:weld_dashboard/src/domain/use_cases/query_collection_board_use_case.dart';

void main() {
  test('default snapshot KPI matches 2026-09-07 collection_status', () {
    final board = QueryCollectionBoardUseCase().execute(
      catalog: _catalog(),
      query: CollectionBoardQuery.initial(),
    );
    expect(board.kpi.equipmentCount, 8);
    expect(board.kpi.connectedCount, 5);
    expect(board.kpi.disconnectedCount, 2);
    expect(board.kpi.errorCount, 1);
    expect(board.kpi.receivedCount, 8272);
    expect(board.kpi.windowLabel, '최근 5분');
    expect(board.kpi.lossWarningCount, 4);
    expect(board.kpi.syncedCount, 3);
    expect(board.kpi.delayedCount, 2);
    expect(board.kpi.unsyncedCount, 3);
    expect(board.kpi.lossRateAverage, closeTo(35.542857, 0.001));
    expect(board.rows.length, 8);
    expect(board.timeline.viewKind, TimelineViewKind.resource);
    expect(board.timeline.resources.length, 8);
    expect(board.timeline.sections.map((section) => section.label).toList(), [
      '압력용기 공사',
      '배관·탱크 공사',
      '철의장 공사',
      '미배정',
    ]);
  });

  test('PJ-01 assignment filter keeps EQ-01 and EQ-02', () {
    final board = QueryCollectionBoardUseCase().execute(
      catalog: _catalog(),
      query: CollectionBoardQuery.initial().copyWith(projectIds: ['PJ-01']),
    );
    expect(board.rows.map((row) => row.equipmentId).toList(), [
      'EQ-01',
      'EQ-02',
    ]);
  });

  test(
    'one equipment filter resolves to day view and keeps empty-row resource when forced',
    () {
      final dayBoard = QueryCollectionBoardUseCase().execute(
        catalog: _catalogWithEvents(),
        query: CollectionBoardQuery.initial().copyWith(equipmentIds: ['EQ-01']),
      );
      expect(dayBoard.timeline.viewKind, TimelineViewKind.day);
      expect(
        dayBoard.timeline.events.every((event) => event.equipmentId == 'EQ-01'),
        isTrue,
      );

      final resourceBoard = QueryCollectionBoardUseCase().execute(
        catalog: _catalogWithEvents(),
        query: CollectionBoardQuery.initial().copyWith(
          equipmentIds: ['EQ-01'],
          viewKind: TimelineViewKind.resource,
        ),
      );
      expect(resourceBoard.timeline.viewKind, TimelineViewKind.resource);
      expect(resourceBoard.timeline.resources.length, 1);

      final roadmapBoard = QueryCollectionBoardUseCase().execute(
        catalog: _catalogWithEvents(),
        query: CollectionBoardQuery.initial().copyWith(
          viewKind: TimelineViewKind.roadmap,
        ),
      );
      expect(roadmapBoard.timeline.viewKind, TimelineViewKind.roadmap);
      expect(roadmapBoard.timeline.eventCount, greaterThan(0));
    },
  );

  test(
    'timeline date range drops other-day events and keeps empty equipment rows',
    () {
      final board = QueryCollectionBoardUseCase().execute(
        catalog: _catalogWithEvents(),
        query: CollectionBoardQuery.initial(),
      );
      expect(
        board.timeline.events.every((event) => event.eventAt.day == 7),
        isTrue,
      );
      expect(board.timeline.resources.length, 8);
    },
  );
}

CollectionCatalog _catalog({List<CollectionEvent> events = const []}) {
  final snapshotAt = DateTime(2026, 9, 7, 9, 50);
  return CollectionCatalog(
    snapshotAt: snapshotAt,
    events: events,
    projects: const [
      Project(projectId: 'PJ-01', projectName: '압력용기 공사'),
      Project(projectId: 'PJ-02', projectName: '배관·탱크 공사'),
      Project(projectId: 'PJ-03', projectName: '철의장 공사'),
    ],
    workers: const [
      Worker(workerId: 'WK-01', workerName: '박대조'),
      Worker(workerId: 'WK-02', workerName: '최실측'),
      Worker(workerId: 'WK-03', workerName: '정용접'),
      Worker(workerId: 'WK-04', workerName: '한기능'),
      Worker(workerId: 'WK-05', workerName: '오현장'),
      Worker(workerId: 'WK-06', workerName: '윤조공'),
    ],
    equipments: const [
      Equipment(
        equipmentId: 'EQ-01',
        equipmentName: '용접기 A라인-1',
        lineName: 'A라인',
      ),
      Equipment(
        equipmentId: 'EQ-02',
        equipmentName: '용접기 A라인-2',
        lineName: 'A라인',
      ),
      Equipment(
        equipmentId: 'EQ-03',
        equipmentName: '용접기 B라인-1',
        lineName: 'B라인',
      ),
      Equipment(
        equipmentId: 'EQ-04',
        equipmentName: '용접기 B라인-2',
        lineName: 'B라인',
      ),
      Equipment(
        equipmentId: 'EQ-05',
        equipmentName: '용접기 C라인-1',
        lineName: 'C라인',
      ),
      Equipment(
        equipmentId: 'EQ-06',
        equipmentName: '용접기 C라인-2',
        lineName: 'C라인',
      ),
      Equipment(
        equipmentId: 'EQ-07',
        equipmentName: '용접기 D라인-1',
        lineName: 'D라인',
      ),
      Equipment(
        equipmentId: 'EQ-08',
        equipmentName: '용접기 D라인-2',
        lineName: 'D라인',
      ),
    ],
    assignments: [
      CollectionAssignment(
        assignmentId: 'AS-0702',
        equipmentId: 'EQ-01',
        projectId: 'PJ-01',
        workerId: 'WK-02',
        assignedFrom: DateTime(2026, 9, 7, 8),
        assignedTo: DateTime(2026, 9, 7, 18),
      ),
      CollectionAssignment(
        assignmentId: 'AS-0703',
        equipmentId: 'EQ-02',
        projectId: 'PJ-01',
        workerId: 'WK-02',
        assignedFrom: DateTime(2026, 9, 7, 6),
        assignedTo: DateTime(2026, 9, 7, 18),
      ),
      CollectionAssignment(
        assignmentId: 'AS-0704',
        equipmentId: 'EQ-03',
        projectId: 'PJ-02',
        workerId: 'WK-03',
        assignedFrom: DateTime(2026, 9, 7, 6),
        assignedTo: DateTime(2026, 9, 7, 18),
      ),
      CollectionAssignment(
        assignmentId: 'AS-0705',
        equipmentId: 'EQ-04',
        projectId: 'PJ-02',
        workerId: 'WK-06',
        assignedFrom: DateTime(2026, 9, 7, 7),
        assignedTo: DateTime(2026, 9, 7, 18),
      ),
      CollectionAssignment(
        assignmentId: 'AS-0706',
        equipmentId: 'EQ-05',
        projectId: 'PJ-02',
        workerId: 'WK-04',
        assignedFrom: DateTime(2026, 9, 7, 6),
        assignedTo: DateTime(2026, 9, 7, 18),
      ),
      CollectionAssignment(
        assignmentId: 'AS-0707',
        equipmentId: 'EQ-06',
        projectId: 'PJ-02',
        workerId: 'WK-04',
        assignedFrom: DateTime(2026, 9, 7, 7),
        assignedTo: DateTime(2026, 9, 7, 18),
      ),
      CollectionAssignment(
        assignmentId: 'AS-0708',
        equipmentId: 'EQ-07',
        projectId: 'PJ-03',
        workerId: 'WK-05',
        assignedFrom: DateTime(2026, 9, 7, 6),
        assignedTo: DateTime(2026, 9, 7, 18),
      ),
    ],
    statuses: [
      CollectionStatus(
        equipmentId: 'EQ-01',
        snapshotAt: snapshotAt,
        connectionStatus: ConnectionStatus.connected,
        receivedCount: 1840,
        windowLabel: '최근 5분',
        lossRatePercent: 1.2,
        timeSyncStatus: TimeSyncStatus.synced,
        clockOffsetMs: 3,
        lastReceivedAt: DateTime(2026, 9, 7, 9, 49, 52),
      ),
      CollectionStatus(
        equipmentId: 'EQ-02',
        snapshotAt: snapshotAt,
        connectionStatus: ConnectionStatus.connected,
        receivedCount: 1622,
        windowLabel: '최근 5분',
        lossRatePercent: 12.4,
        timeSyncStatus: TimeSyncStatus.synced,
        clockOffsetMs: 8,
        lastReceivedAt: DateTime(2026, 9, 7, 9, 49, 41),
      ),
      CollectionStatus(
        equipmentId: 'EQ-03',
        snapshotAt: snapshotAt,
        connectionStatus: ConnectionStatus.disconnected,
        receivedCount: 0,
        windowLabel: '최근 5분',
        lossRatePercent: 100,
        timeSyncStatus: TimeSyncStatus.unsynced,
        clockOffsetMs: null,
        lastReceivedAt: DateTime(2026, 9, 7, 8, 12, 4),
      ),
      CollectionStatus(
        equipmentId: 'EQ-04',
        snapshotAt: snapshotAt,
        connectionStatus: ConnectionStatus.error,
        receivedCount: 94,
        windowLabel: '최근 5분',
        lossRatePercent: 41.8,
        timeSyncStatus: TimeSyncStatus.delayed,
        clockOffsetMs: 420,
        lastReceivedAt: DateTime(2026, 9, 7, 9, 47, 18),
      ),
      CollectionStatus(
        equipmentId: 'EQ-05',
        snapshotAt: snapshotAt,
        connectionStatus: ConnectionStatus.connected,
        receivedCount: 1710,
        windowLabel: '최근 5분',
        lossRatePercent: 4.6,
        timeSyncStatus: TimeSyncStatus.delayed,
        clockOffsetMs: 180,
        lastReceivedAt: DateTime(2026, 9, 7, 9, 49, 33),
      ),
      CollectionStatus(
        equipmentId: 'EQ-06',
        snapshotAt: snapshotAt,
        connectionStatus: ConnectionStatus.connected,
        receivedCount: 980,
        windowLabel: '최근 5분',
        lossRatePercent: null,
        timeSyncStatus: TimeSyncStatus.unsynced,
        clockOffsetMs: null,
        lastReceivedAt: DateTime(2026, 9, 7, 9, 48, 11),
      ),
      CollectionStatus(
        equipmentId: 'EQ-07',
        snapshotAt: snapshotAt,
        connectionStatus: ConnectionStatus.connected,
        receivedCount: 2014,
        windowLabel: '최근 5분',
        lossRatePercent: 0.8,
        timeSyncStatus: TimeSyncStatus.synced,
        clockOffsetMs: 2,
        lastReceivedAt: DateTime(2026, 9, 7, 9, 49, 58),
      ),
      CollectionStatus(
        equipmentId: 'EQ-08',
        snapshotAt: snapshotAt,
        connectionStatus: ConnectionStatus.disconnected,
        receivedCount: 12,
        windowLabel: '최근 5분',
        lossRatePercent: 88,
        timeSyncStatus: TimeSyncStatus.unsynced,
        clockOffsetMs: null,
        lastReceivedAt: DateTime(2026, 9, 6, 22, 4, 40),
      ),
    ],
  );
}

CollectionCatalog _catalogWithEvents() {
  return _catalog(
    events: [
      CollectionEvent(
        eventId: 'EV-001',
        equipmentId: 'EQ-01',
        equipmentName: '용접기 A라인-1',
        lineName: 'A라인',
        eventAt: DateTime(2026, 9, 6, 16),
        durationSec: 9000,
        connectionStatus: ConnectionStatus.connected,
        receivedCount: 1760,
        windowLabel: '최근 5분',
        lossRatePercent: 1,
        timeSyncStatus: TimeSyncStatus.synced,
        clockOffsetMs: 4,
      ),
      CollectionEvent(
        eventId: 'EV-007',
        equipmentId: 'EQ-01',
        equipmentName: '용접기 A라인-1',
        lineName: 'A라인',
        eventAt: DateTime(2026, 9, 7, 6),
        durationSec: 7200,
        connectionStatus: ConnectionStatus.connected,
        receivedCount: 1720,
        windowLabel: '최근 5분',
        lossRatePercent: 0.9,
        timeSyncStatus: TimeSyncStatus.synced,
        clockOffsetMs: 4,
      ),
      CollectionEvent(
        eventId: 'EV-010',
        equipmentId: 'EQ-02',
        equipmentName: '용접기 A라인-2',
        lineName: 'A라인',
        eventAt: DateTime(2026, 9, 7, 6, 20),
        durationSec: 6000,
        connectionStatus: ConnectionStatus.connected,
        receivedCount: 1680,
        windowLabel: '최근 5분',
        lossRatePercent: 4.2,
        timeSyncStatus: TimeSyncStatus.synced,
        clockOffsetMs: 6,
      ),
    ],
  );
}
