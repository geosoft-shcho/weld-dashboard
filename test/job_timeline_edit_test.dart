import 'dart:async';

import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/timeline_board_helpers.dart';

import 'package:connectrpc/connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/repositories/job_timeline_edit_requests.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/entities/label_vocab.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment_type.dart';
import 'package:weld_dashboard/src/domain/entities/work_detail_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/repositories/job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/label_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/tool_run_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/work_detail_repository.dart';
import 'package:weld_dashboard/src/domain/timeline_time.dart';
import 'package:weld_dashboard/src/domain/use_cases/change_timeline_status_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_track_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_track_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_job_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/entities/ask_answer.dart';
import 'package:weld_dashboard/src/domain/repositories/ask_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/ask_question_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/label_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/load_job_project_id_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_history_work_attachments_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/tool_run_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_track_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_view_model.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/multimodal_timeline_board.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('update mask lists only changed fields', () {
    final request = buildUpdateClipRequest(clipId: '1', startNs: '1000000000');

    expect(request.clip.clipId.toString(), '1');
    expect(request.clip.timelineStartNs.toString(), '1000000000');
    expect(request.clip.hasTimelineEndNs(), isFalse);
    expect(request.clip.hasTrackId(), isFalse);
    expect(request.clip.hasProvenance(), isFalse);
    expect(request.updateMask.paths, ['timeline_start_ns']);
    expect(request.updateMask.toProto3Json(), 'timelineStartNs');
  });

  test('timeline update mask lists only the changed name', () {
    final request = buildUpdateTimelineRequest(jobId: '128', name: '수정한 이름');

    expect(request.timeline.jobId.toString(), '128');
    expect(request.timeline.name, '수정한 이름');
    expect(request.updateMask.paths, ['name']);
  });

  test('timeline delete sends only the job id', () {
    final request = buildDeleteTimelineRequest(jobId: '128');

    expect(request.jobId.toString(), '128');
  });

  test('track update omits fields that were not changed', () {
    final request = buildUpdateTrackRequest(trackId: '1', name: '음성');

    expect(request.track.name, '음성');
    expect(request.track.hasOrder(), isFalse);
    expect(request.track.hasVisible(), isFalse);
    expect(request.updateMask.paths, ['name']);
  });

  test('create clip attaches by asset id and skips provenance', () {
    final request = buildCreateClipRequest(
      trackId: '1',
      kind: TimelineClipKind.video,
      startNs: '0',
      endNs: '1000000000',
      assetId: '20',
    );

    expect(request.clip.hasClipId(), isFalse);
    expect(request.clip.hasProvenance(), isFalse);
    expect(request.clip.hasKind(), isTrue);
    expect(request.clip.source.assetId.toString(), '20');
    expect(request.clip.source.hasAssetDurationNs(), isFalse);
    expect(request.clip.source.hasAssetStartTimeNs(), isFalse);
    expect(request.clip.timelineEndNs.toString(), '1000000000');
    expect(
      request.clip.timelineStartNs.compareTo(request.clip.timelineEndNs),
      lessThan(0),
    );
  });

  test('create clip sends the source interval and omits read-only fields', () {
    final request = buildCreateClipRequest(
      trackId: '1',
      kind: TimelineClipKind.video,
      startNs: '10000000000',
      endNs: '399295000000',
      assetId: '20',
      sourceStartNs: '0',
      sourceEndNs: '389295000000',
    );

    expect(request.clip.source.startNs.toString(), '0');
    expect(request.clip.source.endNs.toString(), '389295000000');
    expect(request.clip.source.hasAssetDurationNs(), isFalse);
    expect(request.clip.source.hasAssetStartTimeNs(), isFalse);
    expect(request.clip.timelineStartNs.toString(), '10000000000');
    expect(request.clip.timelineEndNs.toString(), '399295000000');
  });

  test('relation clip sends kind and the two clip ids', () {
    final request = buildCreateClipRequest(
      trackId: '3',
      kind: TimelineClipKind.relation,
      startNs: '0',
      endNs: '1000000000',
      description: 'clip.mp4 ↔ take-b.mp4',
      fromClipId: '1',
      toClipId: '2',
    );

    expect(request.clip.kind.name, 'CLIP_KIND_RELATION');
    expect(request.clip.relation.fromClipId.toString(), '1');
    expect(request.clip.relation.toClipId.toString(), '2');
    expect(request.clip.hasSource(), isFalse);
    expect(request.clip.hasLabelValueId(), isFalse);
    expect(request.clip.hasProvenance(), isFalse);
    expect(request.clip.hasClipId(), isFalse);
    expect(request.clip.description, 'clip.mp4 ↔ take-b.mp4');
  });

  test('create track leaves id and visibility for the server', () {
    final request = buildCreateTrackRequest(jobId: '1', name: '자막');

    expect(request.track.jobId.toString(), '1');
    expect(request.track.hasTrackId(), isFalse);
    expect(request.track.hasVisible(), isFalse);
  });

  test('closed interval is rejected before a write', () async {
    final repository = _ThrowingTimelineRepository();
    expect(
      () => CreateClipUseCase(repository).execute(
        trackId: 'track-1',
        kind: TimelineClipKind.video,
        startNs: '5',
        endNs: '5',
      ),
      throwsA(
        isA<JobTimelineException>().having(
          (error) => error.failure,
          'failure',
          JobTimelineFailure.invalidArgument,
        ),
      ),
    );
    expect(repository.writeCount, 0);
  });

  test(
    'a source interval past the asset length is rejected before a write',
    () async {
      final repository = _ThrowingTimelineRepository();
      expect(
        () => CreateClipUseCase(repository).execute(
          trackId: 'track-1',
          kind: TimelineClipKind.video,
          startNs: '0',
          endNs: '1000000000',
          sourceStartNs: '0',
          sourceEndNs: '2000000000',
          sourceLimitNs: '1000000000',
        ),
        throwsA(
          isA<JobTimelineException>().having(
            (error) => error.failure,
            'failure',
            JobTimelineFailure.invalidArgument,
          ),
        ),
      );
      expect(repository.writeCount, 0);
    },
  );

  test('a relation of the same clip is rejected before a write', () async {
    final repository = _ThrowingTimelineRepository();
    expect(
      () => CreateClipUseCase(repository).execute(
        trackId: 'track-1',
        kind: TimelineClipKind.relation,
        startNs: '0',
        endNs: '1000000000',
        fromClipId: '1',
        toClipId: '1',
      ),
      throwsA(
        isA<JobTimelineException>().having(
          (error) => error.failure,
          'failure',
          JobTimelineFailure.invalidArgument,
        ),
      ),
    );
    expect(repository.writeCount, 0);
  });

  test('connect codes stay distinct', () {
    final overlap = timelineExceptionFromConnect(
      ConnectException(Code.failedPrecondition, '구간이 겹칩니다.'),
      emptyMessage: '실패',
    );
    final aborted = timelineExceptionFromConnect(
      ConnectException(Code.aborted, ''),
      emptyMessage: '실패',
    );

    expect(overlap.failure, JobTimelineFailure.failedPrecondition);
    expect(overlap.message, '구간이 겹칩니다.');
    expect(aborted.failure, JobTimelineFailure.aborted);
    expect(aborted.message, '실패');
  });

  test('overlap keeps the timeline already on screen', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    repository.failure = const JobTimelineException(
      '구간이 겹칩니다.',
      failure: JobTimelineFailure.failedPrecondition,
    );

    await viewModel.updateTimelineClip(
      clipId: 'clip-1',
      startNs: '1000000000',
      endNs: '2000000000',
    );

    expect(viewModel.timelineStatus, JobTimelineStatus.draft);
    expect(viewModel.timelineTracks.single.name, '영상');
    expect(viewModel.timelineHint, '구간이 겹칩니다.');
    expect(repository.getCount, 1);
    expect(repository.updateCount, 1);
    expect(repository.lastStartNs, '1000000000');
    expect(repository.lastEndNs, '2000000000');
  });

  test('aborted status change reloads the timeline', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    repository
      ..failure = const JobTimelineException(
        '먼저 바뀌었습니다.',
        failure: JobTimelineFailure.aborted,
      )
      ..nextTimeline = const JobTimeline(
        jobId: 'job-1',
        name: '최신',
        status: JobTimelineStatus.confirmed,
        tracks: [],
      );

    await viewModel.changeTimelineStatus(JobTimelineStatus.suggested);

    expect(viewModel.timelineStatus, JobTimelineStatus.confirmed);
    expect(viewModel.timelineHint, contains('다시 불러왔습니다'));
    expect(viewModel.timelineHint, contains('먼저 바뀌었습니다'));
    expect(repository.changeCount, 1);
    expect(repository.lastFromStatus, JobTimelineStatus.draft);
    expect(repository.lastToStatus, JobTimelineStatus.suggested);
    expect(repository.getCount, 2);
  });

  test('unchanged timeline save skips UpdateTimeline', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    final emptyName = await viewModel.didSaveTimeline(
      name: '  ',
      description: '',
    );
    final message = await viewModel.didSaveTimeline(
      name: '작업',
      description: '',
    );

    expect(emptyName, '타임라인 이름을 입력하세요.');
    expect(message, isNull);
    expect(repository.updateTimelineCount, 0);
  });

  test('timeline save sends only the changed name and reloads', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    final message = await viewModel.didSaveTimeline(
      name: '수정',
      description: '',
    );

    expect(message, isNull);
    expect(repository.updateTimelineCount, 1);
    expect(repository.lastUpdatedTimelineName, '수정');
    expect(repository.lastUpdatedTimelineDescription, isNull);
    expect(viewModel.timelineName, '수정');
    expect(repository.getCount, 2);
  });

  test('timeline save keeps the server message when the write fails', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    repository.failure = const JobTimelineException(
      '저장 거절',
      failure: JobTimelineFailure.invalidArgument,
    );

    final message = await viewModel.didSaveTimeline(
      name: '수정',
      description: '',
    );

    expect(message, '저장 거절');
    expect(viewModel.timelineName, '작업');
    expect(repository.getCount, 1);
  });

  test('timeline delete reloads and clears the selected clip', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    viewModel.didSelectSampleClip('clip-1');
    repository.nextTimeline = const JobTimeline(
      jobId: 'job-1',
      name: '',
      status: JobTimelineStatus.draft,
      tracks: [],
    );

    final message = await viewModel.didDeleteTimeline();

    expect(message, isNull);
    expect(repository.deleteTimelineCount, 1);
    expect(repository.lastDeletedTimelineJobId, 'job-1');
    expect(repository.getCount, 2);
    expect(viewModel.selectedClipId, isEmpty);
    expect(viewModel.timelineTracks, isEmpty);
  });

  test('server clip resize sends only the changed endpoint', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    await viewModel.didCommitClipRange('clip-1', 1, 10);

    expect(repository.updateCount, 1);
    expect(repository.lastStartNs, '1000000000');
    expect(repository.lastEndNs, isNull);
    expect(repository.lastTrackId, isNull);
  });

  test('deleting a server clip refreshes from the server', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    repository.nextTimeline = const JobTimeline(
      jobId: 'job-1',
      name: '작업',
      status: JobTimelineStatus.draft,
      tracks: [],
    );
    viewModel.didSelectSampleClip('clip-1');

    await viewModel.didTapDeleteSelection();

    expect(repository.deleteCount, 1);
    expect(viewModel.timelineTracks, isEmpty);
    expect(viewModel.selectedClipId, isEmpty);
  });

  test('track add sends only the typed name', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    await viewModel.didSubmitNewTimelineTrack('  ');
    expect(repository.createTrackCount, 0);
    expect(viewModel.timelineHint, '트랙 이름을 입력하세요.');

    await viewModel.didSubmitNewTimelineTrack('  자막  ');

    expect(repository.createTrackCount, 1);
    expect(repository.lastCreatedTrackName, '자막');
    expect(repository.lastCreatedTrackOrder, isNull);
    expect(repository.lastCreatedTrackIsVisible, isNull);
  });

  test('track edit without a selected server clip does nothing', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    await viewModel.didSubmitTimelineTrackName('카메라');
    await viewModel.didTapDeleteSelectedTimelineTrack();

    expect(repository.updateTrackCount, 0);
    expect(repository.deleteTrackCount, 0);
  });

  test('renaming uses the selected server track id and name only', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    viewModel.didSelectSampleClip('clip-1');

    await viewModel.didSubmitTimelineTrackName('영상');
    expect(repository.updateTrackCount, 0);

    await viewModel.didSubmitTimelineTrackName('카메라');

    expect(repository.updateTrackCount, 1);
    expect(repository.lastUpdatedTrackId, 'track-video');
    expect(repository.lastUpdatedTrackName, '카메라');
    expect(repository.lastUpdatedTrackOrder, isNull);
    expect(repository.lastUpdatedTrackIsVisible, isNull);
  });

  test('dropping an asset on a server track creates a clip', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(
      repository,
      workDetail: _VideoAttachmentRepository(),
    );
    await viewModel.loadAttachments();

    await viewModel.didDropAsset(
      dragData: '${VideoMultimodalViewModel.ASSET_DRAG_PREFIX}asset-9',
      laneKey: 'track-video',
      startSeconds: 1.5,
    );

    final startNs = nanosecondsFromSeconds(1.5);
    final endNs = nanosecondsFromSeconds(
      1.5 + VideoMultimodalViewModel.DEFAULT_TIMELESS_CLIP_SECONDS,
    );
    expect(repository.createClipCount, 1);
    expect(repository.lastCreatedClipTrackId, 'track-video');
    expect(repository.lastCreatedClipKind, TimelineClipKind.video);
    expect(repository.lastCreatedClipStartNs, startNs);
    expect(repository.lastCreatedClipEndNs, endNs);
    expect(isOpenNanosecondInterval(startNs, endNs), isTrue);
    expect(repository.lastCreatedClipAssetId, 'asset-9');
    expect(repository.lastCreatedClipLabelValueId, isEmpty);
    expect(repository.lastCreatedClipDescription, isEmpty);
    expect(repository.lastCreatedSourceStartNs, isEmpty);
    expect(repository.lastCreatedSourceEndNs, isEmpty);
    final notice = viewModel.takeCreatedClipNotice();
    expect(notice?.kindLabel, '영상');
    expect(notice?.body, 'take.mp4');
    expect(viewModel.takeCreatedClipNotice(), isNull);
  });

  test('dropping an asset with a duration places the whole file', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(
      repository,
      workDetail: const _VideoAttachmentRepository(durationNs: '2000000000'),
    );
    await viewModel.loadAttachments();

    await viewModel.didDropAsset(
      dragData: '${VideoMultimodalViewModel.ASSET_DRAG_PREFIX}asset-9',
      laneKey: 'track-video',
      startSeconds: 1.5,
    );

    final startNs = nanosecondsFromSeconds(1.5);
    expect(repository.createClipCount, 1);
    expect(repository.lastCreatedClipStartNs, startNs);
    expect(
      repository.lastCreatedClipEndNs,
      addNanoseconds(startNs, '2000000000'),
    );
    expect(repository.lastCreatedSourceStartNs, '0');
    expect(repository.lastCreatedSourceEndNs, '2000000000');
  });

  test('drops off a server track do not create a clip', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(
      repository,
      workDetail: _VideoAttachmentRepository(),
    );
    await viewModel.loadAttachments();
    const dragData = '${VideoMultimodalViewModel.ASSET_DRAG_PREFIX}asset-9';

    await viewModel.didDropAsset(
      dragData: dragData,
      laneKey: 'saved_attachment',
      startSeconds: 2,
    );
    await viewModel.didDropAsset(
      dragData: dragData,
      laneKey: 'audio_manual',
      startSeconds: 2,
    );
    await viewModel.didDropAsset(
      dragData: dragData,
      laneKey: 'relation',
      startSeconds: 2,
    );
    await viewModel.didDropAsset(
      dragData: 'file:take.mp4',
      laneKey: 'track-video',
      startSeconds: 1.5,
    );
    await viewModel.didDropAsset(
      dragData: dragData,
      laneKey: 'track-video',
      startSeconds: -1,
    );

    expect(repository.createClipCount, 0);
    expect(viewModel.timelineHint, '구간이 너무 짧습니다.');
    expect(viewModel.takeCreatedClipNotice(), isNull);
  });

  test('status choice sends a different status', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    await viewModel.didChooseTimelineStatus(JobTimelineStatus.draft);
    expect(repository.changeCount, 0);

    await viewModel.didChooseTimelineStatus(JobTimelineStatus.confirmed);

    expect(repository.changeCount, 1);
    expect(repository.lastFromStatus, JobTimelineStatus.draft);
    expect(repository.lastToStatus, JobTimelineStatus.confirmed);
  });

  testWidgets('server clip delete asks before the request', (tester) async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await tester.runAsync(() => viewModel.loadAttachments());
    viewModel.didSelectSampleClip('clip-1');
    repository.nextTimeline = const JobTimeline(
      jobId: 'job-1',
      name: '작업',
      status: JobTimelineStatus.draft,
      tracks: [],
    );
    await tester.pumpWidget(_board(viewModel));

    await tester.tap(find.text('클립 삭제'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('이 클립을 삭제할까요?'), findsOneWidget);
    expect(repository.deleteCount, 0);
    expect(viewModel.selectedClipId, 'clip-1');

    await tester.tap(find.text('취소'));
    await tester.pump();
    expect(repository.deleteCount, 0);
    expect(viewModel.selectedClipId, 'clip-1');

    await tester.tap(find.text('클립 삭제'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('확인'));
    await tester.pump();

    expect(repository.deleteCount, 1);
    expect(repository.lastDeletedClipId, 'clip-1');
    expect(viewModel.selectedClipId, isEmpty);
  });

  testWidgets('status choices stay in the toolbar', (tester) async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await tester.runAsync(() => viewModel.loadAttachments());
    await tester.pumpWidget(_board(viewModel));

    await tester.tap(find.text('상태 초안'));
    await tester.pump();
    expect(find.text('확정'), findsOneWidget);
    expect(repository.changeCount, 0);

    await tester.tap(find.text('확정'));
    await tester.pump();
    expect(repository.changeCount, 1);
    expect(repository.lastToStatus, JobTimelineStatus.confirmed);
    expect(find.text('확정'), findsNothing);
  });

  testWidgets('track buttons call the open track actions', (tester) async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await tester.runAsync(() => viewModel.loadAttachments());
    await tester.pumpWidget(_board(viewModel));

    await tester.enterText(
      find.byKey(const Key('new-timeline-track-name')),
      '자막',
    );
    await tester.tap(find.text('트랙 추가'));
    await tester.pump();

    expect(repository.createTrackCount, 1);
    expect(repository.lastCreatedTrackName, '자막');
    expect(repository.lastCreatedTrackOrder, isNull);
    expect(repository.lastCreatedTrackIsVisible, isNull);

    await tester.pump();
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, '트랙 수정'))
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, '트랙 삭제'))
          .onPressed,
      isNull,
    );

    viewModel.didSelectSampleClip('clip-1');
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('selected-timeline-track-name')),
      '카메라',
    );
    await tester.tap(find.text('트랙 수정'));
    await tester.pump();
    expect(repository.lastUpdatedTrackId, 'track-video');
    expect(repository.lastUpdatedTrackName, '카메라');

    await tester.tap(find.text('트랙 삭제'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('이 트랙의 클립도 함께 지워집니다.'), findsOneWidget);
    await tester.tap(find.text('지우기'));
    await tester.pump();
    expect(repository.deleteTrackCount, 1);
    expect(repository.lastDeletedTrackId, 'track-video');
  });

  test('two server clips create a relation track and clip', () async {
    final repository = _ScriptedTimelineRepository(_twoClipTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    repository.nextTimeline = _twoClipTimeline(
      extraTracks: const [
        TimelineTrack(
          trackId: 'track-relation',
          name: '관계',
          order: 2,
          clips: [],
        ),
      ],
    );
    viewModel.didTapToggleRelationMode();
    await viewModel.didTapClipForRelation('clip-1');

    expect(repository.createTrackCount, 0);
    expect(repository.createClipCount, 0);
    expect(viewModel.relationPrompt, 'Relation 모드 — 두 번째 클립을 클릭하세요');

    await viewModel.didTapClipForRelation('clip-2');

    expect(repository.createTrackCount, 1);
    expect(repository.lastCreatedTrackName, '관계');
    expect(repository.lastCreatedTrackOrder, isNull);
    expect(repository.lastCreatedTrackIsVisible, isNull);
    expect(repository.createClipCount, 1);
    expect(repository.lastCreatedClipTrackId, 'track-relation');
    expect(repository.lastCreatedClipKind, TimelineClipKind.relation);
    expect(repository.lastCreatedFromClipId, 'clip-1');
    expect(repository.lastCreatedToClipId, 'clip-2');
    expect(repository.lastCreatedClipAssetId, isEmpty);
    expect(repository.lastCreatedClipLabelValueId, isEmpty);
    expect(repository.lastCreatedClipDescription, 'clip.mp4 ↔ take-b.mp4');
    expect(repository.lastCreatedClipStartNs, '0');
    expect(repository.lastCreatedClipEndNs, '30000000000');
    expect(viewModel.isRelationMode, isFalse);
    final notice = viewModel.takeCreatedClipNotice();
    expect(notice?.kindLabel, '관계');
    expect(notice?.body, 'clip.mp4 ↔ take-b.mp4');
  });

  test('an existing relation track is reused', () async {
    final repository = _ScriptedTimelineRepository(
      _twoClipTimeline(
        extraTracks: const [
          TimelineTrack(
            trackId: 'track-later',
            name: '관계',
            order: 4,
            clips: [],
          ),
          TimelineTrack(
            trackId: 'track-earlier',
            name: ' 관계 ',
            order: 1,
            clips: [],
          ),
        ],
      ),
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    viewModel.didTapToggleRelationMode();
    await viewModel.didTapClipForRelation('clip-2');
    await viewModel.didTapClipForRelation('clip-1');

    expect(repository.createTrackCount, 0);
    expect(repository.createClipCount, 1);
    expect(repository.lastCreatedClipTrackId, 'track-earlier');
    expect(repository.lastCreatedFromClipId, 'clip-2');
    expect(repository.lastCreatedToClipId, 'clip-1');
  });

  test('the same clip twice does not write a relation', () async {
    final repository = _ScriptedTimelineRepository(_twoClipTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    viewModel.didTapToggleRelationMode();
    await viewModel.didTapClipForRelation('clip-1');
    await viewModel.didTapClipForRelation('clip-1');

    expect(repository.createTrackCount, 0);
    expect(repository.createClipCount, 0);
    expect(viewModel.isRelationMode, isTrue);
    expect(viewModel.relationPrompt, 'Relation 모드 — 두 번째 클립을 클릭하세요');
    expect(viewModel.takeCreatedClipNotice(), isNull);
  });

  test('a closed relation interval does not write', () async {
    final repository = _ScriptedTimelineRepository(
      _twoClipTimeline(
        startNs: '5',
        endNs: '5',
        secondStartNs: '5',
        secondEndNs: '5',
      ),
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    viewModel.didTapToggleRelationMode();
    await viewModel.didTapClipForRelation('clip-1');
    await viewModel.didTapClipForRelation('clip-2');

    expect(repository.createTrackCount, 0);
    expect(repository.createClipCount, 0);
    expect(viewModel.timelineHint, '구간이 너무 짧습니다.');
    expect(viewModel.isRelationMode, isTrue);
    expect(viewModel.takeCreatedClipNotice(), isNull);
  });

  test('a clip outside the timeline does not write a relation', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    viewModel.didTapToggleRelationMode();

    expect(await viewModel.didTapClipForRelation('missing'), isFalse);
    expect(repository.createTrackCount, 0);
    expect(repository.createClipCount, 0);
    expect(viewModel.relationPrompt, 'Relation 모드 — 첫 번째 클립을 클릭하세요');
  });

  test('clip selection outside relation mode does not write', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    expect(await viewModel.didTapClipForRelation('clip-1'), isFalse);
    expect(repository.createClipCount, 0);
    viewModel.didSelectSampleClip('clip-1');
    expect(viewModel.selectedClipId, 'clip-1');
    expect(viewModel.isRelationMode, isFalse);
  });

  testWidgets('relation banner cancels without a write', (tester) async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(repository);
    await tester.runAsync(() => viewModel.loadAttachments());
    await tester.pumpWidget(_board(viewModel));

    await tester.tap(find.text('클립 관계'));
    await tester.pump();
    expect(find.text('Relation 모드 — 첫 번째 클립을 클릭하세요'), findsOneWidget);
    expect(repository.createTrackCount, 0);

    await tester.tap(find.text('취소'));
    await tester.pump();
    expect(find.text('Relation 모드 — 첫 번째 클립을 클릭하세요'), findsNothing);
    expect(viewModel.isRelationMode, isFalse);
    expect(repository.createClipCount, 0);
  });

  testWidgets('a created relation clip shows a kind dialog', (tester) async {
    final repository = _ScriptedTimelineRepository(_twoClipTimeline());
    final viewModel = _viewModel(repository);
    await tester.runAsync(() => viewModel.loadAttachments());
    repository.nextTimeline = _twoClipTimeline(
      extraTracks: const [
        TimelineTrack(
          trackId: 'track-relation',
          name: '관계',
          order: 2,
          clips: [],
        ),
      ],
    );
    await tester.pumpWidget(_board(viewModel));

    await tester.tap(find.text('클립 관계'));
    await tester.pump();
    await tester.tap(find.text('clip.mp4'), warnIfMissed: false);
    await tester.pump();
    expect(find.text('관계 클립을 만들었습니다'), findsNothing);

    await tester.tap(find.text('take-b.mp4'), warnIfMissed: false);
    await tester.pump();
    await tester.pump();

    expect(find.text('클립 생성'), findsOneWidget);
    expect(find.text('관계 클립을 만들었습니다'), findsOneWidget);
    expect(find.text('clip.mp4 ↔ take-b.mp4'), findsOneWidget);
    await tester.tap(find.text('확인'));
    await tester.pump();
    expect(find.text('관계 클립을 만들었습니다'), findsNothing);
  });

  testWidgets('a created video clip shows a kind dialog', (tester) async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    final viewModel = _viewModel(
      repository,
      workDetail: _VideoAttachmentRepository(),
    );
    await tester.runAsync(() => viewModel.loadAttachments());
    await tester.pumpWidget(_board(viewModel));

    final target = tester.widget<DragTarget<String>>(
      find.byType(DragTarget<String>),
    );
    target.onAcceptWithDetails!(
      DragTargetDetails<String>(
        data: '${VideoMultimodalViewModel.ASSET_DRAG_PREFIX}asset-9',
        offset: Offset.zero,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('클립 생성'), findsOneWidget);
    expect(find.text('영상 클립을 만들었습니다'), findsOneWidget);
    expect(find.text('take.mp4'), findsOneWidget);
    await tester.tap(find.text('확인'));
    await tester.pump();
    expect(find.text('영상 클립을 만들었습니다'), findsNothing);
    expect(repository.createClipCount, 1);
    expect(repository.lastCreatedClipKind, TimelineClipKind.video);
  });

  testWidgets('row list scrolls under a fixed track labels header', (tester) async {
    final repository = _ScriptedTimelineRepository(_manyTrackTimeline());
    final viewModel = _viewModel(repository);
    await tester.runAsync(() => viewModel.loadAttachments());
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_board(viewModel));
    await tester.pump();

    expect(find.text('트랙 (24)'), findsOneWidget);
    final tagsBottom = tester.getRect(find.text('트랙 (24)')).bottom;
    final before = tester.getRect(find.text('트랙 0'));
    expect(before.top, greaterThan(tagsBottom));

    await tester.drag(
      find.byKey(const Key('timeline-track-labels')),
      const Offset(0, -420),
    );
    await tester.pump();

    expect(find.text('트랙 (24)'), findsOneWidget);
    final firstRow = tester.getRect(find.text('트랙 0'));
    expect(firstRow.bottom, lessThanOrEqualTo(tagsBottom));
    final trackClip = tester.getRect(find.text('file-0.mp4'));
    expect((firstRow.top - trackClip.top).abs(), lessThan(16));
  });

  testWidgets(
    'ruler seeks at 600 pixels per minute before and after scrolling',
    (tester) async {
      final viewModel = _viewModel(
        _ScriptedTimelineRepository(
          _timelineWithClip(
            clipId: '1',
            playbackUrl: 'https://example.test/video.mp4',
            endNs: '2700000000000',
          ),
        ),
      );
      await tester.runAsync(() => viewModel.loadAttachments());
      await tester.pumpWidget(_board(viewModel));
      final ruler = find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is TimelineRulerPainter,
      );
      expect(viewModel.pixelsPerSecond * 60, 600);
      expect(viewModel.pixelsPerSecond * 300, 3000);
      expect(viewModel.pixelsPerSecond * 400, 4000);
      await tester.tapAt(tester.getTopLeft(ruler) + const Offset(400, 5));
      await tester.pump();
      expect(viewModel.playheadSeconds, closeTo(40, 0.001));

      final scroll = tester.widget<SingleChildScrollView>(
        find
            .ancestor(of: ruler, matching: find.byType(SingleChildScrollView))
            .first,
      );
      scroll.controller!.jumpTo(600);
      await tester.pump();
      await tester.tapAt(tester.getTopLeft(ruler) + const Offset(1000, 5));
      await tester.pump();
      expect(viewModel.playheadSeconds, closeTo(100, 0.001));
    },
  );

  test(
    'selecting a clip reads GetClip and keeps the latest response',
    () async {
      final repository = _ScriptedTimelineRepository(_pairTimeline());
      repository.holdClipDetail = true;
      final viewModel = _viewModel(repository);
      await viewModel.loadAttachments();

      viewModel.didSelectSampleClip('clip-a');
      viewModel.didSelectSampleClip('clip-b');
      expect(repository.getClipIds, ['clip-a', 'clip-b']);

      repository.clipGates[1].complete(
        const ClipDetail(
          clipId: 'clip-b',
          hasAsset: true,
          fields: [
            ClipField(label: 'clipId', value: 'clip-b'),
            ClipField(label: 'provenance.targetId', value: '클립 9247'),
          ],
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.selectedClipId, 'clip-b');
      expect(
        viewModel.clipDetailFields
            .firstWhere((field) => field.label == 'provenance.targetId')
            .value,
        '클립 9247',
      );

      repository.clipGates[0].complete(
        const ClipDetail(
          clipId: 'clip-a',
          fields: [ClipField(label: 'clipId', value: 'clip-a')],
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.selectedClipId, 'clip-b');
      expect(
        viewModel.clipDetailFields.any((field) => field.value == 'clip-a'),
        isFalse,
      );
    },
  );

  test('a missing clip keeps the selected timeline clip', () async {
    final repository = _ScriptedTimelineRepository(_loadedTimeline());
    repository.clipFailure = const JobTimelineException(
      '클립을 찾지 못했습니다.',
      failure: JobTimelineFailure.notFound,
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    viewModel.didSelectSampleClip('clip-1');
    await Future<void>.delayed(Duration.zero);

    expect(repository.getClipIds, ['clip-1']);
    expect(viewModel.selectedClipId, 'clip-1');
    expect(viewModel.clipDetailMessage, '클립을 찾지 못했습니다.');
    expect(viewModel.selectedClip?.clipId, 'clip-1');
  });

  test(
    'a video GetClip plays from timelineStartNs until timelineEndNs',
    () async {
      const mediaUrl = 'http://media.example/9764.mp4';
      final repository = _ScriptedTimelineRepository(
        _timelineWithClip(
          clipId: '9764',
          playbackUrl: mediaUrl,
          endNs: '390083999999',
        ),
      );
      repository.nextClipDetail = const ClipDetail(
        clipId: '9764',
        fields: [],
        isVideo: true,
        timelineStartNs: '0',
        timelineEndNs: '390083999999',
      );
      final viewModel = _viewModel(repository);
      await viewModel.loadAttachments();

      viewModel.didSelectSampleClip('9764');
      await Future<void>.delayed(Duration.zero);

      expect(repository.getClipIds, ['9764']);
      expect(viewModel.playheadSeconds, closeTo(0, 0.0001));
      expect(viewModel.wantsPlayback, isTrue);
      expect(viewModel.activeVideoBar?.mediaUrl, mediaUrl);
      expect(viewModel.activeVideoBar?.startSeconds, closeTo(0, 0.0001));
      expect(viewModel.activeVideoBar?.endSeconds, closeTo(390.084, 0.001));

      viewModel.didReceiveVideoClock(
        mediaUrl: mediaUrl,
        localSeconds: 392,
        isPlaying: false,
      );
      expect(viewModel.playheadSeconds, closeTo(0, 0.0001));
      expect(viewModel.wantsPlayback, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 500));
      viewModel.didReceiveVideoClock(
        mediaUrl: mediaUrl,
        localSeconds: 1,
        isPlaying: true,
      );
      expect(viewModel.playheadSeconds, closeTo(1, 0.0001));

      viewModel.didReceiveVideoClock(
        mediaUrl: mediaUrl,
        localSeconds: 390.084,
        isPlaying: true,
      );
      expect(viewModel.wantsPlayback, isFalse);
      expect(viewModel.playheadSeconds, lessThan(390.084));
      expect(viewModel.activeVideoBar?.attachmentId, '9764');
    },
  );

  test('a timeline seek keeps the playing video on that time', () async {
    const mediaUrl = 'http://media.example/9764.mp4';
    final repository = _ScriptedTimelineRepository(
      _timelineWithClip(
        clipId: '9764',
        playbackUrl: mediaUrl,
        endNs: '390083999999',
      ),
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    viewModel.didTapTogglePlayback();
    viewModel.didSeekToSeconds(10);

    final bar = viewModel.activeVideoBar;
    expect(viewModel.playheadSeconds, closeTo(10, 0.0001));
    expect(viewModel.wantsPlayback, isTrue);
    expect(bar?.startSeconds, closeTo(0, 0.0001));
    expect(
      ((viewModel.playheadSeconds - bar!.startSeconds) * 1000).round(),
      10000,
    );

    viewModel.didReceiveVideoClock(
      mediaUrl: mediaUrl,
      localSeconds: 0,
      isPlaying: true,
    );
    expect(viewModel.playheadSeconds, closeTo(10, 0.0001));

    viewModel.didReceiveVideoClock(
      mediaUrl: mediaUrl,
      localSeconds: 10,
      isPlaying: true,
    );
    expect(viewModel.playheadSeconds, closeTo(10, 0.0001));

    viewModel.didReceiveVideoClock(
      mediaUrl: mediaUrl,
      localSeconds: 11,
      isPlaying: true,
    );
    expect(viewModel.playheadSeconds, closeTo(11, 0.0001));
  });

  test('a paused timeline seek stays paused', () async {
    final repository = _ScriptedTimelineRepository(
      _timelineWithClip(
        clipId: '9764',
        playbackUrl: 'http://media.example/9764.mp4',
        endNs: '390083999999',
      ),
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    viewModel.didSeekToSeconds(10);

    expect(viewModel.playheadSeconds, closeTo(10, 0.0001));
    expect(viewModel.wantsPlayback, isFalse);
    expect(viewModel.activeVideoBar?.mediaUrl, 'http://media.example/9764.mp4');
  });

  test('a seek outside every video moves only the playhead', () async {
    const mediaUrl = 'http://media.example/9764.mp4';
    final repository = _ScriptedTimelineRepository(
      _timelineWithClip(
        clipId: '9764',
        playbackUrl: mediaUrl,
        endNs: '390083999999',
      ),
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    viewModel.didTapTogglePlayback();

    viewModel.didSeekToSeconds(390.084);

    expect(viewModel.playheadSeconds, closeTo(390.084, 0.001));
    expect(viewModel.activeVideoBar, isNull);
    expect(viewModel.wantsPlayback, isFalse);

    viewModel.didReceiveVideoClock(
      mediaUrl: mediaUrl,
      localSeconds: 0,
      isPlaying: true,
    );
    expect(viewModel.playheadSeconds, closeTo(390.084, 0.001));
  });

  test('a seek on a later clip uses that clip timeline start', () async {
    const mediaUrl = 'http://media.example/later.mp4';
    final repository = _ScriptedTimelineRepository(
      _timelineWithClip(
        clipId: 'later',
        playbackUrl: mediaUrl,
        startNs: '100000000000',
        endNs: '130000000000',
      ),
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    viewModel.didSeekToSeconds(110);
    viewModel.didTapTogglePlayback();
    viewModel.didSeekToSeconds(120);

    final bar = viewModel.activeVideoBar;
    expect(viewModel.playheadSeconds, closeTo(120, 0.0001));
    expect(viewModel.wantsPlayback, isTrue);
    expect(bar?.startSeconds, closeTo(100, 0.0001));
    expect(
      ((viewModel.playheadSeconds - bar!.startSeconds) * 1000).round(),
      20000,
    );

    viewModel.didReceiveVideoClock(
      mediaUrl: mediaUrl,
      localSeconds: 10,
      isPlaying: true,
    );
    expect(viewModel.playheadSeconds, closeTo(120, 0.0001));
  });

  test('preview uses the selected track and the file start time', () async {
    const depthUrl = 'http://media.example/depth.mp4';
    const actionUrl = 'http://media.example/action.mp4';
    final repository = _ScriptedTimelineRepository(
      JobTimeline(
        jobId: 'job-1',
        name: '작업',
        tracks: [
          TimelineTrack(
            trackId: 'depth',
            name: '깊이',
            order: 1,
            clips: [
              TimelineClip(
                clipId: '101',
                trackId: 'depth',
                kind: TimelineClipKind.video,
                startNs: '0',
                endNs: '40000000000',
                assetId: '1',
                fileName: 'depth.mp4',
                playbackUrl: depthUrl,
                description: '',
                showsToolBadge: false,
                sourceStartNs: '0',
                sourceEndNs: '40000000000',
                assetDurationNs: '40000000000',
                assetStartTimeNs: '428559000000',
              ),
            ],
          ),
          TimelineTrack(
            trackId: 'action',
            name: '액션',
            order: 2,
            clips: [
              TimelineClip(
                clipId: '103',
                trackId: 'action',
                kind: TimelineClipKind.video,
                startNs: '25000000000',
                endNs: '35000000000',
                assetId: '3',
                fileName: 'action.mp4',
                playbackUrl: actionUrl,
                description: '',
                showsToolBadge: false,
                sourceStartNs: '0',
                sourceEndNs: '15000000000',
                assetDurationNs: '15000000000',
              ),
              TimelineClip(
                clipId: '104',
                trackId: 'action',
                kind: TimelineClipKind.video,
                startNs: '40000000000',
                endNs: '55000000000',
                assetId: '4',
                fileName: 'later.mp4',
                playbackUrl: 'http://media.example/later.mp4',
                description: '',
                showsToolBadge: false,
              ),
            ],
          ),
        ],
      ),
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();
    viewModel.didSeekToSeconds(28);

    expect(viewModel.activeVideoBar?.mediaUrl, depthUrl);
    expect(viewModel.fileSeekMilliseconds(viewModel.activeVideoBar!), 456559);
    expect(
      viewModel.playbackRateFor(viewModel.activeVideoBar!),
      closeTo(1, 0.0001),
    );

    viewModel.didSelectSampleClip('103');
    await Future<void>.delayed(Duration.zero);
    viewModel.didSeekToSeconds(28);

    expect(viewModel.activeVideoBar?.mediaUrl, actionUrl);
    expect(viewModel.fileSeekMilliseconds(viewModel.activeVideoBar!), 4500);
    expect(
      viewModel.playbackRateFor(viewModel.activeVideoBar!),
      closeTo(1.5, 0.0001),
    );

    viewModel.didSelectSampleClip('101');
    await Future<void>.delayed(Duration.zero);
    viewModel.didSeekToSeconds(50);

    expect(viewModel.activeVideoBar, isNull);
  });

  test('an unselected playhead uses the first covering video track', () async {
    const laterUrl = 'http://media.example/later.mp4';
    const smallUrl = 'http://media.example/small.mp4';
    const largeUrl = 'http://media.example/large.mp4';
    final repository = _ScriptedTimelineRepository(
      JobTimeline(
        jobId: 'job-1',
        name: '작업',
        tracks: [
          TimelineTrack(
            trackId: 'tag',
            name: '태그',
            order: 1,
            clips: [
              TimelineClip(
                clipId: 'tag-1',
                trackId: 'tag',
                kind: TimelineClipKind.tag,
                startNs: '0',
                endNs: '100000000000',
                assetId: '',
                fileName: '',
                playbackUrl: '',
                description: '',
                showsToolBadge: false,
              ),
            ],
          ),
          TimelineTrack(
            trackId: 'later',
            name: '나중',
            order: 2,
            clips: [
              TimelineClip(
                clipId: '102',
                trackId: 'later',
                kind: TimelineClipKind.video,
                startNs: '20000000000',
                endNs: '40000000000',
                assetId: '2',
                fileName: 'later.mp4',
                playbackUrl: laterUrl,
                description: '',
                showsToolBadge: false,
              ),
            ],
          ),
          TimelineTrack(
            trackId: 'action',
            name: '액션',
            order: 3,
            clips: [
              TimelineClip(
                clipId: '103',
                trackId: 'action',
                kind: TimelineClipKind.video,
                startNs: '0',
                endNs: '30000000000',
                assetId: '3',
                fileName: 'small.mp4',
                playbackUrl: smallUrl,
                description: '',
                showsToolBadge: false,
              ),
              TimelineClip(
                clipId: '110',
                trackId: 'action',
                kind: TimelineClipKind.video,
                startNs: '5000000000',
                endNs: '15000000000',
                assetId: '4',
                fileName: 'large.mp4',
                playbackUrl: largeUrl,
                description: '',
                showsToolBadge: false,
              ),
            ],
          ),
        ],
      ),
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    viewModel.didSeekToSeconds(10);
    expect(viewModel.playheadSeconds, closeTo(10, 0.0001));
    expect(viewModel.selectedClipId, isEmpty);
    expect(viewModel.activeVideoBar?.mediaUrl, largeUrl);

    viewModel.didSeekToSeconds(25);
    expect(viewModel.activeVideoBar?.mediaUrl, laterUrl);

    viewModel.didSeekToSeconds(50);
    expect(viewModel.playheadSeconds, closeTo(50, 0.0001));
    expect(viewModel.activeVideoBar, isNull);

    viewModel.didSelectSampleClip('tag-1');
    await Future<void>.delayed(Duration.zero);
    viewModel.didSeekToSeconds(10);
    expect(viewModel.activeVideoBar, isNull);
  });

  test(
    'a pose GetClip keeps pose selected and plays its target video',
    () async {
      const poseUrl = 'http://media.example/pose.json';
      const videoUrl = 'http://media.example/video.mp4';
      final repository = _ScriptedTimelineRepository(
        _poseTimeline('http://media.example/stale-timeline-video.mp4'),
      );
      repository.clipDetailsById['pose-1'] = const ClipDetail(
        clipId: 'pose-1',
        fields: [ClipField(label: 'kind', value: 'POSE')],
        hasAsset: true,
        isPose: true,
        timelineStartNs: '10000000000',
        timelineEndNs: '20000000000',
        sourceStartNs: '2000000000',
        sourceEndNs: '8000000000',
        assetId: '30',
        assetContentUrl: poseUrl,
        targetKind: ClipTargetKind.clip,
        targetId: 'video-1',
        hasTargetClip: true,
        targetClipId: 'video-1',
        targetClipKind: 'VIDEO',
        targetTimelineStartNs: '5000000000',
        targetTimelineEndNs: '30000000000',
        hasTargetAsset: true,
        targetAssetId: '20',
        targetAssetFileName: 'target.mp4',
        targetAssetContentUrl: videoUrl,
      );
      repository.contentByUrl[poseUrl] = _poseBody(time: 3);
      final viewModel = _viewModel(repository);
      await viewModel.loadAttachments();

      viewModel.didSelectSampleClip('pose-1');
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.selectedClipId, 'pose-1');
      expect(viewModel.selectedClip?.clipId, 'pose-1');
      expect(viewModel.activeVideoBar?.attachmentId, 'video-1');
      expect(viewModel.activeVideoBar?.mediaUrl, videoUrl);
      expect(viewModel.wantsPlayback, isTrue);
      expect(viewModel.playheadSeconds, 10);
      expect(repository.readUrls, [poseUrl]);
      expect(viewModel.activeVideoOverlayFrames, hasLength(1));
      expect(
        viewModel.activeVideoOverlayFrames.single.start,
        const Duration(seconds: 6),
      );
    },
  );

  test(
    'a pose without target clip does not select an arbitrary video',
    () async {
      final repository = _ScriptedTimelineRepository(
        _poseTimeline('http://media.example/video.mp4'),
      );
      repository.clipDetailsById['pose-1'] = const ClipDetail(
        clipId: 'pose-1',
        fields: [ClipField(label: 'kind', value: 'POSE')],
        hasAsset: true,
        isPose: true,
        timelineStartNs: '10000000000',
        timelineEndNs: '20000000000',
        assetId: '30',
        assetContentUrl: 'http://media.example/pose.json',
        hasTargetAsset: true,
        targetAssetId: '20',
        targetAssetContentUrl: 'http://media.example/video.mp4',
      );
      final viewModel = _viewModel(repository);
      await viewModel.loadAttachments();

      viewModel.didSelectSampleClip('pose-1');
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.selectedClipId, 'pose-1');
      expect(viewModel.activeVideoBar, isNull);
      expect(viewModel.clipDetailMessage, contains('대상 영상 클립'));
    },
  );

  test(
    'a pose with an asset target does not treat it as a video clip',
    () async {
      final repository = _ScriptedTimelineRepository(
        _poseTimeline('http://media.example/video.mp4'),
      );
      repository.clipDetailsById['pose-1'] = const ClipDetail(
        clipId: 'pose-1',
        fields: [ClipField(label: 'kind', value: 'POSE')],
        hasAsset: true,
        isPose: true,
        timelineStartNs: '10000000000',
        timelineEndNs: '20000000000',
        assetId: '30',
        assetContentUrl: 'http://media.example/pose.json',
        hasTargetAsset: true,
        targetAssetId: '20',
        targetAssetContentUrl: 'http://media.example/video.mp4',
      );
      final viewModel = _viewModel(repository);
      await viewModel.loadAttachments();

      viewModel.didSelectSampleClip('pose-1');
      await Future<void>.delayed(Duration.zero);

      expect(repository.getClipIds, ['pose-1']);
      expect(viewModel.activeVideoBar, isNull);
      expect(viewModel.clipDetailMessage, contains('대상 영상 클립'));
    },
  );

  test('a pose without target asset does not start video playback', () async {
    final repository = _ScriptedTimelineRepository(
      _poseTimeline('http://media.example/video.mp4'),
    );
    repository.clipDetailsById['pose-1'] = const ClipDetail(
      clipId: 'pose-1',
      fields: [],
      hasAsset: true,
      isPose: true,
      timelineStartNs: '10000000000',
      timelineEndNs: '20000000000',
      assetId: '30',
      assetContentUrl: 'http://media.example/pose.json',
      hasTargetClip: true,
      targetClipId: 'video-1',
      targetClipKind: 'VIDEO',
      targetTimelineStartNs: '5000000000',
      targetTimelineEndNs: '30000000000',
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    viewModel.didSelectSampleClip('pose-1');
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.activeVideoBar, isNull);
    expect(viewModel.clipDetailMessage, contains('대상 영상 파일'));
  });

  test('a pose uses the target returned by its own GetClip', () async {
    const poseUrl = 'http://media.example/pose.json';
    const videoUrl = 'http://media.example/target.mp4';
    final poseTimeline = _poseTimeline(videoUrl);
    final repository = _ScriptedTimelineRepository(
      JobTimeline(
        jobId: poseTimeline.jobId,
        name: poseTimeline.name,
        tracks: [poseTimeline.tracks.last],
      ),
    );
    repository.clipDetailsById['pose-1'] = const ClipDetail(
      clipId: 'pose-1',
      fields: [],
      hasAsset: true,
      isPose: true,
      timelineStartNs: '10000000000',
      timelineEndNs: '20000000000',
      assetId: '30',
      assetContentUrl: poseUrl,
      targetKind: ClipTargetKind.clip,
      targetId: 'video-1',
      hasTargetClip: true,
      targetClipId: 'video-1',
      targetClipKind: 'VIDEO',
      targetTimelineStartNs: '5000000000',
      targetTimelineEndNs: '30000000000',
      hasTargetAsset: true,
      targetAssetId: '20',
      targetAssetFileName: 'target.mp4',
      targetAssetContentUrl: videoUrl,
    );
    repository.contentByUrl[poseUrl] = _poseBody(time: 1);
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    viewModel.didSelectSampleClip('pose-1');
    await Future<void>.delayed(Duration.zero);

    expect(repository.getClipIds, ['pose-1']);
    expect(viewModel.selectedClipId, 'pose-1');
    expect(viewModel.activeVideoBar?.mediaUrl, videoUrl);
  });

  test(
    'a pose outside its target timeline aligns to the video start',
    () async {
      const poseUrl = 'http://media.example/pose.json';
      const videoUrl = 'http://media.example/video.mp4';
      final repository = _ScriptedTimelineRepository(_poseTimeline(videoUrl));
      repository.clipDetailsById['pose-1'] = const ClipDetail(
        clipId: 'pose-1',
        fields: [],
        hasAsset: true,
        isPose: true,
        timelineStartNs: '40000000000',
        timelineEndNs: '50000000000',
        assetId: '30',
        assetContentUrl: poseUrl,
        targetKind: ClipTargetKind.clip,
        targetId: 'video-1',
        hasTargetClip: true,
        targetClipId: 'video-1',
        targetClipKind: 'VIDEO',
        targetTimelineStartNs: '5000000000',
        targetTimelineEndNs: '30000000000',
        hasTargetAsset: true,
        targetAssetId: '20',
        targetAssetFileName: 'video.mp4',
        targetAssetContentUrl: videoUrl,
      );
      repository.contentByUrl[poseUrl] = _poseBody(time: 1);
      final viewModel = _viewModel(repository);
      await viewModel.loadAttachments();

      viewModel.didSelectSampleClip('pose-1');
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.activeVideoBar?.attachmentId, 'video-1');
      expect(viewModel.playheadSeconds, 5);
      expect(viewModel.activeVideoOverlayFrames, hasLength(1));
      expect(
        viewModel.activeVideoOverlayFrames.single.start,
        const Duration(seconds: 1),
      );
    },
  );

  test('a late pose body cannot overwrite a newer clip selection', () async {
    const poseUrl = 'http://media.example/pose.json';
    const videoUrl = 'http://media.example/video.mp4';
    final repository = _ScriptedTimelineRepository(_poseTimeline(videoUrl));
    repository.clipDetailsById['pose-1'] = const ClipDetail(
      clipId: 'pose-1',
      fields: [],
      hasAsset: true,
      isPose: true,
      timelineStartNs: '10000000000',
      timelineEndNs: '20000000000',
      assetId: '30',
      assetContentUrl: poseUrl,
      targetKind: ClipTargetKind.clip,
      targetId: 'video-1',
      hasTargetClip: true,
      targetClipId: 'video-1',
      targetClipKind: 'VIDEO',
      targetTimelineStartNs: '5000000000',
      targetTimelineEndNs: '30000000000',
      hasTargetAsset: true,
      targetAssetId: '20',
      targetAssetFileName: 'video.mp4',
      targetAssetContentUrl: videoUrl,
    );
    final poseBody = Completer<String>();
    repository.contentGatesByUrl[poseUrl] = poseBody;
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    viewModel.didSelectSampleClip('pose-1');
    await Future<void>.delayed(Duration.zero);
    viewModel.didSelectSampleClip('video-1');
    poseBody.complete(_poseBody(time: 1));
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.selectedClipId, 'video-1');
    expect(viewModel.activeVideoBar?.attachmentId, 'video-1');
    expect(viewModel.activeVideoOverlayFrames, isEmpty);
  });

  test('an overlapping pose is not drawn on another video', () async {
    const poseUrl = 'http://media.example/pose.json';
    const frontUrl = 'http://media.example/front.mp4';
    const targetUrl = 'http://media.example/back.mp4';
    final repository = _ScriptedTimelineRepository(
      JobTimeline(
        jobId: 'job-1',
        name: '작업',
        overlays: [
          TimelineOverlay(
            assetId: '30',
            kind: TimelineOverlayKind.pose,
            contentUrl: poseUrl,
            timelineStartNs: '0',
            timelineEndNs: '40000000000',
            sourceStartNs: '0',
            sourceEndNs: '40000000000',
          ),
        ],
        tracks: [
          TimelineTrack(
            trackId: 'front',
            name: '앞',
            order: 1,
            clips: [
              TimelineClip(
                clipId: '3065',
                trackId: 'front',
                kind: TimelineClipKind.video,
                startNs: '0',
                endNs: '40000000000',
                assetId: '11',
                fileName: 'depth_front_view.mp4',
                playbackUrl: frontUrl,
                description: '',
                showsToolBadge: false,
              ),
            ],
          ),
          TimelineTrack(
            trackId: 'back',
            name: '뒤',
            order: 2,
            clips: [
              TimelineClip(
                clipId: '9764',
                trackId: 'back',
                kind: TimelineClipKind.video,
                startNs: '0',
                endNs: '40000000000',
                assetId: '12',
                fileName: 'depth_back_color.mp4',
                playbackUrl: targetUrl,
                description: '',
                showsToolBadge: false,
              ),
            ],
          ),
          const TimelineTrack(
            trackId: 'pose',
            name: '포즈',
            order: 3,
            clips: [
              TimelineClip(
                clipId: '17364',
                trackId: 'pose',
                kind: TimelineClipKind.pose,
                startNs: '0',
                endNs: '40000000000',
                assetId: '30',
                fileName: 'run204.json',
                playbackUrl: '',
                description: '',
                showsToolBadge: true,
              ),
            ],
          ),
        ],
      ),
    );
    repository.contentByUrl[poseUrl] = _poseBody(time: 1);
    repository.clipDetailsById['17364'] = const ClipDetail(
      clipId: '17364',
      fields: [],
      hasAsset: true,
      isPose: true,
      timelineStartNs: '0',
      timelineEndNs: '40000000000',
      sourceStartNs: '0',
      sourceEndNs: '40000000000',
      assetId: '30',
      assetContentUrl: poseUrl,
      targetKind: ClipTargetKind.clip,
      targetId: '9764',
      hasTargetClip: true,
      targetClipId: '9764',
      targetClipKind: 'VIDEO',
      targetTimelineStartNs: '0',
      targetTimelineEndNs: '40000000000',
      hasTargetAsset: true,
      targetAssetId: '12',
      targetAssetFileName: 'depth_back_color.mp4',
      targetAssetContentUrl: targetUrl,
    );
    final viewModel = _viewModel(repository);
    await viewModel.loadAttachments();

    expect(viewModel.activeVideoBar?.attachmentId, '3065');
    expect(viewModel.activeVideoOverlayFrames, isEmpty);

    viewModel.didSelectSampleClip('17364');
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.activeVideoBar?.attachmentId, '9764');
    expect(viewModel.activeVideoBar?.mediaUrl, targetUrl);
    expect(viewModel.activeVideoOverlayFrames, hasLength(1));
  });
}

Widget _board(VideoMultimodalViewModel viewModel) {
  return MaterialApp(
    home: Scaffold(
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          return MultimodalTimelineBoard(viewModel: viewModel);
        },
      ),
    ),
  );
}

JobTimeline _twoClipTimeline({
  String startNs = '0',
  String endNs = '10000000000',
  String secondStartNs = '20000000000',
  String secondEndNs = '30000000000',
  List<TimelineTrack> extraTracks = const [],
}) {
  return JobTimeline(
    jobId: 'job-1',
    name: '작업',
    status: JobTimelineStatus.draft,
    tracks: [
      TimelineTrack(
        trackId: 'track-video',
        name: '영상',
        order: 0,
        clips: [
          TimelineClip(
            clipId: 'clip-1',
            trackId: 'track-video',
            kind: TimelineClipKind.video,
            startNs: startNs,
            endNs: endNs,
            assetId: 'asset-1',
            fileName: 'clip.mp4',
            playbackUrl: 'https://example.test/clip.mp4',
            description: '',
            showsToolBadge: false,
          ),
          TimelineClip(
            clipId: 'clip-2',
            trackId: 'track-video',
            kind: TimelineClipKind.video,
            startNs: secondStartNs,
            endNs: secondEndNs,
            assetId: 'asset-2',
            fileName: 'take-b.mp4',
            playbackUrl: 'https://example.test/take-b.mp4',
            description: '',
            showsToolBadge: false,
          ),
        ],
      ),
      ...extraTracks,
    ],
  );
}

JobTimeline _manyTrackTimeline() {
  return JobTimeline(
    jobId: 'job-1',
    name: '작업',
    status: JobTimelineStatus.draft,
    tracks: [
      for (var index = 0; index < 24; index++)
        TimelineTrack(
          trackId: 'track-$index',
          name: '트랙 $index',
          order: index,
          clips: [
            TimelineClip(
              clipId: 'clip-$index',
              trackId: 'track-$index',
              kind: TimelineClipKind.video,
              startNs: '0',
              endNs: '1000000000',
              assetId: 'asset-$index',
              fileName: 'file-$index.mp4',
              playbackUrl: 'https://example.test/file-$index.mp4',
              description: '',
              showsToolBadge: false,
            ),
          ],
        ),
    ],
  );
}

JobTimeline _timelineWithClip({
  required String clipId,
  required String playbackUrl,
  required String endNs,
  String startNs = '0',
}) {
  return JobTimeline(
    jobId: 'job-1',
    name: '작업',
    tracks: [
      TimelineTrack(
        trackId: 'track-1',
        name: '영상',
        order: 1,
        clips: [
          TimelineClip(
            clipId: clipId,
            trackId: 'track-1',
            kind: TimelineClipKind.video,
            startNs: startNs,
            endNs: endNs,
            assetId: '9',
            fileName: 'take.mp4',
            playbackUrl: playbackUrl,
            description: '',
            showsToolBadge: false,
          ),
        ],
      ),
    ],
  );
}

JobTimeline _poseTimeline(String videoUrl) {
  return JobTimeline(
    jobId: 'job-1',
    name: '작업',
    tracks: [
      TimelineTrack(
        trackId: 'video-track',
        name: '영상',
        order: 1,
        clips: [
          TimelineClip(
            clipId: 'video-1',
            trackId: 'video-track',
            kind: TimelineClipKind.video,
            startNs: '5000000000',
            endNs: '30000000000',
            assetId: '20',
            fileName: 'video.mp4',
            playbackUrl: videoUrl,
            description: '',
            showsToolBadge: false,
          ),
        ],
      ),
      const TimelineTrack(
        trackId: 'pose-track',
        name: '포즈',
        order: 2,
        clips: [
          TimelineClip(
            clipId: 'pose-1',
            trackId: 'pose-track',
            kind: TimelineClipKind.pose,
            startNs: '10000000000',
            endNs: '20000000000',
            assetId: '30',
            fileName: 'pose.json',
            playbackUrl: '',
            description: '',
            showsToolBadge: true,
          ),
        ],
      ),
    ],
  );
}

String _poseBody({required double time}) =>
    '''
{"data":{"frameRate":24,"keypointSchema":["tip"],"skeleton":[],
"lsfResult":{"value":{"sequence":[{"time":$time,"enabled":true,
"x":10,"y":20,"width":30,"height":40,
"keypoints":[{"name":"tip","x":50,"y":60}]}]}}}}
''';

JobTimeline _pairTimeline() {
  return const JobTimeline(
    jobId: 'job-1',
    name: '작업',
    tracks: [
      TimelineTrack(
        trackId: 'track-1',
        name: '영상',
        order: 1,
        clips: [
          TimelineClip(
            clipId: 'clip-a',
            trackId: 'track-1',
            kind: TimelineClipKind.video,
            startNs: '0',
            endNs: '1000000000',
            assetId: '1',
            fileName: 'a.mp4',
            playbackUrl: 'https://example.test/a.mp4',
            description: '',
            showsToolBadge: false,
          ),
          TimelineClip(
            clipId: 'clip-b',
            trackId: 'track-1',
            kind: TimelineClipKind.tag,
            startNs: '0',
            endNs: '1000000000',
            assetId: '',
            fileName: '',
            playbackUrl: '',
            description: '',
            showsToolBadge: false,
          ),
        ],
      ),
    ],
  );
}

JobTimeline _loadedTimeline() {
  return const JobTimeline(
    jobId: 'job-1',
    name: '작업',
    status: JobTimelineStatus.draft,
    tracks: [
      TimelineTrack(
        trackId: 'track-video',
        name: '영상',
        order: 1,
        clips: [
          TimelineClip(
            clipId: 'clip-1',
            trackId: 'track-video',
            kind: TimelineClipKind.video,
            startNs: '0',
            endNs: '10000000000',
            assetId: 'asset-1',
            fileName: 'clip.mp4',
            playbackUrl: 'https://example.test/clip.mp4',
            description: '',
            showsToolBadge: false,
          ),
        ],
      ),
    ],
  );
}

VideoMultimodalViewModel _viewModel(
  _ScriptedTimelineRepository repository, {
  WorkDetailRepository? workDetail,
}) {
  return VideoMultimodalViewModel(
    listHistoryWorkAttachmentsUseCase: ListHistoryWorkAttachmentsUseCase(
      workDetail ?? _EmptyWorkDetailRepository(),
    ),
    getJobTimelineUseCase: GetJobTimelineUseCase(repository),
    getClipUseCase: GetClipUseCase(repository),
    createTrackUseCase: CreateTrackUseCase(repository),
    updateTrackUseCase: UpdateTrackUseCase(repository),
    deleteTrackUseCase: DeleteTrackUseCase(repository),
    createClipUseCase: CreateClipUseCase(repository),
    updateClipUseCase: UpdateClipUseCase(repository),
    deleteClipUseCase: DeleteClipUseCase(repository),
    changeTimelineStatusUseCase: ChangeTimelineStatusUseCase(repository),
    updateTimelineUseCase: UpdateTimelineUseCase(repository),
    deleteTimelineUseCase: DeleteTimelineUseCase(repository),
    toolRunUseCase: ToolRunUseCase(_IdleToolRunRepository()),
    labelUseCase: LabelUseCase(_IdleLabelRepository()),
    askQuestionUseCase: AskQuestionUseCase(_IdleAskRepository()),
    loadJobProjectIdUseCase: LoadJobProjectIdUseCase(
      workDetail ?? _EmptyWorkDetailRepository(),
    ),
    jobId: 'job-1',
  );
}

class _IdleAskRepository implements AskRepository {
  @override
  Future<AskAnswer> askQuestion({
    required String projectId,
    required String question,
    String sessionId = '',
  }) {
    throw StateError('unused');
  }
}

class _VideoAttachmentRepository implements WorkDetailRepository {
  const _VideoAttachmentRepository({this.durationNs = ''});

  final String durationNs;
  @override
  Future<String> loadProjectId({required String jobId}) async {
    return '';
  }

  @override
  Future<WorkDetailCatalog> loadCatalog({String jobId = ''}) async {
    return const WorkDetailCatalog(items: [], attachments: []);
  }

  @override
  Future<List<WorkAttachment>> listAttachments({String jobId = ''}) async {
    return [
      WorkAttachment(
        attachmentId: 'asset-9',
        jobId: 'job-1',
        fileType: WorkAttachmentType.video,
        fileName: 'take.mp4',
        note: '',
        content: '',
        durationNs: durationNs,
      ),
    ];
  }
}

class _EmptyWorkDetailRepository implements WorkDetailRepository {
  @override
  Future<String> loadProjectId({required String jobId}) async {
    return '';
  }

  @override
  Future<WorkDetailCatalog> loadCatalog({String jobId = ''}) async {
    return const WorkDetailCatalog(items: [], attachments: []);
  }

  @override
  Future<List<WorkAttachment>> listAttachments({String jobId = ''}) async {
    return const [];
  }
}

class _ThrowingTimelineRepository implements JobTimelineRepository {
  int writeCount = 0;

  @override
  Future<JobTimeline> getTimeline({required String jobId}) {
    throw StateError('unused');
  }

  @override
  Future<ClipDetail> getClip({required String clipId}) {
    throw StateError('unused');
  }

  @override
  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) {
    writeCount += 1;
    throw StateError('unused');
  }

  @override
  Future<void> updateTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) {
    writeCount += 1;
    throw StateError('unused');
  }

  @override
  Future<void> deleteTrack({required String trackId}) {
    writeCount += 1;
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
    String fromClipId = '',
    String toClipId = '',
    String sourceStartNs = '',
    String sourceEndNs = '',
  }) {
    writeCount += 1;
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
    writeCount += 1;
    throw StateError('unused');
  }

  @override
  Future<void> deleteClip({required String clipId}) {
    writeCount += 1;
    throw StateError('unused');
  }

  @override
  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) {
    writeCount += 1;
    throw StateError('unused');
  }

  @override
  Future<void> updateTimeline({
    required String jobId,
    String? name,
    String? description,
  }) {
    writeCount += 1;
    throw StateError('unused');
  }

  @override
  Future<void> deleteTimeline({required String jobId}) {
    writeCount += 1;
    throw StateError('unused');
  }

  @override
  Future<String> readContent({required String url}) {
    throw StateError('unused');
  }
}

class _ScriptedTimelineRepository implements JobTimelineRepository {
  _ScriptedTimelineRepository(this.current);

  JobTimeline current;
  JobTimeline? nextTimeline;
  JobTimelineException? failure;
  int getCount = 0;
  int updateCount = 0;
  int deleteCount = 0;
  String? lastDeletedClipId;
  int changeCount = 0;
  int updateTimelineCount = 0;
  String? lastUpdatedTimelineName;
  String? lastUpdatedTimelineDescription;
  int deleteTimelineCount = 0;
  String? lastDeletedTimelineJobId;
  int createTrackCount = 0;
  String? lastCreatedTrackName;
  int? lastCreatedTrackOrder;
  bool? lastCreatedTrackIsVisible;
  int updateTrackCount = 0;
  String? lastUpdatedTrackId;
  String? lastUpdatedTrackName;
  int? lastUpdatedTrackOrder;
  bool? lastUpdatedTrackIsVisible;
  int deleteTrackCount = 0;
  String? lastDeletedTrackId;
  int createClipCount = 0;
  String? lastCreatedClipTrackId;
  TimelineClipKind? lastCreatedClipKind;
  String? lastCreatedClipStartNs;
  String? lastCreatedClipEndNs;
  String? lastCreatedClipAssetId;
  String lastCreatedClipLabelValueId = '';
  String lastCreatedClipDescription = '';
  String lastCreatedFromClipId = '';
  String lastCreatedToClipId = '';
  String lastCreatedSourceStartNs = '';
  String lastCreatedSourceEndNs = '';
  String? lastStartNs;
  String? lastEndNs;
  String? lastTrackId;
  JobTimelineStatus? lastFromStatus;
  JobTimelineStatus? lastToStatus;
  final List<String> getClipIds = [];
  final List<Completer<ClipDetail>> clipGates = [];
  bool holdClipDetail = false;
  ClipDetail? nextClipDetail;
  final Map<String, ClipDetail> clipDetailsById = {};
  final Map<String, String> contentByUrl = {};
  final Map<String, Completer<String>> contentGatesByUrl = {};
  final List<String> readUrls = [];
  JobTimelineException? clipFailure;

  @override
  Future<JobTimeline> getTimeline({required String jobId}) async {
    getCount += 1;
    final upcoming = nextTimeline;
    if (getCount > 1 && upcoming != null) {
      current = upcoming;
    }
    return current;
  }

  @override
  Future<ClipDetail> getClip({required String clipId}) async {
    getClipIds.add(clipId);
    if (clipFailure != null) {
      throw clipFailure!;
    }
    if (holdClipDetail) {
      final gate = Completer<ClipDetail>();
      clipGates.add(gate);
      return gate.future;
    }
    return clipDetailsById[clipId] ??
        nextClipDetail ??
        ClipDetail(
          clipId: clipId,
          fields: [ClipField(label: 'clipId', value: clipId)],
        );
  }

  @override
  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) async {
    createTrackCount += 1;
    lastCreatedTrackName = name;
    lastCreatedTrackOrder = order;
    lastCreatedTrackIsVisible = isVisible;
    _throwFailure();
  }

  @override
  Future<void> updateTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) async {
    updateTrackCount += 1;
    lastUpdatedTrackId = trackId;
    lastUpdatedTrackName = name;
    lastUpdatedTrackOrder = order;
    lastUpdatedTrackIsVisible = isVisible;
    _throwFailure();
  }

  @override
  Future<void> deleteTrack({required String trackId}) async {
    deleteTrackCount += 1;
    lastDeletedTrackId = trackId;
    _throwFailure();
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
    String fromClipId = '',
    String toClipId = '',
    String sourceStartNs = '',
    String sourceEndNs = '',
  }) async {
    createClipCount += 1;
    lastCreatedClipTrackId = trackId;
    lastCreatedClipKind = kind;
    lastCreatedClipStartNs = startNs;
    lastCreatedClipEndNs = endNs;
    lastCreatedClipAssetId = assetId;
    lastCreatedClipLabelValueId = labelValueId;
    lastCreatedClipDescription = description;
    lastCreatedFromClipId = fromClipId;
    lastCreatedToClipId = toClipId;
    lastCreatedSourceStartNs = sourceStartNs;
    lastCreatedSourceEndNs = sourceEndNs;
    _throwFailure();
  }

  void _throwFailure() {
    final error = failure;
    failure = null;
    if (error != null) {
      throw error;
    }
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
  }) async {
    updateCount += 1;
    lastTrackId = trackId;
    lastStartNs = startNs;
    lastEndNs = endNs;
    final error = failure;
    failure = null;
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<void> deleteClip({required String clipId}) async {
    deleteCount += 1;
    lastDeletedClipId = clipId;
  }

  @override
  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) async {
    changeCount += 1;
    lastFromStatus = fromStatus;
    lastToStatus = toStatus;
    final error = failure;
    failure = null;
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<void> updateTimeline({
    required String jobId,
    String? name,
    String? description,
  }) async {
    updateTimelineCount += 1;
    lastUpdatedTimelineName = name;
    lastUpdatedTimelineDescription = description;
    final error = failure;
    failure = null;
    if (error != null) {
      throw error;
    }
    current = JobTimeline(
      jobId: current.jobId,
      name: name ?? current.name,
      description: description ?? current.description,
      status: current.status,
      tracks: current.tracks,
      overlays: current.overlays,
    );
  }

  @override
  Future<void> deleteTimeline({required String jobId}) async {
    deleteTimelineCount += 1;
    lastDeletedTimelineJobId = jobId;
    final error = failure;
    failure = null;
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<String> readContent({required String url}) async {
    readUrls.add(url);
    final gate = contentGatesByUrl[url];
    if (gate != null) {
      return gate.future;
    }
    return contentByUrl[url] ?? '';
  }
}

class _IdleLabelRepository implements LabelRepository {
  @override
  Future<List<LabelNode>> listLabels() async => const [];

  @override
  Future<LabelNode> createValue({
    required String name,
    String parentValueId = '',
  }) {
    throw StateError('unused');
  }

  @override
  Future<LabelNode> renameValue({
    required String valueId,
    required String name,
  }) {
    throw StateError('unused');
  }

  @override
  Future<void> deprecateValue({required String valueId}) {
    throw StateError('unused');
  }
}

class _IdleToolRunRepository implements ToolRunRepository {
  @override
  Future<List<InferenceTool>> listEnabledTools({
    bool includeDisabled = false,
  }) async => const [];

  @override
  Future<List<ToolRunSnapshot>> listJobRuns({required String jobId}) async {
    return const [];
  }

  @override
  Future<ToolRunSnapshot> startRun({
    required String toolId,
    required ToolRunTargetKind kind,
    required String targetId,
  }) {
    throw StateError('unused');
  }

  @override
  Future<ToolRunSnapshot> getRun({required String runId}) {
    throw StateError('unused');
  }

  @override
  Future<ToolRunSnapshot> cancelRun({required String runId}) {
    throw StateError('unused');
  }
}
