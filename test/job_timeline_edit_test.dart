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
import 'package:weld_dashboard/src/domain/use_cases/delete_track_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_job_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/label_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_history_work_attachments_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/tool_run_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_clip_use_case.dart';
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
    expect(request.clip.timelineEndNs.toString(), '1000000000');
    expect(
      request.clip.timelineStartNs.compareTo(request.clip.timelineEndNs),
      lessThan(0),
    );
  });

  test('relation clip omits kind and keeps only input clip ids', () {
    final request = buildCreateClipRequest(
      trackId: '3',
      kind: TimelineClipKind.unspecified,
      startNs: '0',
      endNs: '1000000000',
      description: 'clip.mp4 ↔ take-b.mp4',
      omitsKind: true,
      inputClipIds: const ['1', '2'],
    );

    expect(request.clip.hasKind(), isFalse);
    expect(request.clip.hasSource(), isFalse);
    expect(request.clip.hasLabelValueId(), isFalse);
    expect(request.clip.description, 'clip.mp4 ↔ take-b.mp4');
    expect(request.clip.provenance.inputClipIds.map((id) => id.toString()), [
      '1',
      '2',
    ]);
    expect(request.clip.provenance.hasConfidence(), isFalse);
    expect(request.clip.provenance.reviewed, isFalse);
    expect(request.clip.provenance.runId.toString(), '0');
    expect(request.clip.provenance.toolId.toString(), '0');
    expect(request.clip.provenance.toolVersion, isEmpty);
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
      1.5 + VideoMultimodalViewModel.MIN_REGION_SECONDS,
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
    expect(repository.lastCreatedClipOmitsKind, isTrue);
    expect(repository.lastCreatedClipInputClipIds, ['clip-1', 'clip-2']);
    expect(repository.lastCreatedClipAssetId, isEmpty);
    expect(repository.lastCreatedClipLabelValueId, isEmpty);
    expect(repository.lastCreatedClipDescription, 'clip.mp4 ↔ take-b.mp4');
    expect(repository.lastCreatedClipStartNs, '0');
    expect(repository.lastCreatedClipEndNs, '30000000000');
    expect(viewModel.isRelationMode, isFalse);
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
    expect(repository.lastCreatedClipInputClipIds, ['clip-2', 'clip-1']);
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

  testWidgets('row list scrolls under a fixed objects header', (tester) async {
    final repository = _ScriptedTimelineRepository(_manyTrackTimeline());
    final viewModel = _viewModel(repository);
    await tester.runAsync(() => viewModel.loadAttachments());
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_board(viewModel));
    await tester.pump();

    expect(find.text('Objects & Tags'), findsOneWidget);
    final tagsBottom = tester.getRect(find.text('Objects & Tags')).bottom;
    final before = tester.getRect(find.text('트랙 0'));
    expect(before.top, greaterThan(tagsBottom));

    await tester.drag(
      find.byKey(const Key('timeline-object-rows')),
      const Offset(0, -420),
    );
    await tester.pump();

    expect(find.text('Objects & Tags'), findsOneWidget);
    final firstRow = tester.getRect(find.text('트랙 0'));
    expect(firstRow.bottom, lessThanOrEqualTo(tagsBottom));
    final trackClip = tester.getRect(find.text('file-0.mp4'));
    expect((firstRow.top - trackClip.top).abs(), lessThan(16));
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
    createTrackUseCase: CreateTrackUseCase(repository),
    updateTrackUseCase: UpdateTrackUseCase(repository),
    deleteTrackUseCase: DeleteTrackUseCase(repository),
    createClipUseCase: CreateClipUseCase(repository),
    updateClipUseCase: UpdateClipUseCase(repository),
    deleteClipUseCase: DeleteClipUseCase(repository),
    changeTimelineStatusUseCase: ChangeTimelineStatusUseCase(repository),
    toolRunUseCase: ToolRunUseCase(_IdleToolRunRepository()),
    labelUseCase: LabelUseCase(_IdleLabelRepository()),
    jobId: 'job-1',
  );
}

class _VideoAttachmentRepository implements WorkDetailRepository {
  @override
  Future<WorkDetailCatalog> loadCatalog({String jobId = ''}) async {
    return const WorkDetailCatalog(items: [], attachments: []);
  }

  @override
  Future<List<WorkAttachment>> listAttachments({String jobId = ''}) async {
    return const [
      WorkAttachment(
        attachmentId: 'asset-9',
        jobId: 'job-1',
        fileType: WorkAttachmentType.video,
        fileName: 'take.mp4',
        note: '',
        content: '',
      ),
    ];
  }
}

class _EmptyWorkDetailRepository implements WorkDetailRepository {
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
    bool omitsKind = false,
    List<String> inputClipIds = const [],
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
  bool lastCreatedClipOmitsKind = false;
  List<String> lastCreatedClipInputClipIds = const [];
  String? lastStartNs;
  String? lastEndNs;
  String? lastTrackId;
  JobTimelineStatus? lastFromStatus;
  JobTimelineStatus? lastToStatus;

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
    bool omitsKind = false,
    List<String> inputClipIds = const [],
  }) async {
    createClipCount += 1;
    lastCreatedClipTrackId = trackId;
    lastCreatedClipKind = kind;
    lastCreatedClipStartNs = startNs;
    lastCreatedClipEndNs = endNs;
    lastCreatedClipAssetId = assetId;
    lastCreatedClipLabelValueId = labelValueId;
    lastCreatedClipDescription = description;
    lastCreatedClipOmitsKind = omitsKind;
    lastCreatedClipInputClipIds = inputClipIds;
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
}

class _IdleLabelRepository implements LabelRepository {
  @override
  Future<List<LabelSection>> listSections() async => const [];

  @override
  Future<LabelChip> createValue({
    required String vocabKey,
    required String name,
  }) {
    throw StateError('unused');
  }

  @override
  Future<LabelChip> renameValue({
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
  Future<List<InferenceTool>> listEnabledTools() async => const [];

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
