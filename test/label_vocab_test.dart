import 'package:fixnum/fixnum.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/compose/v1/compose.pb.dart';
import 'package:weld_dashboard/src/data/repositories/job_timeline_edit_requests.dart';
import 'package:weld_dashboard/src/data/repositories/label_requests.dart';
import 'package:weld_dashboard/src/data/repositories/remote_job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/entities/job_timeline.dart';
import 'package:weld_dashboard/src/domain/entities/label_vocab.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment.dart';
import 'package:weld_dashboard/src/domain/entities/work_detail_catalog.dart';
import 'package:weld_dashboard/src/domain/repositories/job_timeline_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/label_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/tool_run_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/work_detail_repository.dart';
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
import 'package:weld_dashboard/src/presentation/core/themes/app_theme.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_view_model.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/multimodal_side_panel.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/multimodal_studio_palette.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/timeline_board_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('list request omits include_deprecated and builds the label tree', () {
    final request = buildListLabelsRequest();
    expect(request.hasIncludeDeprecated(), isFalse);

    final roots = labelNodesFrom([
      LabelValue(valueId: Int64(1), name: 'speaker'),
      LabelValue(valueId: Int64(4), parentValueId: Int64(1), name: 'speaker_1'),
      LabelValue(
        valueId: Int64(5),
        parentValueId: Int64(1),
        name: 'retired',
        deprecated: true,
      ),
      LabelValue(name: 'missing'),
      LabelValue(valueId: Int64(8), parentValueId: Int64(4), name: 'speaker_1'),
      LabelValue(valueId: Int64(9), parentValueId: Int64(99), name: 'loose'),
    ]);

    expect(roots, hasLength(2));
    expect(roots.first.valueId, '1');
    expect(roots.first.name, 'speaker');
    expect(roots.first.children.single.valueId, '4');
    expect(roots.first.children.single.name, 'speaker_1');
    expect(roots.first.children.single.children.single.valueId, '8');
    expect(roots.first.children.single.children.single.name, 'speaker_1');
    expect(roots.last.valueId, '9');
    expect(roots.last.name, 'loose');
  });

  test('rename mask is name and deprecate mask is deprecated', () {
    final renamed = buildRenameLabelValueRequest(valueId: '4', name: 'next');
    expect(renamed.value.valueId.toString(), '4');
    expect(renamed.value.name, 'next');
    expect(renamed.value.hasDeprecated(), isFalse);
    expect(renamed.updateMask.paths, ['name']);

    final hidden = buildDeprecateLabelValueRequest('4');
    expect(hidden.value.valueId.toString(), '4');
    expect(hidden.value.deprecated, isTrue);
    expect(hidden.value.hasName(), isFalse);
    expect(hidden.updateMask.paths, ['deprecated']);

    final created = buildCreateLabelValueRequest(
      name: 'arc',
      parentValueId: '1',
    );
    expect(created.hasParentValueId(), isTrue);
    expect(created.parentValueId.toString(), '1');
    expect(created.name, 'arc');
    expect(created.hasDescription(), isFalse);

    final root = buildCreateLabelValueRequest(name: 'speaker');
    expect(root.hasParentValueId(), isFalse);
    expect(root.name, 'speaker');
    expect(
      () => buildCreateLabelValueRequest(name: ' '),
      throwsA(isA<LabelException>()),
    );
  });

  test('opening labels loads vocabs and keeps the chip identity', () async {
    final labels = _ScriptedLabels()
      ..roots = const [
        LabelNode(
          valueId: '1',
          name: 'speaker',
          children: [
            LabelNode(valueId: '4', name: 'torch', parentValueId: '1'),
            LabelNode(valueId: '8', name: 'torch', parentValueId: '1'),
          ],
        ),
      ];
    final timeline = _CountingTimelineRepository();
    final viewModel = _viewModel(labels, timeline);
    addTearDown(viewModel.dispose);

    viewModel.didTapToggleLabels();
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.isLabelsOpen, isTrue);
    expect(labels.listCount, 1);
    expect(viewModel.labelRoots.single.name, 'speaker');
    expect(viewModel.labelRoots.single.valueId, '1');
    expect(viewModel.labelRoots.single.children.map((node) => node.valueId), [
      '4',
      '8',
    ]);

    viewModel.didSelectLabelValue('8');
    expect(viewModel.selectedLabelValueId, '8');
    expect(timeline.createClipCount, 0);
    expect(viewModel.timelineClips, isEmpty);

    expect(await viewModel.didAddLabelValue(name: '  '), isFalse);
    expect(labels.createCount, 0);

    labels.created = const LabelNode(
      valueId: '9',
      name: 'arc',
      parentValueId: '1',
    );
    expect(
      await viewModel.didAddLabelValue(name: ' arc ', parentValueId: '1'),
      isTrue,
    );
    expect(labels.createdParentValueId, '1');
    expect(labels.createdName, 'arc');
    expect(viewModel.labelRoots.single.children.last.valueId, '9');

    labels.renamed = const LabelNode(
      valueId: '8',
      name: 'weld',
      parentValueId: '1',
    );
    await viewModel.didRenameLabelValue(valueId: '8', name: 'weld');
    expect(labels.renamedValueId, '8');
    expect(viewModel.labelRoots.single.children.map((node) => node.name), [
      'torch',
      'weld',
      'arc',
    ]);
    expect(viewModel.selectedLabelValueId, '8');

    await viewModel.didDeprecateLabelValue(valueId: '8');
    expect(labels.deprecatedValueId, '8');
    expect(viewModel.labelRoots.single.children.map((node) => node.valueId), [
      '4',
      '9',
    ]);
    expect(viewModel.selectedLabelValueId, isEmpty);
    expect(timeline.createClipCount, 0);
  });

  testWidgets('labels panel shows the label tree as rows', (tester) async {
    final labels = _ScriptedLabels()
      ..roots = const [
        LabelNode(
          valueId: '1',
          name: 'speaker',
          children: [
            LabelNode(valueId: '4', name: 'speaker_1', parentValueId: '1'),
          ],
        ),
      ];
    final viewModel = _viewModel(labels, _CountingTimelineRepository());
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return MaterialApp(
            home: fluent.FluentTheme(
              data: AppTheme.dark,
              child: viewModel.side == VideoMultimodalSide.none
                  ? const SizedBox.shrink()
                  : MultimodalSidePanel(viewModel: viewModel, onClose: () {}),
            ),
          );
        },
      ),
    );
    viewModel.didTapToggleLabels();
    await tester.pump();
    await tester.pump();

    expect(find.text('오디오 구간'), findsNothing);
    expect(find.text('비디오 객체'), findsNothing);
    expect(find.text('speaker'), findsOneWidget);
    expect(find.text('speaker_1'), findsOneWidget);
    expect(find.text('#speaker_1'), findsNothing);
    expect(find.text('아래에 추가'), findsNothing);
    expect(find.text('맨 위 라벨 추가'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.text('맨 위 라벨 추가'),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.text('클립에 붙이기'),
      ),
      findsNothing,
    );
    expect(find.byIcon(Icons.edit_outlined), findsNothing);
    expect(find.text('자막 막대'), findsNothing);
    expect(
      tester
          .widget<fluent.Button>(find.widgetWithText(fluent.Button, '클립에 붙이기'))
          .onPressed,
      isNull,
    );
    expect(find.text('라벨 떼기'), findsNothing);

    await tester.tap(find.text('맨 위 라벨 추가'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.text('새 라벨 이름'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('speaker'));
    await tester.pump();
    expect(viewModel.selectedLabelValueId, '1');
    expect(find.text('아래에 추가'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(
      tester
          .widget<fluent.Button>(find.widgetWithText(fluent.Button, '클립에 붙이기'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pump();
    expect(find.text('speaker_1'), findsNothing);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();
    expect(find.text('speaker_1'), findsOneWidget);
  });

  test('timeline keeps a clip label id and drops zero', () {
    final timeline = jobTimelineFromResponse(
      GetTimelineResponse(
        timeline: Timeline(jobId: Int64(128), name: '작업'),
        tracks: [Track(trackId: Int64(1), name: '영상', order: 1)],
        clips: [
          Clip(
            clipId: Int64(10),
            trackId: Int64(1),
            timelineStartNs: Int64.ZERO,
            timelineEndNs: Int64(10000000000),
            description: '메모',
          ),
          Clip(
            clipId: Int64(11),
            trackId: Int64(1),
            timelineStartNs: Int64(10000000000),
            timelineEndNs: Int64(20000000000),
            labelValueId: Int64(4),
            description: '메모',
          ),
        ],
      ),
      resolveContentUrl: (url) => url,
    );

    expect(timeline.clips.first.labelValueId, isEmpty);
    expect(timeline.clips.first.description, '메모');
    expect(timeline.clips.last.labelValueId, '4');
    expect(timeline.clips.last.description, '메모');
  });

  test('attach writes only the label id and rename leaves the clip', () async {
    final labeled = buildUpdateClipRequest(clipId: '10', labelValueId: '4');
    expect(labeled.updateMask.paths, ['label_value_id']);
    expect(labeled.clip.labelValueId.toString(), '4');
    expect(labeled.clip.hasSource(), isFalse);
    expect(labeled.clip.hasTimelineStartNs(), isFalse);
    expect(labeled.clip.hasDescription(), isFalse);

    final cleared = buildUpdateClipRequest(clipId: '10', labelValueId: '0');
    expect(cleared.updateMask.paths, ['label_value_id']);
    expect(cleared.clip.labelValueId.toInt(), 0);

    final labels = _ScriptedLabels()
      ..roots = const [
        LabelNode(
          valueId: '1',
          name: 'speaker',
          children: [
            LabelNode(valueId: '4', name: 'speaker_1', parentValueId: '1'),
            LabelNode(valueId: '8', name: 'torch', parentValueId: '1'),
          ],
        ),
      ];
    final timeline = _CountingTimelineRepository()..hasClip = true;
    final viewModel = _viewModel(labels, timeline);
    addTearDown(viewModel.dispose);

    await viewModel.loadAttachments();
    expect(labels.listCount, 1);
    expect(viewModel.labelForClip(viewModel.timelineClips.single), '메모');
    expect(viewModel.clipCaption(viewModel.timelineClips.single), '메모');
    expect(
      buildTimelineBoardRows(viewModel).single.clips.single.hasLabel,
      isFalse,
    );

    viewModel.didSelectLabelValue('4');
    expect(viewModel.canAttachLabelToSelection, isFalse);
    expect(timeline.updateClipCount, 0);
    expect(timeline.createClipCount, 0);

    viewModel.didSelectSampleClip('10');
    expect(viewModel.canAttachLabelToSelection, isTrue);
    expect(viewModel.canDetachLabelFromSelection, isFalse);

    await viewModel.didAttachLabelToSelectedClip();
    expect(timeline.updateClipCount, 1);
    expect(timeline.updatedLabelValueId, '4');
    expect(timeline.updatedTrackId, isNull);
    expect(timeline.updatedStartNs, isNull);
    expect(timeline.updatedEndNs, isNull);
    expect(timeline.updatedAssetId, isNull);
    expect(timeline.updatedDescription, isNull);
    expect(timeline.updatedReviewed, isNull);
    expect(timeline.createClipCount, 0);
    expect(viewModel.timelineClips.single.description, '메모');
    expect(viewModel.timelineClips.single.labelValueId, '4');
    expect(viewModel.labelForClip(viewModel.timelineClips.single), 'speaker_1');
    expect(viewModel.clipCaption(viewModel.timelineClips.single), '#speaker_1');
    final labeledRow = buildTimelineBoardRows(viewModel).single.clips.single;
    expect(labeledRow.hasLabel, isTrue);
    expect(labeledRow.text, '#speaker_1');
    expect(labeledRow.background, MultimodalStudioPalette.PLUM_100);

    labels.renamed = const LabelNode(
      valueId: '4',
      name: 'host',
      parentValueId: '1',
    );
    await viewModel.didRenameLabelValue(valueId: '4', name: 'host');
    expect(timeline.updateClipCount, 1);
    expect(viewModel.labelForClip(viewModel.timelineClips.single), 'host');
    expect(viewModel.labelRoots.single.children.first.valueId, '4');
    expect(viewModel.labelRoots.single.children.last.name, 'torch');

    await viewModel.didDeprecateLabelValue(valueId: '4');
    expect(timeline.updateClipCount, 1);
    expect(viewModel.labelForClip(viewModel.timelineClips.single), '4');
    expect(viewModel.clipCaption(viewModel.timelineClips.single), '#4');

    await viewModel.didDetachLabelFromSelectedClip();
    expect(timeline.updateClipCount, 2);
    expect(timeline.updatedLabelValueId, '0');
    expect(viewModel.timelineClips.single.labelValueId, isEmpty);
    expect(viewModel.timelineClips.single.description, '메모');
    expect(viewModel.labelForClip(viewModel.timelineClips.single), '메모');
    expect(viewModel.clipCaption(viewModel.timelineClips.single), '메모');
    expect(
      buildTimelineBoardRows(viewModel).single.clips.single.hasLabel,
      isFalse,
    );
    expect(viewModel.canDetachLabelFromSelection, isFalse);
  });
}

VideoMultimodalViewModel _viewModel(
  _ScriptedLabels labels,
  _CountingTimelineRepository timeline,
) {
  return VideoMultimodalViewModel(
    listHistoryWorkAttachmentsUseCase: ListHistoryWorkAttachmentsUseCase(
      _EmptyWorkDetailRepository(),
    ),
    getJobTimelineUseCase: GetJobTimelineUseCase(timeline),
    createTrackUseCase: CreateTrackUseCase(timeline),
    updateTrackUseCase: UpdateTrackUseCase(timeline),
    deleteTrackUseCase: DeleteTrackUseCase(timeline),
    createClipUseCase: CreateClipUseCase(timeline),
    updateClipUseCase: UpdateClipUseCase(timeline),
    deleteClipUseCase: DeleteClipUseCase(timeline),
    changeTimelineStatusUseCase: ChangeTimelineStatusUseCase(timeline),
    toolRunUseCase: ToolRunUseCase(_IdleToolRunRepository()),
    labelUseCase: LabelUseCase(labels),
    jobId: '128',
  );
}

class _ScriptedLabels implements LabelRepository {
  List<LabelNode> roots = const [];
  int listCount = 0;
  int createCount = 0;
  String createdParentValueId = '';
  String createdName = '';
  LabelNode created = const LabelNode(valueId: '9', name: 'arc');
  String renamedValueId = '';
  LabelNode renamed = const LabelNode(valueId: '8', name: 'weld');
  String deprecatedValueId = '';

  @override
  Future<List<LabelNode>> listLabels() async {
    listCount += 1;
    return roots;
  }

  @override
  Future<LabelNode> createValue({
    required String name,
    String parentValueId = '',
  }) async {
    createCount += 1;
    createdParentValueId = parentValueId;
    createdName = name;
    return created;
  }

  @override
  Future<LabelNode> renameValue({
    required String valueId,
    required String name,
  }) async {
    renamedValueId = valueId;
    return renamed;
  }

  @override
  Future<void> deprecateValue({required String valueId}) async {
    deprecatedValueId = valueId;
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

class _CountingTimelineRepository implements JobTimelineRepository {
  int createClipCount = 0;
  int updateClipCount = 0;
  bool hasClip = false;
  String clipLabelValueId = '';
  String? updatedLabelValueId;
  String? updatedTrackId;
  String? updatedStartNs;
  String? updatedEndNs;
  String? updatedAssetId;
  String? updatedDescription;
  bool? updatedReviewed;

  @override
  Future<JobTimeline> getTimeline({required String jobId}) async {
    if (!hasClip) {
      return JobTimeline.empty;
    }
    return JobTimeline(
      jobId: jobId,
      name: '작업',
      tracks: [
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
              assetId: '',
              fileName: 'clip.mp4',
              playbackUrl: '',
              description: '메모',
              showsToolBadge: false,
              labelValueId: clipLabelValueId,
            ),
          ],
        ),
      ],
    );
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
  }) async {
    createClipCount += 1;
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
    updateClipCount += 1;
    updatedLabelValueId = labelValueId;
    updatedTrackId = trackId;
    updatedStartNs = startNs;
    updatedEndNs = endNs;
    updatedAssetId = assetId;
    updatedDescription = description;
    updatedReviewed = isReviewed;
    if (labelValueId != null) {
      clipLabelValueId = labelValueId == '0' ? '' : labelValueId;
    }
  }

  @override
  Future<void> deleteClip({required String clipId}) async {}

  @override
  Future<void> changeTimelineStatus({
    required String jobId,
    required JobTimelineStatus fromStatus,
    required JobTimelineStatus toStatus,
  }) async {}

  @override
  Future<String> readContent({required String url}) async => '';
}
