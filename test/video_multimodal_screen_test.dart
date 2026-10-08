import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
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
import 'package:weld_dashboard/src/presentation/core/di/locator.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_screen.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_view_model.dart';
import 'package:weld_dashboard/src/presentation/navigation/app_coordinator.dart';

void main() {
  setUp(() async {
    await locator.reset();
    locator.registerFactoryParam<VideoMultimodalViewModel, String, void>((
      jobId,
      _,
    ) {
      final timeline = _FakeTimelineRepository();
      return VideoMultimodalViewModel(
        listHistoryWorkAttachmentsUseCase: ListHistoryWorkAttachmentsUseCase(
          _FakeWorkDetailRepository(),
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
        labelUseCase: LabelUseCase(_IdleLabelRepository()),
        jobId: jobId,
      );
    });
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('shows the timeline for the open job', (tester) async {
    final coordinator = AppCoordinator();
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      FluentApp(
        home: ChangeNotifierProvider<AppCoordinator>.value(
          value: coordinator,
          child: const VideoMultimodalScreen(jobId: 'H001'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('clip.mp4'), findsWidgets);
    expect(find.text('other.pdf'), findsNothing);
    expect(find.text('영상'), findsOneWidget);
  });
}

class _FakeTimelineRepository implements JobTimelineRepository {
  @override
  Future<JobTimeline> getTimeline({required String jobId}) async {
    return JobTimeline(
      jobId: jobId,
      name: '작업',
      tracks: const [
        TimelineTrack(
          trackId: 'track-video',
          name: '영상',
          order: 1,
          isVisible: true,
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

  @override
  Future<String> readContent({required String url}) async => '';
}

class _FakeWorkDetailRepository implements WorkDetailRepository {
  @override
  Future<WorkDetailCatalog> loadCatalog({String jobId = ''}) async {
    return const WorkDetailCatalog(items: [], attachments: []);
  }

  @override
  Future<List<WorkAttachment>> listAttachments({String jobId = ''}) async {
    const attachments = [
      WorkAttachment(
        attachmentId: 'a1',
        jobId: 'H001',
        fileType: WorkAttachmentType.video,
        fileName: 'clip.mp4',
        note: '',
        content: 'assets/data/missing.mp4',
      ),
      WorkAttachment(
        attachmentId: 'a2',
        jobId: 'OTHER',
        fileType: WorkAttachmentType.pdf,
        fileName: 'other.pdf',
        note: '',
        content: 'memo',
      ),
    ];
    if (jobId.isEmpty) {
      return attachments;
    }
    return [
      for (final attachment in attachments)
        if (attachment.jobId == jobId) attachment,
    ];
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
