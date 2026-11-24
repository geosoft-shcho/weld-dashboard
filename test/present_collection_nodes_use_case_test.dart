import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/collected_node.dart';
import 'package:weld_dashboard/src/domain/entities/collection_board_query.dart';
import 'package:weld_dashboard/src/domain/use_cases/present_collection_nodes_use_case.dart';

void main() {
  final useCase = PresentCollectionNodesUseCase();
  final day = DateTime(2026, 10, 26);
  final query = CollectionBoardQuery.initial().copyWith(
    selectedDate: day,
    startMinutes: 0,
    endMinutes: 1440,
  );

  CollectedNode nodeWith(List<CollectedTimeRange> segments) {
    return CollectedNode(
      path: const CollectedNodePath(
        view: CollectedNodeView.project,
        level: CollectedNodeLevel.project,
        projectNo: 'TEST1020',
        jobId: '',
        passId: '',
      ),
      label: '공사테스트',
      hasChildren: true,
      assetCount: 1,
      totalSizeBytes: 1,
      firstRecordedAt: null,
      lastRecordedAt: null,
      lastCollectedAt: null,
      jobCount: 1,
      workDurationSeconds: 0,
      startedAt: segments.first.startedAt,
      endedAt: segments.last.endedAt,
      contentUrl: '',
      segments: segments,
    );
  }

  test('drops point segments before the selected day window', () {
    final board = useCase.execute(
      nodes: [
        nodeWith([
          CollectedTimeRange(
            startedAt: DateTime(2026, 9, 14, 15),
            endedAt: DateTime(2026, 9, 14, 15),
          ),
        ]),
      ],
      query: query,
    );
    expect(board.timeline.events, isEmpty);
  });

  test('keeps in-window points at the original startedAt', () {
    final pointAt = DateTime(2026, 10, 26, 11, 30);
    final board = useCase.execute(
      nodes: [
        nodeWith([
          CollectedTimeRange(startedAt: pointAt, endedAt: pointAt),
        ]),
      ],
      query: query,
    );
    expect(board.timeline.events, hasLength(1));
    expect(board.timeline.events.single.isPoint, isTrue);
    expect(board.timeline.events.single.eventAt, pointAt);
  });

  test('clips spanning ranges to the selected day window', () {
    final board = useCase.execute(
      nodes: [
        nodeWith([
          CollectedTimeRange(
            startedAt: DateTime(2026, 10, 25, 20),
            endedAt: DateTime(2026, 10, 27, 10),
          ),
        ]),
      ],
      query: query,
    );
    expect(board.timeline.events, hasLength(1));
    final event = board.timeline.events.single;
    expect(event.isPoint, isFalse);
    expect(event.eventAt, DateTime(2026, 10, 26));
    expect(event.durationSec, 24 * 60 * 60);
  });
}
