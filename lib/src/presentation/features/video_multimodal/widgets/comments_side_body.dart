import 'package:flutter/material.dart';

import '../video_multimodal_view_model.dart';
import 'screen_comment_list.dart';
import 'side_panel_chrome.dart';

class CommentsSideBody extends StatelessWidget {
  const CommentsSideBody({
    super.key,
    required this.viewModel,
    required this.onClose,
  });

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SidePanelFrame(
      head: SidePanelHead(title: '코멘트', onClose: onClose),
      body: ScreenCommentList(
        jobId: viewModel.jobId,
        reloadCount: viewModel.commentListReloadCount,
        onPlay: (comment) {
          viewModel.didPlayCommentTarget(
            clipId: comment.playClipId,
            playheadNs: comment.playheadNs,
            videoAssetId: comment.videoAssetId,
          );
        },
      ),
    );
  }
}
