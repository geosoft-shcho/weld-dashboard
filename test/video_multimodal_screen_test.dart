import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment.dart';
import 'package:weld_dashboard/src/domain/entities/work_attachment_type.dart';
import 'package:weld_dashboard/src/domain/entities/work_detail_catalog.dart';
import 'package:weld_dashboard/src/domain/repositories/work_detail_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_history_work_attachments_use_case.dart';
import 'package:weld_dashboard/src/presentation/core/di/locator.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_screen.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/video_multimodal_view_model.dart';
import 'package:weld_dashboard/src/presentation/navigation/app_coordinator.dart';

void main() {
  setUp(() async {
    await locator.reset();
    locator.registerFactoryParam<VideoMultimodalViewModel, String, void>(
      (jobId, _) => VideoMultimodalViewModel(
        listHistoryWorkAttachmentsUseCase: ListHistoryWorkAttachmentsUseCase(
          _FakeWorkDetailRepository(),
        ),
        jobId: jobId,
      ),
    );
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('shows attachments for the open history only', (tester) async {
    final coordinator = AppCoordinator();
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
