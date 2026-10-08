import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/asset/v1/asset.pbenum.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/tool/v1/tool.pb.dart';
import 'package:weld_dashboard/src/data/repositories/tool_run_requests.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment_type.dart';
import 'package:weld_dashboard/src/domain/entities/work_detail_catalog.dart';
import 'package:weld_dashboard/src/domain/repositories/job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/tool_run_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/work_detail_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/change_timeline_status_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/create_track_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/delete_track_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_job_timeline_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_history_work_attachments_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/tool_run_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_clip_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_track_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_view_model.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/multimodal_dialogs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('start request uses one RunTarget', () {
    final clip = buildStartRunRequest(
      toolId: '7',
      kind: ToolRunTargetKind.clip,
      targetId: '880',
    );
    expect(clip.trigger, RunTrigger.RUN_TRIGGER_MANUAL);
    expect(clip.target.whichTarget(), RunTarget_Target.clipId);
    expect(clip.target.clipId.toString(), '880');

    final asset = buildStartRunRequest(
      toolId: '7',
      kind: ToolRunTargetKind.asset,
      targetId: '5012',
    );
    expect(asset.trigger, RunTrigger.RUN_TRIGGER_MANUAL);
    expect(asset.target.whichTarget(), RunTarget_Target.assetId);

    final job = buildStartRunRequest(
      toolId: '7',
      kind: ToolRunTargetKind.job,
      targetId: '128',
    );
    expect(job.trigger, RunTrigger.RUN_TRIGGER_AUTO_TAGGING);
    expect(job.target.whichTarget(), RunTarget_Target.jobId);
    expect(job.toProto3Json().toString().contains('targetId'), isFalse);
  });

  test('list follows the job and get waits for the result', () {
    final listed = buildListJobRunsRequest('128');
    expect(listed.target.whichTarget(), RunTarget_Target.jobId);
    expect(listed.target.jobId.toString(), '128');

    final read = buildGetRunRequest('9');
    expect(read.waitForTerminal, isTrue);
    expect(read.runId.toString(), '9');

    expect(
      () => buildStartRunRequest(
        toolId: '7',
        kind: ToolRunTargetKind.job,
        targetId: '',
      ),
      throwsA(isA<ToolRunException>()),
    );
  });

  test('enabled tools omit disabled rows and queued is in progress', () {
    final tools = enabledInferenceTools([
      Tool(toolId: Int64(7), name: 'pose', enabled: true),
      Tool(toolId: Int64(8), name: 'off', enabled: false),
      Tool(toolId: Int64.ZERO, name: 'missing', enabled: true),
    ]);
    expect(tools.map((tool) => tool.name), ['pose']);

    final stt = enabledInferenceTools([
      Tool(
        toolId: Int64(1),
        name: 'STT faster-whisper',
        endpoint: 'http://192.168.100.3:38901',
        remoteModelName: 'faster-whisper',
        toolVersion: 'large-v3-turbo',
        pattern: ToolPattern.TOOL_PATTERN_PUSH,
        payloadKind: 'stt',
        supportedInputKinds: [AssetKind.ASSET_KIND_VIDEO],
        unit: ToolUnit.TOOL_UNIT_SECOND,
        dispatch: ToolDispatch.TOOL_DISPATCH_ON_DEMAND,
        enabled: true,
      ),
    ]);
    expect(
      stt.single.summary,
      'id 1 · endpoint http://192.168.100.3:38901\n'
      'model faster-whisper · version large-v3-turbo\n'
      'pattern push · payload stt · input video · unit second · dispatch on demand',
    );

    final queued = toolRunSnapshotFrom(
      ToolRun(
        runId: Int64(3),
        toolId: Int64(7),
        status: RunStatus.RUN_STATUS_QUEUED,
      ),
    );
    expect(queued.status, ToolRunStatus.queued);
    expect(queued.isInProgress, isTrue);
  });

  test('start prefers a clip, then a file, then the job', () async {
    final repository = _ScriptedToolRuns();
    final useCase = ToolRunUseCase(repository);

    await useCase.start(toolId: '7', jobId: '128', clipId: '10', assetId: '20');
    expect(repository.startedKind, ToolRunTargetKind.clip);
    expect(repository.startedTargetId, '10');

    await useCase.start(toolId: '7', jobId: '128', clipId: '', assetId: '20');
    expect(repository.startedKind, ToolRunTargetKind.asset);
    expect(repository.startedTargetId, '20');

    await useCase.start(toolId: '7', jobId: '128', clipId: '', assetId: '');
    expect(repository.startedKind, ToolRunTargetKind.job);
    expect(repository.startedTargetId, '128');
  });

  testWidgets('inference dialog lists enabled tools', (tester) async {
    final tools = _ScriptedToolRuns()
      ..tools = const [
        InferenceTool(
          toolId: '7',
          name: 'pose',
          summary: 'id 7 · pattern push · input video',
        ),
      ];
    final viewModel = _viewModel(tools);
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () =>
                  showMultimodalInferencePicker(context, viewModel),
              child: const Text('열기'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('열기'));
    await tester.pump();
    await tester.pump();

    expect(find.text('pose'), findsOneWidget);
    expect(find.text('id 7 · pattern push · input video'), findsOneWidget);
    expect(find.text('pose-sample'), findsNothing);
    expect(find.text('실행'), findsOneWidget);
  });

  testWidgets('run starts the tool chosen in the list', (tester) async {
    final tools = _ScriptedToolRuns()
      ..tools = const [
        InferenceTool(toolId: '7', name: 'pose'),
        InferenceTool(toolId: '8', name: 'bbox'),
      ];
    final viewModel = _viewModel(tools);
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () =>
                  showMultimodalInferencePicker(context, viewModel),
              child: const Text('열기'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('열기'));
    await tester.pump();
    await tester.pump();

    FilledButton runButton() {
      return tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, '실행'),
      );
    }

    expect(runButton().onPressed, isNull);

    await tester.tap(find.text('bbox'));
    await tester.pump();
    expect(viewModel.inferenceModelName, isEmpty);
    expect(find.text('추론 모델 선택'), findsOneWidget);

    await tester.tap(find.text('실행'));
    await tester.pump();
    expect(viewModel.inferenceModelName, 'bbox');
    expect(tools.startedTargetId, '128');
    expect(find.text('추론 모델 선택'), findsNothing);
  });

  test('opening the page restores a queued run', () async {
    final tools = _ScriptedToolRuns()
      ..jobRuns = [
        const ToolRunSnapshot(
          runId: '4',
          toolId: '7',
          status: ToolRunStatus.queued,
          errorMessage: '',
        ),
      ]
      ..tools = const [InferenceTool(toolId: '7', name: 'pose')];
    final viewModel = _viewModel(tools);
    addTearDown(viewModel.dispose);

    await viewModel.loadAttachments();

    expect(viewModel.inferencePhase, InferencePanelPhase.queued);
    expect(viewModel.inferenceModelName, 'pose');
    expect(viewModel.inferenceMessage, isEmpty);
  });

  test('a selected clip is the run target', () async {
    final tools = _ScriptedToolRuns();
    final viewModel = _viewModel(tools);
    addTearDown(viewModel.dispose);

    await viewModel.loadAttachments();
    viewModel.didSelectSampleClip('10');
    await viewModel.didStartInference(toolId: '7', toolName: 'pose');

    expect(tools.startedKind, ToolRunTargetKind.clip);
    expect(tools.startedTargetId, '10');
    expect(viewModel.inferencePhase, InferencePanelPhase.queued);
  });

  test('a selected file is the run target when no clip is selected', () async {
    final tools = _ScriptedToolRuns();
    final viewModel = _viewModel(
      tools,
      workDetail: _FileWorkDetailRepository(),
    );
    addTearDown(viewModel.dispose);

    await viewModel.loadAttachments();
    viewModel.didTapBar('20');
    await viewModel.didStartInference(toolId: '7', toolName: 'pose');

    expect(tools.startedKind, ToolRunTargetKind.asset);
    expect(tools.startedTargetId, '20');
  });

  test('StartRun stays queued until GetRun reports success', () async {
    final tools = _ScriptedToolRuns()
      ..startStatus = ToolRunStatus.succeeded
      ..nextReads.add(
        const ToolRunSnapshot(
          runId: '3',
          toolId: '7',
          status: ToolRunStatus.queued,
          errorMessage: '',
        ),
      );
    final timeline = _QuietTimelineRepository();
    final viewModel = _viewModel(tools, timeline: timeline);
    addTearDown(viewModel.dispose);

    await viewModel.didStartInference(toolId: '7', toolName: 'pose');
    await _flushTurns();

    expect(tools.getCount, greaterThan(0));
    expect(tools.startedKind, ToolRunTargetKind.job);
    expect(tools.startedTargetId, '128');
    expect(viewModel.inferencePhase, InferencePanelPhase.queued);
    expect(viewModel.inferenceMessage, isEmpty);
    expect(timeline.readCount, 0);
  });

  test('GetRun success reloads the timeline', () async {
    final tools = _ScriptedToolRuns()
      ..nextReads.add(
        const ToolRunSnapshot(
          runId: '3',
          toolId: '7',
          status: ToolRunStatus.succeeded,
          errorMessage: '',
        ),
      );
    final timeline = _QuietTimelineRepository();
    final viewModel = _viewModel(tools, timeline: timeline);
    addTearDown(viewModel.dispose);

    await viewModel.didStartInference(toolId: '7', toolName: 'pose');
    await _flushTurns();

    expect(viewModel.inferencePhase, InferencePanelPhase.hidden);
    expect(timeline.readCount, 1);
    expect(viewModel.timelineTracks, isNotEmpty);
  });

  test('cancel calls CancelRun and closes the panel', () async {
    final tools = _ScriptedToolRuns();
    final viewModel = _viewModel(tools);
    addTearDown(viewModel.dispose);

    await viewModel.didStartInference(toolId: '7', toolName: 'pose');
    await viewModel.didCancelInference();

    expect(tools.cancelCount, 1);
    expect(viewModel.inferencePhase, InferencePanelPhase.hidden);
    expect(viewModel.isInferenceVisible, isFalse);
  });

  test('a failed run keeps the board and shows the server message', () async {
    final tools = _ScriptedToolRuns()
      ..nextReads.add(
        const ToolRunSnapshot(
          runId: '3',
          toolId: '7',
          status: ToolRunStatus.failed,
          errorMessage: '모델 오류',
        ),
      );
    final timeline = _QuietTimelineRepository();
    final viewModel = _viewModel(tools, timeline: timeline);
    addTearDown(viewModel.dispose);

    await viewModel.didStartInference(toolId: '7', toolName: 'pose');
    await _flushTurns();

    expect(viewModel.inferencePhase, InferencePanelPhase.failed);
    expect(viewModel.inferenceMessage, '모델 오류');
    expect(timeline.readCount, 0);
  });
}

Future<void> _flushTurns() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

VideoMultimodalViewModel _viewModel(
  _ScriptedToolRuns tools, {
  JobTimelineRepository? timeline,
  WorkDetailRepository? workDetail,
}) {
  final timelineRepository = timeline ?? _QuietTimelineRepository();
  return VideoMultimodalViewModel(
    listHistoryWorkAttachmentsUseCase: ListHistoryWorkAttachmentsUseCase(
      workDetail ?? _EmptyWorkDetailRepository(),
    ),
    getJobTimelineUseCase: GetJobTimelineUseCase(timelineRepository),
    createTrackUseCase: CreateTrackUseCase(timelineRepository),
    updateTrackUseCase: UpdateTrackUseCase(timelineRepository),
    deleteTrackUseCase: DeleteTrackUseCase(timelineRepository),
    createClipUseCase: CreateClipUseCase(timelineRepository),
    updateClipUseCase: UpdateClipUseCase(timelineRepository),
    deleteClipUseCase: DeleteClipUseCase(timelineRepository),
    changeTimelineStatusUseCase: ChangeTimelineStatusUseCase(
      timelineRepository,
    ),
    toolRunUseCase: ToolRunUseCase(tools),
    jobId: '128',
  );
}

class _ScriptedToolRuns implements ToolRunRepository {
  List<InferenceTool> tools = const [];
  List<ToolRunSnapshot> jobRuns = const [];
  final List<ToolRunSnapshot> nextReads = [];
  ToolRunTargetKind? startedKind;
  String startedTargetId = '';
  ToolRunStatus startStatus = ToolRunStatus.queued;
  int cancelCount = 0;
  int getCount = 0;

  @override
  Future<List<InferenceTool>> listEnabledTools() async => tools;

  @override
  Future<List<ToolRunSnapshot>> listJobRuns({required String jobId}) async {
    return jobRuns;
  }

  @override
  Future<ToolRunSnapshot> startRun({
    required String toolId,
    required ToolRunTargetKind kind,
    required String targetId,
  }) async {
    startedKind = kind;
    startedTargetId = targetId;
    return ToolRunSnapshot(
      runId: '3',
      toolId: '7',
      status: startStatus,
      errorMessage: '',
    );
  }

  @override
  Future<ToolRunSnapshot> getRun({required String runId}) {
    getCount += 1;
    if (nextReads.isEmpty) {
      return Completer<ToolRunSnapshot>().future;
    }
    return Future.value(nextReads.removeAt(0));
  }

  @override
  Future<ToolRunSnapshot> cancelRun({required String runId}) async {
    cancelCount += 1;
    return ToolRunSnapshot(
      runId: runId,
      toolId: '7',
      status: ToolRunStatus.canceled,
      errorMessage: '',
    );
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

class _FileWorkDetailRepository implements WorkDetailRepository {
  @override
  Future<WorkDetailCatalog> loadCatalog({String jobId = ''}) async {
    return const WorkDetailCatalog(items: [], attachments: []);
  }

  @override
  Future<List<WorkAttachment>> listAttachments({String jobId = ''}) async {
    return const [
      WorkAttachment(
        attachmentId: '20',
        jobId: '128',
        fileType: WorkAttachmentType.video,
        fileName: 'take.mp4',
        note: '',
        content: '',
      ),
    ];
  }
}

class _QuietTimelineRepository implements JobTimelineRepository {
  int readCount = 0;

  JobTimeline _timeline(String jobId) {
    return JobTimeline(
      jobId: jobId,
      name: '작업',
      tracks: const [
        TimelineTrack(
          trackId: '1',
          name: '영상',
          order: 1,
          clips: [
            TimelineClip(
              clipId: '10',
              trackId: '1',
              kind: TimelineClipKind.video,
              startNs: '0',
              endNs: '10000000000',
              assetId: '20',
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

  @override
  Future<JobTimeline> getTimeline({required String jobId}) async {
    readCount += 1;
    return _timeline(jobId);
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
    bool omitsKind = false,
    List<String> inputClipIds = const [],
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
}
