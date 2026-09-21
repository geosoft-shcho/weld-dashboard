import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/collection_event.dart';
import 'package:weld_dashboard/src/domain/entities/connection_status.dart';
import 'package:weld_dashboard/src/domain/entities/time_sync_status.dart';
import 'package:weld_dashboard/src/presentation/features/collection_monitoring/widgets/collection_roadmap_layout.dart';

void main() {
  CollectionEvent eventAt(int hour, int minute, {String id = 'e'}) {
    return CollectionEvent(
      eventId: id,
      equipmentId: 'EQ-01',
      equipmentName: 'W1',
      lineName: 'A라인',
      eventAt: DateTime(2026, 9, 7, hour, minute),
      durationSec: 60,
      connectionStatus: ConnectionStatus.connected,
      receivedCount: 1,
      windowLabel: '1m',
      lossRatePercent: null,
      timeSyncStatus: TimeSyncStatus.synced,
      clockOffsetMs: null,
    );
  }

  test('places later events further right and stacks overlapping lanes', () {
    final laid = layoutRoadmapMilestones(
      events: [
        eventAt(8, 0, id: 'a'),
        eventAt(8, 5, id: 'b'), // overlaps 168px at ppm=2 → needs new lane
        eventAt(12, 0, id: 'c'),
      ],
      rangeStartMinutes: 0,
      pixelsPerMinute: 2,
    );
    expect(laid.map((m) => m.event.eventId), ['a', 'b', 'c']);
    expect(laid[0].lane, 0);
    expect(laid[0].isAbove, isTrue);
    expect(laid[1].lane, greaterThan(0));
    expect(laid[2].startMinutes, 12 * 60);
    expect(laid[2].startMinutes, greaterThan(laid[0].startMinutes));
  });
}
