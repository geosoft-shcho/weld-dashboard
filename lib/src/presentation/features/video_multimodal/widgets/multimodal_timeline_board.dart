import 'package:flutter/gestures.dart';
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
  double _trackedPlayhead = -1;
  double _trackedPixels = -1;
  double _draftStart = -1;
  double _draftEnd = -1;
  _ClipEdit? _edit;

  VideoMultimodalViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _trackedPlayhead = widget.viewModel.playheadSeconds;
    _trackedPixels = widget.viewModel.pixelsPerSecond;
  }

  @override
  void didUpdateWidget(covariant MultimodalTimelineBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final headMoved = _trackedPlayhead != viewModel.playheadSeconds;
    final zoomChanged = _trackedPixels != viewModel.pixelsPerSecond;
    _trackedPlayhead = viewModel.playheadSeconds;
    _trackedPixels = viewModel.pixelsPerSecond;
    if (!headMoved && !zoomChanged) {
      return;
    }
    if (!viewModel.isVideoPlaying && !zoomChanged) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _followPlayhead(pinHead: zoomChanged),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _followPlayhead({bool pinHead = false}) {
    if (!_scrollController.hasClients) {
      return;
    }
    final now = DateTime.now();
    if (!pinHead && now.difference(_lastAutoScrollAt).inMilliseconds < 80) {
      return;
    }
    final position = _scrollController.position;
    final head = viewModel.playheadSeconds * viewModel.pixelsPerSecond;
    const margin = 48.0;
    final viewLeft = position.pixels;
    final viewRight = viewLeft + position.viewportDimension;
    if (!pinHead && head >= viewLeft + margin && head <= viewRight - margin) {
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
          _toolbar(),
          if (viewModel.isLinkMode) _linkBanner(),
          _header(),
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
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.SAND_0,
        border: Border(
          bottom: BorderSide(color: MultimodalStudioPalette.SAND_300),
        ),
      ),
      child: Row(
        children: [
          _toolGroup([
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
          ]),
          const SizedBox(width: 8),
          _toolGroup([
            _tool('−', onPressed: viewModel.didTapZoomOut),
            _tool('+', onPressed: viewModel.didTapZoomIn),
          ]),
          const Spacer(),
          _toolGroup([
            _tool(
              'Lanes',
              selected: viewModel.isLaneMenuOpen,
              onPressed: viewModel.didTapToggleLaneMenu,
            ),
            _tool(
              '👁',
              selected: viewModel.areAuxiliaryRowsHidden,
              onPressed: viewModel.didTapToggleAuxiliaryRows,
            ),
            _tool('Marker', onPressed: viewModel.didTapAddMarker),
            _tool('Labels', onPressed: viewModel.didTapToggleLabels),
          ], isLast: true),
        ],
      ),
    );
  }

  Widget _toolGroup(List<Widget> children, {bool isLast = false}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                right: BorderSide(color: MultimodalStudioPalette.SAND_300),
              ),
      ),
      child: Padding(
        padding: EdgeInsets.only(right: isLast ? 0 : 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) const SizedBox(width: 2),
              children[index],
            ],
          ],
        ),
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
            ? MultimodalStudioPalette.GRAPE_500
            : MultimodalStudioPalette.SAND_900,
        backgroundColor: selected
            ? MultimodalStudioPalette.GRAPE_100
            : Colors.transparent,
        disabledForegroundColor: MultimodalStudioPalette.SAND_600,
        side: BorderSide(
          color: selected
              ? MultimodalStudioPalette.GRAPE_500
              : MultimodalStudioPalette.SAND_300,
        ),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontSize: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
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
      right: 12,
      top: 36,
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
                    fontSize: 11,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.SAND_0,
        border: Border(
          bottom: BorderSide(color: MultimodalStudioPalette.SAND_300),
        ),
      ),
      child: Row(
        children: [
          _tool(
            viewModel.isVideoPlaying ? '❚❚' : '▶',
            onPressed: viewModel.didTapTogglePlayback,
          ),
          const SizedBox(width: 8),
          Text(
            '${viewModel.playheadLabel} | ${viewModel.spanLabel}',
            style: const TextStyle(
              color: MultimodalStudioPalette.GRAPE_500,
              fontSize: 11,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const Spacer(),
          const Text(
            '속성 · ',
            style: TextStyle(
              color: MultimodalStudioPalette.SAND_600,
              fontSize: 11,
            ),
          ),
          _tool('툴바에서 열기', onPressed: viewModel.didTapToggleProperties),
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
    return Listener(
      onPointerSignal: (event) {
        if (event is! PointerScrollEvent) {
          return;
        }
        if (event.scrollDelta.dy.abs() <= event.scrollDelta.dx.abs()) {
          return;
        }
        GestureBinding.instance.pointerSignalResolver.register(event, (
          resolved,
        ) {
          if (resolved is! PointerScrollEvent) {
            return;
          }
          if (resolved.scrollDelta.dy > 0) {
            viewModel.didTapZoomOut();
          } else if (resolved.scrollDelta.dy < 0) {
            viewModel.didTapZoomIn();
          }
        });
      },
      child: SingleChildScrollView(
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
      ),
    );
  }

  Widget _ruler(double width) {
    final span = viewModel.spanSeconds;
    final step = span > 60
        ? 10.0
        : span > 20
        ? 5.0
        : 2.0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) =>
          viewModel.didSeekToSeconds(_secondsAt(details.localPosition.dx)),
      child: CustomPaint(
        size: Size(width, 22),
        painter: _RulerPainter(
          spanSeconds: span,
          pixelsPerSecond: viewModel.pixelsPerSecond,
          stepSeconds: step,
        ),
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
    final range = _shownRange(clip);
    final left = range.startSeconds * viewModel.pixelsPerSecond;
    var width =
        (range.endSeconds - range.startSeconds) * viewModel.pixelsPerSecond;
    final minimum = row.laneKey == 'relation'
        ? VideoMultimodalViewModel.MIN_RELATION_CLIP_WIDTH
        : VideoMultimodalViewModel.MIN_CLIP_WIDTH;
    if (width < minimum) {
      width = minimum;
    }
    final selected = _isClipSelected(clip);
    final canEdit =
        clip.clipId.isNotEmpty &&
        (row.laneKey == 'stt' || row.laneKey == 'audio_manual');
    return Positioned(
      left: left,
      top: 4,
      width: width,
      height: 20,
      child: GestureDetector(
        onTap: () => _selectClip(clip),
        onHorizontalDragStart: canEdit ? (_) => _beginEdit(clip) : null,
        onHorizontalDragUpdate: canEdit
            ? (details) => _moveEdit(
                clip.clipId,
                details.delta.dx / viewModel.pixelsPerSecond,
              )
            : null,
        onHorizontalDragEnd: canEdit ? (_) => _commitEdit() : null,
        onHorizontalDragCancel: canEdit ? () => _clearEdit() : null,
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
              if (canEdit && selected) ...[
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 6,
                  child: _resizeHandle(clip, isLeading: true),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 6,
                  child: _resizeHandle(clip, isLeading: false),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _resizeHandle(_TimelineClip clip, {required bool isLeading}) {
    return GestureDetector(
      onHorizontalDragStart: (_) => _beginEdit(clip),
      onHorizontalDragUpdate: (details) => _resizeEdit(
        clip.clipId,
        details.delta.dx / viewModel.pixelsPerSecond,
        isLeading: isLeading,
      ),
      onHorizontalDragEnd: (_) => _commitEdit(),
      onHorizontalDragCancel: _clearEdit,
      child: const MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: ColoredBox(color: Color(0x66FFFFFF)),
      ),
    );
  }

  _ClipEdit _shownRange(_TimelineClip clip) {
    final edit = _edit;
    if (edit != null && edit.clipId == clip.clipId) {
      return edit;
    }
    return _ClipEdit(
      clipId: clip.clipId,
      startSeconds: clip.startSeconds,
      endSeconds: clip.endSeconds,
    );
  }

  void _beginEdit(_TimelineClip clip) {
    setState(() {
      _edit = _ClipEdit(
        clipId: clip.clipId,
        startSeconds: clip.startSeconds,
        endSeconds: clip.endSeconds,
      );
    });
  }

  void _moveEdit(String clipId, double deltaSeconds) {
    final edit = _edit;
    if (edit == null || edit.clipId != clipId) {
      return;
    }
    setState(() => _edit = edit.move(deltaSeconds, viewModel.spanSeconds));
  }

  void _resizeEdit(
    String clipId,
    double deltaSeconds, {
    required bool isLeading,
  }) {
    final edit = _edit;
    if (edit == null || edit.clipId != clipId) {
      return;
    }
    setState(
      () => _edit = isLeading
          ? edit.resizeLeading(deltaSeconds)
          : edit.resizeTrailing(deltaSeconds, viewModel.spanSeconds),
    );
  }

  void _commitEdit() {
    final edit = _edit;
    if (edit == null) {
      return;
    }
    viewModel.didCommitClipRange(
      edit.clipId,
      edit.startSeconds,
      edit.endSeconds,
    );
    setState(() => _edit = null);
  }

  void _clearEdit() {
    setState(() => _edit = null);
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

class _ClipEdit {
  const _ClipEdit({
    required this.clipId,
    required this.startSeconds,
    required this.endSeconds,
  });

  final String clipId;
  final double startSeconds;
  final double endSeconds;

  double get length => endSeconds - startSeconds;

  _ClipEdit move(double deltaSeconds, double span) {
    final duration = length;
    var start = startSeconds + deltaSeconds;
    if (start < 0) {
      start = 0;
    }
    if (start + duration > span) {
      start = (span - duration).clamp(0.0, span).toDouble();
    }
    return _ClipEdit(
      clipId: clipId,
      startSeconds: start,
      endSeconds: start + duration,
    );
  }

  _ClipEdit resizeLeading(double deltaSeconds) {
    final next = (startSeconds + deltaSeconds).clamp(
      0.0,
      endSeconds - VideoMultimodalViewModel.MIN_REGION_SECONDS,
    );
    return _ClipEdit(
      clipId: clipId,
      startSeconds: next.toDouble(),
      endSeconds: endSeconds,
    );
  }

  _ClipEdit resizeTrailing(double deltaSeconds, double span) {
    final next = (endSeconds + deltaSeconds).clamp(
      startSeconds + VideoMultimodalViewModel.MIN_REGION_SECONDS,
      span,
    );
    return _ClipEdit(
      clipId: clipId,
      startSeconds: startSeconds,
      endSeconds: next.toDouble(),
    );
  }
}

class _RulerPainter extends CustomPainter {
  const _RulerPainter({
    required this.spanSeconds,
    required this.pixelsPerSecond,
    required this.stepSeconds,
  });

  final double spanSeconds;
  final double pixelsPerSecond;
  final double stepSeconds;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = MultimodalStudioPalette.SAND_0,
    );
    final line = Paint()
      ..color = MultimodalStudioPalette.SAND_200
      ..strokeWidth = 1;
    final steps = stepSeconds <= 0 ? 0 : (spanSeconds / stepSeconds).floor();
    for (var index = 0; index <= steps; index++) {
      final second = index * stepSeconds;
      final x = second * pixelsPerSecond;
      canvas.drawLine(Offset(x, 12), Offset(x, size.height), line);
      final total = second.round();
      final label = '${total ~/ 60}:${(total % 60).toString().padLeft(2, '0')}';
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: MultimodalStudioPalette.SAND_600,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(x + 3, 0));
      painter.dispose();
    }
  }

  @override
  bool shouldRepaint(covariant _RulerPainter oldDelegate) {
    return oldDelegate.spanSeconds != spanSeconds ||
        oldDelegate.pixelsPerSecond != pixelsPerSecond ||
        oldDelegate.stepSeconds != stepSeconds;
  }
}
