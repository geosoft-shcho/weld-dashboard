import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/compose/v1/compose.pb.dart';
import 'package:weld_dashboard/src/data/repositories/label_requests.dart';
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
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_view_model.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/multimodal_side_panel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('list request omits include_deprecated and drops hidden values', () {
    final request = buildListLabelVocabsRequest();
    expect(request.hasIncludeDeprecated(), isFalse);

    final sections = labelSectionsFrom([
      LabelVocab(
        key: 'speaker',
        values: [
          LabelValue(valueId: Int64(4), name: 'speaker_1'),
          LabelValue(valueId: Int64(5), name: 'retired', deprecated: true),
          LabelValue(name: 'missing'),
        ],
      ),
      LabelVocab(key: ''),
    ]);

    expect(sections, hasLength(1));
    expect(sections.single.vocabKey, 'speaker');
    expect(sections.single.chips, hasLength(1));
    expect(sections.single.chips.single.valueId, '4');
    expect(sections.single.chips.single.name, 'speaker_1');
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
      vocabKey: 'speaker',
      name: 'arc',
    );
    expect(created.vocabKey, 'speaker');
    expect(created.name, 'arc');
    expect(created.hasDescription(), isFalse);
    expect(
      () => buildCreateLabelValueRequest(vocabKey: 'speaker', name: ' '),
      throwsA(isA<LabelException>()),
    );
  });

  test('opening labels loads vocabs and keeps the chip identity', () async {
    final labels = _ScriptedLabels()
      ..sections = const [
        LabelSection(
          vocabKey: 'speaker',
          chips: [
            LabelChip(valueId: '4', name: 'torch'),
            LabelChip(valueId: '8', name: 'torch'),
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
    expect(viewModel.labelSections.single.vocabKey, 'speaker');
    expect(viewModel.labelSections.single.chips.map((chip) => chip.valueId), [
      '4',
      '8',
    ]);

    viewModel.didSelectLabelValue('8');
    expect(viewModel.selectedLabelValueId, '8');
    expect(timeline.createClipCount, 0);
    expect(viewModel.timelineClips, isEmpty);

    expect(await viewModel.didAddLabelValue('speaker', '  '), isFalse);
    expect(labels.createCount, 0);

    labels.created = const LabelChip(valueId: '9', name: 'arc');
    expect(await viewModel.didAddLabelValue('speaker', ' arc '), isTrue);
    expect(labels.createdVocabKey, 'speaker');
    expect(labels.createdName, 'arc');
    expect(viewModel.labelSections.single.chips.last.valueId, '9');

    labels.renamed = const LabelChip(valueId: '8', name: 'weld');
    await viewModel.didRenameLabelValue(
      vocabKey: 'speaker',
      valueId: '8',
      name: 'weld',
    );
    expect(labels.renamedValueId, '8');
    expect(viewModel.labelSections.single.chips.map((chip) => chip.name), [
      'torch',
      'weld',
      'arc',
    ]);
    expect(viewModel.selectedLabelValueId, '8');

    await viewModel.didDeprecateLabelValue(vocabKey: 'speaker', valueId: '8');
    expect(labels.deprecatedValueId, '8');
    expect(viewModel.labelSections.single.chips.map((chip) => chip.valueId), [
      '4',
      '9',
    ]);
    expect(viewModel.selectedLabelValueId, isEmpty);
    expect(timeline.createClipCount, 0);
  });

  testWidgets('labels panel shows vocab keys from the server', (tester) async {
    final labels = _ScriptedLabels()
      ..sections = const [
        LabelSection(
          vocabKey: 'speaker',
          chips: [LabelChip(valueId: '4', name: 'speaker_1')],
        ),
      ];
    final viewModel = _viewModel(labels, _CountingTimelineRepository());
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return MaterialApp(
            home: viewModel.side == VideoMultimodalSide.none
                ? const SizedBox.shrink()
                : MultimodalSidePanel(viewModel: viewModel, onClose: () {}),
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
    expect(find.text('#speaker_1'), findsOneWidget);
    expect(find.text('라벨 추가'), findsOneWidget);
    expect(find.text('자막 막대'), findsNothing);
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
  List<LabelSection> sections = const [];
  int listCount = 0;
  int createCount = 0;
  String createdVocabKey = '';
  String createdName = '';
  LabelChip created = const LabelChip(valueId: '9', name: 'arc');
  String renamedValueId = '';
  LabelChip renamed = const LabelChip(valueId: '8', name: 'weld');
  String deprecatedValueId = '';

  @override
  Future<List<LabelSection>> listSections() async {
    listCount += 1;
    return sections;
  }

  @override
  Future<LabelChip> createValue({
    required String vocabKey,
    required String name,
  }) async {
    createCount += 1;
    createdVocabKey = vocabKey;
    createdName = name;
    return created;
  }

  @override
  Future<LabelChip> renameValue({
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

  @override
  Future<JobTimeline> getTimeline({required String jobId}) async {
    return JobTimeline.empty;
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
