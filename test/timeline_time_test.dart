import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/repositories/job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/timeline_time.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_job_timeline_use_case.dart';

void main() {
  test('keeps nanoseconds as text and converts only for display', () {
    expect(secondsFromNanoseconds('0'), 0);
    expect(secondsFromNanoseconds('1000000000'), 1);
    expect(secondsFromNanoseconds('1500000000'), 1.5);
    expect(secondsFromNanoseconds(''), 0);
    expect(isOpenNanosecondInterval('0', '1000000000'), isTrue);
    expect(isOpenNanosecondInterval('5', '5'), isFalse);
    expect(nanosecondsFromSeconds(0), '0');
    expect(nanosecondsFromSeconds(-1), '0');
    expect(nanosecondsFromSeconds(1), '1000000000');
    expect(nanosecondsFromSeconds(1.5), '1500000000');
  });

  test('empty job id does not call the repository', () async {
    final timeline = await GetJobTimelineUseCase(
      _ThrowingTimelineRepository(),
    ).execute(jobId: '');
    expect(timeline.tracks, isEmpty);
  });
}

class _ThrowingTimelineRepository implements JobTimelineRepository {
  @override
  Future<JobTimeline> getTimeline({required String jobId}) {
    throw StateError('should not load $jobId');
  }

  @override
  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) {
    throw StateError('unused');
  }

  @override
  Future<void> updateTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) {
    throw StateError('unused');
  }

  @override
  Future<void> deleteTrack({required String trackId}) {
    throw StateError('unused');
  }

  @override
  Future<void> createClip({
    required String trackId,
    required TimelineClipKind kind,
    required String startNs,
    required String endNs,
    String assetId = '',
    String labelValueId = '',
    String description = '',
    bool omitsKind = false,
    List<String> inputClipIds = const [],
  }) {
    throw StateError('unused');
  }

  @override
  Future<void> updateClip({
    required String clipId,
    String? trackId,
    String? startNs,
    String? endNs,
    String? assetId,
    String? labelValueId,
    String? description,
    bool? isReviewed,
  }) {
    throw StateError('unused');
  }

  @override
  Future<void> deleteClip({required String clipId}) {
    throw StateError('unused');
  }

  @override
  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) {
    throw StateError('unused');
  }
}
