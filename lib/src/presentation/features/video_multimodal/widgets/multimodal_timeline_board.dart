import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/job_timeline.dart';
import '../../work_detail/widgets/work_detail_material_scope.dart';
import '../video_multimodal_view_model.dart';
import 'multimodal_dialogs.dart';
import 'multimodal_studio_palette.dart';
import 'timeline_board_helpers.dart';
import 'timeseries_clip_chart.dart';

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
  static const double _EDIT_TOOL_HEIGHT = 28;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _trackLabelScrollController = ScrollController();
  final ScrollController _trackScrollController = ScrollController();
  final TextEditingController _newTrackNameController = TextEditingController();
  final TextEditingController _trackNameController = TextEditingController();
  String _shownTrackId = '';
  DateTime _lastAutoScrollAt = DateTime.fromMillisecondsSinceEpoch(0);
  double _trackedPlayhead = -1;
  String _trackedClipId = '';
  TimelineClipEdit? _edit;
  bool _isStatusChoicesOpen = false;

  VideoMultimodalViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _trackedPlayhead = widget.viewModel.playheadSeconds;
    _trackedClipId = widget.viewModel.selectedClipId;
    _trackLabelScrollController.addListener(_syncTrackLanesFromLabels);
    _trackScrollController.addListener(_syncTrackLabelsFromLanes);
    _syncSelectedTrackName();
  }

  @override
  void didUpdateWidget(covariant MultimodalTimelineBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSelectedTrackName();
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
    _trackLabelScrollController.removeListener(_syncTrackLanesFromLabels);
    _trackScrollController.removeListener(_syncTrackLabelsFromLanes);
    _newTrackNameController.dispose();
    _trackNameController.dispose();
    _scrollController.dispose();
    _trackLabelScrollController.dispose();
    _trackScrollController.dispose();
    super.dispose();
  }

  bool _isSyncingRowScroll = false;

  void _syncTrackLanesFromLabels() {
    _alignRowScroll(_trackLabelScrollController, _trackScrollController);
  }

  void _syncTrackLabelsFromLanes() {
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
      builder: (dialogContext) {
        return WorkDetailMaterialScope(
          child: AlertDialog(
            content: const Text('이 트랙의 클립도 함께 지워집니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('지우기'),
              ),
            ],
          ),
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
    final hasMedia = rows.isNotEmpty && viewModel.spanSeconds > 0;
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
          hasMedia ? _filled(rows) : _empty(),
          if (viewModel.isLaneMenuOpen) _laneMenu(),
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
              _trackLabels(rows),
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
            // 임시 메뉴 비활성화
            // _statusMenu(),
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
    return Container(
      width: 180,
      height: _EDIT_TOOL_HEIGHT,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: MultimodalStudioPalette.SAND_300),
        borderRadius: BorderRadius.circular(3),
      ),
      child: TextField(
        key: key,
        controller: controller,
        enabled: enabled,
        cursorHeight: 14,
        style: const TextStyle(fontSize: 11, height: 1.2),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 11,
            height: 1.2,
            color: MultimodalStudioPalette.SAND_600,
          ),
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
    return SizedBox(
      height: _EDIT_TOOL_HEIGHT,
      child: TextButton(
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(0, _EDIT_TOOL_HEIGHT),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          textStyle: const TextStyle(fontSize: 11, height: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
        child: Text(label),
      ),
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

  static const TextStyle _TRACK_LABEL_STYLE = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle _TRACK_IDENTITY_STYLE = TextStyle(
    color: MultimodalStudioPalette.SAND_600,
    fontSize: 9,
  );
  // 좌우 패딩 + 색 상자 + AI 배지 + clip id 여유
  static const double _TRACK_LABEL_SIDE = 140;

  double _labelTextWidth(String text) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: _TRACK_LABEL_STYLE),
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  double _trackLabelsWidth(List<TimelineBoardRow> rows) {
    var widest = _labelTextWidth('트랙 (${viewModel.timelineTracks.length})');
    for (final row in rows) {
      final width = _labelTextWidth(row.label);
      if (width > widest) {
        widest = width;
      }
    }
    return widest + _TRACK_LABEL_SIDE;
  }

  Widget _trackLabels(List<TimelineBoardRow> rows) {
    return Container(
      width: _trackLabelsWidth(rows),
      decoration: const BoxDecoration(
        color: MultimodalStudioPalette.SAND_200,
        border: Border(
          right: BorderSide(color: MultimodalStudioPalette.SAND_300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 22,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '트랙 (${viewModel.timelineTracks.length})',
                  style: const TextStyle(
                    color: MultimodalStudioPalette.SAND_600,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: const Key('timeline-track-labels'),
              controller: _trackLabelScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (final row in rows) _trackLabelRow(row)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trackLabelRow(TimelineBoardRow row) {
    if (row.clips.isEmpty) {
      return _trackLabel(
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
      child: _trackLabel(
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

  Widget _trackLabel(
    TimelineBoardRow row, {
    required Color swatch,
    required Color border,
    bool isSelected = false,
    String identity = '',
  }) {
    return Container(
      height: row.height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: isSelected ? MultimodalStudioPalette.GRAPE_100 : null,
      child: Row(
        children: [
          if (viewModel.isServerTimelineTrack(row.laneKey))
            GestureDetector(
              onTap: () => viewModel.didTapMonitorTrack(row.laneKey),
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  viewModel.isTrackMonitored(row.laneKey)
                      ? Icons.videocam
                      : Icons.videocam_outlined,
                  size: 14,
                  color: viewModel.isTrackMonitored(row.laneKey)
                      ? MultimodalStudioPalette.GRAPE_700
                      : MultimodalStudioPalette.SAND_600,
                ),
              ),
            ),
          if (viewModel.isServerTimelineTrack(row.laneKey) &&
              viewModel.trackHasTimeseries(row.laneKey))
            GestureDetector(
              onTap: () => viewModel.didTapToggleTimeseriesChart(row.laneKey),
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.show_chart,
                  size: 14,
                  color: row.isChartExpanded
                      ? MultimodalStudioPalette.GRAPE_700
                      : MultimodalStudioPalette.SAND_600,
                ),
              ),
            ),
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
          Text(
            row.label,
            maxLines: 1,
            softWrap: false,
            style: _TRACK_LABEL_STYLE.copyWith(color: row.labelColor),
          ),
          if (identity.isNotEmpty) ...[
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                identity,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: _TRACK_IDENTITY_STYLE,
              ),
            ),
          ],
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
          _tool(
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

  void _seekRuler(Offset localInViewport) {
    if (localInViewport.dy < 0 || localInViewport.dy > _RULER_HEIGHT) {
      return;
    }
    final scroll = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;
    final contentX = localInViewport.dx + scroll;
    final rawSeconds = contentX / viewModel.pixelsPerSecond;
    final seconds = rawSeconds.clamp(0.0, viewModel.spanSeconds);
    final before = viewModel.playheadSeconds;
    viewModel.didSeekToSeconds(seconds);
    if (!kDebugMode) {
      return;
    }
    debugPrint(
      '[RULER] x=${contentX.toStringAsFixed(1)} '
      'scroll=${scroll.toStringAsFixed(1)} '
      'raw=${rawSeconds.toStringAsFixed(3)}s '
      'playhead ${before.toStringAsFixed(3)}s -> '
      '${viewModel.playheadSeconds.toStringAsFixed(3)}s',
    );
  }

  Widget _tracks(List<TimelineBoardRow> rows) {
    final width = viewModel.trackWidth;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) => _seekRuler(event.localPosition),
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
                    left: viewModel.playheadSeconds * viewModel.pixelsPerSecond,
                    top: 0,
                    bottom: 0,
                    child: const IgnorePointer(
                      child: SizedBox(
                        width: 2,
                        child: ColoredBox(
                          color: MultimodalStudioPalette.DANGER,
                        ),
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
      },
    );
  }

  Widget _ruler(double width) {
    final span = viewModel.spanSeconds;
    return CustomPaint(
      size: Size(width, _RULER_HEIGHT),
      painter: TimelineRulerPainter(
        spanSeconds: span,
        pixelsPerSecond: viewModel.pixelsPerSecond,
      ),
    );
  }

  Widget _track(TimelineBoardRow row, double width) {
    final track = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) =>
          viewModel.didSeekToSeconds(_secondsAt(details.localPosition.dx)),
      child: Container(
        height: row.height,
        width: width,
        color: MultimodalStudioPalette.SAND_0,
        child: Stack(
          children: [
            for (final clip in row.clips) _clip(clip, row),
            for (final clip in row.clips)
              if (clip.poseMarks.isNotEmpty) ..._poseMarks(clip),
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
            _acceptDroppedAsset(
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
    final canEdit = rangeIdOf(clip).isNotEmpty && !clip.isChartExpanded;
    if (canEdit && selected && width < 12) {
      width = 12;
    }
    if (clip.isChartExpanded) {
      return Positioned(
        left: left,
        top: 0,
        width: width < 160 ? 160 : width,
        height: row.height,
        child: GestureDetector(
          onTap: () => _selectClip(clip),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: MultimodalStudioPalette.GRAPE_400,
                width: 1,
              ),
            ),
            child: TimeseriesClipChart(
              series: viewModel.timeseriesSeries,
              isLoading: viewModel.isTimeseriesChartLoading,
              errorMessage: viewModel.timeseriesChartError,
              selectedTimeMs: viewModel.timeseriesSelectedTimeMs,
              onTimeTapMs: viewModel.didTapTimeseriesChartTime,
            ),
          ),
        ),
      );
    }
    return Positioned(
      left: left,
      top: 4 + clip.laneIndex * TIMELINE_TRACK_LANE_HEIGHT,
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
                  clip.rateLabel.isEmpty
                      ? clip.text
                      : '${clip.text} ${clip.rateLabel}',
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

  List<Widget> _poseMarks(TimelineBoardClip clip) {
    final top = 8.0 + clip.laneIndex * TIMELINE_TRACK_LANE_HEIGHT;
    final marks = <Widget>[];
    final pps = viewModel.pixelsPerSecond;
    for (var index = 0; index < clip.poseMarks.length; index++) {
      final mark = clip.poseMarks[index];
      final left = mark.startSeconds * pps;
      final durationSeconds = mark.endSeconds - mark.startSeconds;
      final rawWidth = durationSeconds * pps;
      var width = rawWidth;
      if (width < 2) {
        width = 2;
      }
      if (index < 3 || index == clip.poseMarks.length - 1) {
        debugPrint(
          '[POSE_BOARD] paint clipId=${clip.clipId} i=$index/'
          '${clip.poseMarks.length} '
          't=${mark.startSeconds.toStringAsFixed(3)}'
          '..${mark.endSeconds.toStringAsFixed(3)} '
          'dur=${durationSeconds.toStringAsFixed(4)}s '
          'rawPx=${rawWidth.toStringAsFixed(2)} drawPx=${width.toStringAsFixed(2)} '
          'left=${left.toStringAsFixed(1)} pps=$pps',
        );
      }
      final seekSeconds = mark.startSeconds + durationSeconds / 2;
      marks.add(
        Positioned(
          left: left,
          top: top,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => viewModel.didSeekToSeconds(seekSeconds),
            child: SizedBox(
              width: width,
              height: 12,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: MultimodalStudioPalette.GRAPE_400,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return marks;
  }

  Future<void> _acceptDroppedAsset({
    required String dragData,
    required String laneKey,
    required double startSeconds,
  }) async {
    await viewModel.didDropAsset(
      dragData: dragData,
      laneKey: laneKey,
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
