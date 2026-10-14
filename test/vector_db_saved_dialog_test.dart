import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/presentation/features/video_multimodal/widgets/vector_db_saved_dialog.dart';

void main() {
  testWidgets('vector save dialog keeps confirm closed until the bar ends', (
    tester,
  ) async {
    await tester.pumpWidget(
      FluentApp(
        home: Builder(
          builder: (context) {
            return Button(
              onPressed: () =>
                  showVectorDbSavedDialog(context, changedTrackCount: 1),
              child: const Text('열기'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('열기'));
    await tester.pump();

    expect(find.text('vector DB로 저장되었습니다'), findsOneWidget);
    expect(confirmButton(tester).onPressed, isNull);
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.widget<ProgressBar>(find.byType(ProgressBar)).value, isNot(0));

    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(confirmButton(tester).onPressed, isNotNull);

    await tester.tap(find.text('확인'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('vector DB로 저장되었습니다'), findsNothing);
  });
}

FilledButton confirmButton(WidgetTester tester) {
  return tester.widget<FilledButton>(find.widgetWithText(FilledButton, '확인'));
}
