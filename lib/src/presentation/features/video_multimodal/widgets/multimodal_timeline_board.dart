import 'package:flutter/material.dart';

import '../../../../domain/entities/job_timeline.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_studio_palette.dart';
import 'timeline_board_helpers.dart';

class MultimodalTimelineBoard extends StatefulWidget {
  const MultimodalTimelineBoard({super.key, required this.viewModel});

  final VideoMultimodalViewModel viewModel;

  @override
  State<MultimodalTimelineBoard> createState() =>
      _MultimodalTimelineBoardState();
}

class _MultimodalTimelineBoardState extends State<MultimodalTimelineBoard> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _objectScrollController = ScrollController();
  final ScrollController _trackScrollController = ScrollController();
  final TextEditingController _newTrackNameController = TextEditingController();
  final TextEditingController _trackNameController = TextEditingController();
  String _shownTrackId = '';
  DateTime _lastAutoScrollAt = DateTime.fromMillisecondsSinceEpoch(0);
  double _trackedPlayhead = -1;
  TimelineClipEdit? _edit;
  bool _isStatusChoicesOpen = false;

  VideoMultimodalViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _trackedPlayhead = widget.viewModel.playheadSeconds;
    _objectScrollController.addListener(_syncTrackRowsToObjects);
    _trackScrollController.addListener(_syncObjectRowsToTracks);
    _syncSelectedTrackName();
  }

  @override
  void didUpdateWidget(covariant MultimodalTimelineBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSelectedTrackName();
    final headMoved = _trackedPlayhead != viewModel.playheadSeconds;
    _trackedPlayhead = viewModel.playheadSeconds;
    if (!headMoved || !viewModel.isVideoPlaying) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _followPlayhead());
  }

  @override
  void dispose() {
    _objectScrollController.removeListener(_syncTrackRowsToObjects);
    _trackScrollController.removeListener(_syncObjectRowsToTracks);
    _newTrackNameController.dispose();
    _trackNameController.dispose();
    _scrollController.dispose();
    _objectScrollController.dispose();
    _trackScrollController.dispose();
    super.dispose();
  }

  bool _isSyncingRowScroll = false;

  void _syncTrackRowsToObjects() {
    _alignRowScroll(_objectScrollController, _trackScrollController);
  }

  void _syncObjectRowsToTracks() {
    _alignRowScroll(_trackScrollController, _objectScrollController);
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

  void _syncSelectedTrackName() {
    final track = viewModel.selectedServerTrack;
    final trackId = track?.trackId ?? '';
    if (trackId == _shownTrackId) {
      return;
    }
    _shownTrackId = trackId;
    _trackNameController.text = track?.name ?? '';
  }

  Future<void> _submitNewTrack() async {
    await viewModel.didSubmitNewTimelineTrack(_newTrackNameController.text);
    if (!mounted || viewModel.timelineHint.isNotEmpty) {
      return;
    }
    _newTrackNameController.clear();
  }

  Future<void> _confirmDeleteTrack() async {
    final didConfirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('이 트랙의 클립도 함께 지워집니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('지우기'),
            ),
          ],
        );
      },
    );
    if (didConfirm != true || !mounted) {
      return;
    }
    await viewModel.didTapDeleteSelectedTimelineTrack();
  }

  Future<void> _confirmDeleteSelection() async {
    if (viewModel.isSelectedServerClip) {
      final didConfirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('이 클립을 삭제할까요?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('확인'),
              ),
            ],
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
    final scrolled = _scrollController.hasClients
        ? _scrollController.offset
        : 0;
    final seconds = (scrolled + localDx) / viewModel.pixelsPerSecond;
    return seconds.clamp(0, viewModel.spanSeconds);
  }

  @override
  Widget build(BuildContext context) {
    final rows = buildTimelineBoardRows(viewModel);
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

  Widget _filled(List<TimelineBoardRow> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _toolbar(),
        _editTools(),
        if (viewModel.isRelationMode) _relationBanner(),
        _header(),
        if (viewModel.hasTimelineHint) _hint(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _objects(rows),
              Expanded(child: _tracks(rows)),
            ],
          ),
        ),
      ],
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
              '클립 선택',
              selected: !viewModel.isRelationMode,
              onPressed: viewModel.didTapSelectTool,
            ),
            _tool(
              '클립 관계',
              selected: viewModel.isRelationMode,
              onPressed: viewModel.didTapToggleRelationMode,
            ),
            _tool(
              '클립 삭제',
              onPressed: viewModel.canDeleteSelection
                  ? _confirmDeleteSelection
                  : null,
            ),
          ]),
          const Spacer(),
          _toolGroup([
            _tool(
              'Lanes',
              selected: viewModel.isLaneMenuOpen,
              onPressed: viewModel.didTapToggleLaneMenu,
            ),
            _tool('Marker', onPressed: viewModel.didTapAddMarker),
            _tool('Labels', onPressed: viewModel.didTapToggleLabels),
          ], isLast: true),
        ],
      ),
    );
  }

  Widget _editTools() {
    final canEditTrack = viewModel.canEditSelectedServerTrack;
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _trackNameField(
              key: const Key('new-timeline-track-name'),
              controller: _newTrackNameController,
              hint: '트랙 이름',
            ),
            _tool('트랙 추가', onPressed: _submitNewTrack),
            _trackNameField(
              key: const Key('selected-timeline-track-name'),
              controller: _trackNameController,
              hint: '선택한 트랙',
              enabled: canEditTrack,
            ),
            _tool(
              '트랙 수정',
              onPressed: canEditTrack
                  ? () => viewModel.didSubmitTimelineTrackName(
                      _trackNameController.text,
                    )
                  : null,
            ),
            Tooltip(
              message: '이 트랙의 클립도 함께 지워집니다.',
              child: _tool(
                '트랙 삭제',
                onPressed: canEditTrack ? _confirmDeleteTrack : null,
              ),
            ),
            _statusMenu(),
          ],
        ),
      ),
    );
  }

  Widget _trackNameField({
    required Key key,
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return SizedBox(
      width: 128,
      height: 28,
      child: TextField(
        key: key,
        controller: controller,
        enabled: enabled,
        style: const TextStyle(fontSize: 11),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 11,
            color: MultimodalStudioPalette.SAND_600,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 6,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _statusMenu() {
    final current = viewModel.timelineStatus;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _tool(
          '상태 ${_timelineStatusLabel(current)}',
          selected: _isStatusChoicesOpen,
          onPressed: () {
            setState(() => _isStatusChoicesOpen = !_isStatusChoicesOpen);
          },
        ),
        if (_isStatusChoicesOpen)
          for (final status in const [
            JobTimelineStatus.draft,
            JobTimelineStatus.suggested,
            JobTimelineStatus.confirmed,
            JobTimelineStatus.rejected,
          ])
            if (status != current)
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: _tool(
                  _timelineStatusLabel(status),
                  onPressed: () {
                    setState(() => _isStatusChoicesOpen = false);
                    viewModel.didChooseTimelineStatus(status);
                  },
                ),
              ),
      ],
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

  Widget _relationBanner() {
    return Container(
      color: MultimodalStudioPalette.GRAPE_0,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              viewModel.relationPrompt,
              style: const TextStyle(
                color: MultimodalStudioPalette.GRAPE_400,
                fontSize: 11,
              ),
            ),
          ),
          TextButton(
            onPressed: viewModel.didTapCancelRelationMode,
            child: const Text('취소', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _laneMenu() {
    final lanes = <({String key, String label})>[
      for (final track in viewModel.timelineTracks)
        (
          key: track.trackId,
          label: track.name.trim().isEmpty ? '트랙' : track.name.trim(),
        ),
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
                  onTap: () => viewModel.didTapToggleLaneKey(lane.key),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          viewModel.isLaneVisible(lane.key)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 16,
                          color: MultimodalStudioPalette.SAND_700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lane.label,
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

  Widget _objects(List<TimelineBoardRow> rows) {
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
          Expanded(
            child: SingleChildScrollView(
              key: const Key('timeline-object-rows'),
              controller: _objectScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (final row in rows) _objectRow(row)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _objectRow(TimelineBoardRow row) {
    if (row.clips.isEmpty) {
      return _objectLabel(
        row,
        swatch: MultimodalStudioPalette.SAND_200,
        border: MultimodalStudioPalette.SAND_900,
      );
    }
    final clip = _rowSelection(row);
    final isSelected = row.clips.any(_isClipSelected);
    final identity = row.clips.length == 1 ? row.clips.first.clipId : '';
    return GestureDetector(
      onTap: () => _selectClip(clip),
      child: _objectLabel(
        row,
        swatch: clip.background,
        border: clip.border == Colors.transparent
            ? clip.foreground
            : clip.border,
        isSelected: isSelected,
        identity: identity,
      ),
    );
  }

  Widget _objectLabel(
    TimelineBoardRow row, {
    required Color swatch,
    required Color border,
    bool isSelected = false,
    String identity = '',
  }) {
    return Container(
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
              color: swatch,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: border),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: row.labelColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (identity.isNotEmpty)
            Flexible(
              child: Text(
                identity,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: MultimodalStudioPalette.SAND_600,
                  fontSize: 9,
                ),
              ),
            ),
        ],
      ),
    );
  }

  TimelineBoardClip _rowSelection(TimelineBoardRow row) {
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
          // const Text(
          //   '속성 · ',
          //   style: TextStyle(
          //     color: MultimodalStudioPalette.SAND_600,
          //     fontSize: 11,
          //   ),
          // ),
          // _tool('툴바에서 열기', onPressed: viewModel.didTapToggleProperties),
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

  Widget _tracks(List<TimelineBoardRow> rows) {
    final width = viewModel.trackWidth;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
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
      },
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
        painter: TimelineRulerPainter(
          spanSeconds: span,
          pixelsPerSecond: viewModel.pixelsPerSecond,
          stepSeconds: step,
        ),
      ),
    );
  }

  Widget _track(TimelineBoardRow row, double width) {
    final track = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) =>
          viewModel.didSeekToSeconds(_secondsAt(details.localPosition.dx)),
      child: Container(
        height: 28,
        width: width,
        color: MultimodalStudioPalette.SAND_0,
        child: Stack(
          children: [
            for (final clip in row.clips) _clip(clip, row),
            for (final clip in row.clips)
              if (clip.showsPoseDots) ..._poseDots(clip),
          ],
        ),
      ),
    );
    if (!viewModel.isServerTimelineTrack(row.laneKey)) {
      return track;
    }
    return Builder(
      builder: (dropContext) {
        return DragTarget<String>(
          onAcceptWithDetails: (details) {
            viewModel.didDropAsset(
              dragData: details.data,
              laneKey: row.laneKey,
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

  Widget _clip(TimelineBoardClip clip, TimelineBoardRow row) {
    final range = _shownRange(clip);
    final left = range.startSeconds * viewModel.pixelsPerSecond;
    var width =
        (range.endSeconds - range.startSeconds) * viewModel.pixelsPerSecond;
    final minimum = VideoMultimodalViewModel.MIN_CLIP_WIDTH;
    if (width < minimum) {
      width = minimum;
    }
    final selected = _isClipSelected(clip);
    final canEdit = rangeIdOf(clip).isNotEmpty;
    if (canEdit && selected && width < 12) {
      width = 12;
    }
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
                rangeIdOf(clip),
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
              width: 1,
            ),
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
                    fontWeight: clip.hasLabel
                        ? FontWeight.w700
                        : FontWeight.w400,
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

  Widget _resizeHandle(TimelineBoardClip clip, {required bool isLeading}) {
    return GestureDetector(
      onHorizontalDragStart: (_) => _beginEdit(clip),
      onHorizontalDragUpdate: (details) => _resizeEdit(
        rangeIdOf(clip),
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

  TimelineClipEdit _shownRange(TimelineBoardClip clip) {
    final edit = _edit;
    final rangeId = rangeIdOf(clip);
    if (edit != null && edit.clipId == rangeId) {
      return edit;
    }
    return TimelineClipEdit(
      clipId: rangeId,
      isBar: clip.clipId.isEmpty,
      startSeconds: clip.startSeconds,
      endSeconds: clip.endSeconds,
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

  List<Widget> _poseDots(TimelineBoardClip clip) {
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

  void _selectClip(TimelineBoardClip clip) {
    if (viewModel.isRelationMode && clip.clipId.isNotEmpty) {
      viewModel.didTapClipForRelation(clip.clipId);
      viewModel.didSeekToSeconds(clip.startSeconds);
      return;
    }
    if (clip.attachmentId.isNotEmpty) {
      viewModel.didTapBar(clip.attachmentId);
      return;
    }
    viewModel.didSelectSampleClip(clip.clipId);
  }

  bool _isClipSelected(TimelineBoardClip clip) {
    if (clip.clipId.isNotEmpty) {
      return clip.clipId == viewModel.selectedClipId;
    }
    return clip.attachmentId.isNotEmpty &&
        clip.attachmentId == (viewModel.selectedBar?.attachmentId ?? '');
  }
}

String _timelineStatusLabel(JobTimelineStatus status) {
  switch (status) {
    case JobTimelineStatus.draft:
      return '초안';
    case JobTimelineStatus.suggested:
      return '제안';
    case JobTimelineStatus.confirmed:
      return '확정';
    case JobTimelineStatus.rejected:
      return '거절';
    case JobTimelineStatus.unspecified:
      return '상태 없음';
  }
}
