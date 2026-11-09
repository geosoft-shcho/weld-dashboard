import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show InputDecoration, OutlineInputBorder, TextField;
import 'package:provider/provider.dart';

import '../../../../domain/entities/screen_comment.dart';
import '../../../core/di/locator.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/waveform_material_scope.dart';
import '../screen_comment_list_view_model.dart';

class ScreenCommentList extends StatelessWidget {
  const ScreenCommentList({
    super.key,
    required this.jobId,
    required this.reloadCount,
    this.onPlay,
  });

  final String jobId;
  final int reloadCount;
  final void Function(ScreenComment comment)? onPlay;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: ValueKey<String>(jobId),
      create: (_) =>
          locator<ScreenCommentListViewModel>(param1: jobId)..loadComments(),
      child: _ScreenCommentListBody(reloadCount: reloadCount, onPlay: onPlay),
    );
  }
}

class _ScreenCommentListBody extends StatefulWidget {
  const _ScreenCommentListBody({required this.reloadCount, this.onPlay});

  final int reloadCount;
  final void Function(ScreenComment comment)? onPlay;

  @override
  State<_ScreenCommentListBody> createState() => _ScreenCommentListBodyState();
}

class _ScreenCommentListBodyState extends State<_ScreenCommentListBody> {
  @override
  void didUpdateWidget(covariant _ScreenCommentListBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reloadCount != widget.reloadCount) {
      context.read<ScreenCommentListViewModel>().loadComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScreenCommentListViewModel>();
    final comments = viewModel.comments;
    if (comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(6),
        child: Text('코멘트 없음', style: TextStyle(fontSize: 12)),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(6),
      itemCount: comments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _ScreenCommentTile(
          comment: comments[index],
          failureText: viewModel.failureText(comments[index].commentId),
          isBusy: viewModel.isBusy(comments[index].commentId),
          onPlay: widget.onPlay,
        );
      },
    );
  }
}

class _ScreenCommentTile extends StatefulWidget {
  const _ScreenCommentTile({
    required this.comment,
    required this.failureText,
    required this.isBusy,
    this.onPlay,
  });

  final ScreenComment comment;
  final String failureText;
  final bool isBusy;
  final void Function(ScreenComment comment)? onPlay;

  @override
  State<_ScreenCommentTile> createState() => _ScreenCommentTileState();
}

class _ScreenCommentTileState extends State<_ScreenCommentTile> {
  late final TextEditingController _bodyController;
  late final FocusNode _bodyFocus;

  @override
  void initState() {
    super.initState();
    _bodyController = TextEditingController(text: widget.comment.body);
    _bodyFocus = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _ScreenCommentTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bodyChanged =
        oldWidget.comment.commentId != widget.comment.commentId ||
        (oldWidget.comment.body != widget.comment.body && !_bodyFocus.hasFocus);
    if (bodyChanged && _bodyController.text != widget.comment.body) {
      _bodyController.text = widget.comment.body;
    }
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  Future<void> _didTapSave() async {
    await context.read<ScreenCommentListViewModel>().updateBody(
      commentId: widget.comment.commentId,
      body: _bodyController.text,
    );
  }

  Future<void> _didTapDelete() async {
    final confirmed = await showDialog<bool>(
      context: _fluentDialogContext(context),
      builder: (dialogContext) => ContentDialog(
        title: const Text('코멘트를 지울까요?'),
        content: const Text('코멘트만 지웁니다. 녹화 파일은 남습니다.'),
        actions: [
          Button(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('지우기'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await context.read<ScreenCommentListViewModel>().deleteComment(
      commentId: widget.comment.commentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = widget.comment.body.isEmpty ? '말만' : widget.comment.body;
    final status = widget.comment.sttLabel;
    final statusMessage = widget.comment.sttMessage.isEmpty
        ? status
        : widget.comment.sttMessage;
    final color = _statusColor(status);
    final canPlay = widget.onPlay != null && widget.comment.canPlay;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: IconButton(
            icon: DecoratedBox(
              decoration: BoxDecoration(
                color: (canPlay ? AppTheme.ACCENT_STEEL : AppTheme.STATUS_OFF)
                    .withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  FluentIcons.play,
                  size: 12,
                  color: canPlay ? AppTheme.ACCENT_STEEL : AppTheme.STATUS_OFF,
                ),
              ),
            ),
            onPressed: canPlay && !widget.isBusy
                ? () => widget.onPlay!(widget.comment)
                : null,
          ),
        ),
        Expanded(
          child: Expander(
            header: Row(
              children: [
                _StatusMark(label: status, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '상태',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  statusMessage,
                  style: TextStyle(color: color, fontSize: 13),
                ),
                if (widget.failureText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.failureText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.STATUS_ERROR,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                const Text(
                  '내용',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                WaveformMaterialScope(
                  child: TextField(
                    controller: _bodyController,
                    focusNode: _bodyFocus,
                    enabled: !widget.isBusy,
                    minLines: 2,
                    maxLines: 4,
                    style: const TextStyle(color: AppTheme.INK, fontSize: 13),
                    cursorColor: AppTheme.ACCENT_STEEL,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '녹화에 덧붙일 글',
                      hintStyle: TextStyle(
                        color: AppTheme.INK.withValues(alpha: 0.45),
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: AppTheme.SURFACE,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF3E424A)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF3E424A)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Spacer(),
                    Tooltip(
                      message: '삭제',
                      child: IconButton(
                        icon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FluentIcons.delete,
                              size: 14,
                              color: AppTheme.STATUS_ERROR,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '삭제',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.STATUS_ERROR,
                              ),
                            ),
                          ],
                        ),
                        onPressed: widget.isBusy ? null : _didTapDelete,
                      ),
                    ),
                    Tooltip(
                      message: '저장',
                      child: IconButton(
                        icon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(FluentIcons.save),
                            SizedBox(width: 4),
                            Text('저장', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        onPressed: widget.isBusy ? null : _didTapSave,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 코멘트 패널은 [WorkDetailMaterialScope] 안에 있어 Fluent 번역이 가려진다.
/// 확인 창은 그 번역 위젯의 바깥 문맥에서 연다.
BuildContext _fluentDialogContext(BuildContext context) {
  BuildContext? host;
  context.visitAncestorElements((element) {
    if (element.widget is! Localizations) {
      return true;
    }
    host = element;
    return false;
  });
  return host ?? context;
}

class _StatusMark extends StatelessWidget {
  const _StatusMark({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(label, style: TextStyle(color: color, fontSize: 12)),
      ),
    );
  }
}

Color _statusColor(String label) {
  switch (label) {
    case '완료':
      return AppTheme.STATUS_OK;
    case '처리 중':
      return AppTheme.ACCENT_STEEL;
    case '실패':
    case '취소':
      return AppTheme.STATUS_ERROR;
    default:
      return AppTheme.STATUS_OFF;
  }
}
