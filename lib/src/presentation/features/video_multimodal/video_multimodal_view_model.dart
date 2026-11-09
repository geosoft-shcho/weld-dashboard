import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/datasources/remote/media_files_debug_log.dart';
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
import '../../../domain/use_cases/create_clip_use_case.dart';
import '../../../domain/use_cases/create_track_use_case.dart';
import '../../../domain/use_cases/delete_clip_use_case.dart';
import '../../../domain/use_cases/delete_timeline_use_case.dart';
import '../../../domain/use_cases/delete_track_use_case.dart';
import '../../../domain/use_cases/get_clip_use_case.dart';
import '../../../domain/entities/waveform_series_bundle.dart';
import '../../../domain/use_cases/get_job_timeline_use_case.dart';
import '../../../domain/use_cases/label_use_case.dart';
import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/use_cases/list_asset_lookup_page_use_case.dart';
import '../../../domain/use_cases/list_history_work_attachments_use_case.dart';
import '../../../domain/use_cases/load_job_project_id_use_case.dart';
import '../../../domain/use_cases/load_audio_waveform_use_case.dart';
import '../../../domain/use_cases/load_timeseries_waveform_use_case.dart';
import '../../../domain/use_cases/tool_run_use_case.dart';
import '../../../domain/use_cases/update_clip_use_case.dart';
import '../../../domain/use_cases/update_timeline_use_case.dart';
import '../../../domain/use_cases/update_track_use_case.dart';
import 'attachment_bar_helpers.dart';
import 'clip_chart_kind.dart';
import 'clip_chart_session.dart';
import 'clip_detail_cache.dart';
import 'clip_detail_load_gate.dart';
import 'label_roots_session_cache.dart';
import 'pose_board_marks.dart';
import 'video_caption.dart';
import 'video_overlay_clock.dart';
import 'video_overlay_frame.dart';
import 'video_overlay_json.dart';
import 'timeline_clip_helpers.dart';
import 'timeline_playhead_clock.dart';
import 'video_playback_rate.dart';
import 'video_subtitle_text.dart';
import 'video_multimodal_models.dart';
export 'video_multimodal_models.dart';

class VideoMultimodalViewModel extends ChangeNotifier {
  VideoMultimodalViewModel({
    required this._listHistoryWorkAttachmentsUseCase,
    required this._listAssetLookupPageUseCase,
    required this._getJobTimelineUseCase,
    required this._getClipUseCase,
    required this._createTrackUseCase,
    required this._updateTrackUseCase,
    required this._deleteTrackUseCase,
    required this._createClipUseCase,
    required this._updateClipUseCase,
    required this._deleteClipUseCase,
    required this._updateTimelineUseCase,
    required this._deleteTimelineUseCase,
    required this._toolRunUseCase,
    required this._labelUseCase,
    required this._askQuestionUseCase,
    required this._getSessionHistoryUseCase,
    required this._askSessionStore,
    required this._loadJobProjectIdUseCase,
    required this._loadTimeseriesWaveformUseCase,
    required this._loadAudioWaveformUseCase,
    required this.jobId,
    this.toolRunPoll = const Duration(seconds: 2),
  });

  static const double MIN_TIMELINE_HEIGHT = 320;
  static const double MAX_TIMELINE_HEIGHT = 720;
  static const double SIDE_WIDTH = 320;
  static const double DEFAULT_PIXELS_PER_SECOND = 10;
  static const double EMPTY_SPAN_SECONDS = 60;
  static const double MIN_TRACK_WIDTH = 640;
  static const double MIN_CLIP_WIDTH = 6;
  static const double MIN_REGION_SECONDS = 0.1;
  static const double DEFAULT_TIMELESS_CLIP_SECONDS = 5;
  static const int ASSETS_DEFAULT_PAGE_SIZE = 20;
  static const String ASSET_DRAG_PREFIX = 'asset:';
  static const String RELATION_TRACK_NAME = '관계';
  static const String LIKE_TRACK_NAME = '좋아요';
  static const String DISLIKE_TRACK_NAME = '싫어요';
  static const String COMMENT_TRACK_NAME = '코멘트';
  static const String RECORDING_VIDEO_TRACK_NAME = '녹화 영상';
  static const String RECORDING_AUDIO_TRACK_NAME = '녹화 음성';

  /// 서버 자동 배치: 장비 없이 올리면 `장비 · 계열`이 `- · video`/`- · audio`가 된다.
  static const String SERVER_EMPTY_EQUIPMENT_VIDEO_TRACK_NAME = '- · video';
  static const String SERVER_EMPTY_EQUIPMENT_AUDIO_TRACK_NAME = '- · audio';

  final ListHistoryWorkAttachmentsUseCase _listHistoryWorkAttachmentsUseCase;
  final ListAssetLookupPageUseCase _listAssetLookupPageUseCase;
  final GetJobTimelineUseCase _getJobTimelineUseCase;
  final GetClipUseCase _getClipUseCase;
  final CreateTrackUseCase _createTrackUseCase;
  final UpdateTrackUseCase _updateTrackUseCase;
  final DeleteTrackUseCase _deleteTrackUseCase;
  final CreateClipUseCase _createClipUseCase;
  final UpdateClipUseCase _updateClipUseCase;
  final DeleteClipUseCase _deleteClipUseCase;
  final UpdateTimelineUseCase _updateTimelineUseCase;
  final DeleteTimelineUseCase _deleteTimelineUseCase;
  final ToolRunUseCase _toolRunUseCase;
  final LabelUseCase _labelUseCase;
  final AskQuestionUseCase _askQuestionUseCase;
  final GetSessionHistoryUseCase _getSessionHistoryUseCase;
  final AskSessionStore _askSessionStore;
  final LoadJobProjectIdUseCase _loadJobProjectIdUseCase;
  final LoadTimeseriesWaveformUseCase _loadTimeseriesWaveformUseCase;
  final LoadAudioWaveformUseCase _loadAudioWaveformUseCase;
  final String jobId;
  final Duration toolRunPoll;

  final TimelinePlayheadClock _playhead = TimelinePlayheadClock();
  int _seekToken = 0;
  VideoMultimodalSide _side = VideoMultimodalSide.none;
  bool _isTrackMenuOpen = false;
  bool _isLoading = false;
  bool _isLoadingAttachments = false;
  bool _isSavingTimeline = false;
  int? _vectorSaveTrackCount;
  bool _hasError = false;
  String _errorMessage = '';
  final List<double> _markerSeconds = [];
  String _noticeText = '';
  List<WorkAttachment> _attachments = const [];
  List<TemporaryAttachmentBar> _bars = const [];
  List<WorkAttachment> _assetsPageRows = const [];
  int _assetsPageIndex = 1;
  int _assetsPageSize = ASSETS_DEFAULT_PAGE_SIZE;
  int _assetsTotalCount = 0;
  final Map<int, String> _assetsPageTokenByPage = <int, String>{1: ''};
  bool _isLoadingAssetsPage = false;
  int _assetsPageLoadEpoch = 0;
  JobTimeline _timeline = JobTimeline.empty;
  final Set<String> _hiddenAttachmentIds = {};
  final Set<String> _hiddenTrackIds = {};
  String _selectedAttachmentId = '';
  String _selectedClipId = '';
  int _clipDetailEpoch = 0;
  bool _isClipDetailLoading = false;
  String _clipDetailMessage = '';
  ClipDetail? _clipDetail;
  final ClipDetailCache _clipDetailCache = ClipDetailCache();
  final ClipDetailLoadGate _clipDetailLoadGate = ClipDetailLoadGate();
  TimelineClip? _playbackVideoClip;

  /// 비영상 선택 시 대상 영상이 없을 때 스테이지에 남겨 둘 직전 영상.
  TimelineClip? _retainedStageVideoClip;
  bool _showsMissingTargetVideoBanner = false;
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
  bool _isCapturingScreenComment = false;
  DateTime? _screenCommentStartedAt;
  final List<Map<String, Object?>> _screenCommentRows = [];
  bool _isCameraRecordingMinimized = false;
  int _commentListReloadCount = 0;
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
  final Map<String, Future<void>> _framesInflight = {};
  final Map<String, Future<void>> _cuesInflight = {};
  final Map<String, List<PoseBoardMark>> _poseBoardMarksByClipId = {};
  final List<SampleLayerSummary> _sampleLayers = const [];

  /// Stage에 동시에 보여 줄 비디오 트랙(최대 [MAX_MONITORED_TRACK_COUNT]).
  final List<String> _monitoredTrackIds = [];
  String _focusedMonitorTrackId = '';
  static const int MAX_MONITORED_TRACK_COUNT = 4;
  final ClipChartSession _chartSession = ClipChartSession();
  DateTime _lastDriftSeekAt = DateTime.fromMillisecondsSinceEpoch(0);
  static const Duration _DRIFT_SEEK_COOLDOWN = Duration(milliseconds: 500);
  double _timelineBoardHeight = MIN_TIMELINE_HEIGHT;

  double get pixelsPerSecond => DEFAULT_PIXELS_PER_SECOND;
  double get timelineBoardHeight => _timelineBoardHeight;
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
  bool get isCommentsOpen => _side == VideoMultimodalSide.comments;
  bool get isTrackMenuOpen => _isTrackMenuOpen;
  bool get isLoading => _isLoading;
  bool get isLoadingAttachments => _isLoadingAttachments;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<double> get markerSeconds => List.unmodifiable(_markerSeconds);
  String get noticeText => _noticeText;
  bool get hasNotice => _noticeText.isNotEmpty;
  List<WorkAttachment> get attachments => List.unmodifiable(_attachments);
  List<WorkAttachment> get assetsPageRows => List.unmodifiable(_assetsPageRows);
  int get assetsPageIndex => _assetsPageIndex;
  int get assetsPageSize => _assetsPageSize;
  int get assetsTotalCount => _assetsTotalCount;
  bool get isLoadingAssetsPage => _isLoadingAssetsPage;
  int get assetsPageCount {
    if (_assetsPageSize < 1) {
      return 1;
    }
    if (_assetsTotalCount <= 0) {
      return 1;
    }
    final count = (_assetsTotalCount + _assetsPageSize - 1) ~/ _assetsPageSize;
    return count < 1 ? 1 : count;
  }

  List<TimelineTrack> get timelineTracks => List.unmodifiable(_timeline.tracks);
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
    for (final attachment in _assetsPageRows) {
      if (attachment.attachmentId == _selectedAttachmentId) {
        return attachment;
      }
    }
    for (final attachment in _attachments) {
      if (attachment.attachmentId == _selectedAttachmentId) {
        return attachment;
      }
    }
    return null;
  }

  bool get canEditSelectedServerTrack => selectedServerTrack != null;

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

  /// 보드 포즈 클립 위 실데이터 막대. 없으면 빈 목록(가짜 fractions 없음).
  List<PoseBoardMark> poseBoardMarksForClip(String clipId) {
    return _poseBoardMarksByClipId[clipId] ?? const [];
  }

  bool get canAttachLabelToSelection =>
      isSelectedServerClip && _selectedLabelValueId.isNotEmpty;

  bool get canDetachLabelFromSelection {
    final clip = _timelineClip(_selectedClipId);
    return clip != null && clip.labelValueId.isNotEmpty;
  }

  TemporaryAttachmentBar? get activeVideoBar =>
      _videoBarFromClip(_activeVideoClip());

  /// 비영상 클립에 대상 영상이 없을 때 스테이지 하단 안내.
  bool get showsMissingTargetVideoBanner => _showsMissingTargetVideoBanner;

  List<String> get monitoredTrackIds {
    final validTrackIds = {for (final track in timelineTracks) track.trackId};
    return [
      for (final trackId in _monitoredTrackIds)
        if (validTrackIds.contains(trackId) && trackHasVideo(trackId)) trackId,
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

  String get chartExpandedClipId => _chartSession.clipId;
  ClipChartKind? get expandedChartKind => _chartSession.kind;
  bool get isTimeseriesChartLoading => _chartSession.isTimeseriesLoading;
  String get timeseriesChartError => _chartSession.timeseriesError;
  WaveformSeriesBundle get timeseriesSeries => _chartSession.timeseriesSeries;
  bool get isAudioChartLoading => _chartSession.isAudioLoading;
  String get audioChartError => _chartSession.audioError;
  List<double> get audioAmplitudes => _chartSession.audioAmplitudes;

  int? get timeseriesSelectedTimeMs {
    final clip = _timelineClip(_chartSession.clipId);
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

  String get playheadLabel => formatPlayheadClock(playheadSeconds);
  String get spanLabel => formatPlayheadClock(spanSeconds);
  String get timelineName => _timeline.name;
  String get timelineDescription => _timeline.description;

  String get pageTitle {
    final workName = _workName.trim();
    if (workName.isNotEmpty) {
      return workName;
    }
    return jobId;
  }

  bool get isVideoPlaying => _playhead.isPlaying;
  bool get wantsPlayback => _playhead.wantsPlayback;
  int get playbackToken => _playbackToken;

  String get assetsSearchQuery => _assetsSearchQuery;
  String get timelineHint => _timelineHint;

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
  int get commentListReloadCount => _commentListReloadCount;
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
      trackId: timelineClip.trackId,
      trackLabel: _trackName(timelineClip.trackId),
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

  String get coveringAudioMediaUrl => coveringAudioClip?.playbackUrl ?? '';

  int get coveringAudioSeekMilliseconds {
    final clip = coveringAudioClip;
    if (clip == null) {
      return 0;
    }
    return fileSeekMillisecondsAt(
      clip: clipPlaybackInputFrom(clip),
      playheadSeconds: playheadSeconds,
      fallbackLocalSeconds:
          playheadSeconds - secondsFromNanoseconds(clip.startNanoseconds),
    );
  }

  double get coveringAudioPlaybackRate {
    final clip = coveringAudioClip;
    if (clip == null) {
      return timelinePlaybackRate;
    }
    return playbackRateAt(
      clip: clipPlaybackInputFrom(clip),
      playheadSeconds: playheadSeconds,
      timelinePlaybackRate: timelinePlaybackRate,
    );
  }

  /// GetTimeline까지 블로킹한 뒤 보드를 그리고, 첨·라벨·도구·오버레이는 백그라운드.
  Future<void> openTimeline() async {
    MediaFilesDebugLog.beginInitialLoad(jobId: jobId);
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _side = VideoMultimodalSide.none;
    _overlayEpoch += 1;
    notifyListeners();
    if (jobId.isEmpty) {
      _timeline = JobTimeline.empty;
      _attachments = const [];
      _bars = const [];
      _resetAssetsPageState();
      _clearOverlayBodies();
      _noticeText = '작업을 열지 못했습니다.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    final timelineOk = await _fetchGetTimeline();
    _isLoading = false;
    notifyListeners();
    if (!timelineOk || _isClosed) {
      return;
    }
    await _loadOpenTimelineBackground();
  }

  Future<bool> _fetchGetTimeline() async {
    try {
      _timeline = await _getJobTimelineUseCase.execute(jobId: jobId);
      final name = _timeline.name.trim();
      if (_workName.isEmpty && name.isNotEmpty) {
        _workName = name;
      }
      return true;
    } on JobTimelineException catch (error) {
      _hasError = true;
      _errorMessage = error.message;
      _timeline = JobTimeline.empty;
      return false;
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _timeline = JobTimeline.empty;
      return false;
    }
  }

  Future<void> _loadOpenTimelineBackground() async {
    await Future.wait<void>([
      _loadSideAssets(),
      _ensureLabels(),
      _restoreActiveToolRunInBackground(),
    ]);
    if (!_isClosed) {
      notifyListeners();
    }
  }

  Future<void> _loadSideAssets() async {
    _isLoadingAttachments = true;
    notifyListeners();
    try {
      await _loadAssetsPage(1);
    } catch (error) {
      _resetAssetsPageState();
      if (!_hasError) {
        _noticeText = error.toString();
      }
    } finally {
      _isLoadingAttachments = false;
      if (!_isClosed) {
        notifyListeners();
      }
    }
  }

  Future<void> didSelectAssetsPage(int page) async {
    if (page < 1 || page == _assetsPageIndex || _isClosed || jobId.isEmpty) {
      return;
    }
    await _loadAssetsPage(page);
  }

  Future<void> didTapResetAssets() async {
    if (jobId.isEmpty || _isClosed || _isLoadingAssetsPage) {
      return;
    }
    _assetsSearchQuery = '';
    _resetAssetsPageCache();
    notifyListeners();
    await _loadAssetsPage(1);
  }

  Future<void> _loadAssetsPage(int page) async {
    if (jobId.isEmpty || _isClosed) {
      return;
    }
    final targetPage = page < 1 ? 1 : page;
    final epoch = ++_assetsPageLoadEpoch;
    _isLoadingAssetsPage = true;
    notifyListeners();
    try {
      final token = await _ensureAssetsPageToken(targetPage);
      if (epoch != _assetsPageLoadEpoch || _isClosed) {
        return;
      }
      final result = await _listAssetLookupPageUseCase.execute(
        kindCode: '',
        query: _assetsSearchQuery.trim(),
        equipmentId: '',
        unattachedOnly: false,
        jobId: jobId,
        pageSize: _assetsPageSize,
        pageToken: token,
      );
      if (epoch != _assetsPageLoadEpoch || _isClosed) {
        return;
      }
      _assetsPageIndex = targetPage;
      _assetsPageRows = [
        for (final row in result.rows) _workAttachmentFromLookupRow(row),
      ];
      _attachments = _assetsPageRows;
      _bars = [
        ...chainAttachmentBars(_attachments, WorkAttachmentType.video),
        ...chainAttachmentBars(_attachments, WorkAttachmentType.audio),
      ];
      if (result.totalCount > 0) {
        _assetsTotalCount = result.totalCount;
      } else if (result.rows.isEmpty && targetPage == 1) {
        _assetsTotalCount = 0;
      }
      if (result.nextPageToken.isNotEmpty) {
        _assetsPageTokenByPage[targetPage + 1] = result.nextPageToken;
      }
    } catch (error) {
      if (epoch != _assetsPageLoadEpoch || _isClosed) {
        return;
      }
      if (_noticeText.isEmpty) {
        _noticeText = error.toString();
      }
    } finally {
      if (epoch == _assetsPageLoadEpoch) {
        _isLoadingAssetsPage = false;
        if (!_isClosed) {
          notifyListeners();
        }
      }
    }
  }

  Future<String> _ensureAssetsPageToken(int page) async {
    final cached = _assetsPageTokenByPage[page];
    if (cached != null) {
      return cached;
    }
    var knownPage = 1;
    for (final entry in _assetsPageTokenByPage.entries) {
      if (entry.key < page && entry.key > knownPage) {
        knownPage = entry.key;
      }
    }
    var cursorPage = knownPage;
    while (cursorPage < page) {
      final token = _assetsPageTokenByPage[cursorPage];
      if (token == null) {
        break;
      }
      final result = await _listAssetLookupPageUseCase.execute(
        kindCode: '',
        query: _assetsSearchQuery.trim(),
        equipmentId: '',
        unattachedOnly: false,
        jobId: jobId,
        pageSize: _assetsPageSize,
        pageToken: token,
      );
      if (result.nextPageToken.isEmpty) {
        _assetsPageTokenByPage[cursorPage + 1] = '';
        break;
      }
      _assetsPageTokenByPage[cursorPage + 1] = result.nextPageToken;
      if (result.totalCount > 0) {
        _assetsTotalCount = result.totalCount;
      }
      cursorPage += 1;
      if (_assetsPageTokenByPage.containsKey(page)) {
        break;
      }
    }
    return _assetsPageTokenByPage[page] ?? '';
  }

  void _resetAssetsPageCache() {
    _assetsPageTokenByPage
      ..clear()
      ..[1] = '';
    _assetsPageIndex = 1;
    _assetsPageRows = const [];
    _assetsTotalCount = 0;
  }

  void _resetAssetsPageState() {
    _resetAssetsPageCache();
    _assetsPageSize = ASSETS_DEFAULT_PAGE_SIZE;
    _isLoadingAssetsPage = false;
    _assetsPageLoadEpoch += 1;
  }

  WorkAttachment _workAttachmentFromLookupRow(AssetLookupRow row) {
    return WorkAttachment(
      attachmentId: row.assetId,
      jobId: jobId,
      fileType: _fileTypeFromKindCode(row.kindCode, row.fileName),
      fileName: row.fileName,
      note: '',
      content: row.contentUrl,
      durationNs: row.durationNs?.toString() ?? '',
    );
  }

  WorkAttachmentType _fileTypeFromKindCode(String kindCode, String fileName) {
    switch (kindCode) {
      case 'video':
        return WorkAttachmentType.video;
      case 'audio':
        return WorkAttachmentType.audio;
      case 'image':
        return WorkAttachmentType.image;
      case 'document':
        return WorkAttachmentType.fromFileName(fileName) ??
            WorkAttachmentType.pdf;
      default:
        return WorkAttachmentType.fromFileName(fileName) ??
            WorkAttachmentType.text;
    }
  }

  Future<void> _restoreActiveToolRunInBackground() async {
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
    }
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
      clip: clipPlaybackInputFrom(clip),
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
    final now = DateTime.now();
    if (now.difference(_lastDriftSeekAt) < _DRIFT_SEEK_COOLDOWN) {
      return;
    }
    _lastDriftSeekAt = now;
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

  int fileSeekMilliseconds(TemporaryAttachmentBar video) {
    final clip = _clipForBar(video);
    return fileSeekMillisecondsAt(
      clip: clip == null ? null : clipPlaybackInputFrom(clip),
      playheadSeconds: playheadSeconds,
      fallbackLocalSeconds: playheadSeconds - video.startSeconds,
    );
  }

  double playbackRateFor(TemporaryAttachmentBar video) {
    final clip = _clipForBar(video);
    return playbackRateAt(
      clip: clip == null ? null : clipPlaybackInputFrom(clip),
      playheadSeconds: playheadSeconds,
      timelinePlaybackRate: timelinePlaybackRate,
    );
  }

  int? fileContentEndMilliseconds(TemporaryAttachmentBar video) {
    final clip = _clipForBar(video);
    if (clip == null) {
      return null;
    }
    return clipFileContentEndMilliseconds(clip: clipPlaybackInputFrom(clip));
  }

  bool doesPlaybackUseStepSeek(TemporaryAttachmentBar video) {
    return doesRequireStepSeek(playbackRateFor(video));
  }

  /// `T`를 덮는 음성 클립(트랙 무관). 겹치면 clipId가 큰 쪽.
  TimelineClip? get coveringAudioClip => _coveringAudioAt(playheadSeconds);
  TimelineClip? _coveringAudioAt(double seconds) {
    final covering = <TimelineClip>[];
    for (final clip in timelineClips) {
      if (clip.kind != TimelineClipKind.audio ||
          clip.playbackUrl.isEmpty ||
          !doesClipCoverSeconds(clip, seconds)) {
        continue;
      }
      covering.add(clip);
    }
    if (covering.isEmpty) {
      return null;
    }
    covering.sort((left, right) => compareTimelineClipId(right, left));
    return covering.first;
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
    final previousVideo = _activeVideoClip();
    final retainStageVideo =
        timelineClip.kind != TimelineClipKind.video &&
        timelineClip.kind != TimelineClipKind.pose;
    _selectedClipId = clipId;
    _clearPoseOverlayOnly();
    if (timelineClip.kind == TimelineClipKind.pose) {
      _playbackVideoClip = null;
      _playbackToken += 1;
    } else if (retainStageVideo) {
      _retainedStageVideoClip = previousVideo;
    } else {
      _retainedStageVideoClip = null;
    }
    _showsMissingTargetVideoBanner = false;
    _side = VideoMultimodalSide.properties;
    _prepareChartIfNeeded(timelineClip);
    didSeekToSeconds(secondsFromNanoseconds(timelineClip.startNanoseconds));
    unawaited(_loadClipDetail(clipId));
  }

  /// 코멘트가 가리키는 클립을 고르고, 그 시각의 영상을 재생한다.
  /// 클립이 타임라인에 없으면 같은 영상의 클립을 찾는다.
  void didPlayCommentTarget({
    required String clipId,
    int? playheadNs,
    String videoAssetId = '',
  }) {
    final selected = _timelineClip(clipId);
    final assetClip = _videoClipForAsset(videoAssetId);
    final clip = selected ?? assetClip;
    if (clip == null) {
      _noticeText = '재생할 영상을 찾지 못했습니다.';
      notifyListeners();
      return;
    }
    _selectedClipId = clip.clipId;
    _showsMissingTargetVideoBanner = false;
    _clearPosePlayback();
    final seconds = playheadNs == null
        ? secondsFromNanoseconds(clip.startNanoseconds)
        : secondsFromNanoseconds('$playheadNs');
    if (clip.kind != TimelineClipKind.video) {
      _retainedStageVideoClip = _coveringVideoAt(seconds) ?? assetClip;
    }
    _playhead.seekTo(
      seconds,
      spanSeconds: spanSeconds,
      resumeIfWasPlaying: false,
    );
    _playhead.play(spanSeconds: spanSeconds);
    _coveringVideoClipId = '';
    _playbackToken += 1;
    _seekToken += 1;
    _syncPlayheadClock();
    _noteScreenCommentChange();
    notifyListeners();
  }

  TimelineClip? _videoClipForAsset(String assetId) {
    if (assetId.isEmpty) {
      return null;
    }
    for (final track in _timeline.tracks) {
      for (final clip in track.clips) {
        if (clip.assetId == assetId && clip.kind == TimelineClipKind.video) {
          return clip;
        }
      }
    }
    return null;
  }

  TimelineClip? _coveringVideoAt(double seconds) {
    for (final clip in timelineClips) {
      if (clip.kind != TimelineClipKind.video ||
          clip.playbackUrl.isEmpty ||
          !doesClipCoverSeconds(clip, seconds)) {
        continue;
      }
      return clip;
    }
    return null;
  }

  Future<void> _loadClipDetail(String clipId) async {
    final epoch = ++_clipDetailEpoch;
    _clipDetailMessage = '';
    final cached = _clipDetailCache.get(clipId);
    if (cached != null) {
      _clipDetailLoadGate.clearPending();
      _clipDetail = cached;
      _isClipDetailLoading = false;
      notifyListeners();
      await _applyLoadedClipDetail(cached, epoch);
      return;
    }
    _isClipDetailLoading = true;
    _clipDetail = null;
    notifyListeners();
    if (!_clipDetailLoadGate.tryBegin(clipId)) {
      return;
    }
    try {
      await _fetchClipDetailNetwork(clipId, epoch);
      while (!_isClosed) {
        final pending = _clipDetailLoadGate.takePendingMatching(_selectedClipId);
        if (pending == null) {
          break;
        }
        final pendingEpoch = _clipDetailEpoch;
        final pendingCached = _clipDetailCache.get(pending);
        if (pendingCached != null) {
          if (pendingEpoch != _clipDetailEpoch ||
              _isClosed ||
              pending != _selectedClipId) {
            continue;
          }
          _clipDetail = pendingCached;
          _isClipDetailLoading = false;
          notifyListeners();
          await _applyLoadedClipDetail(pendingCached, pendingEpoch);
          continue;
        }
        await _fetchClipDetailNetwork(pending, pendingEpoch);
      }
    } finally {
      _clipDetailLoadGate.end();
      final leftover = _clipDetailLoadGate.takeLeftover();
      if (leftover != null && !_isClosed) {
        unawaited(_loadClipDetail(leftover));
      }
    }
  }

  Future<void> _fetchClipDetailNetwork(String clipId, int epoch) async {
    try {
      final detail = await _clipDetailCache.getOrLoad(
        clipId,
        () => _getClipUseCase.execute(clipId: clipId),
      );
      if (epoch != _clipDetailEpoch || _isClosed) {
        return;
      }
      if (detail.clipId != _selectedClipId) {
        return;
      }
      _clipDetail = detail;
      _isClipDetailLoading = false;
      notifyListeners();
      await _applyLoadedClipDetail(detail, epoch);
    } on JobTimelineException catch (error) {
      if (epoch != _clipDetailEpoch || _isClosed) {
        return;
      }
      if (clipId != _selectedClipId) {
        return;
      }
      _clipDetailMessage = error.message;
      _isClipDetailLoading = false;
      notifyListeners();
    } catch (error) {
      if (epoch != _clipDetailEpoch || _isClosed) {
        return;
      }
      if (clipId != _selectedClipId) {
        return;
      }
      _clipDetailMessage = error.toString();
      _isClipDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> _applyLoadedClipDetail(ClipDetail detail, int epoch) async {
    final clip = _timelineClip(detail.clipId);
    final needsPoseBody =
        detail.isPose || clip?.kind == TimelineClipKind.pose;
    if (clip != null && needsPoseBody) {
      await _ensureOverlayBodiesForSelection(clip, detail: detail);
    } else if (clip != null) {
      unawaited(
        _ensureOverlayBodiesForSelection(clip, detail: detail).then((_) {
          if (epoch != _clipDetailEpoch || _isClosed) {
            return;
          }
          notifyListeners();
        }),
      );
    }
    if (epoch != _clipDetailEpoch || _isClosed) {
      return;
    }
    if (detail.isPose) {
      _retainedStageVideoClip = null;
      _showsMissingTargetVideoBanner = false;
      await _startPosePlayback(detail, epoch);
    } else if (detail.isVideo) {
      _retainedStageVideoClip = null;
      _showsMissingTargetVideoBanner = false;
      _startVideoRange(detail);
    } else {
      _startTargetVideoPlayback(detail);
    }
    if (epoch != _clipDetailEpoch || _isClosed) {
      return;
    }
    if (clip != null) {
      _loadChartFor(clip, detail);
    }
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
    // 타임라인 covering이 이미 같은 URL이면 token만 올리지 않고 시크.
    final active = _activeVideoClip();
    if (active != null && active.playbackUrl == clip.playbackUrl) {
      didSeekToSeconds(secondsFromNanoseconds(startNs), resumePlayback: true);
      return;
    }
    _bindStageVideo(clip, seekStartNs: startNs);
  }

  /// 비영상 클립의 GetClip 대상 영상(targetClip+targetAsset)을 스테이지에 올린다.
  void _startTargetVideoPlayback(ClipDetail detail) {
    final video = _targetVideoClipFromDetail(detail);
    if (video == null) {
      _showsMissingTargetVideoBanner = true;
      return;
    }
    _showsMissingTargetVideoBanner = false;
    _retainedStageVideoClip = null;
    final seekStartNs = overlaySeekStartNs(detail, video);
    _bindStageVideo(video, seekStartNs: seekStartNs);
  }

  /// 같은 playbackUrl이면 클립·token을 갈아끼우지 않고 시크만 한다.
  void _bindStageVideo(TimelineClip video, {required String seekStartNs}) {
    final currentUrl = _playbackVideoClip?.playbackUrl ?? '';
    final activeUrl = _activeVideoClip()?.playbackUrl ?? '';
    final sameUrl =
        video.playbackUrl.isNotEmpty &&
        (video.playbackUrl == currentUrl || video.playbackUrl == activeUrl);
    if (!sameUrl) {
      _playbackVideoClip = video;
      _playbackToken += 1;
    } else if (_playbackVideoClip == null ||
        _playbackVideoClip!.playbackUrl != video.playbackUrl) {
      // covering만 같고 playback 슬롯이 비었으면 슬롯만 맞춘다(token 유지).
      _playbackVideoClip = video;
    }
    didSeekToSeconds(
      secondsFromNanoseconds(seekStartNs),
      resumePlayback: true,
    );
  }

  TimelineClip? _targetVideoClipFromDetail(ClipDetail detail) {
    if (!detail.hasTargetClip || detail.targetClipKind != 'VIDEO') {
      return null;
    }
    if (!isOpenNanosecondInterval(
      detail.targetTimelineStartNs,
      detail.targetTimelineEndNs,
    )) {
      return null;
    }
    final placed = _timelineClip(detail.targetClipId);
    final playbackUrl = placed != null && placed.playbackUrl.isNotEmpty
        ? placed.playbackUrl
        : detail.targetAssetContentUrl;
    if (playbackUrl.isEmpty) {
      return null;
    }
    if (placed == null &&
        (!detail.hasTargetAsset || !detail.isTargetAssetVideo)) {
      return null;
    }
    return TimelineClip(
      clipId: detail.targetClipId,
      trackId: placed?.trackId ?? '',
      kind: TimelineClipKind.video,
      startNs: detail.targetTimelineStartNs.isNotEmpty
          ? detail.targetTimelineStartNs
          : (placed?.startNs ?? ''),
      endNs: detail.targetTimelineEndNs.isNotEmpty
          ? detail.targetTimelineEndNs
          : (placed?.endNs ?? ''),
      assetId: placed != null && placed.assetId.isNotEmpty
          ? placed.assetId
          : detail.targetAssetId,
      fileName: placed != null && placed.fileName.isNotEmpty
          ? placed.fileName
          : detail.targetAssetFileName,
      playbackUrl: playbackUrl,
      description: '',
      showsToolBadge: false,
      sourceStartNs: placed?.sourceStartNs ?? '',
      sourceEndNs: placed?.sourceEndNs ?? '',
      assetDurationNs: placed?.assetDurationNs ?? '',
      assetStartTimeNs: placed?.assetStartTimeNs ?? '',
      waveformUrl: placed?.waveformUrl ?? '',
    );
  }

  Future<void> _startPosePlayback(ClipDetail pose, int epoch) async {
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
    final poseJsonUrl = _poseJsonUrl(pose);
    if (poseJsonUrl.isEmpty) {
      _failPose(pose, '포즈 좌표 파일 주소가 없습니다.');
      return;
    }
    if (!isOpenNanosecondInterval(pose.timelineStartNs, pose.timelineEndNs)) {
      _failPose(pose, '포즈 클립의 시간 구간이 올바르지 않습니다.');
      return;
    }

    final video = _targetVideoClipFromDetail(pose);
    if (video == null || video.playbackUrl.isEmpty) {
      _failPose(pose, '포즈의 대상 영상 파일이 없습니다.');
      return;
    }
    if (!isOpenNanosecondInterval(video.startNs, video.endNs)) {
      _failPose(pose, '대상 영상의 시간 구간이 올바르지 않습니다.');
      return;
    }

    final poseOverlapsVideo = doTimelineIntervalsOverlap(
      pose.timelineStartNs,
      pose.timelineEndNs,
      video.startNs,
      video.endNs,
    );
    final overlayStartNs = poseOverlapsVideo
        ? pose.timelineStartNs
        : video.startNs;
    final overlayEndNs = poseOverlapsVideo ? pose.timelineEndNs : video.endNs;
    _bindStageVideo(video, seekStartNs: overlayStartNs);

    await _ensurePoseFrames(assetId: pose.assetId, url: poseJsonUrl);
    if (epoch != _clipDetailEpoch || _isClosed) {
      return;
    }
    final frames =
        _framesByAssetId[pose.assetId] ?? const <VideoOverlayFrame>[];
    if (frames.isEmpty) {
      _failPose(pose, '포즈 좌표 파일을 읽지 못했거나 표시할 좌표가 없습니다.');
      return;
    }
    _selectedPoseOverlay = TimelineOverlay(
      assetId: pose.assetId,
      kind: TimelineOverlayKind.pose,
      contentUrl: poseJsonUrl,
      timelineStartNs: overlayStartNs,
      timelineEndNs: overlayEndNs,
      sourceStartNs: pose.sourceStartNs,
      sourceEndNs: pose.sourceEndNs,
    );
    _selectedPoseFrames = frames;
  }

  /// 타임라인 overlay·pose 클립 URL을 우선하고, 없을 때만 GetClip asset URL.
  String _poseJsonUrl(ClipDetail pose) {
    final fromOverlay = _overlayContentUrl(pose.assetId);
    if (fromOverlay != null && fromOverlay.isNotEmpty) {
      return fromOverlay;
    }
    final poseClip = _timelineClip(pose.clipId);
    if (poseClip != null && poseClip.playbackUrl.isNotEmpty) {
      return poseClip.playbackUrl;
    }
    return pose.assetContentUrl;
  }

  void _failPose(ClipDetail pose, String message) {
    _clipDetailMessage = message;
  }

  TimelineClip? _activeVideoClip() {
    final selected = _timelineClip(_selectedClipId);
    if (selected != null && selected.kind != TimelineClipKind.video) {
      final playback = _playbackVideoClip;
      if (playback != null && doesClipCoverSeconds(playback, playheadSeconds)) {
        return playback;
      }
      if (selected.kind == TimelineClipKind.pose) {
        return null;
      }
      final onTrack = _videoOnSelectedTrack(playheadSeconds);
      if (onTrack != null) {
        return onTrack;
      }
      return _retainedStageVideoClip;
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
          !doesClipCoverSeconds(clip, seconds)) {
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
    covering.sort((left, right) => compareTimelineClipId(right, left));
    return covering.first;
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

  void _dropClipDetail() {
    _clipDetailEpoch += 1;
    _isClipDetailLoading = false;
    _clipDetailLoadGate.clearPending();
    _clipDetailMessage = '';
    _clipDetail = null;
    _retainedStageVideoClip = null;
    _showsMissingTargetVideoBanner = false;
    _clearPosePlayback();
  }

  void _clearPoseOverlayOnly() {
    _selectedPoseOverlay = null;
    _selectedPoseFrames = const [];
  }

  void _clearPosePlayback() {
    _clearPoseOverlayOnly();
    _playbackVideoClip = null;
    _playhead.pause();
    _playbackToken += 1;
  }

  void didTapBar(String attachmentId) {
    WorkAttachment? attachment = _attachmentById(attachmentId);
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
    _isTrackMenuOpen = false;
    if (bar != null) {
      didSeekToSeconds(bar.startSeconds);
      return;
    }
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
    _noteScreenCommentChange();
    notifyListeners();
  }

  void didTapTogglePlayback() {
    if (_playhead.wantsPlayback) {
      _playhead.pause();
      _playbackToken += 1;
      _noteScreenCommentChange();
      notifyListeners();
      return;
    }
    _playhead.play(spanSeconds: spanSeconds);
    _coveringVideoClipId = '';
    _playbackToken += 1;
    _seekToken += 1;
    _syncPlayheadClock();
    _noteScreenCommentChange();
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
    if (coveringChanged || _doesPrimaryCoveringNeedStepSeek()) {
      _seekToken += 1;
    }
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

  /// 선택한 클립에 필요한 오버레이·포즈 본문만 ReadContent로 채운다.
  Future<void> _ensureOverlayBodiesForSelection(
    TimelineClip clip, {
    ClipDetail? detail,
  }) async {
    final epoch = _overlayEpoch;
    if (detail?.isPose == true || clip.kind == TimelineClipKind.pose) {
      final assetId = detail != null && detail.assetId.isNotEmpty
          ? detail.assetId
          : clip.assetId;
      final url = detail != null
          ? _poseJsonUrl(detail)
          : (_overlayContentUrl(clip.assetId) ?? clip.playbackUrl);
      await _ensurePoseFrames(assetId: assetId, url: url);
      return;
    }
    if (clip.kind == TimelineClipKind.subtitle) {
      final url = _overlayContentUrl(clip.assetId) ?? clip.playbackUrl;
      await _ensureSubtitleCues(assetId: clip.assetId, url: url);
      return;
    }
    if (detail?.isVideo == true || clip.kind == TimelineClipKind.video) {
      final startNs = detail != null && detail.timelineStartNs.isNotEmpty
          ? detail.timelineStartNs
          : clip.startNs;
      final endNs = detail != null && detail.timelineEndNs.isNotEmpty
          ? detail.timelineEndNs
          : clip.endNs;
      await _ensureSubtitleOverlaysOverlapping(
        startNs: startNs,
        endNs: endNs,
        epoch: epoch,
      );
      return;
    }
    if (detail != null &&
        detail.hasTargetClip &&
        detail.targetClipKind == 'VIDEO') {
      await _ensureSubtitleOverlaysOverlapping(
        startNs: detail.targetTimelineStartNs,
        endNs: detail.targetTimelineEndNs,
        epoch: epoch,
      );
    }
  }

  String? _overlayContentUrl(String assetId) {
    if (assetId.isEmpty) {
      return null;
    }
    for (final overlay in _timeline.overlays) {
      if (overlay.assetId == assetId && overlay.contentUrl.isNotEmpty) {
        return overlay.contentUrl;
      }
    }
    return null;
  }

  Future<void> _ensurePoseFrames({
    required String assetId,
    required String url,
  }) async {
    if (assetId.isEmpty || url.isEmpty) {
      return;
    }
    if (_framesByAssetId.containsKey(assetId)) {
      return;
    }
    final pending = _framesInflight[assetId];
    if (pending != null) {
      await pending;
      return;
    }
    final epoch = _overlayEpoch;
    final future = () async {
      final body = await _getJobTimelineUseCase.readContent(url: url);
      if (epoch != _overlayEpoch || _isClosed) {
        return;
      }
      _framesByAssetId[assetId] = parsePoseOverlay(body);
      _rebuildPoseBoardMarks();
    }();
    _framesInflight[assetId] = future;
    try {
      await future;
    } finally {
      if (identical(_framesInflight[assetId], future)) {
        _framesInflight.remove(assetId);
      }
    }
  }

  Future<void> _ensureSubtitleCues({
    required String assetId,
    required String url,
  }) async {
    if (assetId.isEmpty || url.isEmpty) {
      return;
    }
    if (_cuesByAssetId.containsKey(assetId)) {
      return;
    }
    final pending = _cuesInflight[assetId];
    if (pending != null) {
      await pending;
      return;
    }
    final epoch = _overlayEpoch;
    final future = () async {
      final body = await _getJobTimelineUseCase.readContent(url: url);
      if (epoch != _overlayEpoch || _isClosed) {
        return;
      }
      _cuesByAssetId[assetId] = parseSubtitleCues(body);
    }();
    _cuesInflight[assetId] = future;
    try {
      await future;
    } finally {
      if (identical(_cuesInflight[assetId], future)) {
        _cuesInflight.remove(assetId);
      }
    }
  }

  void _clearOverlayBodies() {
    _framesByAssetId.clear();
    _cuesByAssetId.clear();
    _framesInflight.clear();
    _cuesInflight.clear();
    _poseBoardMarksByClipId.clear();
  }

  Future<void> _ensureSubtitleOverlaysOverlapping({
    required String startNs,
    required String endNs,
    required int epoch,
  }) async {
    if (startNs.isEmpty || endNs.isEmpty) {
      return;
    }
    final pending = <Future<void>>[];
    final queuedAssetIds = <String>{};
    for (final overlay in _timeline.overlays) {
      if (overlay.kind != TimelineOverlayKind.subtitle) {
        continue;
      }
      if (overlay.assetId.isEmpty) {
        continue;
      }
      if (!doTimelineIntervalsOverlap(
        overlay.timelineStartNs,
        overlay.timelineEndNs,
        startNs,
        endNs,
      )) {
        continue;
      }
      if (!queuedAssetIds.add(overlay.assetId)) {
        continue;
      }
      pending.add(
        _ensureSubtitleCues(assetId: overlay.assetId, url: overlay.contentUrl),
      );
    }
    if (pending.isEmpty) {
      return;
    }
    await Future.wait(pending);
    if (epoch != _overlayEpoch || _isClosed) {
      return;
    }
  }

  void _rebuildPoseBoardMarks() {
    final next = <String, List<PoseBoardMark>>{};
    for (final clip in _timeline.clips) {
      if (clip.kind != TimelineClipKind.pose) {
        continue;
      }
      final frames = _framesByAssetId[clip.assetId];
      if (frames == null || frames.isEmpty) {
        continue;
      }
      final startSeconds = secondsFromNanoseconds(clip.startNs);
      final endSeconds = secondsFromNanoseconds(clip.endNs);
      final marks = poseBoardMarksFromFrames(
        frames: frames,
        clipStartSeconds: startSeconds,
        clipEndSeconds: endSeconds,
      );
      if (marks.isEmpty) {
        continue;
      }
      next[clip.clipId] = marks;
    }
    _poseBoardMarksByClipId
      ..clear()
      ..addAll(next);
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
    if (trackId.isEmpty || !trackHasVideo(trackId)) {
      return;
    }
    if (_monitoredTrackIds.contains(trackId)) {
      _monitoredTrackIds.remove(trackId);
      if (_focusedMonitorTrackId == trackId) {
        _setFocusedMonitorTrack(
          monitoredTrackIds.isEmpty ? '' : monitoredTrackIds.first,
        );
      }
      notifyListeners();
      return;
    }
    if (monitoredTrackIds.length >= MAX_MONITORED_TRACK_COUNT) {
      didShowNotice('모니터는 최대 $MAX_MONITORED_TRACK_COUNT개까지입니다.');
      return;
    }
    _monitoredTrackIds.add(trackId);
    _setFocusedMonitorTrack(trackId);
    notifyListeners();
  }

  bool trackHasTimeseries(String trackId) =>
      _trackHasChartKind(trackId, ClipChartKind.timeseries);
  bool trackHasAudio(String trackId) =>
      _trackHasChartKind(trackId, ClipChartKind.audio);
  bool _trackHasChartKind(String trackId, ClipChartKind chartKind) {
    for (final clip in _timeline.clips) {
      if (clip.trackId == trackId && clipChartKindOf(clip.kind) == chartKind) {
        return true;
      }
    }
    return false;
  }

  /// 트랙에 재생 URL이 있는 VIDEO 클립이 있으면 true (videocam·모니터 대상).
  bool trackHasVideo(String trackId) {
    for (final clip in _timeline.clips) {
      if (clip.trackId == trackId &&
          clip.kind == TimelineClipKind.video &&
          clip.playbackUrl.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  bool isTimeseriesChartExpanded(String clipId) =>
      clipId.isNotEmpty && clipId == _chartSession.clipId;
  void didTapToggleTimeseriesChart(String trackId) {
    _didTapToggleChart(trackId, ClipChartKind.timeseries);
  }

  void didTapToggleAudioChart(String trackId) {
    _didTapToggleChart(trackId, ClipChartKind.audio);
  }

  void _didTapToggleChart(String trackId, ClipChartKind chartKind) {
    if (trackId.isEmpty || !_trackHasChartKind(trackId, chartKind)) {
      return;
    }
    final timelineKind = chartKind.timelineKind;
    final selected = _timelineClip(_selectedClipId);
    TimelineClip? target;
    if (selected != null &&
        selected.trackId == trackId &&
        clipChartKindOf(selected.kind) == chartKind) {
      target = selected;
    } else {
      target = _coveringClipOnTrack(trackId, playheadSeconds, timelineKind);
      target ??= _firstClipOnTrack(trackId, timelineKind);
    }
    if (target == null) {
      return;
    }
    if (_chartSession.clipId == target.clipId) {
      _collapseChart();
      notifyListeners();
      return;
    }
    _prepareChart(target, chartKind);
    unawaited(_loadClipDetail(target.clipId));
  }

  void didTapTimeseriesChartTime(int timeMs) {
    _didSeekChartTime(timeMs);
  }

  void didTapAudioChartTime(int timeMs) {
    _didSeekChartTime(timeMs);
  }

  void _didSeekChartTime(int timeMs) {
    final clip = _timelineClip(_chartSession.clipId);
    if (clip == null) {
      return;
    }
    final start = secondsFromNanoseconds(clip.startNanoseconds);
    didSeekToSeconds(start + timeMs / 1000.0);
  }

  TimelineClip? _coveringClipOnTrack(
    String trackId,
    double seconds,
    TimelineClipKind kind,
  ) {
    TimelineClip? best;
    for (final clip in _timeline.clips) {
      if (clip.trackId != trackId || clip.kind != kind) {
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

  TimelineClip? _firstClipOnTrack(String trackId, TimelineClipKind kind) {
    TimelineClip? best;
    for (final clip in _timeline.clips) {
      if (clip.trackId != trackId || clip.kind != kind) {
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

  void _prepareChartIfNeeded(TimelineClip clip) {
    final chartKind = clipChartKindOf(clip.kind);
    if (chartKind == null) {
      _collapseChart();
      return;
    }
    if (_chartSession.clipId == clip.clipId) {
      return;
    }
    _prepareChart(clip, chartKind);
  }

  /// 차트 UI만 연다. GetClip은 호출하지 않는다.
  void _prepareChart(TimelineClip clip, ClipChartKind chartKind) {
    _chartSession.prepare(clipId: clip.clipId, kind: chartKind);
    _selectedClipId = clip.clipId;
    notifyListeners();
  }

  void _collapseChart() {
    _chartSession.collapse();
  }

  void _loadChartFor(TimelineClip clip, ClipDetail detail) {
    final chartKind = clipChartKindOf(clip.kind);
    if (chartKind == null || _chartSession.clipId != clip.clipId) {
      return;
    }
    switch (chartKind) {
      case ClipChartKind.audio:
        unawaited(_loadAudioChart(clip, detail));
      case ClipChartKind.timeseries:
        unawaited(_loadTimeseriesChart(clip, detail));
    }
  }

  Future<void> _loadTimeseriesChart(
    TimelineClip clip,
    ClipDetail detail,
  ) async {
    final epoch = _chartSession.beginLoad();
    notifyListeners();
    if (clip.contentUrl.isEmpty) {
      if (!_chartSession.isCurrentEpoch(epoch) || _isClosed) {
        return;
      }
      _chartSession.isLoading = false;
      _chartSession.error = '파형 주소가 없습니다';
      notifyListeners();
      return;
    }
    try {
      final load = await _loadTimeseriesWaveformUseCase.execute(
        contentUrl: clip.contentUrl,
        channelNames: detail.channelNames,
      );
      if (!_chartSession.isCurrentEpoch(epoch) || _isClosed) {
        return;
      }
      _chartSession.timeseriesSeries = load.series;
      if (!load.series.doesHaveAnySeries) {
        _chartSession.error = '파형 데이터 없음';
      }
    } catch (error) {
      if (!_chartSession.isCurrentEpoch(epoch) || _isClosed) {
        return;
      }
      _chartSession.error = error.toString();
      _chartSession.timeseriesSeries =
          LoadTimeseriesWaveformUseCase.emptySeries;
    } finally {
      if (_chartSession.isCurrentEpoch(epoch) && !_isClosed) {
        _chartSession.isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _loadAudioChart(TimelineClip clip, ClipDetail detail) async {
    final epoch = _chartSession.beginLoad();
    notifyListeners();
    final waveformUrl = clip.waveformUrl.isNotEmpty
        ? clip.waveformUrl
        : detail.waveformUrl;
    final sourceStartNs = detail.sourceStartNs.isNotEmpty
        ? detail.sourceStartNs
        : clip.sourceStartNs;
    final sourceEndNs = detail.sourceEndNs.isNotEmpty
        ? detail.sourceEndNs
        : clip.sourceEndNs;
    try {
      final load = await _loadAudioWaveformUseCase.execute(
        waveformUrl: waveformUrl,
        sourceStartNs: sourceStartNs,
        sourceEndNs: sourceEndNs,
      );
      if (!_chartSession.isCurrentEpoch(epoch) || _isClosed) {
        return;
      }
      _chartSession.audioAmplitudes = load.amplitudes;
      _chartSession.error = load.errorMessage;
    } catch (error) {
      if (!_chartSession.isCurrentEpoch(epoch) || _isClosed) {
        return;
      }
      _chartSession.error = error.toString();
      _chartSession.audioAmplitudes = const [];
    } finally {
      if (_chartSession.isCurrentEpoch(epoch) && !_isClosed) {
        _chartSession.isLoading = false;
        notifyListeners();
      }
    }
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
        await _ensureProjectId();
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

  Future<void> _ensureProjectId() async {
    if (jobId.isEmpty || _projectId.isNotEmpty) {
      return;
    }
    try {
      final projectId = await _loadJobProjectIdUseCase.execute(jobId: jobId);
      if (!_isClosed && projectId.isNotEmpty) {
        _projectId = projectId;
      }
    } catch (error) {
      return;
    }
  }

  void didTapCitation(AskCitation citation) {
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
        doesClipCoverSeconds(named, citation.startSeconds)) {
      return named;
    }
    return _videoClipAt(citation.startSeconds);
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
    return timelineClipKindLabel(clip.kind);
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
      LabelRootsSessionCache.put(_labelRoots);
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
      LabelRootsSessionCache.put(_labelRoots);
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
      LabelRootsSessionCache.put(_labelRoots);
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

  Future<void> loadLabelSections() => _ensureLabels();
  Future<void> _ensureLabels() async {
    final epoch = ++_labelEpoch;
    final cached = LabelRootsSessionCache.roots;
    if (cached != null) {
      if (epoch != _labelEpoch || _isClosed) {
        return;
      }
      _labelRoots = List<LabelNode>.from(cached);
      _isLoadingLabels = false;
      _labelMessage = '';
      notifyListeners();
      return;
    }
    _isLoadingLabels = true;
    _labelMessage = '';
    notifyListeners();
    try {
      final roots = await _labelUseCase.listLabels();
      if (epoch != _labelEpoch || _isClosed) {
        return;
      }
      _labelRoots = roots;
      LabelRootsSessionCache.put(roots);
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

  void didTapToggleLabels() {
    final willOpen = _side != VideoMultimodalSide.labels;
    _toggleSide(VideoMultimodalSide.labels);
    if (willOpen) {
      unawaited(loadLabelSections());
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
    if (isSpeechToText && isDepthVideoFileName(_selectedTargetFileName())) {
      _inferencePhase = InferencePanelPhase.failed;
      _inferenceMessage = '깊이 영상에는 소리가 없어 STT를 실행할 수 없습니다.';
      notifyListeners();
      return;
    }
    if (isSpeechToText && !_ensureSpeechToTextClipSelected()) {
      _inferencePhase = InferencePanelPhase.failed;
      _inferenceMessage = 'STT는 음성 클립을 대상으로 실행하세요. 녹화 음성을 선택한 뒤 다시 실행하세요.';
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

  void didBeginScreenCommentCapture() {
    _isCapturingScreenComment = true;
    _screenCommentStartedAt = DateTime.now();
    _screenCommentRows
      ..clear()
      ..add(_screenCommentRow(0));
  }

  List<Map<String, Object?>> takeScreenCommentContext() {
    if (_screenCommentRows.isEmpty) {
      return [_screenCommentRow(0)];
    }
    return [
      for (final row in _screenCommentRows) Map<String, Object?>.from(row),
    ];
  }

  void _noteScreenCommentChange() {
    if (!_isCapturingScreenComment || _screenCommentStartedAt == null) {
      return;
    }
    final elapsed = DateTime.now().difference(_screenCommentStartedAt!);
    final tMs = elapsed.inMilliseconds < 0 ? 0 : elapsed.inMilliseconds;
    final row = _screenCommentRow(tMs);
    final previous = _screenCommentRows.last;
    if (_screenCommentSignature(previous) == _screenCommentSignature(row)) {
      return;
    }
    _screenCommentRows.add(row);
  }

  String _screenCommentSignature(Map<String, Object?> row) {
    return '${row['range']}|${row['selected']}|${row['view']}';
  }

  Map<String, Object?> _screenCommentRow(int tMs) {
    final nanoseconds = nanosecondsFromSeconds(playheadSeconds);
    final point = int.tryParse(nanoseconds) ?? 0;
    final row = <String, Object?>{
      't_ms': tMs,
      'screen': 'multimodal',
      'range': {'start_ns': point, 'end_ns': point},
    };
    final job = int.tryParse(jobId);
    if (job != null) {
      row['job_id'] = job;
    }
    final clip = _timelineClip(_selectedClipId);
    final clipId = int.tryParse(clip?.clipId ?? '');
    if (clipId != null) {
      row['selected'] = [
        {'clip_id': clipId},
      ];
    }
    final tracks = <int>[];
    for (final trackId in monitoredTrackIds) {
      final value = int.tryParse(trackId);
      if (value != null) {
        tracks.add(value);
      }
    }
    final view = <String, Object?>{
      'playing': wantsPlayback,
      'speed': timelinePlaybackRate,
    };
    if (tracks.isNotEmpty) {
      view['tracks'] = tracks;
    }
    final panel = switch (_side) {
      VideoMultimodalSide.assets => 'assets',
      VideoMultimodalSide.properties => 'properties',
      VideoMultimodalSide.labels => 'labels',
      VideoMultimodalSide.ask => 'ask',
      VideoMultimodalSide.comments => 'comments',
      VideoMultimodalSide.none => null,
    };
    if (panel != null) {
      view['panel'] = panel;
    }
    row['view'] = view;
    return row;
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

  /// STT는 음성 클립 대상. 영상/미선택이면 녹화 음성(또는 아무 음성) 클립으로 맞춘다.
  bool _ensureSpeechToTextClipSelected() {
    final selected = _timelineClip(_selectedClipId);
    if (selected != null && selected.kind == TimelineClipKind.audio) {
      return true;
    }
    for (final track in _timeline.tracks) {
      if (!_isRecordingTrackName(track.name, isVideo: false)) {
        continue;
      }
      for (final clip in track.clips) {
        if (clip.kind == TimelineClipKind.audio && clip.clipId.isNotEmpty) {
          _selectedClipId = clip.clipId;
          return true;
        }
      }
    }
    for (final track in _timeline.tracks) {
      for (final clip in track.clips) {
        if (clip.kind == TimelineClipKind.audio && clip.clipId.isNotEmpty) {
          _selectedClipId = clip.clipId;
          return true;
        }
      }
    }
    return false;
  }

  void didTapSelectTool() {
    _isRelationMode = false;
    _relationAnchorClipId = '';
    _clearNotice();
    notifyListeners();
  }

  Future<void> _restoreActiveToolRun() async {
    if (jobId.isEmpty || _inferencePhase != InferencePanelPhase.hidden) {
      return;
    }
    late final List<ToolRunSnapshot> runs;
    try {
      runs = await _toolRunUseCase.listJobRuns(jobId: jobId);
    } catch (error) {
      rethrow;
    }
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
    _inferenceMessage = run.status == ToolRunStatus.queued
        ? run.queueWaitLabel
        : '';
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

  void didClearTimelineHint() {
    if (_timelineHint.isEmpty) {
      return;
    }
    _timelineHint = '';
    notifyListeners();
  }

  Future<String?> _ensureTrackId(
    String name, {
    bool announceVectorSave = true,
  }) async {
    final existing = _trackIdByName(name);
    if (existing != null) {
      return existing;
    }
    final didCreate = await createTimelineTrack(
      name: name,
      announceVectorSave: announceVectorSave,
    );
    if (!didCreate) {
      return null;
    }
    return _trackIdByName(name);
  }

  /// 업로드마다 별도 녹화 트랙. 같은 asset이면 기존 녹화 트랙을 재사용한다.
  Future<String?> _ensureRecordingTrackId({
    required String assetId,
    required bool isVideo,
  }) async {
    final existingClip = _findAssetClip(assetId);
    if (existingClip != null &&
        _isRecordingTrackName(
          _trackName(existingClip.trackId),
          isVideo: isVideo,
        )) {
      return existingClip.trackId;
    }
    final wanted = _nextRecordingTrackName(isVideo: isVideo);
    if (!_hasRecordingTrack(isVideo: isVideo)) {
      final placeholder = isVideo
          ? SERVER_EMPTY_EQUIPMENT_VIDEO_TRACK_NAME
          : SERVER_EMPTY_EQUIPMENT_AUDIO_TRACK_NAME;
      final placeholderId = _trackIdByName(placeholder);
      if (placeholderId != null) {
        final didRename = await _commitServerWrite(
          () =>
              _updateTrackUseCase.execute(trackId: placeholderId, name: wanted),
          changedTrackCount: 1,
          announceVectorSave: false,
        );
        if (!didRename) {
          return null;
        }
        return _trackIdByName(wanted) ?? placeholderId;
      }
    }
    return _ensureTrackId(wanted, announceVectorSave: false);
  }

  String _nextRecordingTrackName({required bool isVideo}) {
    final base = isVideo
        ? RECORDING_VIDEO_TRACK_NAME
        : RECORDING_AUDIO_TRACK_NAME;
    if (_trackIdByName(base) == null) {
      return base;
    }
    var index = 2;
    while (_trackIdByName('$base $index') != null) {
      index += 1;
    }
    return '$base $index';
  }

  bool _hasRecordingTrack({required bool isVideo}) {
    for (final track in _timeline.tracks) {
      if (_isRecordingTrackName(track.name, isVideo: isVideo)) {
        return true;
      }
    }
    return false;
  }

  bool _isRecordingTrackName(String name, {required bool isVideo}) {
    final trimmed = name.trim();
    final base = isVideo
        ? RECORDING_VIDEO_TRACK_NAME
        : RECORDING_AUDIO_TRACK_NAME;
    return trimmed == base || trimmed.startsWith('$base ');
  }

  String? _trackIdByName(String name) {
    for (final track in _timeline.tracks) {
      if (track.name.trim() == name && track.trackId.isNotEmpty) {
        return track.trackId;
      }
    }
    return null;
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
    bool announceVectorSave = true,
  }) {
    return _commitServerWrite(
      () => _createTrackUseCase.execute(
        jobId: jobId,
        name: name,
        order: order,
        isVisible: isVisible,
      ),
      changedTrackCount: 1,
      announceVectorSave: announceVectorSave,
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
    bool announceVectorSave = true,
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
      announceVectorSave: announceVectorSave,
    );
  }

  Future<bool> updateTimelineClip({
    required String clipId,
    String? trackId,
    String? startNs,
    String? endNs,
    String? assetId,
    String? labelValueId,
    String? description,
    bool? isReviewed,
    bool announceVectorSave = true,
  }) {
    final clip = _timelineClip(clipId);
    if (clip == null) {
      return Future.value(false);
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
      return Future.value(true);
    }
    final resolvedStart = nextStart ?? clip.startNs;
    final resolvedEnd = nextEnd ?? clip.endNs;
    if ((nextStart != null || nextEnd != null) &&
        !isOpenNanosecondInterval(resolvedStart, resolvedEnd)) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return Future.value(false);
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
      announceVectorSave: announceVectorSave,
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
    if (!didReload) {
      throw JobTimelineException(
        _timelineHint.isEmpty ? '타임라인을 불러오지 못했습니다.' : _timelineHint,
      );
    }
    if (_isClosed) {
      return;
    }
    final trackId = await _ensureRecordingTrackId(
      assetId: assetId,
      isVideo: isVideo,
    );
    if (trackId == null) {
      throw JobTimelineException(
        _timelineHint.isEmpty ? '녹화 트랙을 만들 수 없습니다.' : _timelineHint,
      );
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
    final range = _recordingClipRangeAtPlayhead(assetId);
    final existing = _findAssetClip(assetId);
    if (existing != null && existing.trackId == trackId) {
      if (existing.startNs == range.startNs && existing.endNs == range.endNs) {
        _selectPlacedRecordingClip(assetId, isVideo: isVideo);
        return;
      }
      final didMove = await updateTimelineClip(
        clipId: existing.clipId,
        startNs: range.startNs,
        endNs: range.endNs,
        announceVectorSave: false,
      );
      if (!didMove) {
        throw JobTimelineException(
          _timelineHint.isEmpty ? '녹화 클립 위치를 맞추지 못했습니다.' : _timelineHint,
        );
      }
      _selectPlacedRecordingClip(assetId, isVideo: isVideo);
      return;
    }
    if (existing != null) {
      final didMove = await updateTimelineClip(
        clipId: existing.clipId,
        trackId: trackId,
        startNs: range.startNs,
        endNs: range.endNs,
        announceVectorSave: false,
      );
      if (!didMove) {
        throw JobTimelineException(
          _timelineHint.isEmpty ? '녹화 트랙으로 옮기지 못했습니다.' : _timelineHint,
        );
      }
      _selectPlacedRecordingClip(assetId, isVideo: isVideo);
      return;
    }
    final didSave = await createTimelineClip(
      trackId: trackId,
      kind: isVideo ? TimelineClipKind.video : TimelineClipKind.audio,
      startNs: range.startNs,
      endNs: range.endNs,
      assetId: assetId,
      sourceStartNs: range.sourceStartNs,
      sourceEndNs: range.sourceEndNs,
      sourceLimitNs: range.sourceLimitNs,
      announceVectorSave: false,
    );
    if (!didSave) {
      throw JobTimelineException(
        _timelineHint.isEmpty ? '녹화 클립을 만들지 못했습니다.' : _timelineHint,
      );
    }
    _selectPlacedRecordingClip(assetId, isVideo: isVideo);
  }

  /// 녹화 업로드 완료 후 타임라인·Assets만 갱신. 전체 로딩 오버레이는 쓰지 않는다.
  Future<void> refreshAfterRecordingUpload() async {
    if (_isClosed || jobId.isEmpty) {
      return;
    }
    _commentListReloadCount += 1;
    notifyListeners();
    await _replaceTimelineFromServer(clearHint: false);
    if (_isClosed) {
      return;
    }
    await _loadSideAssets();
  }

  void _selectPlacedRecordingClip(String assetId, {required bool isVideo}) {
    if (isVideo || _isClosed) {
      return;
    }
    final clip = _findAssetClip(assetId);
    if (clip == null || clip.clipId.isEmpty) {
      return;
    }
    _selectedClipId = clip.clipId;
    notifyListeners();
  }

  ({
    String startNs,
    String endNs,
    String sourceStartNs,
    String sourceEndNs,
    String sourceLimitNs,
  })
  _recordingClipRangeAtPlayhead(String assetId) {
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
        throw const JobTimelineException('소스 구간이 올바르지 않습니다.');
      }
    } else {
      endNs = nanosecondsFromSeconds(
        startSeconds + DEFAULT_TIMELESS_CLIP_SECONDS,
      );
      sourceStartNs = '';
      sourceEndNs = '';
    }
    if (!isOpenNanosecondInterval(startNs, endNs)) {
      throw const JobTimelineException('구간이 너무 짧습니다.');
    }
    return (
      startNs: startNs,
      endNs: endNs,
      sourceStartNs: sourceStartNs,
      sourceEndNs: sourceEndNs,
      sourceLimitNs: hasDuration ? durationNs : '',
    );
  }

  TimelineClip? _findAssetClip(String assetId) {
    for (final track in _timeline.tracks) {
      for (final clip in track.clips) {
        if (clip.assetId == assetId) {
          return clip;
        }
      }
    }
    return null;
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
    required String trackId,
    required double startSeconds,
  }) {
    _createdClipNotice = null;
    if (dragData.startsWith('media:')) {
      didRejectMediaDrop();
      return Future.value();
    }
    final attachmentId = _attachmentIdFromDragData(dragData);
    if (isServerTimelineTrack(trackId)) {
      if (attachmentId == null) {
        return Future.value();
      }
      final attachment = _attachmentById(attachmentId);
      if (attachment == null) {
        return Future.value();
      }
      return didCreateTimelineClipOnTrack(
        trackId: trackId,
        attachment: attachment,
        startSeconds: startSeconds,
      );
    }
    return Future.value();
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
    for (final attachment in _assetsPageRows) {
      if (attachment.attachmentId == attachmentId) {
        return attachment;
      }
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
    final kindLabel = timelineClipKindLabel(kind);
    final trimmed = detail.trim();
    return CreatedClipNotice(
      kindLabel: kindLabel,
      body: trimmed.isEmpty ? kindLabel : trimmed,
    );
  }

  TimelineClipKind _clipKindForAttachment(WorkAttachment attachment) {
    final clipKind = attachment.clipKind;
    if (clipKind != null) {
      return clipKind;
    }
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
    bool announceVectorSave = true,
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
      if (didSave && announceVectorSave) {
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
      _clipDetailCache.clear();
      _overlayEpoch += 1;
      _clearOverlayBodies();
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

  void didRejectMediaDrop() {
    _timelineHint = '영상·오디오는 타임라인에 떨어뜨릴 수 없습니다.';
    notifyListeners();
  }

  bool isServerTimelineTrack(String trackId) {
    for (final track in _timeline.tracks) {
      if (track.trackId == trackId) {
        return true;
      }
    }
    return false;
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

  String clipCaption(TimelineClip clip) {
    final text = labelForClip(clip);
    if (clip.labelValueId.isEmpty) {
      return text;
    }
    return '#$text';
  }

  void didReceiveWorkName(String workName) {
    _workName = workName.trim();
    notifyListeners();
  }

  bool isTrackVisible(String trackId) => !_hiddenTrackIds.contains(trackId);
  CreatedClipNotice? takeCreatedClipNotice() {
    final notice = _createdClipNotice;
    _createdClipNotice = null;
    return notice;
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
    final next = query;
    if (next == _assetsSearchQuery) {
      return;
    }
    _assetsSearchQuery = next;
    _resetAssetsPageCache();
    notifyListeners();
    _loadAssetsPage(1);
  }

  void didTapRefresh() {
    openTimeline();
  }

  void didTapToggleAssets() {
    final willOpen = _side != VideoMultimodalSide.assets;
    _toggleSide(VideoMultimodalSide.assets);
    if (willOpen &&
        _assetsPageRows.isEmpty &&
        !_isLoadingAssetsPage &&
        jobId.isNotEmpty) {
      unawaited(_loadAssetsPage(1));
    }
  }

  void didTapToggleProperties() {
    _toggleSide(VideoMultimodalSide.properties);
  }

  void didTapToggleComments() {
    _toggleSide(VideoMultimodalSide.comments);
  }

  /// 보드 상단 핸들을 위로 끌면 커지고, 아래로 끌면 줄어든다.
  void didDragTimelineBoardHeight(double deltaDy, {required double maxHeight}) {
    final limit = maxHeight.clamp(MIN_TIMELINE_HEIGHT, MAX_TIMELINE_HEIGHT);
    _timelineBoardHeight = (_timelineBoardHeight - deltaDy).clamp(
      MIN_TIMELINE_HEIGHT,
      limit,
    );
    notifyListeners();
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
    _isTrackMenuOpen = false;
    _noteScreenCommentChange();
    notifyListeners();
  }

  void didTapCloseSide() {
    if (_side == VideoMultimodalSide.none) {
      return;
    }
    _side = VideoMultimodalSide.none;
    _noteScreenCommentChange();
    notifyListeners();
  }

  void didTapToggleTrackVisibility(String trackId) {
    if (_hiddenTrackIds.contains(trackId)) {
      _hiddenTrackIds.remove(trackId);
    } else {
      _hiddenTrackIds.add(trackId);
    }
    notifyListeners();
  }

  void didTapToggleTrackMenu() {
    _isTrackMenuOpen = !_isTrackMenuOpen;
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

  void _clearNotice() {
    _noticeText = '';
  }

  @override
  void dispose() {
    _isClosed = true;
    _clipDetailLoadGate.clearPending();
    _playhead.dispose();
    _clipDetailEpoch += 1;
    _toolRunEpoch += 1;
    _labelEpoch += 1;
    _overlayEpoch += 1;
    super.dispose();
  }
}
