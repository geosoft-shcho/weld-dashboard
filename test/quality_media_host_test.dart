import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/quality_media.dart';
import 'package:weld_dashboard/src/domain/entities/quality_media_tab.dart';
import 'package:weld_dashboard/src/domain/entities/quality_result_group.dart';
import 'package:weld_dashboard/src/presentation/features/quality_issue/widgets/quality_media_host.dart';

void main() {
  testWidgets('shows scan and video tabs when video has no URL', (
    tester,
  ) async {
    final group = QualityResultGroup(
      qualityResultId: 'QR-001',
      paperDocNo: 'PAP-260906-014',
      commonKey: 'WO-2026-0312|J-A-14',
      passId: 'P-A14-1',
      segmentId: 'SEG-A14-1A',
      inspectedAt: '2026-09-06',
      inspectorName: '검사자',
      judgement: '불합격',
      issueSummary: '루트 언더컷 의심',
      scanFile: '',
      scanPages: 8,
      videoFile: '',
      items: const [],
      media: const [
        QualityMedia(
          type: QualityMediaTab.pdf,
          url: 'http://192.168.100.3:33201/files/connection-beam-ndt.pdf',
          filePath: 'connection-beam-ndt.pdf',
          pageCount: 8,
        ),
        QualityMedia(
          type: QualityMediaTab.video,
          url: '',
          filePath: 'data/attachments/arc-root-issue.mp4',
          pageCount: 0,
        ),
      ],
    );
    await tester.pumpWidget(
      FluentApp(
        home: ScaffoldPage(
          content: QualityMediaHost(
            group: group,
            selectedTab: QualityMediaTab.video,
            selectedMediaIndex: 0,
            onSelectTab: (_) {},
            onSelectMediaIndex: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('Video'), findsOneWidget);
    expect(find.text('현장 영상이 연동되지 않았습니다.'), findsOneWidget);
  });
}
