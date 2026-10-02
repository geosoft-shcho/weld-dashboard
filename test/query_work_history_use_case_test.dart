import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/equipment.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_item.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_project_filter.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_query.dart';
import 'package:weld_dashboard/src/domain/entities/worker.dart';
import 'package:weld_dashboard/src/domain/use_cases/query_work_history_use_case.dart';

void main() {
  test('default query returns latest 20 of 22 rows and keeps more', () {
    final board = QueryWorkHistoryUseCase().execute(
      catalog: _catalog(),
      query: WorkHistoryQuery.initial(),
    );
    expect(board.totalCount, 22);
    expect(board.visibleRows.length, 20);
    expect(board.doesHaveMore, isTrue);
    expect(board.visibleRows.first.historyId, 'H001');
    expect(board.visibleRows.last.historyId, 'H020');
  });

  test('second batch shows all rows without a pager', () {
    final board = QueryWorkHistoryUseCase().execute(
      catalog: _catalog(),
      query: WorkHistoryQuery.initial().copyWith(visibleCount: 40),
    );
    expect(board.visibleRows.length, 22);
    expect(board.doesHaveMore, isFalse);
    expect(board.visibleRows.last.historyId, 'H022');
  });

  test('common key partial match and project filter narrow the rows', () {
    final board = QueryWorkHistoryUseCase().execute(
      catalog: _catalog(),
      query: WorkHistoryQuery.initial().copyWith(
        commonKey: 'J-A-14',
        projectNo: 'TP129',
        visibleCount: 40,
      ),
    );
    expect(board.visibleRows.map((item) => item.historyId).toList(), [
      'H001',
      'H009',
      'H017',
    ]);
    expect(board.visibleRows.first.passCount, 3);
    expect(board.visibleRows.first.attachmentCount, 2);
    expect(board.projects, isNotEmpty);
  });

  test('invalid date range returns no rows', () {
    final board = QueryWorkHistoryUseCase().execute(
      catalog: _catalog(),
      query: WorkHistoryQuery.initial().copyWith(
        fromDate: DateTime(2026, 9, 7),
        toDate: DateTime(2026, 9, 1),
      ),
    );
    expect(board.query.doesHaveInvalidDateRange, isTrue);
    expect(board.totalCount, 0);
    expect(board.visibleRows, isEmpty);
  });
}

WorkHistoryCatalog _catalog() {
  const projects = [
    WorkHistoryProjectFilter(
      projectNo: 'TP129',
      projectName: '압력용기 공사',
      units: [
        WorkHistoryUnitFilter(unitNo: '05', itemCodes: ['LD-A']),
      ],
    ),
    WorkHistoryProjectFilter(
      projectNo: 'DEMO',
      projectName: '데모',
      units: [
        WorkHistoryUnitFilter(unitNo: '00', itemCodes: ['P600-1']),
      ],
    ),
  ];
  const workers = [
    Worker(workerId: 'WK-01', workerName: '박대조'),
    Worker(workerId: 'WK-02', workerName: '최실측'),
  ];
  const equipments = [
    Equipment(
      equipmentId: 'EQ-01',
      equipmentName: '용접기 A라인-1',
      lineName: 'A라인',
    ),
  ];
  final items = [
    for (var index = 1; index <= 22; index++)
      WorkHistoryItem(
        historyId: 'H${index.toString().padLeft(3, '0')}',
        commonKey: index == 1 || index == 9 || index == 17
            ? 'WO-2026-0312|J-A-14'
            : 'WO-2026-0318|J-B-03',
        projectNo: index == 1 || index == 9 || index == 17 ? 'TP129' : 'DEMO',
        unitNo: index == 1 || index == 9 || index == 17 ? '05' : '00',
        itemCode: index == 1 || index == 9 || index == 17 ? 'LD-A' : 'P600-1',
        itemName: index == 1 || index == 9 || index == 17
            ? 'LEG DIAGONAL A'
            : '600 파이프 1번',
        workerId: 'WK-01',
        workerName: '박대조',
        equipmentId: 'EQ-01',
        equipmentName: '용접기 A라인-1',
        workedAt: DateTime(2026, 9, 6).subtract(Duration(days: index - 1)),
        passCount: index == 1 || index == 9 || index == 17 ? 3 : 1,
        attachmentCount: index == 1 ? 2 : 0,
      ),
  ];
  return WorkHistoryCatalog(
    items: items,
    projects: projects,
    workers: workers,
    equipments: equipments,
  );
}
