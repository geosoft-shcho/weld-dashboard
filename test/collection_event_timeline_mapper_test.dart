import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/presentation/features/collection_monitoring/widgets/collection_event_timeline_mapper.dart';

void main() {
  test('zoom 24 with wide budget uses fit ppm to fill viewport', () {
    // zoomPpm for 24h = 0.8; budget 1358 / 1440 ≈ 0.943
    final ppm = CollectionEventTimelineMapper.pixelsPerMinuteForViewport(
      zoomHours: 24,
      canvasBudget: 1358,
      startHour: 0,
      endHour: 24,
    );
    expect(ppm, closeTo(1358 / 1440, 0.0001));
    expect(ppm * 1440, closeTo(1358, 0.01));
  });

  test('zoom 4 keeps denser zoom ppm and exceeds budget', () {
    final zoomPpm = CollectionEventTimelineMapper.pixelsPerMinute(4);
    final ppm = CollectionEventTimelineMapper.pixelsPerMinuteForViewport(
      zoomHours: 4,
      canvasBudget: 1358,
      startHour: 0,
      endHour: 24,
    );
    expect(ppm, zoomPpm);
    expect(ppm * 1440, greaterThan(1358));
  });

  test('non-finite or empty budget falls back to zoom ppm', () {
    final zoomPpm = CollectionEventTimelineMapper.pixelsPerMinute(24);
    expect(
      CollectionEventTimelineMapper.pixelsPerMinuteForViewport(
        zoomHours: 24,
        canvasBudget: double.infinity,
        startHour: 0,
        endHour: 24,
      ),
      zoomPpm,
    );
    expect(
      CollectionEventTimelineMapper.pixelsPerMinuteForViewport(
        zoomHours: 24,
        canvasBudget: 0,
        startHour: 0,
        endHour: 24,
      ),
      zoomPpm,
    );
  });

  test('short range fits budget across fewer minutes', () {
    final ppm = CollectionEventTimelineMapper.pixelsPerMinuteForViewport(
      zoomHours: 24,
      canvasBudget: 800,
      startHour: 8,
      endHour: 12,
    );
    expect(ppm, closeTo(800 / 240, 0.0001));
  });
}
