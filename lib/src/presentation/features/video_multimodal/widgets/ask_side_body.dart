import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../../../domain/entities/ask_answer.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';
import 'side_panel_chrome.dart';

class AskSideBody extends StatefulWidget {
  const AskSideBody({super.key, required this.viewModel, required this.onClose});

  final VideoMultimodalViewModel viewModel;
  final VoidCallback onClose;

  @override
  State<AskSideBody> createState() => _AskSideBodyState();
}

class _AskSideBodyState extends State<AskSideBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    widget.viewModel.didSendAsk(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final turns = viewModel.askTurns;
    final playheadSeconds = viewModel.playheadSeconds;
    return SidePanelFrame(
      head: SidePanelHead(title: '영상 질의', onClose: widget.onClose),
      body: viewModel.isLoadingAskHistory
          ? const _AskHistoryLoading()
          : turns.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  '영상을 바탕으로 질문해 보세요.\n예: 용접 장면',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MultimodalStudioPalette.PANEL_MUTED,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                for (final turn in turns)
                  _AskMessage(
                    turn: turn,
                    playheadSeconds: playheadSeconds,
                    viewModel: viewModel,
                  ),
                if (viewModel.isAsking) const _AskPending(),
              ],
            ),
      foot: DecoratedBox(
        decoration: const BoxDecoration(
          color: MultimodalStudioPalette.PANEL_PAPER,
          border: Border(
            top: BorderSide(color: MultimodalStudioPalette.PANEL_LINE),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: sidePanelFieldTextStyle,
                    cursorColor: MultimodalStudioPalette.PANEL_ACCENT,
                    decoration: sidePanelFieldDecoration('영상 내용에 대해 질문하세요'),
                    onSubmitted: widget.viewModel.isAsking
                        ? null
                        : (_) => _send(),
                  ),
                ),
                const SizedBox(width: 4),
                SidePanelAccentButton(
                  label: '전송',
                  onPressed: widget.viewModel.isAsking ? null : _send,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AskMessage extends StatelessWidget {
  const _AskMessage({
    required this.turn,
    required this.playheadSeconds,
    required this.viewModel,
  });

  final AskTurn turn;
  final double playheadSeconds;
  final VideoMultimodalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      constraints: turn.isUser ? const BoxConstraints(maxWidth: 240) : null,
      decoration: BoxDecoration(
        color: turn.isUser
            ? MultimodalStudioPalette.PANEL_ACCENT_FILL
            : MultimodalStudioPalette.PANEL_PAPER,
        border: Border.all(color: MultimodalStudioPalette.PANEL_LINE),
      ),
      child: turn.isUser
          ? Text(
              turn.text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: MultimodalStudioPalette.PANEL_INK,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AskAnswerBody(text: turn.text),
                if (turn.citations.isNotEmpty)
                  _AskCitationsBlock(
                    citations: turn.citations,
                    playheadSeconds: playheadSeconds,
                    viewModel: viewModel,
                  ),
              ],
            ),
    );
    if (turn.isUser) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }
    return SizedBox(width: double.infinity, child: bubble);
  }
}

class _AskAnswerBody extends StatelessWidget {
  const _AskAnswerBody({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MultimodalStudioPalette.PANEL_ACCENT_FILL,
        border: Border.all(color: MultimodalStudioPalette.PANEL_LINE),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '답변',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: MultimodalStudioPalette.PANEL_MUTED,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: MultimodalStudioPalette.PANEL_INK,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AskCitationsBlock extends StatelessWidget {
  const _AskCitationsBlock({
    required this.citations,
    required this.playheadSeconds,
    required this.viewModel,
  });

  final List<AskCitation> citations;
  final double playheadSeconds;
  final VideoMultimodalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MultimodalStudioPalette.PANEL_PAGE,
          border: Border.all(color: MultimodalStudioPalette.PANEL_LINE),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '근거',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: MultimodalStudioPalette.PANEL_MUTED,
                ),
              ),
              const SizedBox(height: 6),
              for (var index = 0; index < citations.length; index++) ...[
                if (index > 0) const SizedBox(height: 6),
                _AskCitationCard(
                  index: index,
                  citation: citations[index],
                  isSelected: _isCitationAtPlayhead(
                    playheadSeconds,
                    citations[index],
                  ),
                  viewModel: viewModel,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AskCitationCard extends StatefulWidget {
  const _AskCitationCard({
    required this.index,
    required this.citation,
    required this.isSelected,
    required this.viewModel,
  });

  final int index;
  final AskCitation citation;
  final bool isSelected;
  final VideoMultimodalViewModel viewModel;

  @override
  State<_AskCitationCard> createState() => _AskCitationCardState();
}

class _AskCitationCardState extends State<_AskCitationCard> {
  final TextEditingController _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _registerComment(AskCitation citation) async {
    final saved = await widget.viewModel.didCommentCitation(
      citation,
      _comment.text,
    );
    if (saved && mounted) {
      _comment.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final citation = widget.citation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AskCitationButton(
          index: widget.index,
          citation: citation,
          isSelected: widget.isSelected,
          onPressed: () => widget.viewModel.didTapCitation(citation),
        ),
        Row(
          children: [
            IconButton(
              tooltip: '좋아요',
              visualDensity: VisualDensity.compact,
              onPressed: () => widget.viewModel.didLikeCitation(citation),
              icon: const Icon(
                fluent.FluentIcons.like,
                size: 16,
                color: MultimodalStudioPalette.PANEL_INK,
              ),
            ),
            IconButton(
              tooltip: '싫어요',
              visualDensity: VisualDensity.compact,
              onPressed: () => widget.viewModel.didDislikeCitation(citation),
              icon: const Icon(
                fluent.FluentIcons.dislike,
                size: 16,
                color: MultimodalStudioPalette.PANEL_INK,
              ),
            ),
            Expanded(
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _comment,
                        style: sidePanelFieldTextStyle,
                        cursorColor: MultimodalStudioPalette.PANEL_ACCENT,
                        decoration: sidePanelFieldDecoration('코멘트를 입력하세요'),
                        onSubmitted: (_) => _registerComment(citation),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SidePanelAccentButton(
                      label: '등록',
                      onPressed: () => _registerComment(citation),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AskCitationButton extends StatelessWidget {
  const _AskCitationButton({
    required this.index,
    required this.citation,
    required this.isSelected,
    required this.onPressed,
  });

  final int index;
  final AskCitation citation;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final range =
        '${_citationClock(citation.startSeconds)}–${_citationClock(citation.endSeconds)}';
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: MultimodalStudioPalette.PANEL_INK,
        backgroundColor: isSelected
            ? MultimodalStudioPalette.PANEL_ACCENT_FILL
            : MultimodalStudioPalette.PANEL_PAGE,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: const Size.fromHeight(36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: BorderSide(
          color: isSelected
              ? MultimodalStudioPalette.PANEL_ACCENT
              : MultimodalStudioPalette.PANEL_LINE,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${_citationTitle(citation.text)}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Text(
            range,
            style: const TextStyle(
              fontSize: 11,
              color: MultimodalStudioPalette.PANEL_MUTED,
            ),
          ),
        ],
      ),
    );
  }
}

class _AskHistoryLoading extends StatelessWidget {
  const _AskHistoryLoading();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        child: fluent.ProgressBar(strokeWidth: 2),
      ),
    );
  }
}

class _AskPending extends StatelessWidget {
  const _AskPending();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            child: fluent.ProgressBar(strokeWidth: 2),
          ),
          SizedBox(height: 8),
          Text(
            '답변을 찾는 중입니다.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: MultimodalStudioPalette.PANEL_MUTED,
            ),
          ),
        ],
      ),
    );
  }
}

bool _isCitationAtPlayhead(double playheadSeconds, AskCitation citation) {
  return (playheadSeconds - citation.startSeconds).abs() < 0.05;
}

String _citationTitle(String text) {
  final parts = [
    for (final part in text.split('|'))
      if (part.trim().isNotEmpty) part.trim(),
  ];
  if (parts.isEmpty) {
    return '근거 영상';
  }
  final title = parts.length >= 4 ? parts[3] : parts.last;
  for (final part in parts) {
    if (part.startsWith('job=')) {
      return '$title · 작업 ${part.substring(4)}';
    }
  }
  return title;
}

String _citationClock(double seconds) {
  final whole = seconds.floor().clamp(0, 86400);
  final hours = whole ~/ 3600;
  final minutes = (whole % 3600) ~/ 60;
  final remain = whole % 60;
  final minuteText = minutes.toString().padLeft(2, '0');
  final secondText = remain.toString().padLeft(2, '0');
  if (hours > 0) {
    return '$hours:$minuteText:$secondText';
  }
  return '$minuteText:$secondText';
}
