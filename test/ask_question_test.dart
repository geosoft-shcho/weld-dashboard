import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/tacittag/rag/v2/rag.pb.dart'
    as rag_pb;
import 'package:weld_dashboard/src/data/repositories/ask_requests.dart';
import 'package:weld_dashboard/src/domain/entities/ask_answer.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/entities/label_vocab.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/entities/work_detail_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment.dart';
import 'package:weld_dashboard/src/domain/repositories/ask_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/label_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/tool_run_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/work_detail_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/ask_question_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/change_timeline_status_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_track_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_track_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_job_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/label_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_history_work_attachments_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/load_job_project_id_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/tool_run_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_track_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_view_model.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/multimodal_side_panel.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/timeline_board_helpers.dart';

void main() {
  test('ask request sends project, question, and a later session', () {
    final first = buildAskQuestionRequest(projectId: '42', question: '용접 장면');
    expect(first.projectId, '42');
    expect(first.question, '용접 장면');
    expect(first.sessionId, isEmpty);
    expect(first.topK, 0);
    expect(first.mediaId, isEmpty);

    final next = buildAskQuestionRequest(
      projectId: '42',
      question: '다음은',
      sessionId: 's1',
    );
    expect(next.sessionId, 's1');
  });

  test('ask answer keeps the reply text and citation times', () {
    final answer = askAnswerFrom(
      rag_pb.AskQuestionResponse(
        answer: '15초에 있습니다.',
        sessionId: 's1',
        citations: [
          rag_pb.Citation(startSec: 15.52, endSec: 23.44),
          rag_pb.Citation(startSec: 30, endSec: 31),
        ],
      ),
    );
    expect(answer.answer, '15초에 있습니다.');
    expect(answer.sessionId, 's1');
    expect(answer.citations, hasLength(2));
    expect(answer.citations.first.startSeconds, 15.52);
    expect(answer.citations.first.endSeconds, 23.44);
  });

  test('ask answer keeps the citation time and segment', () {
    final response = rag_pb.AskQuestionResponse()
      ..mergeFromProto3Json({
        'answer': '캡 구간입니다.',
        'projectId': '7',
        'citations': [
          {
            'startSec': 1946,
            'endSec': 2894.1,
            'text': '캡(cap) 용접 구간 · 01호기 DGT-ERB-01',
            'score': 0.3428,
            'layerId': 'tag',
            'segmentId': 'clip__1218',
          },
        ],
      });
    final answer = askAnswerFrom(response);
    final citation = answer.citations.single;
    expect(citation.startSeconds, 1946);
    expect(citation.endSeconds, 2894.1);
    expect(citation.text, '캡(cap) 용접 구간 · 01호기 DGT-ERB-01');
    expect(citation.segmentId, 'clip__1218');
  });

  test('empty question and missing project skip the server', () async {
    final asks = _ScriptedAsk();
    final useCase = AskQuestionUseCase(asks);
    expect(
      () => useCase.execute(projectId: '42', question: '  '),
      throwsA(
        isA<AskException>().having(
          (error) => error.message,
          'message',
          '질문을 입력하세요.',
        ),
      ),
    );
    expect(
      () => useCase.execute(projectId: '', question: '용접 장면'),
      throwsA(
        isA<AskException>().having(
          (error) => error.message,
          'message',
          '공사 번호를 찾지 못했습니다.',
        ),
      ),
    );
    expect(asks.calls, isEmpty);
  });

  test('a question shows the answer and reuses the session', () async {
    final asks = _ScriptedAsk();
    final viewModel = _viewModel(asks, projectId: '42');

    await viewModel.didSendAsk('   ');
    expect(viewModel.askTurns, isEmpty);

    await viewModel.didSendAsk('  용접 장면  ');
    expect(asks.calls.single.projectId, '42');
    expect(asks.calls.single.question, '용접 장면');
    expect(asks.calls.single.sessionId, isEmpty);
    expect(viewModel.askTurns.first.text, '용접 장면');
    expect(viewModel.askTurns.last.text, '15초에 있습니다.');
    expect(viewModel.askTurns.last.citations.single.startSeconds, 15.52);
    expect(viewModel.askTurns.last.citations.single.endSeconds, 23.44);
    expect(viewModel.isAsking, isFalse);

    asks.next = const AskAnswer(answer: '그 다음입니다.', sessionId: 's2');
    await viewModel.didSendAsk('다음은');
    expect(asks.calls.last.sessionId, 's1');
    expect(viewModel.askTurns.last.text, '그 다음입니다.');
  });

  test('a failed question keeps the session and shows the message', () async {
    final asks = _ScriptedAsk();
    final viewModel = _viewModel(asks, projectId: '42');
    await viewModel.didSendAsk('용접 장면');

    asks.error = const AskException('검색에 실패했습니다.');
    await viewModel.didSendAsk('다시');
    expect(viewModel.askTurns.last.text, '검색에 실패했습니다.');
    expect(viewModel.askTurns.last.citations, isEmpty);

    asks.error = null;
    asks.next = const AskAnswer(answer: '이어서 답합니다.', sessionId: 's1');
    await viewModel.didSendAsk('이어서');
    expect(asks.calls.last.sessionId, 's1');
  });

  test('a missing project id does not call AskQuestion', () async {
    final asks = _ScriptedAsk();
    final viewModel = _viewModel(asks, projectId: '');
    await viewModel.didSendAsk('용접 장면');
    expect(asks.calls, isEmpty);
    expect(viewModel.askTurns.last.text, '공사 번호를 찾지 못했습니다.');
  });

  test('a citation seeks the video that covers its start', () async {
    const mediaUrl = 'http://media.example/video.mp4';
    final viewModel = _viewModel(
      _ScriptedAsk(),
      projectId: '42',
      timeline: _timelineWith([
        _clip(
          clipId: 'clip__1218',
          kind: TimelineClipKind.tag,
          playbackUrl: '',
        ),
        _clip(clipId: 'video-1', playbackUrl: mediaUrl),
      ]),
    );
    await viewModel.loadAttachments();
    viewModel.didTapToggleAsk();

    viewModel.didTapCitation(
      const AskCitation(
        startSeconds: 1946,
        endSeconds: 2894.1,
        text: '캡(cap) 용접 구간 · 01호기 DGT-ERB-01',
        segmentId: 'clip__1218',
      ),
    );
    expect(viewModel.playheadSeconds, 1946);
    expect(viewModel.wantsPlayback, isTrue);
    expect(viewModel.noticeText, isEmpty);
    expect(viewModel.selectedClipId, 'clip__1218');
    expect(viewModel.isAskOpen, isTrue);
    expect(viewModel.isPropertiesOpen, isFalse);
    expect(viewModel.activeVideoBar?.mediaUrl, mediaUrl);
    expect(viewModel.activeVideoBar?.startSeconds, 0);

    viewModel.didSeekToSeconds(4);
    expect(viewModel.playheadSeconds, 4);
    expect(viewModel.activeVideoBar?.mediaUrl, mediaUrl);
  });

  test('a citation plays the video clip named by its segment', () async {
    const mediaUrl = 'http://media.example/named.mp4';
    final viewModel = _viewModel(
      _ScriptedAsk(),
      projectId: '42',
      timeline: _timelineWith([
        _clip(clipId: 'clip__1218', playbackUrl: mediaUrl),
        _clip(
          clipId: 'earlier',
          playbackUrl: 'http://media.example/earlier.mp4',
          endSeconds: 1000,
        ),
      ]),
    );
    await viewModel.loadAttachments();

    viewModel.didTapCitation(
      const AskCitation(
        startSeconds: 1946,
        endSeconds: 2894.1,
        segmentId: 'clip__1218',
      ),
    );
    expect(viewModel.playheadSeconds, 1946);
    expect(viewModel.activeVideoBar?.mediaUrl, mediaUrl);
    expect(viewModel.selectedClipId, 'clip__1218');
  });

  test('a citation without a matching segment keeps the selection', () async {
    final viewModel = _viewModel(
      _ScriptedAsk(),
      projectId: '42',
      timeline: _timelineWith([
        _clip(clipId: 'video-1', playbackUrl: 'http://media.example/video.mp4'),
      ]),
    );
    await viewModel.loadAttachments();
    viewModel.didSelectSampleClip('video-1');
    expect(viewModel.selectedClipId, 'video-1');
    expect(viewModel.isPropertiesOpen, isTrue);

    viewModel.didTapCitation(
      const AskCitation(
        startSeconds: 1946,
        endSeconds: 2894.1,
        segmentId: 'clip__missing',
      ),
    );
    expect(viewModel.selectedClipId, 'video-1');
    expect(viewModel.isPropertiesOpen, isTrue);
    expect(viewModel.playheadSeconds, 1946);
  });

  test('a matching tag stays selected when no video covers the time', () async {
    final viewModel = _viewModel(
      _ScriptedAsk(),
      projectId: '42',
      timeline: _timelineWith([
        _clip(
          clipId: 'clip__1218',
          kind: TimelineClipKind.tag,
          playbackUrl: '',
          endSeconds: 100,
        ),
      ]),
    );
    await viewModel.loadAttachments();
    viewModel.didTapToggleAsk();
    viewModel.didTapCitation(
      const AskCitation(
        startSeconds: 1946,
        endSeconds: 2894.1,
        segmentId: 'clip__1218',
      ),
    );
    expect(viewModel.selectedClipId, 'clip__1218');
    expect(viewModel.isAskOpen, isTrue);
    expect(viewModel.playheadSeconds, 0);
    expect(viewModel.noticeText, '이 근거 영상을 열 수 없습니다.');
  });

  test('a citation without a video does not change playback', () async {
    final viewModel = _viewModel(_ScriptedAsk(), projectId: '42');
    await viewModel.loadAttachments();
    viewModel.didTapCitation(
      const AskCitation(
        startSeconds: 1946,
        endSeconds: 2894.1,
        segmentId: 'clip__1218',
      ),
    );
    expect(viewModel.playheadSeconds, 0);
    expect(viewModel.noticeText, '이 근거 영상을 열 수 없습니다.');
    expect(viewModel.wantsPlayback, isFalse);
    expect(viewModel.selectedClipId, isEmpty);
  });

  testWidgets('the ask field and send button share a height', (tester) async {
    final viewModel = _viewModel(_ScriptedAsk(), projectId: '42');
    addTearDown(viewModel.dispose);
    await viewModel.loadAttachments();
    viewModel.didTapToggleAsk();

    await tester.pumpWidget(
      MaterialApp(
        home: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return MultimodalSidePanel(viewModel: viewModel, onClose: () {});
          },
        ),
      ),
    );
    await tester.pump();

    final field = tester.getSize(find.byType(TextField));
    final button = tester.getSize(find.widgetWithText(TextButton, '전송'));
    expect(button.height, field.height);
  });

  test('a citation like reuses one track and one label', () async {
    final timeline = _RecordingTimeline(
      const JobTimeline(jobId: '128', name: '작업', tracks: []),
    );
    final labels = _RecordingLabels();
    final viewModel = _viewModel(
      _ScriptedAsk(),
      projectId: '42',
      timelineRepository: timeline,
      labelRepository: labels,
    );
    const citation = AskCitation(
      startSeconds: 15.52,
      endSeconds: 23.44,
      text: '용접 장면',
    );
    viewModel.didSelectLabelValue('7');

    expect(await viewModel.didLikeCitation(citation), isTrue);
    expect(await viewModel.didLikeCitation(citation), isTrue);

    expect(labels.created, ['좋아요']);
    expect(timeline.trackNames, ['좋아요']);
    expect(timeline.clips, hasLength(2));
    expect(timeline.clips.first.kind, TimelineClipKind.tag);
    expect(timeline.clips.first.labelValueId, 'label-1');
    expect(timeline.clips.first.description, '용접 장면');
    expect(timeline.clips.first.startNs, isNot(timeline.clips.first.endNs));
  });

  test('a citation like uses an existing label of the same name', () async {
    final timeline = _RecordingTimeline(
      const JobTimeline(jobId: '128', name: '작업', tracks: []),
    );
    final labels = _RecordingLabels(const [
      LabelNode(valueId: '9', name: '좋아요'),
    ]);
    final viewModel = _viewModel(
      _ScriptedAsk(),
      projectId: '42',
      timelineRepository: timeline,
      labelRepository: labels,
    );

    expect(
      await viewModel.didLikeCitation(
        const AskCitation(startSeconds: 1, endSeconds: 2, text: '용접'),
      ),
      isTrue,
    );
    expect(labels.created, isEmpty);
    expect(timeline.clips.single.labelValueId, '9');
  });

  test('an empty citation comment does not create a clip', () async {
    final timeline = _RecordingTimeline(
      const JobTimeline(jobId: '128', name: '작업', tracks: []),
    );
    final viewModel = _viewModel(
      _ScriptedAsk(),
      projectId: '42',
      timelineRepository: timeline,
    );

    expect(
      await viewModel.didCommentCitation(
        const AskCitation(startSeconds: 1, endSeconds: 2),
        '   ',
      ),
      isFalse,
    );
    expect(timeline.trackNames, isEmpty);
    expect(timeline.clips, isEmpty);
  });

  test('an object row outside the list scrolls to that row', () {
    expect(
      revealOffsetForObjectRow(
        rowIndex: 4,
        rowExtent: 28,
        pixels: 0,
        viewport: 56,
        maxScrollExtent: 200,
      ),
      112,
    );
    expect(
      revealOffsetForObjectRow(
        rowIndex: 0,
        rowExtent: 28,
        pixels: 0,
        viewport: 56,
        maxScrollExtent: 200,
      ),
      isNull,
    );
  });
}

JobTimeline _timelineWith(List<TimelineClip> clips) {
  return JobTimeline(
    jobId: '128',
    name: '작업',
    tracks: [
      TimelineTrack(trackId: 'track-1', name: '영상', order: 0, clips: clips),
    ],
  );
}

TimelineClip _clip({
  required String clipId,
  String playbackUrl = 'http://media.example/video.mp4',
  TimelineClipKind kind = TimelineClipKind.video,
  double endSeconds = 4000,
}) {
  return TimelineClip(
    clipId: clipId,
    trackId: 'track-1',
    kind: kind,
    startNs: '0',
    endNs: '${(endSeconds * 1000000000).round()}',
    assetId: '1',
    fileName: 'video.mp4',
    playbackUrl: playbackUrl,
    description: '',
    showsToolBadge: false,
  );
}

VideoMultimodalViewModel _viewModel(
  _ScriptedAsk asks, {
  required String projectId,
  JobTimeline timeline = JobTimeline.empty,
  JobTimelineRepository? timelineRepository,
  LabelRepository? labelRepository,
}) {
  final repository = timelineRepository ?? _IdleTimeline(timeline);
  final workDetail = _ProjectWorkDetail(projectId);
  return VideoMultimodalViewModel(
    listHistoryWorkAttachmentsUseCase: ListHistoryWorkAttachmentsUseCase(
      workDetail,
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
    labelUseCase: LabelUseCase(labelRepository ?? _IdleLabelRepository()),
    askQuestionUseCase: AskQuestionUseCase(asks),
    loadJobProjectIdUseCase: LoadJobProjectIdUseCase(workDetail),
    jobId: '128',
  );
}

class _ScriptedAsk implements AskRepository {
  final List<({String projectId, String question, String sessionId})> calls =
      [];
  AskAnswer next = const AskAnswer(
    answer: '15초에 있습니다.',
    sessionId: 's1',
    citations: [AskCitation(startSeconds: 15.52, endSeconds: 23.44)],
  );
  AskException? error;

  @override
  Future<AskAnswer> askQuestion({
    required String projectId,
    required String question,
    String sessionId = '',
  }) async {
    calls.add((projectId: projectId, question: question, sessionId: sessionId));
    final failure = error;
    if (failure != null) {
      throw failure;
    }
    return next;
  }
}

class _ProjectWorkDetail implements WorkDetailRepository {
  _ProjectWorkDetail(this.projectId);

  final String projectId;

  @override
  Future<String> loadProjectId({required String jobId}) async {
    return projectId;
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

class _IdleTimeline implements JobTimelineRepository {
  _IdleTimeline(this.timeline);

  final JobTimeline timeline;

  @override
  Future<JobTimeline> getTimeline({required String jobId}) async {
    return timeline;
  }

  @override
  Future<ClipDetail> getClip({required String clipId}) async {
    return ClipDetail.empty;
  }

  @override
  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) async {}

  @override
  Future<void> updateTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) async {}

  @override
  Future<void> deleteTrack({required String trackId}) async {}

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
  }) async {}

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
  }) async {}

  @override
  Future<void> deleteClip({required String clipId}) async {}

  @override
  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) async {}

  @override
  Future<void> updateTimeline({
    required String jobId,
    String? name,
    String? description,
  }) async {}

  @override
  Future<void> deleteTimeline({required String jobId}) async {}

  @override
  Future<String> readContent({required String url}) async {
    return '';
  }
}

class _SavedClip {
  const _SavedClip({
    required this.trackId,
    required this.kind,
    required this.labelValueId,
    required this.startNs,
    required this.endNs,
    required this.description,
  });

  final String trackId;
  final TimelineClipKind kind;
  final String labelValueId;
  final String startNs;
  final String endNs;
  final String description;
}

class _RecordingTimeline extends _IdleTimeline {
  _RecordingTimeline(JobTimeline timeline) : super(timeline) {
    current = timeline;
  }

  late JobTimeline current;
  final trackNames = <String>[];
  final clips = <_SavedClip>[];

  @override
  Future<JobTimeline> getTimeline({required String jobId}) async {
    return current;
  }

  @override
  Future<void> createTrack({
    required String jobId,
    required String name,
    int? order,
    bool? isVisible,
  }) async {
    trackNames.add(name);
    current = JobTimeline(
      jobId: current.jobId,
      name: current.name,
      tracks: [
        ...current.tracks,
        TimelineTrack(
          trackId: 'track-${trackNames.length}',
          name: name,
          order: current.tracks.length,
          clips: const [],
        ),
      ],
    );
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
    clips.add(
      _SavedClip(
        trackId: trackId,
        kind: kind,
        labelValueId: labelValueId,
        startNs: startNs,
        endNs: endNs,
        description: description,
      ),
    );
  }
}

class _RecordingLabels implements LabelRepository {
  _RecordingLabels([List<LabelNode> nodes = const []]) {
    this.nodes.addAll(nodes);
  }

  final nodes = <LabelNode>[];
  final created = <String>[];

  @override
  Future<List<LabelNode>> listLabels() async {
    return List.of(nodes);
  }

  @override
  Future<LabelNode> createValue({
    required String name,
    String parentValueId = '',
  }) async {
    created.add(name);
    final node = LabelNode(
      valueId: 'label-${created.length}',
      name: name,
      parentValueId: parentValueId,
    );
    nodes.add(node);
    return node;
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
