import 'dart:ui' show FontFeature, PointerDeviceKind;

import 'package:flutter/material.dart';

import '../../work_detail/widgets/work_detail_material_scope.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_dialogs.dart';
import 'multimodal_studio_palette.dart';
import 'pose_board_mark_layer.dart';
import 'timeline_board_clip_bar.dart';
import 'timeline_board_helpers.dart';
import 'timeline_board_toolbar.dart';
import 'timeline_board_track_labels.dart';
import 'timeline_board_track_tools.dart';

class MultimodalTimelineBoard extends StatefulWidget {
  const MultimodalTimelineBoard({
    super.key,
    required this.viewModel,
    required this.maxHeight,
  });

  final VideoMultimodalViewModel viewModel;
  final double maxHeight;

  @override
  State<MultimodalTimelineBoard> createState() =>
      _MultimodalTimelineBoardState();
}

class _MultimodalTimelineBoardState extends State<MultimodalTimelineBoard> {
  static const double _RULER_HEIGHT = 22;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _trackLabelScrollController = ScrollController();
  final ScrollController _trackScrollController = ScrollController();
  DateTime _lastAutoScrollAt = DateTime.fromMillisecondsSinceEpoch(0);
  double _trackedPlayhead = -1;
  String _trackedClipId = '';
  TimelineClipEdit? _edit;
  bool _isRulerDragging = false;
  int? _rulerPointer;
  bool _rulerDidPan = false;
  double _rulerDragDistance = 0;

  VideoMultimodalViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _trackedPlayhead = widget.viewModel.playheadSeconds;
    _trackedClipId = widget.viewModel.selectedClipId;
    _trackLabelScrollController.addListener(_syncTrackRowsFromLabels);
    _trackScrollController.addListener(_syncTrackLabelsFromRows);
  }

  @override
  void didUpdateWidget(covariant MultimodalTimelineBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final headMoved = _trackedPlayhead != viewModel.playheadSeconds;
    _trackedPlayhead = viewModel.playheadSeconds;
    final clipChanged = _trackedClipId != viewModel.selectedClipId;
    _trackedClipId = viewModel.selectedClipId;
    if (clipChanged && viewModel.selectedClipId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _revealSelectedTrackLabel();
        }
      });
    }
    if (!headMoved || !viewModel.isVideoPlaying) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _followPlayhead());
  }

  @override
  void dispose() {
    _trackLabelScrollController.removeListener(_syncTrackRowsFromLabels);
    _trackScrollController.removeListener(_syncTrackLabelsFromRows);
    _scrollController.dispose();
    _trackLabelScrollController.dispose();
    _trackScrollController.dispose();
    super.dispose();
  }

  bool _isSyncingRowScroll = false;

  void _syncTrackRowsFromLabels() {
    _alignRowScroll(_trackLabelScrollController, _trackScrollController);
  }

  void _syncTrackLabelsFromRows() {
    _alignRowScroll(_trackScrollController, _trackLabelScrollController);
  }

  void _alignRowScroll(ScrollController source, ScrollController target) {
    if (_isSyncingRowScroll || !source.hasClients || !target.hasClients) {
      return;
    }
    if (!source.position.hasContentDimensions ||
        !target.position.hasContentDimensions) {
      return;
    }
    final offset = source.offset.clamp(0.0, target.position.maxScrollExtent);
    if ((target.offset - offset).abs() < 0.5) {
      return;
    }
    _isSyncingRowScroll = true;
    target.jumpTo(offset);
    _isSyncingRowScroll = false;
  }

  Future<void> _confirmDeleteSelection() async {
    if (viewModel.isSelectedServerClip) {
      final didConfirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return WorkDetailMaterialScope(
            child: AlertDialog(
              content: const Text('이 클립을 삭제할까요?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        },
      );
      if (didConfirm != true || !mounted) {
        return;
      }
    }
    await viewModel.didTapDeleteSelection();
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

  void _revealSelectedTrackLabel() {
    if (!_trackLabelScrollController.hasClients) {
      return;
    }
    final rows = buildTimelineBoardRows(viewModel);
    final rowIndex = rows.indexWhere(
      (row) => row.clips.any((clip) => clip.clipId == viewModel.selectedClipId),
    );
    if (rowIndex < 0) {
      return;
    }
    var rowTop = 0.0;
    for (var index = 0; index < rowIndex; index++) {
      rowTop += rows[index].height;
    }
    final position = _trackLabelScrollController.position;
    final offset = revealOffsetForPlacedRow(
      rowTop: rowTop,
      rowExtent: rows[rowIndex].height,
      pixels: position.pixels,
      viewport: position.viewportDimension,
      maxScrollExtent: position.maxScrollExtent,
    );
    if (offset == null) {
      return;
    }
    _trackLabelScrollController.jumpTo(offset);
  }

  double _secondsInBox(BuildContext dropContext, Offset global) {
    final box = dropContext.findRenderObject();
    if (box is! RenderBox) {
      return viewModel.playheadSeconds;
    }
    final local = box.globalToLocal(global);
    return (local.dx / viewModel.pixelsPerSecond)
        .clamp(0.0, viewModel.spanSeconds)
        .toDouble();
  }

  double _secondsAt(double localDx) {
    // 룰러와 트랙의 로컬 좌표에는 이미 가로 스크롤이 반영되어 있다.
    final seconds = localDx / viewModel.pixelsPerSecond;
    return seconds.clamp(0, viewModel.spanSeconds);
  }

  @override
  Widget build(BuildContext context) {
    final rows = buildTimelineBoardRows(viewModel);
    final height = viewModel.timelineBoardHeight.clamp(
      VideoMultimodalViewModel.MIN_TIMELINE_HEIGHT,
      widget.maxHeight,
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 12),
      decoration: BoxDecoration(
        color: MultimodalStudioPalette.SAND_100,
        border: Border.all(color: MultimodalStudioPalette.SAND_300),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      height: height,
      child: Stack(
        children: [
          _filled(rows),
          if (viewModel.isTrackMenuOpen)
            TimelineBoardTrackMenu(viewModel: viewModel, boardHeight: height),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 6,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (details) {
                viewModel.didDragTimelineBoardHeight(
                  details.delta.dy,
                  maxHeight: widget.maxHeight,
                );
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeRow,
                child: ColoredBox(color: Color(0x00000000)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filled(List<TimelineBoardRow> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TimelineBoardToolbar(
          viewModel: viewModel,
          onConfirmDeleteSelection: _confirmDeleteSelection,
        ),
        _header(),
        if (viewModel.hasTimelineHint) _hint(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _trackLabels(rows),
              Expanded(child: _tracks(rows)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _trackLabels(List<TimelineBoardRow> rows) {
    return TimelineBoardTrackLabels(
      viewModel: viewModel,
      rows: rows,
      scrollController: _trackLabelScrollController,
      onSelectClip: _selectClip,
    );
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
          TimelineBoardToolButton(
            viewModel.isVideoPlaying ? '❚❚' : '▶',
            onPressed: viewModel.didTapTogglePlayback,
          ),
          const SizedBox(width: 8),
          TimelineBoardToolButton(
            viewModel.timelinePlaybackRateLabel,
            onPressed: viewModel.didTapCycleTimelinePlaybackRate,
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

  void _seekRulerAtContentX(double contentX) {
    final rawSeconds = contentX / viewModel.pixelsPerSecond;
    final seconds = rawSeconds.clamp(0.0, viewModel.spanSeconds);
    viewModel.didSeekToSeconds(seconds);
  }

  void _panRulerBy(double deltaDx) {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    final next = (_scrollController.offset - deltaDx).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((next - _scrollController.offset).abs() < 0.01) {
      return;
    }
    _scrollController.jumpTo(next);
  }

  void _onRulerPointerDown(PointerDownEvent event) {
    _rulerPointer = event.pointer;
    _rulerDidPan = false;
    _rulerDragDistance = 0;
    setState(() => _isRulerDragging = true);
  }

  void _onRulerPointerMove(PointerMoveEvent event) {
    if (_rulerPointer != event.pointer) {
      return;
    }
    _rulerDragDistance += event.delta.dx.abs();
    if (_rulerDragDistance < 2 && !_rulerDidPan) {
      return;
    }
    final before = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;
    _panRulerBy(event.delta.dx);
    final after = _scrollController.hasClients ? _scrollController.offset : 0.0;
    if ((after - before).abs() > 0.01) {
      _rulerDidPan = true;
    }
  }

  void _onRulerPointerUp(PointerUpEvent event) {
    if (_rulerPointer != event.pointer) {
      return;
    }
    if (!_rulerDidPan) {
      _seekRulerAtContentX(event.localPosition.dx);
    }
    _rulerPointer = null;
    _rulerDidPan = false;
    _rulerDragDistance = 0;
    setState(() => _isRulerDragging = false);
  }

  void _onRulerPointerCancel(PointerCancelEvent event) {
    if (_rulerPointer != event.pointer) {
      return;
    }
    _rulerPointer = null;
    _rulerDidPan = false;
    _rulerDragDistance = 0;
    setState(() => _isRulerDragging = false);
  }

  Widget _tracks(List<TimelineBoardRow> rows) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = viewModel.trackWidth > constraints.maxWidth
            ? viewModel.trackWidth
            : constraints.maxWidth;
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.trackpad},
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              height: constraints.maxHeight,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ruler(width),
                      Expanded(
                        child: SingleChildScrollView(
                          key: const Key('timeline-track-rows'),
                          controller: _trackScrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final row in rows) _track(row, width),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left:
                        viewModel.playheadSeconds * viewModel.pixelsPerSecond -
                        6,
                    top: 0,
                    bottom: 0,
                    width: 12,
                    child: const IgnorePointer(child: _PlayheadMarker()),
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
      },
    );
  }

  Widget _ruler(double width) {
    final span = viewModel.spanSeconds;
    return MouseRegion(
      cursor: _isRulerDragging
          ? SystemMouseCursors.grabbing
          : SystemMouseCursors.grab,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _onRulerPointerDown,
        onPointerMove: _onRulerPointerMove,
        onPointerUp: _onRulerPointerUp,
        onPointerCancel: _onRulerPointerCancel,
        child: CustomPaint(
          size: Size(width, _RULER_HEIGHT),
          painter: TimelineRulerPainter(
            spanSeconds: span,
            pixelsPerSecond: viewModel.pixelsPerSecond,
          ),
        ),
      ),
    );
  }

  Widget _track(TimelineBoardRow row, double width) {
    Widget content = Stack(
      children: [
        for (final clip in row.clips)
          TimelineBoardClipBar(
            viewModel: viewModel,
            clip: clip,
            row: row,
            edit: _edit,
            isSelected: _isClipSelected(clip),
            onTap: () => _selectClip(clip),
            onBeginEdit: _beginEdit,
            onMove: _moveEdit,
            onResize: _resizeEdit,
            onCommit: _commitEdit,
            onClear: _clearEdit,
          ),
        for (final clip in row.clips)
          if (clip.poseMarks.isNotEmpty)
            ...buildPoseBoardMarkWidgets(
              clip: clip,
              pixelsPerSecond: viewModel.pixelsPerSecond,
              seekHandler: viewModel.didSeekToSeconds,
            ),
      ],
    );
    if (!row.isEnabled) {
      content = IgnorePointer(child: Opacity(opacity: 0.4, child: content));
    }
    final track = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: row.isEnabled
          ? (details) =>
                viewModel.didSeekToSeconds(_secondsAt(details.localPosition.dx))
          : null,
      child: Container(
        height: row.height,
        width: width,
        color: MultimodalStudioPalette.SAND_0,
        child: content,
      ),
    );
    if (!viewModel.isServerTimelineTrack(row.trackId) || !row.isEnabled) {
      return track;
    }
    return Builder(
      builder: (dropContext) {
        return DragTarget<String>(
          onAcceptWithDetails: (details) {
            _acceptDroppedAsset(
              dragData: details.data,
              trackId: row.trackId,
              startSeconds: _secondsInBox(dropContext, details.offset),
            );
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
      },
    );
  }

  void _beginEdit(TimelineBoardClip clip) {
    setState(() {
      _edit = TimelineClipEdit(
        clipId: rangeIdOf(clip),
        isBar: clip.clipId.isEmpty,
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
    final limit = edit.isBar ? double.infinity : viewModel.spanSeconds;
    setState(() => _edit = edit.move(deltaSeconds, limit));
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
    final limit = edit.isBar ? double.infinity : viewModel.spanSeconds;
    setState(
      () => _edit = isLeading
          ? edit.resizeLeading(deltaSeconds)
          : edit.resizeTrailing(deltaSeconds, limit),
    );
  }

  void _commitEdit() {
    final edit = _edit;
    if (edit == null) {
      return;
    }
    if (edit.isBar) {
      viewModel.didCommitBarRange(
        edit.clipId,
        edit.startSeconds,
        edit.endSeconds,
      );
    } else {
      viewModel.didCommitClipRange(
        edit.clipId,
        edit.startSeconds,
        edit.endSeconds,
      );
    }
    setState(() => _edit = null);
  }

  void _clearEdit() {
    setState(() => _edit = null);
  }

  Future<void> _acceptDroppedAsset({
    required String dragData,
    required String trackId,
    required double startSeconds,
  }) async {
    await viewModel.didDropAsset(
      dragData: dragData,
      trackId: trackId,
      startSeconds: startSeconds,
    );
    await _showCreatedClipNotice();
  }

  Future<void> _showCreatedClipNotice() async {
    final notice = viewModel.takeCreatedClipNotice();
    if (notice == null || !mounted) {
      return;
    }
    await showMultimodalCreatedClipDialog(context, notice);
  }

  void _selectClip(TimelineBoardClip clip) {
    if (viewModel.isRelationMode && clip.clipId.isNotEmpty) {
      _selectClipForRelation(clip);
      return;
    }
    if (clip.attachmentId.isNotEmpty) {
      viewModel.didTapBar(clip.attachmentId);
      return;
    }
    viewModel.didSelectSampleClip(clip.clipId);
  }

  Future<void> _selectClipForRelation(TimelineBoardClip clip) async {
    await viewModel.didTapClipForRelation(clip.clipId);
    viewModel.didSeekToSeconds(clip.startSeconds);
    await _showCreatedClipNotice();
  }

  bool _isClipSelected(TimelineBoardClip clip) {
    if (clip.clipId.isNotEmpty) {
      return clip.clipId == viewModel.selectedClipId;
    }
    return clip.attachmentId.isNotEmpty &&
        clip.attachmentId == (viewModel.selectedBar?.attachmentId ?? '');
  }
}

/// 재생 위치 세로선 + 상단 역삼각형(수집 모니터링 NowMarker와 동일 형태).
class _PlayheadMarker extends StatelessWidget {
  const _PlayheadMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          size: const Size(12, 8),
          painter: const _PlayheadCaretPainter(
            color: MultimodalStudioPalette.DANGER,
          ),
        ),
        Expanded(
          child: Center(
            child: Container(width: 2, color: MultimodalStudioPalette.DANGER),
          ),
        ),
      ],
    );
  }
}

class _PlayheadCaretPainter extends CustomPainter {
  const _PlayheadCaretPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _PlayheadCaretPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
