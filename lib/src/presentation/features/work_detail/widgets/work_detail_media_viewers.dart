import 'package:fluent_ui/fluent_ui.dart';

import '../work_detail_view_model.dart';
import 'work_detail_chewie_stage.dart';
import 'work_detail_empty_bar.dart';
import 'work_detail_file_strip.dart';
import 'work_detail_host.dart';
import 'work_detail_just_audio_stage.dart';

class WorkDetailVideoViewer extends StatelessWidget {
  const WorkDetailVideoViewer({super.key, required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final files = viewModel.visibleAttachments;
    final attachment = viewModel.selectedAttachment;
    if (attachment == null) {
      return const WorkDetailEmptyBar(message: '이 작업에 비디오 파일이 없습니다');
    }
    final assetPath = attachment.networkUrl ?? attachment.assetPath;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkDetailFileStrip(viewModel: viewModel, files: files),
        const SizedBox(height: 8),
        Expanded(
          child: WorkDetailHost(
            packageName: 'video_player + chewie',
            attachment: attachment,
            index: viewModel.selectedFileIndex,
            total: files.length,
            child: assetPath == null
                ? const Center(child: Text('재생할 비디오 파일이 없습니다'))
                : WorkDetailChewieStage(
                    key: ValueKey(attachment.attachmentId),
                    assetPath: assetPath,
                  ),
          ),
        ),
      ],
    );
  }
}

class WorkDetailAudioViewer extends StatelessWidget {
  const WorkDetailAudioViewer({super.key, required this.viewModel});

  final WorkDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final files = viewModel.visibleAttachments;
    final attachment = viewModel.selectedAttachment;
    if (attachment == null) {
      return const WorkDetailEmptyBar(message: '이 작업에 오디오 파일이 없습니다');
    }
    final assetPath = attachment.networkUrl ?? attachment.assetPath;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkDetailFileStrip(viewModel: viewModel, files: files),
        const SizedBox(height: 8),
        Expanded(
          child: WorkDetailHost(
            packageName: 'just_audio + waveform_visualizer',
            attachment: attachment,
            index: viewModel.selectedFileIndex,
            total: files.length,
            child: assetPath == null
                ? const Center(child: Text('재생할 오디오 파일이 없습니다'))
                : WorkDetailJustAudioStage(
                    key: ValueKey(attachment.attachmentId),
                    assetPath: assetPath,
                  ),
          ),
        ),
      ],
    );
  }
}
