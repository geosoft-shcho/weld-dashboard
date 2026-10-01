import 'package:camera/camera.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../core/di/locator.dart';
import '../camera_recording_view_model.dart';

Future<void> showCameraRecordingDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return ChangeNotifierProvider(
        create: (_) => locator<CameraRecordingViewModel>()..prepare(),
        child: const CameraRecordingDialog(),
      );
    },
  );
}

class CameraRecordingDialog extends StatelessWidget {
  const CameraRecordingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraRecordingViewModel>();
    final controller = viewModel.cameraController;
    return ContentDialog(
      title: const Text('카메라 녹화'),
      constraints: const BoxConstraints(maxWidth: 720),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (viewModel.noticeText.isNotEmpty)
            InfoBar(
              title: Text(viewModel.isNoticeError ? '녹화 실패' : '안내'),
              content: Text(viewModel.noticeText),
              severity: viewModel.isNoticeError
                  ? InfoBarSeverity.error
                  : InfoBarSeverity.info,
            ),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: SizedBox(
              height: 320,
              child: controller == null
                  ? const Center(child: ProgressRing())
                  : CameraPreview(controller),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: viewModel.canStart ? viewModel.didTapStart : null,
                child: const Text('시작'),
              ),
              Button(
                onPressed: viewModel.canStop ? viewModel.didTapStop : null,
                child: const Text('정지'),
              ),
              Button(
                onPressed: viewModel.canSaveVideo
                    ? viewModel.didTapSaveVideo
                    : null,
                child: const Text('영상 저장'),
              ),
              Button(
                onPressed: viewModel.canSaveAudio
                    ? viewModel.didTapSaveAudio
                    : null,
                child: const Text('음성 저장'),
              ),
              if (viewModel.canRetry)
                Button(
                  onPressed: viewModel.didTapRetry,
                  child: const Text('다시 시도'),
                ),
            ],
          ),
        ],
      ),
      actions: [
        Button(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
