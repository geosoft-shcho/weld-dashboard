import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../core/di/locator.dart';
import '../../core/themes/app_theme.dart';
import '../../navigation/app_coordinator.dart';
import 'video_multimodal_view_model.dart';
import 'widgets/multimodal_inference_panel.dart';
import 'widgets/multimodal_page_toolbar.dart';
import 'widgets/multimodal_side_panel.dart';
import 'widgets/multimodal_timeline_board.dart';
import 'widgets/multimodal_video_stage.dart';

class VideoMultimodalScreen extends StatelessWidget {
  const VideoMultimodalScreen({super.key, required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          locator<VideoMultimodalViewModel>(param1: jobId)..loadAttachments(),
      child: const _VideoMultimodalBody(),
    );
  }
}

class _VideoMultimodalBody extends StatelessWidget {
  const _VideoMultimodalBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VideoMultimodalViewModel>();
    final coordinator = context.read<AppCoordinator>();
    return ColoredBox(
      color: AppTheme.SURFACE,
      child: SizedBox.expand(
        child: ScaffoldPage(
          padding: EdgeInsets.zero,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MultimodalPageToolbar(
                viewModel: viewModel,
                title: viewModel.pageTitle,
                onBack: () =>
                    coordinator.didTapBackFromVideoMultimodal(context),
              ),
              if (viewModel.hasError)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: InfoBar(
                    title: const Text('타임라인 조회 실패'),
                    content: Text(viewModel.errorMessage),
                    severity: InfoBarSeverity.error,
                    action: Button(
                      onPressed: viewModel.loadAttachments,
                      child: const Text('다시 시도'),
                    ),
                  ),
                ),
              if (viewModel.hasNotice)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: InfoBar(
                    title: const Text('안내'),
                    content: Text(viewModel.noticeText),
                    severity: InfoBarSeverity.warning,
                    onClose: viewModel.didDismissNotice,
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: MultimodalVideoStage(
                                  viewModel: viewModel,
                                ),
                              ),
                              MultimodalTimelineBoard(viewModel: viewModel),
                            ],
                          ),
                        ),
                        if (viewModel.side != VideoMultimodalSide.none)
                          MultimodalSidePanel(
                            viewModel: viewModel,
                            onClose: viewModel.didTapCloseSide,
                          ),
                      ],
                    ),
                    MultimodalInferencePanel(viewModel: viewModel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
