import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/clip_file_position.dart';
import '../../../domain/entities/ask_answer.dart';
import '../../../domain/entities/job_timeline.dart';
import '../../../domain/entities/label_vocab.dart';
import '../../../domain/entities/tool_run.dart';
import '../../../domain/entities/work_attachment.dart';
import '../../../domain/entities/work_attachment_type.dart';
import '../../../domain/repositories/ask_session_store.dart';
import '../../../domain/timeline_clip_playback.dart';
import '../../../domain/timeline_time.dart';
import '../../../domain/use_cases/ask_question_use_case.dart';
import '../../../domain/use_cases/get_session_history_use_case.dart';
import '../../../domain/use_cases/change_timeline_status_use_case.dart';
import '../../../domain/use_cases/create_clip_use_case.dart';
import '../../../domain/use_cases/create_track_use_case.dart';
import '../../../domain/use_cases/delete_clip_use_case.dart';
import '../../../domain/use_cases/delete_timeline_use_case.dart';
import '../../../domain/use_cases/delete_track_use_case.dart';
import '../../../domain/use_cases/get_clip_use_case.dart';
import '../../../domain/entities/timeseries_waveform_load.dart';
import '../../../domain/entities/waveform_series_bundle.dart';
import '../../../domain/use_cases/get_job_timeline_use_case.dart';
import '../../../domain/use_cases/label_use_case.dart';
import '../../../domain/use_cases/list_history_work_attachments_use_case.dart';
import '../../../domain/use_cases/load_job_project_id_use_case.dart';
import '../../../domain/use_cases/load_timeseries_waveform_use_case.dart';
import '../../../domain/use_cases/tool_run_use_case.dart';
import '../../../domain/use_cases/update_clip_use_case.dart';
import '../../../domain/use_cases/update_timeline_use_case.dart';
import '../../../domain/use_cases/update_track_use_case.dart';
import 'video_caption.dart';
import 'video_overlay_clock.dart';
import 'video_overlay_frame.dart';
import 'video_overlay_json.dart';
import 'playhead_covering_log.dart';
import 'timeline_playhead_clock.dart';
import 'video_playback_rate.dart';
import 'video_subtitle_text.dart';
import 'video_multimodal_models.dart';
export 'video_multimodal_models.dart';

class VideoMultimodalViewModel extends ChangeNotifier {
  VideoMultimodalViewModel({
    required this._listHistoryWorkAttachmentsUseCase,
    required this._getJobTimelineUseCase,
    required this._getClipUseCase,
    required this._createTrackUseCase,
    required this._updateTrackUseCase,
    required this._deleteTrackUseCase,
    required this._createClipUseCase,
    required this._updateClipUseCase,
    required this._deleteClipUseCase,
    required this._changeTimelineStatusUseCase,
    required this._updateTimelineUseCase,
    required this._deleteTimelineUseCase,
    required this._toolRunUseCase,
    required this._labelUseCase,
    required this._askQuestionUseCase,
    required this._getSessionHistoryUseCase,
    required this._askSessionStore,
    required this._loadJobProjectIdUseCase,
    required this._loadTimeseriesWaveformUseCase,
    required this.jobId,
    this.toolRunPoll = const Duration(seconds: 2),
  });

  static const double MIN_TIMELINE_HEIGHT = 320;
  static const double SIDE_WIDTH = 320;
  static const double DEFAULT_PIXELS_PER_SECOND = 10;
  static const double EMPTY_SPAN_SECONDS = 60;
  static const double PROVISIONAL_BAR_SECONDS = 10;
  static const double MIN_TRACK_WIDTH = 640;
  static const double MIN_CLIP_WIDTH = 6;
  static const double MIN_REGION_SECONDS = 0.1;
  static const double DEFAULT_TIMELESS_CLIP_SECONDS = 5;
  static const String ASSET_DRAG_PREFIX = 'asset:';
  static const String RELATION_TRACK_NAME = '관계';
  static const String LIKE_TRACK_NAME = '좋아요';
  static const String DISLIKE_TRACK_NAME = '싫어요';
  static const String COMMENT_TRACK_NAME = '코멘트';
  static const String RECORDING_VIDEO_TRACK_NAME = '녹화 영상';
  static const String RECORDING_AUDIO_TRACK_NAME = '녹화 음성';

  final ListHistoryWorkAttachmentsUseCase _listHistoryWorkAttachmentsUseCase;
  final GetJobTimelineUseCase _getJobTimelineUseCase;
  final GetClipUseCase _getClipUseCase;
  final CreateTrackUseCase _createTrackUseCase;
  final UpdateTrackUseCase _updateTrackUseCase;
  final DeleteTrackUseCase _deleteTrackUseCase;
  final CreateClipUseCase _createClipUseCase;
  final UpdateClipUseCase _updateClipUseCase;
  final DeleteClipUseCase _deleteClipUseCase;
  final ChangeTimelineStatusUseCase _changeTimelineStatusUseCase;
  final UpdateTimelineUseCase _updateTimelineUseCase;
  final DeleteTimelineUseCase _deleteTimelineUseCase;
  final ToolRunUseCase _toolRunUseCase;
  final LabelUseCase _labelUseCase;
  final AskQuestionUseCase _askQuestionUseCase;
  final GetSessionHistoryUseCase _getSessionHistoryUseCase;
  final AskSessionStore _askSessionStore;
  final LoadJobProjectIdUseCase _loadJobProjectIdUseCase;
  final LoadTimeseriesWaveformUseCase _loadTimeseriesWaveformUseCase;
  final String jobId;
  final Duration toolRunPoll;

  final TimelinePlayheadClock _playhead = TimelinePlayheadClock();
  final PlayheadCoveringLog _playheadCoveringLog = PlayheadCoveringLog();
  int _seekToken = 0;
  VideoMultimodalSide _side = VideoMultimodalSide.none;
  bool _isLaneMenuOpen = false;
  bool _isLoading = false;
  bool _isSavingTimeline = false;
  int? _vectorSaveTrackCount;
  bool _hasError = false;
  String _errorMessage = '';
  final List<double> _markerSeconds = [];
  String _noticeText = '';
  List<WorkAttachment> _attachments = const [];
  List<TemporaryAttachmentBar> _bars = const [];
  JobTimeline _timeline = JobTimeline.empty;
  final Set<String> _hiddenAttachmentIds = {};
  final Set<String> _hiddenLaneKeys = {};
  String _selectedAttachmentId = '';
  String _selectedClipId = '';
  int _clipDetailEpoch = 0;
  bool _isClipDetailLoading = false;
  String _clipDetailMessage = '';
  ClipDetail? _clipDetail;
  TimelineClip? _playbackVideoClip;
  TimelineOverlay? _selectedPoseOverlay;
  List<VideoOverlayFrame> _selectedPoseFrames = const [];
  bool _isRelationMode = false;
  String _relationAnchorClipId = '';
  String _workName = '';
  String _assetsSearchQuery = '';
  String _timelineHint = '';
  CreatedClipNotice? _createdClipNotice;
  String _selectedLabelValueId = '';
  bool _isLoadingLabels = false;
  String _labelMessage = '';
  int _labelEpoch = 0;
  List<LabelNode> _labelRoots = const [];
  int _playbackToken = 0;
  String _coveringVideoClipId = '';
  InferencePanelPhase _inferencePhase = InferencePanelPhase.hidden;
  bool _isCameraRecordingOpen = false;
  bool _isCameraRecordingMinimized = false;
  double _cameraRecordingOffsetX = 24;
  double _cameraRecordingOffsetY = 24;
  bool _isInferenceMinimized = false;
  double _inferenceOffsetX = 24;
  double _inferenceOffsetY = 24;
  String _inferenceModelName = '';
  String _inferenceMessage = '';
  double _inferenceProgressPercent = 0;
  int _inferenceRemainingSeconds = 0;
  String _activeRunId = '';
  int _toolRunEpoch = 0;
  bool _isClosed = false;
  final List<AskTurn> _askTurns = [];
  String _askSessionId = '';
  String _projectId = '';
  bool _isAsking = false;
  bool _isLoadingAskHistory = false;
  int _overlayEpoch = 0;
  final Map<String, List<VideoOverlayFrame>> _framesByAssetId = {};
  final Map<String, List<VideoCaption>> _cuesByAssetId = {};
  final List<SampleLayerSummary> _sampleLayers = const [];

  /// Stage에 동시에 보여 줄 비디오 트랙(최대 [MAX_MONITORED_TRACK_COUNT]).
  final List<String> _monitoredTrackIds = [];
  String _focusedMonitorTrackId = '';
  static const int MAX_MONITORED_TRACK_COUNT = 4;
  String _chartExpandedClipId = '';
  int _timeseriesChartEpoch = 0;
  bool _isTimeseriesChartLoading = false;
  String _timeseriesChartError = '';
  WaveformSeriesBundle _timeseriesSeries =
      LoadTimeseriesWaveformUseCase.emptySeries;
  DateTime _lastMonitorDebugAt = DateTime.fromMillisecondsSinceEpoch(0);
  static const Duration _MONITOR_DEBUG_INTERVAL = Duration(seconds: 2);

  double get pixelsPerSecond => DEFAULT_PIXELS_PER_SECOND;
  double get playheadSeconds => _playhead.playheadSeconds;

  /// 타임라인 배속(기본 1). `playbackRate = timeline × clip`.
  double get timelinePlaybackRate => _playhead.timelinePlaybackRate;
  String get timelinePlaybackRateLabel => _playhead.timelinePlaybackRateLabel;
  int get seekToken => _seekToken;
  VideoMultimodalSide get side => _side;
  bool get isAssetsOpen => _side == VideoMultimodalSide.assets;
  bool get isPropertiesOpen => _side == VideoMultimodalSide.properties;
  bool get isAskOpen => _side == VideoMultimodalSide.ask;
  bool get isLabelsOpen => _side == VideoMultimodalSide.labels;
  bool get isLaneMenuOpen => _isLaneMenuOpen;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<double> get markerSeconds => List.unmodifiable(_markerSeconds);
  String get noticeText => _noticeText;
  bool get hasNotice => _noticeText.isNotEmpty;
  List<WorkAttachment> get attachments => List.unmodifiable(_attachments);
  List<TimelineTrack> get timelineTracks => List.unmodifiable(_timeline.tracks);
  JobTimelineStatus get timelineStatus => _timeline.status;
  List<TimelineClip> get timelineClips => [
    for (final track in _timeline.tracks) ...track.clips,
  ];

  List<TemporaryAttachmentBar> get visibleBars => [
    for (final bar in _bars)
      if (!_hiddenAttachmentIds.contains(bar.attachmentId)) bar,
  ];

  TimelineTrack? get selectedServerTrack {
    final clip = _timelineClip(_selectedClipId);
    if (clip == null) {
      return null;
    }
    for (final track in _timeline.tracks) {
      if (track.trackId == clip.trackId) {
        return track;
      }
    }
    return null;
  }

  WorkAttachment? get selectedAttachment {
    if (_selectedAttachmentId.isEmpty) {
      return null;
    }
    for (final attachment in _attachments) {
      if (attachment.attachmentId == _selectedAttachmentId) {
        return attachment;
      }
    }
    return null;
  }

  bool get canEditSelectedServerTrack => selectedServerTrack != null;

  bool isServerTimelineTrack(String laneKey) {
    for (final track in _timeline.tracks) {
      if (track.trackId == laneKey) {
        return true;
      }
    }
    return false;
  }

  TemporaryAttachmentBar? get selectedBar {
    for (final bar in _bars) {
      if (bar.attachmentId == _selectedAttachmentId) {
        return bar;
      }
    }
    return null;
  }

  List<VideoCaption> get activeVideoCaptions {
    final video = activeVideoBar;
    if (video == null) {
      return const [];
    }
    return captionsOnVideo(
      videoStartSeconds: video.startSeconds,
      videoEndSeconds: video.endSeconds,
      overlays: _timeline.overlays,
      cuesByAssetId: _cuesByAssetId,
    );
  }

  List<VideoOverlayFrame> get activeVideoOverlayFrames {
    final video = activeVideoBar;
    final playback = _playbackVideoClip;
    final poseOverlay = _selectedPoseOverlay;
    final selected = _timelineClip(_selectedClipId);
    if (video == null ||
        playback == null ||
        poseOverlay == null ||
        selected?.kind != TimelineClipKind.pose ||
        video.attachmentId != playback.clipId) {
      return const [];
    }
    return framesOnVideo(
      videoStartSeconds: video.startSeconds,
      videoEndSeconds: video.endSeconds,
      overlays: [poseOverlay],
      framesByAssetId: {poseOverlay.assetId: _selectedPoseFrames},
    );
  }

  TimelineClip? _videoClipAt(double seconds) {
    TimelineClip? chosen;
    var chosenStart = 0.0;
    for (final clip in timelineClips) {
      if (clip.kind != TimelineClipKind.video || clip.playbackUrl.isEmpty) {
        continue;
      }
      final start = secondsFromNanoseconds(clip.startNanoseconds);
      final end = secondsFromNanoseconds(clip.endNanoseconds);
      if (seconds < start || seconds >= end) {
        continue;
      }
      if (chosen == null || start < chosenStart) {
        chosen = clip;
        chosenStart = start;
      }
    }
    return chosen;
  }

  TimelineClip? _timelineClip(String clipId) {
    for (final clip in timelineClips) {
      if (clip.clipId == clipId) {
        return clip;
      }
    }
    return null;
  }

  String _trackName(String trackId) {
    for (final track in _timeline.tracks) {
      if (track.trackId == trackId && track.name.trim().isNotEmpty) {
        return track.name.trim();
      }
    }
    return '트랙';
  }

  bool get canAttachLabelToSelection =>
      isSelectedServerClip && _selectedLabelValueId.isNotEmpty;

  bool get canDetachLabelFromSelection {
    final clip = _timelineClip(_selectedClipId);
    return clip != null && clip.labelValueId.isNotEmpty;
  }

  String labelForClip(TimelineClip clip) {
    if (clip.labelValueId.isNotEmpty) {
      final name = _labelName(clip.labelValueId);
      if (name.isNotEmpty) {
        return name;
      }
      return clip.labelValueId;
    }
    final note = clip.description.trim();
    if (note.isNotEmpty) {
      return note;
    }
    final fileName = clip.fileName.trim();
    if (fileName.isNotEmpty) {
      return fileName;
    }
    return _kindLabel(clip.kind);
  }

  String clipCaption(TimelineClip clip) {
    final text = labelForClip(clip);
    if (clip.labelValueId.isEmpty) {
      return text;
    }
    return '#$text';
  }

  String _kindLabel(TimelineClipKind kind) {
    switch (kind) {
      case TimelineClipKind.video:
        return '영상';
      case TimelineClipKind.audio:
        return '음성';
      case TimelineClipKind.image:
        return '이미지';
      case TimelineClipKind.pdf:
        return 'PDF';
      case TimelineClipKind.subtitle:
        return '자막';
      case TimelineClipKind.pose:
        return '포즈';
      case TimelineClipKind.timeseries:
        return '시계열';
      case TimelineClipKind.pointCloud:
        return '포인트클라우드';
      case TimelineClipKind.file:
        return '파일';
      case TimelineClipKind.tag:
        return '태그';
      case TimelineClipKind.region:
        return '영역';
      case TimelineClipKind.relation:
        return '관계';
      case TimelineClipKind.unspecified:
        return '클립';
    }
  }

  TemporaryAttachmentBar? get activeVideoBar =>
      _videoBarFromClip(_activeVideoClip());

  List<String> get monitoredTrackIds {
    final validTrackIds = {for (final track in timelineTracks) track.trackId};
    return [
      for (final trackId in _monitoredTrackIds)
        if (validTrackIds.contains(trackId)) trackId,
    ];
  }

  String get focusedMonitorTrackId {
    final trackIds = monitoredTrackIds;
    if (trackIds.isEmpty) {
      return '';
    }
    if (trackIds.contains(_focusedMonitorTrackId)) {
      return _focusedMonitorTrackId;
    }
    return trackIds.first;
  }

  bool isTrackMonitored(String trackId) => monitoredTrackIds.contains(trackId);

  bool isMonitorSlotFocused(String trackId) => focusedMonitorTrackId == trackId;

  String monitorTrackLabel(String trackId) {
    final name = _trackName(trackId).trim();
    if (name.isNotEmpty) {
      return name;
    }
    return trackId;
  }

  TemporaryAttachmentBar? videoBarForTrack(String trackId) =>
      _videoBarFromClip(_coveringVideoOnTrack(trackId, playheadSeconds));

  List<VideoCaption> captionsForTrack(String trackId) {
    final video = videoBarForTrack(trackId);
    if (video == null) {
      return const [];
    }
    return captionsOnVideo(
      videoStartSeconds: video.startSeconds,
      videoEndSeconds: video.endSeconds,
      overlays: _timeline.overlays,
      cuesByAssetId: _cuesByAssetId,
    );
  }

  List<VideoOverlayFrame> overlayFramesForTrack(String trackId) {
    final video = videoBarForTrack(trackId);
    final active = activeVideoBar;
    if (video == null ||
        active == null ||
        video.attachmentId != active.attachmentId) {
      return const [];
    }
    return activeVideoOverlayFrames;
  }

  void didTapMonitorTrack(String trackId) {
    if (trackId.isEmpty) {
      return;
    }
    if (_monitoredTrackIds.contains(trackId)) {
      _monitoredTrackIds.remove(trackId);
      if (_focusedMonitorTrackId == trackId) {
        _setFocusedMonitorTrack(
          _monitoredTrackIds.isEmpty ? '' : _monitoredTrackIds.first,
        );
      }
      notifyListeners();
      return;
    }
    if (_monitoredTrackIds.length >= MAX_MONITORED_TRACK_COUNT) {
      didShowNotice('모니터는 최대 $MAX_MONITORED_TRACK_COUNT개까지입니다.');
      return;
    }
    _monitoredTrackIds.add(trackId);
    _setFocusedMonitorTrack(trackId);
    notifyListeners();
  }

  String get chartExpandedClipId => _chartExpandedClipId;
  bool get isTimeseriesChartLoading => _isTimeseriesChartLoading;
  String get timeseriesChartError => _timeseriesChartError;
  WaveformSeriesBundle get timeseriesSeries => _timeseriesSeries;

  bool trackHasTimeseries(String trackId) {
    for (final clip in _timeline.clips) {
      if (clip.trackId == trackId && clip.kind == TimelineClipKind.timeseries) {
        return true;
      }
    }
    return false;
  }

  bool isTimeseriesChartExpanded(String clipId) =>
      clipId.isNotEmpty && clipId == _chartExpandedClipId;

  int? get timeseriesSelectedTimeMs {
    final clip = _timelineClip(_chartExpandedClipId);
    if (clip == null) {
      return null;
    }
    final start = secondsFromNanoseconds(clip.startNanoseconds);
    final end = secondsFromNanoseconds(clip.endNanoseconds);
    if (end <= start) {
      return 0;
    }
    final local = (playheadSeconds - start).clamp(0.0, end - start);
    return (local * 1000).round();
  }

  void didTapToggleTimeseriesChart(String trackId) {
    if (trackId.isEmpty || !trackHasTimeseries(trackId)) {
      return;
    }
    final selected = _timelineClip(_selectedClipId);
    TimelineClip? target;
    if (selected != null &&
        selected.trackId == trackId &&
        selected.kind == TimelineClipKind.timeseries) {
      target = selected;
    } else {
      target = _coveringTimeseriesOnTrack(trackId, playheadSeconds);
      target ??= _firstTimeseriesOnTrack(trackId);
    }
    if (target == null) {
      return;
    }
    if (_chartExpandedClipId == target.clipId) {
      _collapseTimeseriesChart();
      notifyListeners();
      return;
    }
    _expandTimeseriesChart(target);
  }

  void didTapTimeseriesChartTime(int timeMs) {
    final clip = _timelineClip(_chartExpandedClipId);
    if (clip == null) {
      return;
    }
    final start = secondsFromNanoseconds(clip.startNanoseconds);
    didSeekToSeconds(start + timeMs / 1000.0);
  }

  TimelineClip? _coveringTimeseriesOnTrack(String trackId, double seconds) {
    TimelineClip? best;
    for (final clip in _timeline.clips) {
      if (clip.trackId != trackId || clip.kind != TimelineClipKind.timeseries) {
        continue;
      }
      final start = secondsFromNanoseconds(clip.startNanoseconds);
      final end = secondsFromNanoseconds(clip.endNanoseconds);
      if (seconds < start || seconds >= end) {
        continue;
      }
      if (best == null || clip.clipId.compareTo(best.clipId) > 0) {
        best = clip;
      }
    }
    return best;
  }

  TimelineClip? _firstTimeseriesOnTrack(String trackId) {
    TimelineClip? best;
    for (final clip in _timeline.clips) {
      if (clip.trackId != trackId || clip.kind != TimelineClipKind.timeseries) {
        continue;
      }
      if (best == null ||
          secondsFromNanoseconds(clip.startNanoseconds) <
              secondsFromNanoseconds(best.startNanoseconds)) {
        best = clip;
      }
    }
    return best;
  }

  void _expandTimeseriesChart(TimelineClip clip) {
    _chartExpandedClipId = clip.clipId;
    _selectedClipId = clip.clipId;
    unawaited(_loadTimeseriesChart(clip));
  }

  void _collapseTimeseriesChart() {
    _chartExpandedClipId = '';
    _timeseriesChartEpoch += 1;
    _isTimeseriesChartLoading = false;
    _timeseriesChartError = '';
    _timeseriesSeries = LoadTimeseriesWaveformUseCase.emptySeries;
  }

  Future<void> _loadTimeseriesChart(TimelineClip clip) async {
    final epoch = ++_timeseriesChartEpoch;
    _isTimeseriesChartLoading = true;
    _timeseriesChartError = '';
    _timeseriesSeries = LoadTimeseriesWaveformUseCase.emptySeries;
    notifyListeners();
    _logTimeseries(
      'request',
      clip: clip,
      detail:
          'urlEmpty=${clip.contentUrl.isEmpty} '
          'urlLen=${clip.contentUrl.length}',
    );
    if (clip.contentUrl.isEmpty) {
      if (epoch != _timeseriesChartEpoch || _isClosed) {
        return;
      }
      _isTimeseriesChartLoading = false;
      _timeseriesChartError = '파형 주소가 없습니다';
      _logTimeseries('skip_empty_url', clip: clip);
      notifyListeners();
      return;
    }
    try {
      final load = await _loadTimeseriesWaveformUseCase.execute(
        contentUrl: clip.contentUrl,
      );
      if (epoch != _timeseriesChartEpoch || _isClosed) {
        _logTimeseries('stale', clip: clip, detail: 'epoch=$epoch');
        return;
      }
      _timeseriesSeries = load.series;
      if (!load.series.doesHaveAnySeries) {
        _timeseriesChartError = '파형 데이터 없음';
      }
      _logTimeseriesLoad(clip, load);
    } catch (error) {
      if (epoch != _timeseriesChartEpoch || _isClosed) {
        return;
      }
      _timeseriesChartError = error.toString();
      _timeseriesSeries = LoadTimeseriesWaveformUseCase.emptySeries;
      _logTimeseries('error', clip: clip, detail: '$error');
    } finally {
      if (epoch == _timeseriesChartEpoch && !_isClosed) {
        _isTimeseriesChartLoading = false;
        notifyListeners();
      }
    }
  }

  void _logTimeseriesLoad(TimelineClip clip, TimeseriesWaveformLoad load) {
    final points = load.series.robot;
    final first = points.isEmpty ? null : points.first;
    final last = points.isEmpty ? null : points.last;
    var currentCount = 0;
    var voltageCount = 0;
    var speedCount = 0;
    var rpmCount = 0;
    for (final point in points) {
      if (point.currentA != null) {
        currentCount += 1;
      }
      if (point.voltageV != null) {
        voltageCount += 1;
      }
      if (point.speedValue != null) {
        speedCount += 1;
      }
      if (point.rotationSpeedRpm != null) {
        rpmCount += 1;
      }
    }
    _logTimeseries(
      'response',
      clip: clip,
      detail:
          'bodyLen=${load.bodyLength} lines=${load.lineCount} '
          'headers=${load.headers.join('|')} '
          'match(time=${load.matchedTimeHeader},'
          'current=${load.matchedCurrentHeader},'
          'voltage=${load.matchedVoltageHeader},'
          'speed=${load.matchedSpeedHeader},'
          'rpm=${load.matchedRpmHeader}) '
          'rawPoints=${load.rawPointCount} points=${load.pointCount} '
          'filled(current=$currentCount,voltage=$voltageCount,'
          'speed=$speedCount,rpm=$rpmCount) '
          'rangeMs=${first?.timeMs ?? '-'}..${last?.timeMs ?? '-'} '
          'sample(t=${first?.timeMs},I=${first?.currentA},'
          'V=${first?.voltageV},S=${first?.speedValue},'
          'rpm=${first?.rotationSpeedRpm})',
    );
  }

  void _logTimeseries(
    String phase, {
    required TimelineClip clip,
    String detail = '',
  }) {
    if (!kDebugMode) {
      return;
    }
    debugPrint(
      '[TIMESERIES] $phase clipId=${clip.clipId} trackId=${clip.trackId} '
      'assetId=${clip.assetId} file=${clip.fileName} '
      'kind=${clip.kind} '
      'timeline=${clip.startNs}..${clip.endNs} '
      'source=${clip.sourceStartNs}..${clip.sourceEndNs} '
      'url=${clip.contentUrl}'
      '${detail.isEmpty ? '' : ' $detail'}',
    );
  }

  void didTapFocusMonitorSlot(String trackId) {
    if (!isTrackMonitored(trackId) || _focusedMonitorTrackId == trackId) {
      return;
    }
    _setFocusedMonitorTrack(trackId);
    notifyListeners();
  }

  void _setFocusedMonitorTrack(String trackId) {
    _focusedMonitorTrackId = trackId;
    _coveringVideoClipId = '';
    if (_playhead.wantsPlayback) {
      _seekToken += 1;
    }
    if (trackId.isEmpty) {
      return;
    }
    _logMonitor(
      'focus_tap',
      sourceTrackId: trackId,
      focusedId: trackId,
      isPlaying: _playhead.isPlaying,
    );
  }

  TemporaryAttachmentBar? _videoBarFromClip(TimelineClip? clip) {
    if (clip == null) {
      return null;
    }
    return TemporaryAttachmentBar(
      attachmentId: clip.clipId,
      fileName: clip.fileName,
      fileTypeLabel: 'video',
      mediaUrl: clip.playbackUrl,
      note: clip.description,
      isVideo: true,
      startSeconds: secondsFromNanoseconds(clip.startNanoseconds),
      endSeconds: secondsFromNanoseconds(clip.endNanoseconds),
    );
  }

  double get spanSeconds {
    var end = 0.0;
    for (final clip in timelineClips) {
      final clipEnd = secondsFromNanoseconds(clip.endNanoseconds);
      if (clipEnd > end) {
        end = clipEnd;
      }
    }
    if (end <= 0) {
      return EMPTY_SPAN_SECONDS;
    }
    return end;
  }

  String get playheadLabel => _formatClock(playheadSeconds);
  String get spanLabel => _formatClock(spanSeconds);
  String get timelineName => _timeline.name;
  String get timelineDescription => _timeline.description;

  String get pageTitle {
    final workName = _workName.trim();
    if (workName.isNotEmpty) {
      return workName;
    }
    return jobId;
  }

  void didReceiveWorkName(String workName) {
    _workName = workName.trim();
    notifyListeners();
  }

  bool get isVideoPlaying => _playhead.isPlaying;
  bool get wantsPlayback => _playhead.wantsPlayback;
  int get playbackToken => _playbackToken;

  bool isLaneVisible(String laneKey) => !_hiddenLaneKeys.contains(laneKey);
  String get assetsSearchQuery => _assetsSearchQuery;
  String get timelineHint => _timelineHint;

  CreatedClipNotice? takeCreatedClipNotice() {
    final notice = _createdClipNotice;
    _createdClipNotice = null;
    return notice;
  }

  bool get hasTimelineHint => _timelineHint.isNotEmpty;
  String get selectedLabelValueId => _selectedLabelValueId;
  bool get isLoadingLabels => _isLoadingLabels;
  String get labelMessage => _labelMessage;
  bool get canDeleteSelection => _selectedClipId.isNotEmpty;
  bool get isSelectedServerClip => _timelineClip(_selectedClipId) != null;
  bool get isRelationMode => _isRelationMode;

  String get relationPrompt {
    if (!_isRelationMode) {
      return '';
    }
    if (_relationAnchorClipId.isEmpty) {
      return 'Relation 모드 — 첫 번째 클립을 클릭하세요';
    }
    return 'Relation 모드 — 두 번째 클립을 클릭하세요';
  }

  String get selectedClipId => _selectedClipId;
  bool get isClipDetailLoading => _isClipDetailLoading;
  String get clipDetailMessage => _clipDetailMessage;
  List<ClipField> get clipDetailFields =>
      _clipDetail?.fields ?? const <ClipField>[];
  InferencePanelPhase get inferencePhase => _inferencePhase;
  bool get isInferenceVisible => _inferencePhase != InferencePanelPhase.hidden;
  int? get vectorSaveNoticeTrackCount => _vectorSaveTrackCount;
  bool get isCameraRecordingOpen => _isCameraRecordingOpen;
  bool get isCameraRecordingMinimized => _isCameraRecordingMinimized;
  double get cameraRecordingOffsetX => _cameraRecordingOffsetX;
  double get cameraRecordingOffsetY => _cameraRecordingOffsetY;
  bool get isInferenceMinimized => _isInferenceMinimized;
  double get inferenceOffsetX => _inferenceOffsetX;
  double get inferenceOffsetY => _inferenceOffsetY;
  String get inferenceModelName => _inferenceModelName;
  String get inferenceMessage => _inferenceMessage;
  double get inferenceProgressValue {
    final ratio = _inferenceProgressPercent / 100;
    if (ratio < 0) {
      return 0;
    }
    if (ratio > 1) {
      return 1;
    }
    return ratio;
  }

  String get inferenceRemainingLabel {
    if (_inferenceRemainingSeconds <= 0) {
      return '알 수 없음';
    }
    return '남은 시간 $_inferenceRemainingSeconds초';
  }

  bool get canCancelInference =>
      _activeRunId.isNotEmpty &&
      (_inferencePhase == InferencePanelPhase.queued ||
          _inferencePhase == InferencePanelPhase.running);
  List<AskTurn> get askTurns => List.unmodifiable(_askTurns);
  bool get isAsking => _isAsking;
  bool get isLoadingAskHistory => _isLoadingAskHistory;
  List<LabelNode> get labelRoots => List.unmodifiable(_labelRoots);
  List<SampleLayerSummary> get sampleLayers => List.unmodifiable(_sampleLayers);

  TimelineSampleClip? get selectedClip {
    final timelineClip = _timelineClip(_selectedClipId);
    if (timelineClip == null) {
      return null;
    }
    return TimelineSampleClip(
      clipId: timelineClip.clipId,
      laneKey: timelineClip.trackId,
      laneLabel: _trackName(timelineClip.trackId),
      text: clipCaption(timelineClip),
      startSeconds: secondsFromNanoseconds(timelineClip.startNanoseconds),
      endSeconds: secondsFromNanoseconds(timelineClip.endNanoseconds),
      showsAiBadge: timelineClip.showsToolMark,
      isDashed: false,
      hasLabel: timelineClip.labelValueId.isNotEmpty,
    );
  }

  double get trackWidth {
    final width = spanSeconds * pixelsPerSecond;
    if (width < MIN_TRACK_WIDTH) {
      return MIN_TRACK_WIDTH;
    }
    return width;
  }

  Future<void> loadAttachments() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _overlayEpoch += 1;
    notifyListeners();
    if (jobId.isEmpty) {
      _timeline = JobTimeline.empty;
      _attachments = const [];
      _bars = const [];
      _framesByAssetId.clear();
      _cuesByAssetId.clear();
      _noticeText = '작업을 열지 못했습니다.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    try {
      _timeline = await _getJobTimelineUseCase.execute(jobId: jobId);
      final name = _timeline.name.trim();
      if (_workName.isEmpty && name.isNotEmpty) {
        _workName = name;
      }
      notifyListeners();
    } on JobTimelineException catch (error) {
      _hasError = true;
      _errorMessage = error.message;
      _timeline = JobTimeline.empty;
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _timeline = JobTimeline.empty;
    }
    try {
      _attachments = await _listHistoryWorkAttachmentsUseCase.execute(
        jobId: jobId,
      );
      _bars = [
        ..._chain(_attachments, WorkAttachmentType.video),
        ..._chain(_attachments, WorkAttachmentType.audio),
      ];
      _side = VideoMultimodalSide.assets;
    } catch (error) {
      _attachments = const [];
      _bars = const [];
      if (!_hasError) {
        _noticeText = error.toString();
      }
    }
    await _loadProjectId();
    await _loadOverlayBodies();
    await loadLabelSections();
    try {
      await _restoreActiveToolRun();
    } on ToolRunException catch (error) {
      if (_noticeText.isEmpty) {
        _noticeText = error.message;
      }
    } catch (error) {
      if (_noticeText.isEmpty) {
        _noticeText = error.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void didTapToggleLane(String attachmentId) {
    if (_hiddenAttachmentIds.contains(attachmentId)) {
      _hiddenAttachmentIds.remove(attachmentId);
    } else {
      _hiddenAttachmentIds.add(attachmentId);
    }
    _playhead.clampToSpan(spanSeconds);
    notifyListeners();
  }

  bool isBarHidden(String attachmentId) {
    return _hiddenAttachmentIds.contains(attachmentId);
  }

  void didChangeAssetsSearch(String query) {
    _assetsSearchQuery = query;
    notifyListeners();
  }

  /// 가이드 §6·§6.2: `T`는 틱만. 파일 시계는 드리프트 시 seek만. 비포커스 무시.
  void didReceiveVideoClock({
    required String mediaUrl,
    required double localSeconds,
    required bool isPlaying,
    String trackId = '',
  }) {
    if (!_playhead.wantsPlayback || _doesPrimaryCoveringNeedStepSeek()) {
      return;
    }
    final clip = _clockClipForVideo(mediaUrl: mediaUrl, trackId: trackId);
    if (clip == null) {
      return;
    }
    final expected = clipFilePositionAt(
      clip: _playbackInput(clip),
      playheadSeconds: playheadSeconds,
    );
    if (expected == null) {
      return;
    }
    if (!doesFileDriftBeyond(
      fileSeconds: localSeconds,
      expectedFileSeconds: expected.fileSeconds,
    )) {
      return;
    }
    _seekToken += 1;
    notifyListeners();
  }

  TimelineClip? _clockClipForVideo({
    required String mediaUrl,
    required String trackId,
  }) {
    if (monitoredTrackIds.isNotEmpty) {
      final focusedId = focusedMonitorTrackId;
      if (trackId.isEmpty || trackId != focusedId) {
        return null;
      }
      final clip = _coveringVideoOnTrack(focusedId, playheadSeconds);
      if (clip == null || clip.playbackUrl != mediaUrl) {
        return null;
      }
      return clip;
    }
    final playing = _activeVideoClip();
    if (playing == null || playing.playbackUrl != mediaUrl) {
      return null;
    }
    return playing;
  }

  void _logMonitor(
    String reason, {
    required String sourceTrackId,
    required String focusedId,
    required bool isPlaying,
    double localSeconds = 0,
    bool throttle = false,
  }) {
    if (!kDebugMode) {
      return;
    }
    if (throttle) {
      final now = DateTime.now();
      if (now.difference(_lastMonitorDebugAt) < _MONITOR_DEBUG_INTERVAL) {
        return;
      }
      _lastMonitorDebugAt = now;
    }
    debugPrint(
      '[MONITOR] $reason '
      'src=$sourceTrackId focus=$focusedId '
      'playhead=${playheadSeconds.toStringAsFixed(3)} '
      'local=${localSeconds.toStringAsFixed(3)} playing=$isPlaying '
      'wants=${_playhead.wantsPlayback} monitored=$monitoredTrackIds',
    );
  }

  int fileSeekMilliseconds(TemporaryAttachmentBar video) {
    final clip = _clipForBar(video);
    return fileSeekMillisecondsAt(
      clip: clip == null ? null : _playbackInput(clip),
      playheadSeconds: playheadSeconds,
      fallbackLocalSeconds: playheadSeconds - video.startSeconds,
    );
  }

  double playbackRateFor(TemporaryAttachmentBar video) {
    final clip = _clipForBar(video);
    return playbackRateAt(
      clip: clip == null ? null : _playbackInput(clip),
      playheadSeconds: playheadSeconds,
      timelinePlaybackRate: timelinePlaybackRate,
    );
  }

  int? fileContentEndMilliseconds(TemporaryAttachmentBar video) {
    final clip = _clipForBar(video);
    if (clip == null) {
      return null;
    }
    return clipFileContentEndMilliseconds(clip: _playbackInput(clip));
  }

  bool doesPlaybackUseStepSeek(TemporaryAttachmentBar video) {
    return doesRequireStepSeek(playbackRateFor(video));
  }

  void didTapCycleTimelinePlaybackRate() {
    _playhead.cycleTimelinePlaybackRate();
    _playbackToken += 1;
    _coveringVideoClipId = '';
    _syncPlayheadClock();
    notifyListeners();
  }

  void didSelectSampleClip(String clipId) {
    final timelineClip = _timelineClip(clipId);
    if (timelineClip == null) {
      return;
    }
    _selectedClipId = clipId;
    _clearPosePlayback();
    _side = VideoMultimodalSide.properties;
    if (timelineClip.kind == TimelineClipKind.timeseries) {
      if (_chartExpandedClipId != clipId) {
        _expandTimeseriesChart(timelineClip);
      }
    } else {
      _collapseTimeseriesChart();
    }
    didSeekToSeconds(secondsFromNanoseconds(timelineClip.startNanoseconds));
    unawaited(_loadClipDetail(clipId));
  }

  Future<void> _loadClipDetail(String clipId) async {
    final epoch = ++_clipDetailEpoch;
    _isClipDetailLoading = true;
    _clipDetailMessage = '';
    _clipDetail = null;
    notifyListeners();
    try {
      final detail = await _getClipUseCase.execute(clipId: clipId);
      if (epoch != _clipDetailEpoch || _isClosed) {
        return;
      }
      _clipDetail = detail;
      if (detail.isPose) {
        await _startPosePlayback(detail, epoch);
      } else {
        _startVideoRange(detail);
      }
      if (epoch != _clipDetailEpoch || _isClosed) {
        return;
      }
    } on JobTimelineException catch (error) {
      if (epoch != _clipDetailEpoch || _isClosed) {
        return;
      }
      _clipDetailMessage = error.message;
      if (_clipDetail?.isPose == true) {
        debugPrint('[POSE] clipId=$clipId failed: ${error.message}');
      }
    } catch (error) {
      if (epoch != _clipDetailEpoch || _isClosed) {
        return;
      }
      _clipDetailMessage = error.toString();
      if (_clipDetail?.isPose == true) {
        debugPrint('[POSE] clipId=$clipId failed: $error');
      }
    }
    _isClipDetailLoading = false;
    notifyListeners();
  }

  void _startVideoRange(ClipDetail detail) {
    if (!detail.isVideo) {
      return;
    }
    final clip = _timelineClip(detail.clipId);
    if (clip == null || clip.playbackUrl.isEmpty) {
      return;
    }
    final startNs = detail.timelineStartNs.isEmpty
        ? clip.startNs
        : detail.timelineStartNs;
    final endNs = detail.timelineEndNs.isEmpty
        ? clip.endNs
        : detail.timelineEndNs;
    if (!isOpenNanosecondInterval(startNs, endNs)) {
      return;
    }
    _playbackToken += 1;
    didSeekToSeconds(secondsFromNanoseconds(startNs), resumePlayback: true);
  }

  Future<void> _startPosePlayback(ClipDetail pose, int epoch) async {
    debugPrint(
      '[POSE] clipId=${pose.clipId} poseAssetId=${pose.assetId} '
      'hasPoseUrl=${pose.assetContentUrl.isNotEmpty}',
    );
    debugPrint(
      '[POSE] hasTargetClip=${pose.hasTargetClip} '
      'targetClipId=${pose.targetClipId} '
      'targetKind=${pose.targetClipKind} '
      'hasTargetAsset=${pose.hasTargetAsset} '
      'targetAssetId=${pose.targetAssetId} '
      'hasVideoUrl=${pose.targetAssetContentUrl.isNotEmpty}',
    );
    if (!pose.hasAsset) {
      _failPose(pose, '포즈 클립이 가리키는 파일이 없습니다.');
      return;
    }
    if (!pose.hasTargetClip) {
      _failPose(pose, '포즈의 대상 영상 클립이 없습니다.');
      return;
    }
    if (pose.targetClipKind != 'VIDEO') {
      _failPose(pose, '포즈의 대상 클립이 영상이 아닙니다.');
      return;
    }
    if (pose.assetContentUrl.isEmpty) {
      _failPose(pose, '포즈 좌표 파일 주소가 없습니다.');
      return;
    }
    if (!isOpenNanosecondInterval(pose.timelineStartNs, pose.timelineEndNs)) {
      _failPose(pose, '포즈 클립의 시간 구간이 올바르지 않습니다.');
      return;
    }

    if (!pose.hasTargetAsset) {
      _failPose(pose, '포즈의 대상 영상 파일이 없습니다.');
      return;
    }
    if (pose.targetAssetContentUrl.isEmpty) {
      _failPose(pose, '대상 영상의 재생 주소가 없습니다.');
      return;
    }
    if (!isOpenNanosecondInterval(
      pose.targetTimelineStartNs,
      pose.targetTimelineEndNs,
    )) {
      _failPose(pose, '대상 영상의 시간 구간이 올바르지 않습니다.');
      return;
    }
    final placed = _timelineClip(pose.targetClipId);
    final video = TimelineClip(
      clipId: pose.targetClipId,
      trackId: placed?.trackId ?? '',
      kind: TimelineClipKind.video,
      startNs: pose.targetTimelineStartNs,
      endNs: pose.targetTimelineEndNs,
      assetId: pose.targetAssetId,
      fileName: pose.targetAssetFileName,
      playbackUrl: pose.targetAssetContentUrl,
      description: '',
      showsToolBadge: false,
      sourceStartNs: placed?.sourceStartNs ?? '',
      sourceEndNs: placed?.sourceEndNs ?? '',
      assetDurationNs: placed?.assetDurationNs ?? '',
      assetStartTimeNs: placed?.assetStartTimeNs ?? '',
    );

    final poseOverlapsVideo = _intervalsOverlap(
      pose.timelineStartNs,
      pose.timelineEndNs,
      video.startNs,
      video.endNs,
    );
    final overlayStartNs = poseOverlapsVideo
        ? pose.timelineStartNs
        : video.startNs;
    final overlayEndNs = poseOverlapsVideo ? pose.timelineEndNs : video.endNs;
    if (!poseOverlapsVideo) {
      debugPrint(
        '[POSE] timeline does not overlap target video; '
        'aligning pose content to video start',
      );
    }

    _playbackVideoClip = video;
    _playbackToken += 1;
    didSeekToSeconds(
      secondsFromNanoseconds(overlayStartNs),
      resumePlayback: true,
    );

    debugPrint('[POSE] loading pose content: assetId=${pose.assetId}');
    final body = await _getJobTimelineUseCase.readContent(
      url: pose.assetContentUrl,
    );
    if (epoch != _clipDetailEpoch || _isClosed) {
      debugPrint('[POSE] stale pose content ignored: ${pose.clipId}');
      return;
    }
    final frames = parsePoseOverlay(body);
    debugPrint(
      '[POSE] pose content loaded: clipId=${pose.clipId} '
      'bytes=${body.length} frames=${frames.length}',
    );
    if (frames.isEmpty) {
      _failPose(pose, '포즈 좌표 파일을 읽지 못했거나 표시할 좌표가 없습니다.');
      return;
    }
    _selectedPoseOverlay = TimelineOverlay(
      assetId: pose.assetId,
      kind: TimelineOverlayKind.pose,
      contentUrl: pose.assetContentUrl,
      timelineStartNs: overlayStartNs,
      timelineEndNs: overlayEndNs,
      sourceStartNs: pose.sourceStartNs,
      sourceEndNs: pose.sourceEndNs,
    );
    _selectedPoseFrames = frames;
    final visibleFrames = activeVideoOverlayFrames;
    final videoBar = activeVideoBar;
    final localMs = videoBar == null
        ? -1
        : ((playheadSeconds - videoBar.startSeconds) * 1000).round();
    final position = Duration(milliseconds: localMs < 0 ? 0 : localMs);
    var hits = 0;
    var boxCount = 0;
    var pointCount = 0;
    var boneCount = 0;
    for (final frame in visibleFrames) {
      boxCount += frame.boxes.length;
      pointCount += frame.points.length;
      boneCount += frame.bones.length;
      if (localMs >= 0 && frame.contains(position)) {
        hits += 1;
      }
    }
    final first = visibleFrames.isEmpty ? null : visibleFrames.first;
    debugPrint(
      '[POSE] overlay ready: clipId=${pose.clipId} '
      'mappedFrames=${visibleFrames.length} '
      'alignedToVideo=${!poseOverlapsVideo}',
    );
    debugPrint(
      '[POSE] draw source: clipId=${pose.clipId} '
      'boxes=$boxCount points=$pointCount bones=$boneCount '
      'first=${first?.start.inMilliseconds ?? '-'}'
      '-${first?.end.inMilliseconds ?? '-'}ms '
      'playheadLocalMs=$localMs hitsAtPlayhead=$hits '
      'videoBar=${videoBar != null}',
    );
  }

  bool _intervalsOverlap(
    String firstStartNs,
    String firstEndNs,
    String secondStartNs,
    String secondEndNs,
  ) {
    final firstStart = secondsFromNanoseconds(firstStartNs);
    final firstEnd = secondsFromNanoseconds(firstEndNs);
    final secondStart = secondsFromNanoseconds(secondStartNs);
    final secondEnd = secondsFromNanoseconds(secondEndNs);
    return firstStart < secondEnd && secondStart < firstEnd;
  }

  void _failPose(ClipDetail pose, String message) {
    _clipDetailMessage = message;
    debugPrint('[POSE] clipId=${pose.clipId} failed: $message');
  }

  TimelineClip? _activeVideoClip() {
    final selected = _timelineClip(_selectedClipId);
    if (selected?.kind == TimelineClipKind.pose) {
      final playback = _playbackVideoClip;
      if (playback != null && _clipCovers(playback, playheadSeconds)) {
        return playback;
      }
      return null;
    }
    return _videoOnSelectedTrack(playheadSeconds);
  }

  TimelineClip? _videoOnSelectedTrack(double seconds) {
    return _coveringVideoOnTrack(_resolvedTrackId(seconds), seconds);
  }

  /// 고른 클립이 없으면 플레이헤드를 덮는 영상이 있는 가장 위 트랙이다.
  String _resolvedTrackId(double seconds) {
    final selected = _timelineClip(_selectedClipId);
    if (selected != null && selected.trackId.isNotEmpty) {
      return selected.trackId;
    }
    for (final track in timelineTracks) {
      if (_coveringVideoOnTrack(track.trackId, seconds) != null) {
        return track.trackId;
      }
    }
    return '';
  }

  TimelineClip? _coveringVideoOnTrack(String trackId, double seconds) {
    if (trackId.isEmpty) {
      return null;
    }
    final covering = <TimelineClip>[];
    for (final clip in timelineClips) {
      if (clip.trackId != trackId ||
          clip.kind != TimelineClipKind.video ||
          clip.playbackUrl.isEmpty ||
          !_clipCovers(clip, seconds)) {
        continue;
      }
      covering.add(clip);
    }
    if (covering.isEmpty) {
      return null;
    }
    final selected = _timelineClip(_selectedClipId);
    if (selected != null &&
        covering.any((clip) => clip.clipId == selected.clipId)) {
      return selected;
    }
    covering.sort((left, right) => _compareClipId(right, left));
    return covering.first;
  }

  int _compareClipId(TimelineClip left, TimelineClip right) {
    final leftId = BigInt.tryParse(left.clipId);
    final rightId = BigInt.tryParse(right.clipId);
    if (leftId != null && rightId != null) {
      return leftId.compareTo(rightId);
    }
    return left.clipId.compareTo(right.clipId);
  }

  TimelineClip? _clipForBar(TemporaryAttachmentBar video) {
    // 모니터 칸은 트랙별 클립 id를 쓴다. mediaUrl만 같다고 선택 트랙으로 바꾸지 않는다.
    final byId = _timelineClip(video.attachmentId);
    if (byId != null) {
      return byId;
    }
    final playing = _activeVideoClip();
    if (playing != null && playing.playbackUrl == video.mediaUrl) {
      return playing;
    }
    return null;
  }

  ClipPlaybackInput _playbackInput(TimelineClip clip) {
    return ClipPlaybackInput(
      timelineStartNs: clip.startNs,
      timelineEndNs: clip.endNs,
      sourceStartNs: clip.sourceStartNs,
      sourceEndNs: clip.sourceEndNs,
      assetDurationNs: clip.assetDurationNs,
      assetStartTimeNs: clip.assetStartTimeNs,
    );
  }

  void _dropClipDetail() {
    _clipDetailEpoch += 1;
    _isClipDetailLoading = false;
    _clipDetailMessage = '';
    _clipDetail = null;
    _clearPosePlayback();
  }

  void _clearPosePlayback() {
    _playbackVideoClip = null;
    _selectedPoseOverlay = null;
    _selectedPoseFrames = const [];
    _playhead.pause();
    _playbackToken += 1;
  }

  void didClearTimelineHint() {
    if (_timelineHint.isEmpty) {
      return;
    }
    _timelineHint = '';
    notifyListeners();
  }

  Future<void> didSendAsk(String text) async {
    final question = text.trim();
    if (question.isEmpty || _isAsking || _isClosed) {
      return;
    }
    _askTurns.add(AskTurn(isUser: true, text: question));
    _isAsking = true;
    notifyListeners();
    try {
      if (_projectId.isEmpty) {
        await _loadProjectId();
      }
      final answer = await _askQuestionUseCase.execute(
        projectId: _projectId,
        question: question,
        sessionId: _askSessionId,
      );
      if (_isClosed) {
        return;
      }
      if (answer.sessionId.isNotEmpty) {
        _askSessionId = answer.sessionId;
        await _askSessionStore.writeSessionId(
          jobId: jobId,
          sessionId: answer.sessionId,
        );
      }
      final answerText = answer.answer.trim();
      _askTurns.add(
        AskTurn(
          isUser: false,
          text: answerText.isEmpty ? '답변이 없습니다.' : answerText,
          citations: answer.citations,
        ),
      );
    } on AskException catch (error) {
      if (_isClosed) {
        return;
      }
      _askTurns.add(AskTurn(isUser: false, text: error.message));
    } catch (_) {
      if (_isClosed) {
        return;
      }
      _askTurns.add(const AskTurn(isUser: false, text: '질의에 답하지 못했습니다.'));
    } finally {
      _isAsking = false;
      if (!_isClosed) {
        notifyListeners();
      }
    }
  }

  Future<void> _loadProjectId() async {
    if (jobId.isEmpty) {
      return;
    }
    try {
      final projectId = await _loadJobProjectIdUseCase.execute(jobId: jobId);
      if (!_isClosed && projectId.isNotEmpty) {
        _projectId = projectId;
      }
    } catch (_) {
      return;
    }
  }

  void didTapCitation(AskCitation citation) {
    _logCitationClipMatch(citation);
    _selectCitationClip(citation);
    if (_citationVideo(citation) == null) {
      _noticeText = '이 근거 영상을 열 수 없습니다.';
      notifyListeners();
      return;
    }
    _noticeText = '';
    _playbackToken += 1;
    didSeekToSeconds(citation.startSeconds, resumePlayback: true);
  }

  Future<bool> didLikeCitation(AskCitation citation) {
    return _saveCitationFeedback(
      citation: citation,
      trackName: LIKE_TRACK_NAME,
      description: _citationFeedbackText(citation, LIKE_TRACK_NAME),
    );
  }

  Future<bool> didDislikeCitation(AskCitation citation) {
    return _saveCitationFeedback(
      citation: citation,
      trackName: DISLIKE_TRACK_NAME,
      description: _citationFeedbackText(citation, DISLIKE_TRACK_NAME),
    );
  }

  Future<bool> didCommentCitation(AskCitation citation, String comment) {
    final text = comment.trim();
    if (text.isEmpty) {
      return Future.value(false);
    }
    return _saveCitationFeedback(
      citation: citation,
      trackName: COMMENT_TRACK_NAME,
      description: text,
    );
  }

  String _citationFeedbackText(AskCitation citation, String fallback) {
    final text = citation.text.trim();
    if (text.isEmpty) {
      return fallback;
    }
    return text;
  }

  Future<bool> _saveCitationFeedback({
    required AskCitation citation,
    required String trackName,
    required String description,
  }) async {
    final startNs = nanosecondsFromSeconds(citation.startSeconds);
    final endNs = nanosecondsFromSeconds(citation.endSeconds);
    if (!isOpenNanosecondInterval(startNs, endNs)) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return false;
    }
    final labelValueId = await _citationFeedbackLabelId(trackName);
    if (labelValueId == null) {
      return false;
    }
    final trackId = await _ensureTrackId(trackName);
    if (trackId == null) {
      return false;
    }
    return createTimelineClip(
      trackId: trackId,
      kind: TimelineClipKind.tag,
      startNs: startNs,
      endNs: endNs,
      labelValueId: labelValueId,
      description: description,
    );
  }

  Future<String?> _citationFeedbackLabelId(String name) async {
    final cached = _labelIdByName(name);
    if (cached != null) {
      return cached;
    }
    try {
      final roots = await _labelUseCase.listLabels();
      if (_isClosed) {
        return null;
      }
      _labelRoots = roots;
      final listed = _labelIdByName(name);
      if (listed != null) {
        return listed;
      }
      final node = await _labelUseCase.createValue(name: name);
      if (_isClosed) {
        return null;
      }
      _labelRoots = insertLabelNode(_labelRoots, node);
      if (node.valueId.isEmpty) {
        return null;
      }
      return node.valueId;
    } on LabelException catch (error) {
      if (_isClosed) {
        return null;
      }
      _timelineHint = error.message;
      notifyListeners();
      return null;
    } catch (error) {
      if (_isClosed) {
        return null;
      }
      _timelineHint = error.toString();
      notifyListeners();
      return null;
    }
  }

  String? _labelIdByName(String name) {
    return _labelIdIn(_labelRoots, name);
  }

  String? _labelIdIn(List<LabelNode> nodes, String name) {
    for (final node in nodes) {
      if (node.name.trim() == name && node.valueId.isNotEmpty) {
        return node.valueId;
      }
      final child = _labelIdIn(node.children, name);
      if (child != null) {
        return child;
      }
    }
    return null;
  }

  Future<String?> _ensureTrackId(String name) async {
    final existing = _trackIdByName(name);
    if (existing != null) {
      return existing;
    }
    final didCreate = await createTimelineTrack(name: name);
    if (!didCreate) {
      return null;
    }
    return _trackIdByName(name);
  }

  String? _trackIdByName(String name) {
    for (final track in _timeline.tracks) {
      if (track.name.trim() == name && track.trackId.isNotEmpty) {
        return track.trackId;
      }
    }
    return null;
  }

  void _logCitationClipMatch(AskCitation citation) {
    if (!kDebugMode) {
      return;
    }
    final matched = citation.segmentId.isEmpty
        ? null
        : _timelineClip(citation.segmentId);
    final clipIds = [for (final clip in timelineClips) clip.clipId].join(', ');
    debugPrint(
      'citation segmentId=${citation.segmentId} '
      'matchedClipId=${matched?.clipId ?? ''} '
      'clipIds=[$clipIds]',
    );
  }

  void _selectCitationClip(AskCitation citation) {
    if (citation.segmentId.isEmpty) {
      return;
    }
    final named = _timelineClip(citation.segmentId);
    if (named == null) {
      return;
    }
    _selectedClipId = named.clipId;
  }

  TimelineClip? _citationVideo(AskCitation citation) {
    final named = _timelineClip(citation.segmentId);
    if (named != null &&
        named.kind == TimelineClipKind.video &&
        named.playbackUrl.isNotEmpty &&
        _clipCovers(named, citation.startSeconds)) {
      return named;
    }
    return _videoClipAt(citation.startSeconds);
  }

  bool _clipCovers(TimelineClip clip, double seconds) {
    final start = secondsFromNanoseconds(clip.startNanoseconds);
    final end = secondsFromNanoseconds(clip.endNanoseconds);
    return seconds >= start && seconds < end;
  }

  void didSelectLabelValue(String valueId) {
    _selectedLabelValueId = valueId;
    _timelineHint = '';
    notifyListeners();
  }

  Future<void> didAttachLabelToSelectedClip() {
    if (!canAttachLabelToSelection) {
      return Future.value();
    }
    return updateTimelineClip(
      clipId: _selectedClipId,
      labelValueId: _selectedLabelValueId,
    );
  }

  Future<void> didDetachLabelFromSelectedClip() {
    if (!canDetachLabelFromSelection) {
      return Future.value();
    }
    return updateTimelineClip(clipId: _selectedClipId, labelValueId: '0');
  }

  String _labelName(String valueId) => labelNameFrom(_labelRoots, valueId);

  Future<bool> didAddLabelValue({
    required String name,
    String parentValueId = '',
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return false;
    }
    try {
      final node = await _labelUseCase.createValue(
        name: trimmed,
        parentValueId: parentValueId,
      );
      if (_isClosed) {
        return false;
      }
      _labelRoots = insertLabelNode(_labelRoots, node);
      _labelMessage = '';
      notifyListeners();
      return true;
    } on LabelException catch (error) {
      if (_isClosed) {
        return false;
      }
      _labelMessage = error.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> didRenameLabelValue({
    required String valueId,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (valueId.isEmpty || trimmed.isEmpty) {
      return;
    }
    try {
      final node = await _labelUseCase.renameValue(
        valueId: valueId,
        name: trimmed,
      );
      if (_isClosed) {
        return;
      }
      _labelRoots = renameLabelNode(_labelRoots, node.valueId, node.name);
      _labelMessage = '';
      notifyListeners();
    } on LabelException catch (error) {
      if (_isClosed) {
        return;
      }
      _labelMessage = error.message;
      notifyListeners();
    }
  }

  Future<void> didDeprecateLabelValue({required String valueId}) async {
    if (valueId.isEmpty) {
      return;
    }
    try {
      await _labelUseCase.deprecateValue(valueId: valueId);
      if (_isClosed) {
        return;
      }
      _labelRoots = removeLabelNode(_labelRoots, valueId);
      if (_selectedLabelValueId == valueId) {
        _selectedLabelValueId = '';
      }
      _labelMessage = '';
      notifyListeners();
    } on LabelException catch (error) {
      if (_isClosed) {
        return;
      }
      _labelMessage = error.message;
      notifyListeners();
    }
  }

  Future<void> loadLabelSections() async {
    final epoch = ++_labelEpoch;
    _isLoadingLabels = true;
    _labelMessage = '';
    notifyListeners();
    try {
      final roots = await _labelUseCase.listLabels();
      if (epoch != _labelEpoch || _isClosed) {
        return;
      }
      _labelRoots = roots;
    } on LabelException catch (error) {
      if (epoch != _labelEpoch || _isClosed) {
        return;
      }
      _labelMessage = error.message;
    } catch (error) {
      if (epoch != _labelEpoch || _isClosed) {
        return;
      }
      _labelMessage = error.toString();
    } finally {
      if (epoch == _labelEpoch && !_isClosed) {
        _isLoadingLabels = false;
        notifyListeners();
      }
    }
  }

  Future<List<InferenceTool>> loadInferenceTools() {
    return _toolRunUseCase.listEnabledTools();
  }

  Future<void> didStartInference({
    required String toolId,
    required String toolName,
    bool isSpeechToText = false,
  }) async {
    final epoch = ++_toolRunEpoch;
    _activeRunId = '';
    _inferenceModelName = toolName;
    _inferenceMessage = '';
    _inferenceProgressPercent = 0;
    _inferenceRemainingSeconds = 0;
    _isInferenceMinimized = false;
    if (isSpeechToText && _isDepthVideo(_selectedTargetFileName())) {
      _inferencePhase = InferencePanelPhase.failed;
      _inferenceMessage = '깊이 영상에는 소리가 없어 STT를 실행할 수 없습니다.';
      notifyListeners();
      return;
    }
    _inferencePhase = InferencePanelPhase.queued;
    notifyListeners();
    try {
      final run = await _toolRunUseCase.start(
        toolId: toolId,
        jobId: jobId,
        clipId: isSelectedServerClip ? _selectedClipId : '',
        assetId: isSelectedServerClip ? '' : _selectedAttachmentId,
      );
      if (epoch != _toolRunEpoch || _isClosed) {
        return;
      }
      if (run.runId.isEmpty) {
        _inferencePhase = InferencePanelPhase.failed;
        _inferenceMessage = '실행을 만들지 못했습니다.';
        notifyListeners();
        return;
      }
      _activeRunId = run.runId;
      _inferencePhase = InferencePanelPhase.queued;
      _inferenceMessage = '';
      notifyListeners();
      unawaited(_followToolRun(epoch));
    } on ToolRunException catch (error) {
      if (epoch != _toolRunEpoch || _isClosed) {
        return;
      }
      _inferencePhase = InferencePanelPhase.failed;
      _inferenceMessage = error.message;
      notifyListeners();
    }
  }

  Future<void> didCancelInference() async {
    final runId = _activeRunId;
    if (runId.isEmpty) {
      return;
    }
    final epoch = ++_toolRunEpoch;
    try {
      final run = await _toolRunUseCase.cancel(runId: runId);
      if (epoch != _toolRunEpoch || _isClosed) {
        return;
      }
      if (run.isInProgress) {
        _rememberOpenRun(run);
        unawaited(_followToolRun(epoch));
        return;
      }
      await _finishToolRun(run, epoch);
    } on ToolRunException catch (error) {
      if (epoch != _toolRunEpoch || _isClosed) {
        return;
      }
      _inferencePhase = InferencePanelPhase.failed;
      _inferenceMessage = error.message;
      notifyListeners();
    }
  }

  void didOpenCameraRecording() {
    if (_isCameraRecordingOpen) {
      return;
    }
    _isCameraRecordingOpen = true;
    _isCameraRecordingMinimized = false;
    notifyListeners();
  }

  void didCloseCameraRecording() {
    if (!_isCameraRecordingOpen) {
      return;
    }
    _isCameraRecordingOpen = false;
    notifyListeners();
  }

  void didMoveCameraRecording(double dx, double dy) {
    _cameraRecordingOffsetX = (_cameraRecordingOffsetX + dx).clamp(0, 1200);
    _cameraRecordingOffsetY = (_cameraRecordingOffsetY + dy).clamp(0, 800);
    notifyListeners();
  }

  void didToggleCameraRecordingMinimized() {
    _isCameraRecordingMinimized = !_isCameraRecordingMinimized;
    notifyListeners();
  }

  void didCloseInference() {
    _toolRunEpoch += 1;
    _activeRunId = '';
    _inferenceMessage = '';
    _inferencePhase = InferencePanelPhase.hidden;
    notifyListeners();
  }

  void didMoveInference(double dx, double dy) {
    _inferenceOffsetX = (_inferenceOffsetX + dx).clamp(0, 1200);
    _inferenceOffsetY = (_inferenceOffsetY + dy).clamp(0, 800);
    notifyListeners();
  }

  void didToggleInferenceMinimized() {
    _isInferenceMinimized = !_isInferenceMinimized;
    notifyListeners();
  }

  void didTapBar(String attachmentId) {
    WorkAttachment? attachment;
    for (final candidate in _attachments) {
      if (candidate.attachmentId == attachmentId) {
        attachment = candidate;
        break;
      }
    }
    TemporaryAttachmentBar? bar;
    for (final candidate in _bars) {
      if (candidate.attachmentId == attachmentId) {
        bar = candidate;
        break;
      }
    }
    if (attachment == null && bar == null) {
      return;
    }
    _selectedAttachmentId = attachmentId;
    if (_timelineClip(_selectedClipId) == null) {
      _selectedClipId = '';
    }
    _side = VideoMultimodalSide.properties;
    _isLaneMenuOpen = false;
    if (bar != null) {
      didSeekToSeconds(bar.startSeconds);
      return;
    }
    notifyListeners();
  }

  void didTapRefresh() {
    loadAttachments();
  }

  void didTapToggleAssets() {
    _toggleSide(VideoMultimodalSide.assets);
  }

  void didTapToggleProperties() {
    _toggleSide(VideoMultimodalSide.properties);
  }

  Future<void> didTapToggleAsk() async {
    final willOpen = _side != VideoMultimodalSide.ask;
    _toggleSide(VideoMultimodalSide.ask);
    if (willOpen) {
      await _restoreAskSessionId();
      await _loadAskHistory();
    }
  }

  Future<void> _restoreAskSessionId() async {
    if (_askSessionId.isNotEmpty || jobId.isEmpty || _isClosed) {
      return;
    }
    final saved = await _askSessionStore.readSessionId(jobId: jobId);
    if (_isClosed || saved.isEmpty) {
      return;
    }
    _askSessionId = saved;
  }

  Future<void> _loadAskHistory() async {
    if (_askSessionId.isEmpty ||
        _isLoadingAskHistory ||
        _isAsking ||
        _isClosed) {
      return;
    }
    _isLoadingAskHistory = true;
    notifyListeners();
    try {
      final history = await _getSessionHistoryUseCase.execute(
        sessionId: _askSessionId,
      );
      if (_isClosed) {
        return;
      }
      if (history.sessionId.isNotEmpty) {
        _askSessionId = history.sessionId;
        await _askSessionStore.writeSessionId(
          jobId: jobId,
          sessionId: history.sessionId,
        );
      }
      _askTurns
        ..clear()
        ..addAll([
          for (final message in history.messages)
            AskTurn(
              isUser: message.isUser,
              text: message.text.trim().isEmpty && !message.isUser
                  ? '답변이 없습니다.'
                  : message.text,
              citations: message.citations,
            ),
        ]);
    } on AskException {
      await _clearAskSession();
    } catch (_) {
      await _clearAskSession();
    } finally {
      _isLoadingAskHistory = false;
      if (!_isClosed) {
        notifyListeners();
      }
    }
  }

  Future<void> _clearAskSession() async {
    _askSessionId = '';
    if (jobId.isNotEmpty) {
      await _askSessionStore.clearSessionId(jobId: jobId);
    }
  }

  void didTapToggleLabels() {
    final willOpen = _side != VideoMultimodalSide.labels;
    _toggleSide(VideoMultimodalSide.labels);
    if (willOpen) {
      unawaited(loadLabelSections());
    }
  }

  void didShowNotice(String text) {
    _noticeText = text;
    notifyListeners();
  }

  void didTapPendingAction(String actionLabel) {
    _noticeText = '$actionLabel은 이 화면에서 아직 연결하지 않았습니다.';
    notifyListeners();
  }

  void _toggleSide(VideoMultimodalSide next) {
    _side = _side == next ? VideoMultimodalSide.none : next;
    _isLaneMenuOpen = false;
    notifyListeners();
  }

  void didTapCloseSide() {
    if (_side == VideoMultimodalSide.none) {
      return;
    }
    _side = VideoMultimodalSide.none;
    notifyListeners();
  }

  void didSeekToSeconds(double seconds, {bool? resumePlayback}) {
    final wasPlaying =
        resumePlayback ?? (_playhead.wantsPlayback || _playhead.isPlaying);
    _playhead.seekTo(
      seconds,
      spanSeconds: spanSeconds,
      resumeIfWasPlaying: wasPlaying,
    );
    _coveringVideoClipId = '';
    _seekToken += 1;
    _playbackToken += 1;
    _syncPlayheadClock();
    _logPlayheadCovering(reason: 'seek');
    notifyListeners();
  }

  Future<void> didTapDeleteSelection() async {
    if (_selectedClipId.isEmpty) {
      return;
    }
    final clipId = _selectedClipId;
    if (_timelineClip(clipId) == null) {
      _selectedClipId = '';
      _dropClipDetail();
      notifyListeners();
      return;
    }
    final didSave = await _commitServerWrite(
      () => _deleteClipUseCase.execute(clipId: clipId),
      changedTrackCount: _changedClipTrackCount(clipId),
    );
    if (didSave) {
      _selectedClipId = '';
      _dropClipDetail();
      notifyListeners();
    }
  }

  Future<bool> createTimelineTrack({
    required String name,
    int? order,
    bool? isVisible,
  }) {
    return _commitServerWrite(
      () => _createTrackUseCase.execute(
        jobId: jobId,
        name: name,
        order: order,
        isVisible: isVisible,
      ),
      changedTrackCount: 1,
    );
  }

  Future<void> updateTimelineTrack({
    required String trackId,
    String? name,
    int? order,
    bool? isVisible,
  }) {
    return _commitServerWrite(
      () => _updateTrackUseCase.execute(
        trackId: trackId,
        name: name,
        order: order,
        isVisible: isVisible,
      ),
      changedTrackCount: 1,
    );
  }

  Future<void> deleteTimelineTrack(String trackId) {
    return _commitServerWrite(
      () => _deleteTrackUseCase.execute(trackId: trackId),
      changedTrackCount: 1,
    );
  }

  Future<bool> createTimelineClip({
    required String trackId,
    required TimelineClipKind kind,
    required String startNs,
    required String endNs,
    String assetId = '',
    String labelValueId = '',
    String description = '',
    String fromClipId = '',
    String toClipId = '',
    String sourceStartNs = '',
    String sourceEndNs = '',
    String sourceLimitNs = '',
  }) {
    return _commitServerWrite(
      () => _createClipUseCase.execute(
        trackId: trackId,
        kind: kind,
        startNs: startNs,
        endNs: endNs,
        assetId: assetId,
        labelValueId: labelValueId,
        description: description,
        fromClipId: fromClipId,
        toClipId: toClipId,
        sourceStartNs: sourceStartNs,
        sourceEndNs: sourceEndNs,
        sourceLimitNs: sourceLimitNs,
      ),
      changedTrackCount: 1,
    );
  }

  Future<void> updateTimelineClip({
    required String clipId,
    String? trackId,
    String? startNs,
    String? endNs,
    String? assetId,
    String? labelValueId,
    String? description,
    bool? isReviewed,
  }) {
    final clip = _timelineClip(clipId);
    if (clip == null) {
      return Future.value();
    }
    final nextTrackId = trackId == null || trackId == clip.trackId
        ? null
        : trackId;
    final nextStart = startNs == null || startNs == clip.startNs
        ? null
        : startNs;
    final nextEnd = endNs == null || endNs == clip.endNs ? null : endNs;
    final nextAssetId = assetId == null || assetId == clip.assetId
        ? null
        : assetId;
    final nextDescription =
        description == null || description == clip.description
        ? null
        : description;
    if (nextTrackId == null &&
        nextStart == null &&
        nextEnd == null &&
        nextAssetId == null &&
        labelValueId == null &&
        nextDescription == null &&
        isReviewed == null) {
      return Future.value();
    }
    final resolvedStart = nextStart ?? clip.startNs;
    final resolvedEnd = nextEnd ?? clip.endNs;
    if ((nextStart != null || nextEnd != null) &&
        !isOpenNanosecondInterval(resolvedStart, resolvedEnd)) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return Future.value();
    }
    return _commitServerWrite(
      () => _updateClipUseCase.execute(
        clipId: clipId,
        trackId: nextTrackId,
        startNs: nextStart,
        endNs: nextEnd,
        assetId: nextAssetId,
        labelValueId: labelValueId,
        description: nextDescription,
        isReviewed: isReviewed,
      ),
      changedTrackCount: _changedClipTrackCount(
        clipId,
        nextTrackId: nextTrackId,
      ),
    );
  }

  Future<String?> didSaveTimeline({
    required String name,
    required String description,
  }) async {
    final nextName = name.trim();
    if (nextName.isEmpty) {
      return '타임라인 이름을 입력하세요.';
    }
    final nextDescription = description.trim();
    final changedName = nextName == _timeline.name ? null : nextName;
    final changedDescription = nextDescription == _timeline.description
        ? null
        : nextDescription;
    if (changedName == null && changedDescription == null) {
      return null;
    }
    final didSave = await _commitServerWrite(
      () => _updateTimelineUseCase.execute(
        jobId: jobId,
        name: changedName,
        description: changedDescription,
      ),
      changedTrackCount: _changedTimelineTrackCount(),
    );
    if (didSave) {
      return null;
    }
    return _writeFailureMessage('타임라인을 저장하지 못했습니다.');
  }

  Future<String?> didDeleteTimeline() async {
    final didDelete = await _commitServerWrite(
      () => _deleteTimelineUseCase.execute(jobId: jobId),
      changedTrackCount: _changedTimelineTrackCount(),
    );
    if (!didDelete) {
      return _writeFailureMessage('타임라인을 지우지 못했습니다.');
    }
    _selectedClipId = '';
    _dropClipDetail();
    _relationAnchorClipId = '';
    _isRelationMode = false;
    notifyListeners();
    return null;
  }

  String _writeFailureMessage(String fallback) {
    return _timelineHint.isEmpty ? fallback : _timelineHint;
  }

  Future<void> changeTimelineStatus(JobTimelineStatus toStatus) {
    if (toStatus == _timeline.status) {
      return Future.value();
    }
    return _commitServerWrite(
      () => _changeTimelineStatusUseCase.execute(
        jobId: jobId,
        fromStatus: _timeline.status,
        toStatus: toStatus,
      ),
      changedTrackCount: _changedTimelineTrackCount(),
    );
  }

  Future<void> didSubmitNewTimelineTrack(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      _timelineHint = '트랙 이름을 입력하세요.';
      notifyListeners();
      return;
    }
    await createTimelineTrack(name: trimmed);
  }

  Future<void> didSubmitTimelineTrackName(String name) {
    final track = selectedServerTrack;
    if (track == null) {
      return Future.value();
    }
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      _timelineHint = '트랙 이름을 입력하세요.';
      notifyListeners();
      return Future.value();
    }
    if (trimmed == track.name.trim()) {
      return Future.value();
    }
    return updateTimelineTrack(trackId: track.trackId, name: trimmed);
  }

  Future<void> didTapDeleteSelectedTimelineTrack() async {
    final track = selectedServerTrack;
    if (track == null) {
      return;
    }
    final didSave = await _commitServerWrite(
      () => _deleteTrackUseCase.execute(trackId: track.trackId),
      changedTrackCount: 1,
    );
    if (didSave) {
      _selectedClipId = '';
      _dropClipDetail();
      notifyListeners();
    }
  }

  Future<void> didPlaceUploadedRecording({
    required String assetId,
    required bool isVideo,
  }) async {
    if (assetId.isEmpty) {
      return;
    }
    final didReload = await _replaceTimelineFromServer(clearHint: false);
    if (!didReload || _hasAssetClip(assetId)) {
      return;
    }
    try {
      _attachments = await _listHistoryWorkAttachmentsUseCase.execute(
        jobId: jobId,
      );
    } catch (_) {
      // 첨부 길이를 모르면 5초 클립으로 놓는다.
    }
    if (_isClosed) {
      return;
    }
    final trackName = isVideo
        ? RECORDING_VIDEO_TRACK_NAME
        : RECORDING_AUDIO_TRACK_NAME;
    final trackId = await _ensureTrackId(trackName);
    if (trackId == null) {
      return;
    }
    final attachment = _attachmentById(assetId);
    final durationNs = attachment?.durationNs.trim() ?? '';
    final hasDuration = durationNs.isNotEmpty && durationNs != '0';
    final startSeconds = playheadSeconds < 0 ? 0.0 : playheadSeconds;
    final startNs = nanosecondsFromSeconds(startSeconds);
    final String endNs;
    final String sourceStartNs;
    final String sourceEndNs;
    if (hasDuration) {
      endNs = addNanoseconds(startNs, durationNs);
      sourceStartNs = '0';
      sourceEndNs = durationNs;
      if (!sourceIntervalFitsAsset(
        sourceStartNs: sourceStartNs,
        sourceEndNs: sourceEndNs,
        assetDurationNs: durationNs,
      )) {
        _timelineHint = '소스 구간이 올바르지 않습니다.';
        notifyListeners();
        return;
      }
    } else {
      endNs = nanosecondsFromSeconds(
        startSeconds + DEFAULT_TIMELESS_CLIP_SECONDS,
      );
      sourceStartNs = '';
      sourceEndNs = '';
    }
    if (!isOpenNanosecondInterval(startNs, endNs)) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return;
    }
    await createTimelineClip(
      trackId: trackId,
      kind: isVideo ? TimelineClipKind.video : TimelineClipKind.audio,
      startNs: startNs,
      endNs: endNs,
      assetId: assetId,
      sourceStartNs: sourceStartNs,
      sourceEndNs: sourceEndNs,
      sourceLimitNs: hasDuration ? durationNs : '',
    );
  }

  bool _hasAssetClip(String assetId) {
    for (final track in _timeline.tracks) {
      for (final clip in track.clips) {
        if (clip.assetId == assetId) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> didCreateTimelineClipOnTrack({
    required String trackId,
    required WorkAttachment attachment,
    required double startSeconds,
  }) async {
    if (!isServerTimelineTrack(trackId) || attachment.attachmentId.isEmpty) {
      return;
    }
    if (startSeconds < 0) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return;
    }
    final startNs = nanosecondsFromSeconds(startSeconds);
    final durationNs = attachment.durationNs.trim();
    final hasDuration = durationNs.isNotEmpty && durationNs != '0';
    final String endNs;
    final String sourceStartNs;
    final String sourceEndNs;
    if (hasDuration) {
      endNs = addNanoseconds(startNs, durationNs);
      sourceStartNs = '0';
      sourceEndNs = durationNs;
      if (!sourceIntervalFitsAsset(
        sourceStartNs: sourceStartNs,
        sourceEndNs: sourceEndNs,
        assetDurationNs: durationNs,
      )) {
        _timelineHint = '소스 구간이 올바르지 않습니다.';
        notifyListeners();
        return;
      }
    } else {
      endNs = nanosecondsFromSeconds(
        startSeconds + DEFAULT_TIMELESS_CLIP_SECONDS,
      );
      sourceStartNs = '';
      sourceEndNs = '';
    }
    if (!isOpenNanosecondInterval(startNs, endNs)) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return;
    }
    final kind = _clipKindForAttachment(attachment);
    final didSave = await createTimelineClip(
      trackId: trackId,
      kind: kind,
      startNs: startNs,
      endNs: endNs,
      assetId: attachment.attachmentId,
      sourceStartNs: sourceStartNs,
      sourceEndNs: sourceEndNs,
      sourceLimitNs: hasDuration ? durationNs : '',
    );
    if (didSave) {
      _createdClipNotice = _noticeForCreatedClip(
        kind: kind,
        detail: attachment.fileName,
      );
    }
  }

  Future<void> didDropAsset({
    required String dragData,
    required String laneKey,
    required double startSeconds,
  }) {
    _createdClipNotice = null;
    if (dragData.startsWith('media:')) {
      didRejectMediaDrop();
      return Future.value();
    }
    final attachmentId = _attachmentIdFromDragData(dragData);
    if (isServerTimelineTrack(laneKey)) {
      if (attachmentId == null) {
        return Future.value();
      }
      final attachment = _attachmentById(attachmentId);
      if (attachment == null) {
        return Future.value();
      }
      return didCreateTimelineClipOnTrack(
        trackId: laneKey,
        attachment: attachment,
        startSeconds: startSeconds,
      );
    }
    return Future.value();
  }

  Future<void> didChooseTimelineStatus(JobTimelineStatus toStatus) {
    return changeTimelineStatus(toStatus);
  }

  void didTapSelectTool() {
    _isRelationMode = false;
    _relationAnchorClipId = '';
    _clearNotice();
    notifyListeners();
  }

  void didTapToggleRelationMode() {
    _isRelationMode = !_isRelationMode;
    _relationAnchorClipId = '';
    _noticeText = '';
    notifyListeners();
  }

  void didTapCancelRelationMode() {
    if (!_isRelationMode) {
      return;
    }
    _isRelationMode = false;
    _relationAnchorClipId = '';
    notifyListeners();
  }

  Future<bool> didTapClipForRelation(String clipId) async {
    _createdClipNotice = null;
    if (!_isRelationMode || clipId.isEmpty) {
      return false;
    }
    final clip = _timelineClip(clipId);
    if (clip == null) {
      return false;
    }
    if (_relationAnchorClipId.isEmpty) {
      _relationAnchorClipId = clipId;
      _selectedClipId = clipId;
      notifyListeners();
      return true;
    }
    if (_relationAnchorClipId == clipId) {
      return true;
    }
    final anchor = _timelineClip(_relationAnchorClipId);
    if (anchor == null) {
      return false;
    }
    final startNs = _earlierNanoseconds(anchor.startNs, clip.startNs);
    final endNs = _laterNanoseconds(anchor.endNs, clip.endNs);
    if (startNs == null ||
        endNs == null ||
        !isOpenNanosecondInterval(startNs, endNs)) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return true;
    }
    final trackId = await _relationTrackIdAfterEnsure();
    if (trackId == null) {
      return true;
    }
    final description = '${labelForClip(anchor)} ↔ ${labelForClip(clip)}';
    final didSave = await createTimelineClip(
      trackId: trackId,
      kind: TimelineClipKind.relation,
      startNs: startNs,
      endNs: endNs,
      description: description,
      fromClipId: anchor.clipId,
      toClipId: clip.clipId,
    );
    if (didSave) {
      _isRelationMode = false;
      _relationAnchorClipId = '';
      _createdClipNotice = _noticeForCreatedClip(
        kind: TimelineClipKind.relation,
        detail: description,
      );
      notifyListeners();
    }
    return true;
  }

  Future<String?> _relationTrackIdAfterEnsure() async {
    final existing = _relationTrackId();
    if (existing != null) {
      return existing;
    }
    final didCreate = await createTimelineTrack(name: RELATION_TRACK_NAME);
    if (!didCreate) {
      return null;
    }
    return _relationTrackId();
  }

  String? _relationTrackId() {
    TimelineTrack? chosen;
    for (final track in _timeline.tracks) {
      if (track.name.trim() != RELATION_TRACK_NAME) {
        continue;
      }
      if (chosen == null || track.order < chosen.order) {
        chosen = track;
      }
    }
    final trackId = chosen?.trackId ?? '';
    if (trackId.isEmpty) {
      return null;
    }
    return trackId;
  }

  String? _earlierNanoseconds(String left, String right) {
    final leftValue = BigInt.tryParse(left);
    final rightValue = BigInt.tryParse(right);
    if (leftValue == null || rightValue == null) {
      return null;
    }
    return leftValue <= rightValue ? left : right;
  }

  String? _laterNanoseconds(String left, String right) {
    final leftValue = BigInt.tryParse(left);
    final rightValue = BigInt.tryParse(right);
    if (leftValue == null || rightValue == null) {
      return null;
    }
    return leftValue >= rightValue ? left : right;
  }

  WorkAttachment? _attachmentById(String attachmentId) {
    if (attachmentId.isEmpty) {
      return null;
    }
    for (final attachment in _attachments) {
      if (attachment.attachmentId == attachmentId) {
        return attachment;
      }
    }
    return null;
  }

  String? _attachmentIdFromDragData(String dragData) {
    if (!dragData.startsWith(ASSET_DRAG_PREFIX)) {
      return null;
    }
    final attachmentId = dragData.substring(ASSET_DRAG_PREFIX.length).trim();
    if (attachmentId.isEmpty) {
      return null;
    }
    return attachmentId;
  }

  CreatedClipNotice _noticeForCreatedClip({
    required TimelineClipKind kind,
    required String detail,
  }) {
    final kindLabel = _kindLabel(kind);
    final trimmed = detail.trim();
    return CreatedClipNotice(
      kindLabel: kindLabel,
      body: trimmed.isEmpty ? kindLabel : trimmed,
    );
  }

  TimelineClipKind _clipKindForAttachment(WorkAttachment attachment) {
    switch (attachment.fileType) {
      case WorkAttachmentType.video:
        return TimelineClipKind.video;
      case WorkAttachmentType.audio:
        return TimelineClipKind.audio;
      case WorkAttachmentType.image:
        return TimelineClipKind.image;
      case WorkAttachmentType.pdf:
        return TimelineClipKind.pdf;
      case WorkAttachmentType.text:
        return TimelineClipKind.file;
    }
  }

  Future<void> didCommitClipRange(
    String clipId,
    double startSeconds,
    double endSeconds,
  ) async {
    final clip = _timelineClip(clipId);
    if (clip == null) {
      return;
    }
    final start = startSeconds < endSeconds ? startSeconds : endSeconds;
    final end = startSeconds < endSeconds ? endSeconds : startSeconds;
    final startNs = nanosecondsFromSeconds(start);
    final endNs = nanosecondsFromSeconds(end);
    if (!isOpenNanosecondInterval(startNs, endNs)) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return;
    }
    await updateTimelineClip(clipId: clipId, startNs: startNs, endNs: endNs);
  }

  void didDismissVectorSaveNotice() {
    if (_vectorSaveTrackCount == null) {
      return;
    }
    _vectorSaveTrackCount = null;
    notifyListeners();
  }

  int _changedTimelineTrackCount() {
    final count = _timeline.tracks.length;
    if (count < 1) {
      return 1;
    }
    return count;
  }

  int _changedClipTrackCount(String clipId, {String? nextTrackId}) {
    final clip = _timelineClip(clipId);
    if (clip == null) {
      return 1;
    }
    if (nextTrackId == null || nextTrackId == clip.trackId) {
      return 1;
    }
    return 2;
  }

  Future<bool> _commitServerWrite(
    Future<void> Function() write, {
    required int changedTrackCount,
  }) async {
    if (_isSavingTimeline || jobId.isEmpty) {
      return false;
    }
    _isSavingTimeline = true;
    var didSave = false;
    try {
      try {
        await write();
      } on JobTimelineException catch (error) {
        await _applyWriteFailure(error);
        return false;
      } catch (error) {
        _timelineHint = error.toString();
        return false;
      }
      didSave = await _replaceTimelineFromServer(clearHint: true);
      if (didSave) {
        _vectorSaveTrackCount = changedTrackCount < 1 ? 1 : changedTrackCount;
      }
      return didSave;
    } finally {
      _isSavingTimeline = false;
      notifyListeners();
    }
  }

  Future<void> _applyWriteFailure(JobTimelineException error) async {
    switch (error.failure) {
      case JobTimelineFailure.aborted:
        final didRefresh = await _replaceTimelineFromServer(clearHint: false);
        if (didRefresh) {
          _timelineHint = error.message.isEmpty
              ? '타임라인 상태가 바뀌어 다시 불러왔습니다.'
              : '타임라인 상태가 바뀌어 다시 불러왔습니다. ${error.message}';
        }
      case JobTimelineFailure.notFound:
        final didRefresh = await _replaceTimelineFromServer(clearHint: false);
        if (didRefresh) {
          _timelineHint = error.message.isEmpty
              ? '대상을 찾지 못해 타임라인을 다시 불러왔습니다.'
              : error.message;
        }
      case JobTimelineFailure.failedPrecondition:
      case JobTimelineFailure.invalidArgument:
      case JobTimelineFailure.unknown:
        _timelineHint = error.message;
    }
  }

  Future<bool> _replaceTimelineFromServer({required bool clearHint}) async {
    try {
      _timeline = await _getJobTimelineUseCase.execute(jobId: jobId);
      _overlayEpoch += 1;
      await _loadOverlayBodies();
      if (clearHint) {
        _timelineHint = '';
      }
      return true;
    } on JobTimelineException catch (error) {
      _timelineHint = error.message;
      return false;
    } catch (error) {
      _timelineHint = error.toString();
      return false;
    }
  }

  void didCommitBarRange(
    String attachmentId,
    double startSeconds,
    double endSeconds,
  ) {
    final index = _bars.indexWhere((bar) => bar.attachmentId == attachmentId);
    if (index < 0) {
      return;
    }
    final start = startSeconds < endSeconds ? startSeconds : endSeconds;
    final end = startSeconds < endSeconds ? endSeconds : startSeconds;
    if (end - start < MIN_REGION_SECONDS) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return;
    }
    final next = [..._bars];
    next[index] = next[index].copyWith(
      startSeconds: start < 0 ? 0 : start,
      endSeconds: end,
    );
    if (next[index].endSeconds - next[index].startSeconds <
        MIN_REGION_SECONDS) {
      next[index] = next[index].copyWith(
        endSeconds: next[index].startSeconds + MIN_REGION_SECONDS,
      );
    }
    _bars = next;
    _timelineHint = '';
    notifyListeners();
  }

  void didTapToggleLaneKey(String laneKey) {
    if (_hiddenLaneKeys.contains(laneKey)) {
      _hiddenLaneKeys.remove(laneKey);
    } else {
      _hiddenLaneKeys.add(laneKey);
    }
    notifyListeners();
  }

  void didRejectMediaDrop() {
    _timelineHint = '영상·오디오는 타임라인에 떨어뜨릴 수 없습니다.';
    notifyListeners();
  }

  void didTapTogglePlayback() {
    if (_playhead.wantsPlayback) {
      _playhead.pause();
      _playbackToken += 1;
      _logPlayheadCovering(reason: 'pause');
      notifyListeners();
      return;
    }
    _playhead.play(spanSeconds: spanSeconds);
    _coveringVideoClipId = '';
    _playbackToken += 1;
    _seekToken += 1;
    _syncPlayheadClock();
    _logPlayheadCovering(reason: 'play');
    notifyListeners();
  }

  /// 가이드 §6: wantsPlayback이면 clock이 `T`를 민다. onTick에서 covering seek.
  void _syncPlayheadClock() {
    if (_isClosed) {
      _playhead.pause();
      return;
    }
    _playhead.syncTimer(
      spanSeconds: () => spanSeconds,
      onTick: () {
        if (_isClosed) {
          _playhead.pause();
          return;
        }
        _syncCoveringSeek();
        notifyListeners();
      },
      onEndedAtSpan: () {
        _playbackToken += 1;
        notifyListeners();
      },
    );
  }

  /// covering 클립이 바뀌면 seek. 스텝 시킹이면 매 틱 seek(가이드 §6 rate 폴백).
  void _syncCoveringSeek() {
    final clip = _primaryCoveringVideoClip();
    final coveringId = clip?.clipId ?? '';
    final coveringChanged = coveringId != _coveringVideoClipId;
    _coveringVideoClipId = coveringId;
    if (coveringChanged) {
      _logPlayheadCovering(clip: clip, reason: 'covering_changed');
    } else {
      _logPlayheadCovering(clip: clip, reason: 'tick', throttle: true);
    }
    if (coveringChanged || _doesPrimaryCoveringNeedStepSeek()) {
      _seekToken += 1;
    }
  }

  void _logPlayheadCovering({
    TimelineClip? clip,
    required String reason,
    bool throttle = false,
  }) {
    final resolved = clip ?? _primaryCoveringVideoClip();
    final bar = resolved == null ? null : _videoBarFromClip(resolved);
    _playheadCoveringLog.log(
      reason: reason,
      playheadSeconds: playheadSeconds,
      spanSeconds: spanSeconds,
      wantsPlayback: _playhead.wantsPlayback,
      modeLabel: monitoredTrackIds.isNotEmpty
          ? 'monitor focus=$focusedMonitorTrackId'
          : 'selected/active',
      clip: resolved,
      seekMs: bar == null ? -1 : fileSeekMilliseconds(bar),
      rate: bar == null ? 0 : playbackRateFor(bar),
      step: bar != null && doesPlaybackUseStepSeek(bar),
      throttle: throttle,
    );
  }

  TimelineClip? _primaryCoveringVideoClip() {
    if (monitoredTrackIds.isNotEmpty) {
      return _coveringVideoOnTrack(focusedMonitorTrackId, playheadSeconds);
    }
    return _activeVideoClip();
  }

  bool _doesPrimaryCoveringNeedStepSeek() {
    final clip = _primaryCoveringVideoClip();
    if (clip == null) {
      return false;
    }
    final bar = _videoBarFromClip(clip);
    return bar != null && doesPlaybackUseStepSeek(bar);
  }

  void didTapToggleLaneMenu() {
    _isLaneMenuOpen = !_isLaneMenuOpen;
    notifyListeners();
  }

  void didTapAddMarker() {
    _markerSeconds.add(playheadSeconds);
    _noticeText = '';
    notifyListeners();
  }

  void didTapMarker(double seconds) {
    didSeekToSeconds(seconds);
  }

  void didDismissNotice() {
    if (_noticeText.isEmpty) {
      return;
    }
    _clearNotice();
    notifyListeners();
  }

  List<TemporaryAttachmentBar> _chain(
    List<WorkAttachment> attachments,
    WorkAttachmentType type,
  ) {
    final bars = <TemporaryAttachmentBar>[];
    var cursor = 0.0;
    for (final attachment in attachments) {
      if (attachment.fileType != type) {
        continue;
      }
      final mediaUrl = attachment.networkUrl ?? attachment.assetPath ?? '';
      if (mediaUrl.isEmpty) {
        continue;
      }
      bars.add(
        TemporaryAttachmentBar(
          attachmentId: attachment.attachmentId,
          fileName: attachment.fileName,
          fileTypeLabel: WorkAttachmentType.extensionOf(attachment.fileName),
          mediaUrl: mediaUrl,
          note: attachment.note,
          isVideo: type == WorkAttachmentType.video,
          startSeconds: cursor,
          endSeconds: cursor + PROVISIONAL_BAR_SECONDS,
        ),
      );
      cursor += PROVISIONAL_BAR_SECONDS;
    }
    return bars;
  }

  void _clearNotice() {
    _noticeText = '';
  }

  @override
  void dispose() {
    _isClosed = true;
    _playhead.dispose();
    _clipDetailEpoch += 1;
    _toolRunEpoch += 1;
    _labelEpoch += 1;
    _overlayEpoch += 1;
    super.dispose();
  }

  Future<void> _loadOverlayBodies() async {
    final epoch = _overlayEpoch;
    _framesByAssetId.clear();
    _cuesByAssetId.clear();
    final urlsByAssetId = <String, String>{};
    for (final overlay in _timeline.overlays) {
      urlsByAssetId.putIfAbsent(overlay.assetId, () => overlay.contentUrl);
    }
    final bodiesByAssetId = <String, String>{};
    for (final entry in urlsByAssetId.entries) {
      if (epoch != _overlayEpoch || _isClosed) {
        return;
      }
      bodiesByAssetId[entry.key] = await _getJobTimelineUseCase.readContent(
        url: entry.value,
      );
    }
    if (epoch != _overlayEpoch || _isClosed) {
      return;
    }
    for (final overlay in _timeline.overlays) {
      final body = bodiesByAssetId[overlay.assetId] ?? '';
      if (overlay.kind == TimelineOverlayKind.pose) {
        _framesByAssetId[overlay.assetId] = parsePoseOverlay(body);
      } else {
        _cuesByAssetId[overlay.assetId] = parseSubtitleCues(body);
      }
    }
  }

  Future<void> _restoreActiveToolRun() async {
    if (jobId.isEmpty || _inferencePhase != InferencePanelPhase.hidden) {
      return;
    }
    final runs = await _toolRunUseCase.listJobRuns(jobId: jobId);
    if (_inferencePhase != InferencePanelPhase.hidden) {
      return;
    }
    ToolRunSnapshot? active;
    for (final run in runs) {
      if (run.isInProgress) {
        active = run;
      }
    }
    if (active == null) {
      return;
    }
    var toolName = '도구 실행';
    try {
      final tools = await _toolRunUseCase.listEnabledTools(
        includeDisabled: true,
      );
      for (final tool in tools) {
        if (tool.toolId == active.toolId && tool.name.isNotEmpty) {
          toolName = tool.name;
          break;
        }
      }
    } on ToolRunException {
      toolName = '도구 실행';
    }
    if (_isClosed || _inferencePhase != InferencePanelPhase.hidden) {
      return;
    }
    _inferenceModelName = toolName;
    _rememberOpenRun(active);
    unawaited(_followToolRun(_toolRunEpoch));
  }

  void _rememberOpenRun(ToolRunSnapshot run) {
    _activeRunId = run.runId;
    _inferenceMessage = '';
    _inferenceProgressPercent = run.progressPercent;
    _inferenceRemainingSeconds = run.estimatedRemainingSeconds;
    _inferencePhase = run.status == ToolRunStatus.running
        ? InferencePanelPhase.running
        : InferencePanelPhase.queued;
    notifyListeners();
  }

  Future<void> _followToolRun(int epoch) async {
    var didRetry = false;
    while (epoch == _toolRunEpoch && !_isClosed) {
      final runId = _activeRunId;
      if (runId.isEmpty) {
        return;
      }
      try {
        final run = await _toolRunUseCase.getRun(runId: runId);
        didRetry = false;
        if (epoch != _toolRunEpoch || _isClosed) {
          return;
        }
        if (run.isInProgress) {
          _rememberOpenRun(run);
          await Future<void>.delayed(toolRunPoll);
          continue;
        }
        await _finishToolRun(run, epoch);
        return;
      } on ToolRunException catch (error) {
        if (epoch != _toolRunEpoch || _isClosed) {
          return;
        }
        if (!didRetry) {
          didRetry = true;
          await Future<void>.delayed(toolRunPoll);
          continue;
        }
        _inferencePhase = InferencePanelPhase.failed;
        _inferenceMessage = error.message;
        notifyListeners();
        return;
      }
    }
  }

  String _selectedTargetFileName() {
    if (isSelectedServerClip) {
      return _timelineClip(_selectedClipId)?.fileName ?? '';
    }
    for (final attachment in _attachments) {
      if (attachment.attachmentId == _selectedAttachmentId) {
        return attachment.fileName;
      }
    }
    return '';
  }

  bool _isDepthVideo(String fileName) {
    final parts = fileName.trim().toLowerCase().split('/');
    if (parts.isEmpty) {
      return false;
    }
    return parts.last.startsWith('depth_');
  }

  Future<void> _finishToolRun(ToolRunSnapshot run, int epoch) async {
    if (epoch != _toolRunEpoch || _isClosed) {
      return;
    }
    switch (run.status) {
      case ToolRunStatus.queued:
      case ToolRunStatus.running:
        _rememberOpenRun(run);
      case ToolRunStatus.succeeded:
        await _replaceTimelineFromServer(clearHint: true);
        if (epoch != _toolRunEpoch || _isClosed) {
          return;
        }
        _activeRunId = '';
        _inferenceMessage = '';
        _inferencePhase = InferencePanelPhase.hidden;
        notifyListeners();
      case ToolRunStatus.failed:
        _inferencePhase = InferencePanelPhase.failed;
        _inferenceMessage = run.errorMessage.isEmpty
            ? '도구 실행에 실패했습니다.'
            : run.errorMessage;
        notifyListeners();
      case ToolRunStatus.canceled:
        _activeRunId = '';
        _inferenceMessage = '';
        _inferencePhase = InferencePanelPhase.hidden;
        notifyListeners();
    }
  }

  String _formatClock(double seconds) {
    final whole = seconds.floor().clamp(0, 86400);
    final minutes = whole ~/ 60;
    final remain = whole % 60;
    final minuteText = minutes.toString().padLeft(2, '0');
    final secondText = remain.toString().padLeft(2, '0');
    return '$minuteText:$secondText';
  }
}
