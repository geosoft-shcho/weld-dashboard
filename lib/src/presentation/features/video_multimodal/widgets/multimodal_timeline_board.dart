import 'package:flutter/material.dart';

import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';

class MultimodalTimelineBoard extends StatefulWidget {
  const MultimodalTimelineBoard({super.key, required this.viewModel});

  final VideoMultimodalViewModel viewModel;

  @override
  State<MultimodalTimelineBoard> createState() =>
      _MultimodalTimelineBoardState();
}

class _MultimodalTimelineBoardState extends State<MultimodalTimelineBoard> {
  final ScrollController _scrollController = ScrollController();
  DateTime _lastAutoScrollAt = DateTime.fromMillisecondsSinceEpoch(0);
  double _draftStart = -1;
  double _draftEnd = -1;
  double _resizeStart = 0;
  double _resizeEnd = 0;

  VideoMultimodalViewModel get viewModel => widget.viewModel;

  @override
  void didUpdateWidget(covariant MultimodalTimelineBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!viewModel.isVideoPlaying) {
      return;
    }
    if (oldWidget.viewModel.playheadSeconds == viewModel.playheadSeconds) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _followPlayhead());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _followPlayhead() {
    if (!_scrollController.hasClients) {
      return;
    }
    final now = DateTime.now();
    if (now.difference(_lastAutoScrollAt).inMilliseconds < 80) {
      return;
    }
    final position = _scrollController.position;
    final head = viewModel.playheadSeconds * viewModel.pixelsPerSecond;
    const margin = 48.0;
    final viewLeft = position.pixels;
    final viewRight = viewLeft + position.viewportDimension;
    if (head >= viewLeft + margin && head <= viewRight - margin) {
      return;
    }
    _lastAutoScrollAt = now;
    final target = (head - position.viewportDimension * 0.3).clamp(
      0.0,
      position.maxScrollExtent,
    );
    _scrollController.jumpTo(target);
  }

  double _secondsAt(double localDx) {
    final scrolled = _scrollController.hasClients
        ? _scrollController.offset
        : 0;
    final seconds = (scrolled + localDx) / viewModel.pixelsPerSecond;
    return seconds.clamp(0, viewModel.spanSeconds);
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows();
    final hasMedia = rows.isNotEmpty && viewModel.spanSeconds > 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 12),
      constraints: const BoxConstraints(
        minHeight: VideoMultimodalViewModel.MIN_TIMELINE_HEIGHT,
      ),
      decoration: BoxDecoration(
        color: MultimodalStudioPalette.SAND_100,
        border: Border.all(color: MultimodalStudioPalette.SAND_300),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      height: VideoMultimodalViewModel.MIN_TIMELINE_HEIGHT,
      child: Stack(
        children: [
          hasMedia ? _filled(rows) : _empty(),
          if (viewModel.isLaneMenuOpen) _laneMenu(),
        ],
      ),
    );
  }

  Widget _empty() {
    return const SizedBox(
      height: 80,
      child: Center(
        child: Text(
          '미디어가 로드되면 멀티 모달 타임라인이 표시됩니다.',
          style: TextStyle(
            color: MultimodalStudioPalette.SAND_600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _filled(List<_TimelineRow> rows) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          _toolbar(),
          if (viewModel.isLinkMode) _linkBanner(),
          if (viewModel.hasTimelineHint) _hint(),
          SizedBox(
            height: 22 + rows.length * 28,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _objects(rows),
                Expanded(child: _tracks(rows)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbar() {
    final viewModel = this.viewModel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: MultimodalStudioPalette.SAND_0,
      child: Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _tool(
            '선택',
            selected: !viewModel.isLinkMode,
            onPressed: viewModel.didTapSelectTool,
          ),
          _tool(
            'Link',
            selected: viewModel.isLinkMode,
            onPressed: viewModel.didTapToggleLinkMode,
          ),
          _tool(
            'Del',
            onPressed: viewModel.canDeleteSelection
                ? viewModel.didTapDeleteSelection
                : null,
          ),
          _tool(
            'Lanes',
            selected: viewModel.isLaneMenuOpen,
            onPressed: viewModel.didTapToggleLaneMenu,
          ),
          _tool(
            viewModel.areAuxiliaryRowsHidden ? '보조 숨김' : '표시',
            selected: viewModel.areAuxiliaryRowsHidden,
            onPressed: viewModel.didTapToggleAuxiliaryRows,
          ),
          _tool('Marker', onPressed: viewModel.didTapAddMarker),
          _tool('Labels', onPressed: viewModel.didTapToggleLabels),
        ],
      ),
    );
  }

  Widget _tool(
    String label, {
    required VoidCallback? onPressed,
    bool selected = false,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: selected
            ? Colors.white
            : MultimodalStudioPalette.SAND_900,
        backgroundColor: selected
            ? MultimodalStudioPalette.GRAPE_500
            : Colors.transparent,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: const TextStyle(fontSize: 11),
      ),
      child: Text(label),
    );
  }

  Widget _linkBanner() {
    return Container(
      color: MultimodalStudioPalette.GRAPE_0,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              viewModel.linkPrompt,
              style: const TextStyle(
                color: MultimodalStudioPalette.GRAPE_400,
                fontSize: 11,
              ),
            ),
          ),
          TextButton(
            onPressed: viewModel.didTapCancelLinkMode,
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  Widget _laneMenu() {
    const lanes = [
      'stt',
      'audio_manual',
      'object',
      'pose_object',
      'saved_attachment',
      'relation',
    ];
    return Positioned(
      left: 120,
      top: 72,
      child: Material(
        elevation: 6,
        color: MultimodalStudioPalette.SAND_0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final lane in lanes)
                InkWell(
                  onTap: () => viewModel.didTapToggleLaneKey(lane),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          viewModel.isLaneVisible(lane)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 16,
                          color: MultimodalStudioPalette.SAND_700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lane,
                          style: const TextStyle(
                            color: MultimodalStudioPalette.SAND_900,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _objects(List<_TimelineRow> rows) {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.SAND_200,
        border: Border(
          right: BorderSide(color: MultimodalStudioPalette.SAND_300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 22,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Objects & Tags',
                  style: TextStyle(
                    color: MultimodalStudioPalette.SAND_600,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
          for (final row in rows) _objectRow(row),
        ],
      ),
    );
  }

  Widget _objectRow(_TimelineRow row) {
    final clip = _rowSelection(row);
    final isSelected = row.clips.any(_isClipSelected);
    final identity = row.clips.length == 1 ? row.clips.first.clipId : '';
    return GestureDetector(
      onTap: () => _selectClip(clip),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: isSelected ? MultimodalStudioPalette.GRAPE_100 : null,
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: clip.background,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: clip.border == Colors.transparent
                      ? clip.foreground
                      : clip.border,
                ),
              ),
            ),
            if (row.showsAiBadge)
              Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: MultimodalStudioPalette.GRAPE_0,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'AI',
                  style: TextStyle(
                    color: MultimodalStudioPalette.GRAPE_700,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Expanded(
              child: Text(
                row.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: row.labelColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (identity.isNotEmpty)
              Text(
                identity,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: MultimodalStudioPalette.SAND_600,
                  fontSize: 9,
                ),
              ),
          ],
        ),
      ),
    );
  }

  _TimelineClip _rowSelection(_TimelineRow row) {
    for (final clip in row.clips) {
      if (_isClipSelected(clip)) {
        return clip;
      }
    }
    return row.clips.first;
  }

  Widget _header() {
    final label = viewModel.selectedAudioLabel;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 2, 10, 2),
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.SAND_0,
        border: Border(
          bottom: BorderSide(color: MultimodalStudioPalette.SAND_200),
        ),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: viewModel.didTapTogglePlayback,
            child: Text(viewModel.isVideoPlaying ? '일시정지' : '재생'),
          ),
          const SizedBox(width: 8),
          Text(
            '${viewModel.playheadLabel} | ${viewModel.spanLabel}',
            style: const TextStyle(
              color: MultimodalStudioPalette.SAND_700,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          if (label.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxWidth: 240),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              decoration: BoxDecoration(
                color: MultimodalStudioPalette.GRAPE_0,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: MultimodalStudioPalette.GRAPE_700,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _hint() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      color: MultimodalStudioPalette.CANTELOUPE_0,
      child: Text(
        viewModel.timelineHint,
        style: const TextStyle(
          color: MultimodalStudioPalette.CANTELOUPE_700,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _tracks(List<_TimelineRow> rows) {
    final width = viewModel.trackWidth;
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            Column(
              children: [
                _ruler(width),
                for (final row in rows) _track(row, width),
              ],
            ),
            Positioned(
              left: viewModel.playheadSeconds * viewModel.pixelsPerSecond,
              top: 0,
              bottom: 0,
              child: const IgnorePointer(
                child: SizedBox(
                  width: 2,
                  child: ColoredBox(color: MultimodalStudioPalette.DANGER),
                ),
              ),
            ),
            for (final marker in viewModel.markerSeconds)
              Positioned(
                left: marker * viewModel.pixelsPerSecond,
                top: 0,
                child: GestureDetector(
                  onTap: () => viewModel.didTapMarker(marker),
                  child: const Icon(
                    Icons.bookmark,
                    size: 16,
                    color: MultimodalStudioPalette.CANTELOUPE_400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _ruler(double width) {
    final span = viewModel.spanSeconds;
    final step = span > 60
        ? 10
        : span > 20
        ? 5
        : 2;
    final ticks = <Widget>[];
    for (var second = 0; second <= span; second += step) {
      ticks.add(
        Positioned(
          left: second * viewModel.pixelsPerSecond,
          top: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.only(left: 4),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: MultimodalStudioPalette.SAND_200),
              ),
            ),
            child: Text(
              _tickLabel(second),
              style: const TextStyle(
                color: MultimodalStudioPalette.SAND_600,
                fontSize: 10,
                height: 2.2,
              ),
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) =>
          viewModel.didSeekToSeconds(_secondsAt(details.localPosition.dx)),
      child: Container(
        height: 22,
        width: width,
        color: MultimodalStudioPalette.SAND_0,
        child: Stack(children: ticks),
      ),
    );
  }

  Widget _track(_TimelineRow row, double width) {
    final interactive = row.laneKey == 'audio_manual';
    final track = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: interactive
          ? null
          : (details) => viewModel.didSeekToSeconds(
              _secondsAt(details.localPosition.dx),
            ),
      onHorizontalDragStart: interactive
          ? (details) {
              final seconds = _secondsAt(details.localPosition.dx);
              setState(() {
                _draftStart = seconds;
                _draftEnd = seconds;
              });
            }
          : null,
      onHorizontalDragUpdate: interactive
          ? (details) =>
                setState(() => _draftEnd = _secondsAt(details.localPosition.dx))
          : null,
      onHorizontalDragEnd: interactive
          ? (_) {
              viewModel.didAddManualClip(_draftStart, _draftEnd);
              setState(() {
                _draftStart = -1;
                _draftEnd = -1;
              });
            }
          : null,
      child: Container(
        height: 28,
        width: width,
        color: MultimodalStudioPalette.SAND_0,
        child: Stack(
          children: [
            for (final clip in row.clips) _clip(clip, row),
            if (row.laneKey == 'pose_object')
              for (final clip in row.clips) ..._poseDots(clip),
            if (interactive && _draftStart >= 0) _draftClip(),
          ],
        ),
      ),
    );
    if (row.laneKey != 'saved_attachment') {
      return track;
    }
    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        final data = details.data;
        if (data.startsWith('media:')) {
          viewModel.didRejectMediaDrop();
          return;
        }
        final name = data.startsWith('file:') ? data.substring(5) : data;
        viewModel.didDropSavedAttachment(name, viewModel.playheadSeconds);
      },
      builder: (context, candidate, rejected) {
        return ColoredBox(
          color: candidate.isEmpty
              ? Colors.transparent
              : MultimodalStudioPalette.GRAPE_100,
          child: track,
        );
      },
    );
  }

  Widget _clip(_TimelineClip clip, _TimelineRow row) {
    final left = clip.startSeconds * viewModel.pixelsPerSecond;
    var width =
        (clip.endSeconds - clip.startSeconds) * viewModel.pixelsPerSecond;
    final minimum = row.laneKey == 'relation'
        ? VideoMultimodalViewModel.MIN_RELATION_CLIP_WIDTH
        : VideoMultimodalViewModel.MIN_CLIP_WIDTH;
    if (width < minimum) {
      width = minimum;
    }
    final selected = _isClipSelected(clip);
    final canResize =
        selected &&
        clip.clipId.isNotEmpty &&
        (row.laneKey == 'stt' || row.laneKey == 'audio_manual');
    return Positioned(
      left: left,
      top: 4,
      width: width,
      height: 20,
      child: GestureDetector(
        onTap: () => _selectClip(clip),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: clip.background,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: selected ? MultimodalStudioPalette.GRAPE_500 : clip.border,
              width: row.laneKey == 'relation' ? 2 : 1,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: MultimodalStudioPalette.GRAPE_500,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  clip.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: clip.foreground,
                    fontSize: 11,
                    height: 1.6,
                  ),
                ),
              ),
              if (canResize) ...[
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 6,
                  child: _resizeHandle(clip, isStart: true),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 6,
                  child: _resizeHandle(clip, isStart: false),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _resizeHandle(_TimelineClip clip, {required bool isStart}) {
    return GestureDetector(
      onHorizontalDragStart: (_) {
        _resizeStart = clip.startSeconds;
        _resizeEnd = clip.endSeconds;
      },
      onHorizontalDragUpdate: (details) {
        final delta = details.delta.dx / viewModel.pixelsPerSecond;
        if (isStart) {
          _resizeStart += delta;
        } else {
          _resizeEnd += delta;
        }
        viewModel.didResizeClip(clip.clipId, _resizeStart, _resizeEnd);
      },
      child: const MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: ColoredBox(color: Color(0x66FFFFFF)),
      ),
    );
  }

  List<Widget> _poseDots(_TimelineClip clip) {
    const fractions = [0.1, 0.35, 0.6, 0.85];
    final left = clip.startSeconds * viewModel.pixelsPerSecond;
    final width =
        (clip.endSeconds - clip.startSeconds) * viewModel.pixelsPerSecond;
    return [
      for (final fraction in fractions)
        Positioned(
          left: left + width * fraction,
          top: 8,
          child: GestureDetector(
            onTap: () => viewModel.didSeekToSeconds(
              clip.startSeconds +
                  (clip.endSeconds - clip.startSeconds) * fraction,
            ),
            child: const SizedBox(
              width: 6,
              height: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: MultimodalStudioPalette.GRAPE_400,
                ),
              ),
            ),
          ),
        ),
    ];
  }

  void _selectClip(_TimelineClip clip) {
    if (clip.clipId.isNotEmpty && viewModel.didTapClipForLink(clip.clipId)) {
      viewModel.didSeekToSeconds(clip.startSeconds);
      return;
    }
    if (clip.attachmentId.isNotEmpty) {
      viewModel.didTapBar(clip.attachmentId);
      return;
    }
    viewModel.didSelectSampleClip(clip.clipId);
  }

  bool _isClipSelected(_TimelineClip clip) {
    if (clip.clipId.isNotEmpty) {
      return clip.clipId == viewModel.selectedClipId;
    }
    return clip.attachmentId.isNotEmpty &&
        clip.attachmentId == (viewModel.selectedBar?.attachmentId ?? '');
  }

  Widget _draftClip() {
    final start = _draftStart < _draftEnd ? _draftStart : _draftEnd;
    final end = _draftStart < _draftEnd ? _draftEnd : _draftStart;
    return Positioned(
      left: start * viewModel.pixelsPerSecond,
      top: 4,
      width: ((end - start) * viewModel.pixelsPerSecond).clamp(
        2,
        viewModel.trackWidth,
      ),
      height: 20,
      child: const DecoratedBox(
        decoration: BoxDecoration(color: MultimodalStudioPalette.GRAPE_100),
      ),
    );
  }

  String _tickLabel(int second) {
    final minutes = second ~/ 60;
    final remain = second % 60;
    return '$minutes:${remain.toString().padLeft(2, '0')}';
  }

  List<_TimelineRow> _rows() {
    final rows = <_TimelineRow>[];
    final videos = [
      for (final bar in viewModel.visibleBars)
        if (bar.isVideo) bar,
    ];
    final audios = [
      for (final bar in viewModel.visibleBars)
        if (!bar.isVideo) bar,
    ];
    if (videos.isNotEmpty && viewModel.isLaneVisible('video')) {
      rows.add(
        _TimelineRow(
          laneKey: 'video',
          label: '영상',
          labelColor: MultimodalStudioPalette.SAND_700,
          showsAiBadge: false,
          clips: [
            for (final bar in videos)
              _TimelineClip(
                clipId: '',
                attachmentId: bar.attachmentId,
                text: bar.fileName,
                startSeconds: bar.startSeconds,
                endSeconds: bar.endSeconds,
                background: MultimodalStudioPalette.GRAPE_100,
                foreground: MultimodalStudioPalette.GRAPE_400,
                border: Colors.transparent,
              ),
          ],
        ),
      );
    }
    if (audios.isNotEmpty && viewModel.isLaneVisible('audio')) {
      rows.add(
        _TimelineRow(
          laneKey: 'audio',
          label: '오디오',
          labelColor: MultimodalStudioPalette.PLUM_500,
          showsAiBadge: false,
          clips: [
            for (final bar in audios)
              _TimelineClip(
                clipId: '',
                attachmentId: bar.attachmentId,
                text: bar.fileName,
                startSeconds: bar.startSeconds,
                endSeconds: bar.endSeconds,
                background: MultimodalStudioPalette.KALE_0,
                foreground: MultimodalStudioPalette.KALE_300,
                border: Colors.transparent,
              ),
          ],
        ),
      );
    }
    const order = [
      'stt',
      'audio_manual',
      'object',
      'pose_object',
      'saved_attachment',
      'relation',
    ];
    for (final laneKey in order) {
      final clips = [
        for (final clip in viewModel.sampleClips)
          if (clip.laneKey == laneKey) clip,
      ];
      if (clips.isEmpty || !viewModel.isLaneVisible(laneKey)) {
        continue;
      }
      final first = clips.first;
      rows.add(
        _TimelineRow(
          laneKey: laneKey,
          label: first.laneLabel,
          labelColor: _labelColor(laneKey),
          showsAiBadge: first.showsAiBadge,
          clips: [
            for (final clip in clips)
              _TimelineClip(
                clipId: clip.clipId,
                attachmentId: '',
                text: clip.text,
                startSeconds: clip.startSeconds,
                endSeconds: clip.endSeconds,
                background: _background(laneKey),
                foreground: _foreground(laneKey),
                border: clip.isDashed
                    ? _foreground(laneKey)
                    : Colors.transparent,
              ),
          ],
        ),
      );
    }
    return rows;
  }

  Color _labelColor(String laneKey) {
    switch (laneKey) {
      case 'object':
      case 'audio_manual':
        return MultimodalStudioPalette.PLUM_500;
      case 'pose_object':
      case 'stt':
        return MultimodalStudioPalette.GRAPE_700;
      default:
        return MultimodalStudioPalette.SAND_700;
    }
  }

  Color _background(String laneKey) {
    switch (laneKey) {
      case 'stt':
        return MultimodalStudioPalette.KALE_0;
      case 'audio_manual':
        return MultimodalStudioPalette.GRAPE_0;
      case 'object':
        return MultimodalStudioPalette.PLUM_100;
      case 'pose_object':
        return MultimodalStudioPalette.GRAPE_0;
      case 'saved_attachment':
        return MultimodalStudioPalette.PERSIMMON_0;
      case 'relation':
        return const Color(0xFF3A2438);
      default:
        return MultimodalStudioPalette.SAND_200;
    }
  }

  Color _foreground(String laneKey) {
    switch (laneKey) {
      case 'stt':
        return MultimodalStudioPalette.KALE_300;
      case 'audio_manual':
      case 'pose_object':
        return MultimodalStudioPalette.GRAPE_700;
      case 'object':
        return MultimodalStudioPalette.PLUM_400;
      case 'saved_attachment':
        return MultimodalStudioPalette.PERSIMMON_300;
      case 'relation':
        return MultimodalStudioPalette.PLUM_400;
      default:
        return MultimodalStudioPalette.SAND_900;
    }
  }
}

class _TimelineRow {
  const _TimelineRow({
    required this.laneKey,
    required this.label,
    required this.labelColor,
    required this.showsAiBadge,
    required this.clips,
  });

  final String laneKey;
  final String label;
  final Color labelColor;
  final bool showsAiBadge;
  final List<_TimelineClip> clips;
}

class _TimelineClip {
  const _TimelineClip({
    required this.clipId,
    required this.attachmentId,
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
    required this.background,
    required this.foreground,
    required this.border,
  });

  final String clipId;
  final String attachmentId;
  final String text;
  final double startSeconds;
  final double endSeconds;
  final Color background;
  final Color foreground;
  final Color border;
}
