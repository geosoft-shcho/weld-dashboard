import 'package:flutter/foundation.dart';

import '../../../domain/entities/job_timeline.dart';
import '../../../domain/entities/work_attachment.dart';
import '../../../domain/entities/work_attachment_type.dart';
import '../../../domain/timeline_time.dart';
import '../../../domain/use_cases/change_timeline_status_use_case.dart';
import '../../../domain/use_cases/create_clip_use_case.dart';
import '../../../domain/use_cases/create_track_use_case.dart';
import '../../../domain/use_cases/delete_clip_use_case.dart';
import '../../../domain/use_cases/delete_track_use_case.dart';
import '../../../domain/use_cases/get_job_timeline_use_case.dart';
import '../../../domain/use_cases/list_history_work_attachments_use_case.dart';
import '../../../domain/use_cases/update_clip_use_case.dart';
import '../../../domain/use_cases/update_track_use_case.dart';
import 'video_caption.dart';
import 'video_frame_mark.dart';
import 'video_frame_mark_debug.dart';
import 'video_frame_mark_json.dart';

enum VideoMultimodalSide { none, assets, properties, ask, labels }

/// ListWorkAttachments 를 타임라인에 임시로 올려 둔 막대.
/// start/end 는 서버 레이어가 아니므로 파일마다 고정 길이로 이어 붙인다.
class TemporaryAttachmentBar {
  const TemporaryAttachmentBar({
    required this.attachmentId,
    required this.fileName,
    required this.fileTypeLabel,
    required this.mediaUrl,
    required this.note,
    required this.isVideo,
    required this.startSeconds,
    required this.endSeconds,
  });

  final String attachmentId;
  final String fileName;
  final String fileTypeLabel;
  final String mediaUrl;
  final String note;
  final bool isVideo;
  final double startSeconds;
  final double endSeconds;

  TemporaryAttachmentBar copyWith({double? startSeconds, double? endSeconds}) {
    return TemporaryAttachmentBar(
      attachmentId: attachmentId,
      fileName: fileName,
      fileTypeLabel: fileTypeLabel,
      mediaUrl: mediaUrl,
      note: note,
      isVideo: isVideo,
      startSeconds: startSeconds ?? this.startSeconds,
      endSeconds: endSeconds ?? this.endSeconds,
    );
  }
}

class TimelineSampleClip {
  TimelineSampleClip({
    required this.clipId,
    required this.laneKey,
    required this.laneLabel,
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
    required this.showsAiBadge,
    required this.isDashed,
  });

  final String clipId;
  final String laneKey;
  final String laneLabel;
  final String text;
  double startSeconds;
  double endSeconds;
  final bool showsAiBadge;
  final bool isDashed;
}

class PaletteSection {
  PaletteSection({
    required this.sectionKey,
    required this.title,
    required this.names,
  });

  final String sectionKey;
  final String title;
  final List<String> names;
}

class AskTurn {
  const AskTurn({
    required this.isUser,
    required this.text,
    this.citationStartSeconds,
    this.citationEndSeconds,
  });

  final bool isUser;
  final String text;
  final double? citationStartSeconds;
  final double? citationEndSeconds;
}

class SampleLayerSummary {
  const SampleLayerSummary({
    required this.layerId,
    required this.displayName,
    required this.kind,
    required this.order,
    required this.isHidden,
    required this.isMainLayer,
    required this.revision,
    required this.contentStatus,
    required this.tagType,
    required this.segmentCount,
  });

  final String layerId;
  final String displayName;
  final String kind;
  final int order;
  final bool isHidden;
  final bool isMainLayer;
  final String revision;
  final String contentStatus;
  final String tagType;
  final int segmentCount;
}

enum InferencePanelPhase { hidden, running, done, failed }

class VideoMultimodalViewModel extends ChangeNotifier {
  VideoMultimodalViewModel({
    required ListHistoryWorkAttachmentsUseCase
    listHistoryWorkAttachmentsUseCase,
    required GetJobTimelineUseCase getJobTimelineUseCase,
    required CreateTrackUseCase createTrackUseCase,
    required UpdateTrackUseCase updateTrackUseCase,
    required DeleteTrackUseCase deleteTrackUseCase,
    required CreateClipUseCase createClipUseCase,
    required UpdateClipUseCase updateClipUseCase,
    required DeleteClipUseCase deleteClipUseCase,
    required ChangeTimelineStatusUseCase changeTimelineStatusUseCase,
    required this.jobId,
  }) : _listHistoryWorkAttachmentsUseCase = listHistoryWorkAttachmentsUseCase,
       _getJobTimelineUseCase = getJobTimelineUseCase,
       _createTrackUseCase = createTrackUseCase,
       _updateTrackUseCase = updateTrackUseCase,
       _deleteTrackUseCase = deleteTrackUseCase,
       _createClipUseCase = createClipUseCase,
       _updateClipUseCase = updateClipUseCase,
       _deleteClipUseCase = deleteClipUseCase,
       _changeTimelineStatusUseCase = changeTimelineStatusUseCase;

  static const double MIN_TIMELINE_HEIGHT = 320;
  static const double SIDE_WIDTH = 320;
  static const double DEFAULT_PIXELS_PER_SECOND = 80;
  static const double EMPTY_SPAN_SECONDS = 60;
  static const double PROVISIONAL_BAR_SECONDS = 10;
  static const double MIN_TRACK_WIDTH = 640;
  static const double MIN_CLIP_WIDTH = 6;
  static const double MIN_REGION_SECONDS = 0.1;
  static const String ASSET_DRAG_PREFIX = 'asset:';
  static const String RELATION_TRACK_NAME = '관계';

  final ListHistoryWorkAttachmentsUseCase _listHistoryWorkAttachmentsUseCase;
  final GetJobTimelineUseCase _getJobTimelineUseCase;
  final CreateTrackUseCase _createTrackUseCase;
  final UpdateTrackUseCase _updateTrackUseCase;
  final DeleteTrackUseCase _deleteTrackUseCase;
  final CreateClipUseCase _createClipUseCase;
  final UpdateClipUseCase _updateClipUseCase;
  final DeleteClipUseCase _deleteClipUseCase;
  final ChangeTimelineStatusUseCase _changeTimelineStatusUseCase;
  final String jobId;

  double _playheadSeconds = 0;
  int _seekToken = 0;
  VideoMultimodalSide _side = VideoMultimodalSide.none;
  bool _isLaneMenuOpen = false;
  bool _isLoading = false;
  bool _isSavingTimeline = false;
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
  bool _isRelationMode = false;
  String _relationAnchorClipId = '';
  String _workName = '';
  String _assetsSearchQuery = '';
  String _timelineHint = '';
  String _selectedAudioLabel = '';
  bool _isVideoPlaying = false;
  bool _wantsPlayback = false;
  int _playbackToken = 0;
  DateTime _ignoreClockUntil = DateTime.fromMillisecondsSinceEpoch(0);
  InferencePanelPhase _inferencePhase = InferencePanelPhase.hidden;
  bool _isInferenceMinimized = false;
  double _inferenceOffsetX = 24;
  double _inferenceOffsetY = 24;
  String _inferenceModelName = '';
  final List<AskTurn> _askTurns = [];
  final List<PaletteSection> _paletteSections = [
    PaletteSection(sectionKey: 'audio', title: '오디오 구간', names: []),
    PaletteSection(sectionKey: 'video', title: '비디오 객체', names: []),
    PaletteSection(sectionKey: 'pose', title: '포즈', names: []),
    PaletteSection(sectionKey: 'bbox', title: '객체 bbox', names: []),
    PaletteSection(sectionKey: 'vector', title: '키포인트 (tip/grip)', names: []),
  ];
  final List<VideoFrameMark> _frameMarks = [];
  final List<SampleLayerSummary> _sampleLayers = const [];

  double get pixelsPerSecond => DEFAULT_PIXELS_PER_SECOND;
  double get playheadSeconds => _playheadSeconds;
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

  List<VideoCaption> get activeVideoCaptions =>
      _captionsForVideo(activeVideoBar);

  /// 재생 중인 영상 파일의 박스·스켈레톤. 실제 좌표가 오면 이 목록을 바꾼다.
  List<VideoFrameMark> get activeVideoFrameMarks => activeVideoBar == null
      ? const <VideoFrameMark>[]
      : List<VideoFrameMark>.unmodifiable(_frameMarks);

  void didUpdateVideoBox({
    required int markIndex,
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    if (markIndex < 0 || markIndex >= _frameMarks.length) {
      return;
    }
    final mark = _frameMarks[markIndex];
    if (mark is! VideoBoxMark) {
      return;
    }
    final next = VideoBoxMark(
      name: mark.name,
      left: left,
      top: top,
      width: width,
      height: height,
      start: mark.start,
      end: mark.end,
    );
    _frameMarks[markIndex] = next;
    debugVideoFrameMark(markIndex, next);
    notifyListeners();
  }

  void didUpdateVideoSkeleton({
    required int markIndex,
    required List<VideoFramePoint> points,
  }) {
    if (markIndex < 0 || markIndex >= _frameMarks.length) {
      return;
    }
    final mark = _frameMarks[markIndex];
    if (mark is! VideoSkeletonMark) {
      return;
    }
    final next = VideoSkeletonMark(
      name: mark.name,
      points: List<VideoFramePoint>.of(points),
      bones: mark.bones,
      start: mark.start,
      end: mark.end,
    );
    _frameMarks[markIndex] = next;
    debugVideoFrameMark(markIndex, next);
    notifyListeners();
  }

  List<VideoCaption> _captionsForVideo(TemporaryAttachmentBar? video) {
    if (video == null) {
      return const [];
    }
    final span = video.endSeconds - video.startSeconds;
    if (span <= 0) {
      return const [];
    }
    final captions = <VideoCaption>[];
    for (final clip in timelineClips) {
      if (clip.kind != TimelineClipKind.subtitle) {
        continue;
      }
      final text = labelForClip(clip);
      if (text.isEmpty) {
        continue;
      }
      final start = secondsFromNanoseconds(clip.startNanoseconds);
      final end = secondsFromNanoseconds(clip.endNanoseconds);
      if (end <= video.startSeconds || start >= video.endSeconds) {
        continue;
      }
      final localStart = (start - video.startSeconds)
          .clamp(0.0, span)
          .toDouble();
      final localEnd = (end - video.startSeconds).clamp(0.0, span).toDouble();
      if (localEnd - localStart < MIN_REGION_SECONDS) {
        continue;
      }
      captions.add(
        VideoCaption(
          text: text,
          start: Duration(milliseconds: (localStart * 1000).round()),
          end: Duration(milliseconds: (localEnd * 1000).round()),
        ),
      );
    }
    return captions;
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

  double? _timelineVideoStart(String mediaUrl) {
    for (final clip in timelineClips) {
      if (clip.kind == TimelineClipKind.video && clip.playbackUrl == mediaUrl) {
        return secondsFromNanoseconds(clip.startNanoseconds);
      }
    }
    return null;
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

  String labelForClip(TimelineClip clip) {
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
      case TimelineClipKind.unspecified:
        return '클립';
    }
  }

  void _followClock({
    required double startSeconds,
    required double localSeconds,
    required bool isPlaying,
    bool notifyWhenIgnored = false,
  }) {
    final expectedLocal = _playheadSeconds - startSeconds;
    final clockSettled = (localSeconds - expectedLocal).abs() <= 0.35;
    if (DateTime.now().isBefore(_ignoreClockUntil) && !clockSettled) {
      if (notifyWhenIgnored) {
        notifyListeners();
      }
      return;
    }
    final next = (startSeconds + localSeconds).clamp(0.0, spanSeconds);
    if ((next - _playheadSeconds).abs() < 0.03 &&
        _isVideoPlaying == isPlaying) {
      return;
    }
    _playheadSeconds = next;
    _isVideoPlaying = isPlaying;
    notifyListeners();
  }

  TemporaryAttachmentBar? get activeVideoBar {
    final clip = _videoClipAt(_playheadSeconds);
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

  String get playheadLabel => _formatClock(_playheadSeconds);
  String get spanLabel => _formatClock(spanSeconds);
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

  bool get isVideoPlaying => _isVideoPlaying;
  bool get wantsPlayback => _wantsPlayback;
  int get playbackToken => _playbackToken;

  bool isLaneVisible(String laneKey) => !_hiddenLaneKeys.contains(laneKey);
  String get assetsSearchQuery => _assetsSearchQuery;
  String get timelineHint => _timelineHint;
  bool get hasTimelineHint => _timelineHint.isNotEmpty;
  String get selectedAudioLabel => _selectedAudioLabel;
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
  InferencePanelPhase get inferencePhase => _inferencePhase;
  bool get isInferenceVisible => _inferencePhase != InferencePanelPhase.hidden;
  bool get isInferenceMinimized => _isInferenceMinimized;
  double get inferenceOffsetX => _inferenceOffsetX;
  double get inferenceOffsetY => _inferenceOffsetY;
  String get inferenceModelName => _inferenceModelName;
  List<AskTurn> get askTurns => List.unmodifiable(_askTurns);
  List<PaletteSection> get paletteSections =>
      List.unmodifiable(_paletteSections);
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
      text: labelForClip(timelineClip),
      startSeconds: secondsFromNanoseconds(timelineClip.startNanoseconds),
      endSeconds: secondsFromNanoseconds(timelineClip.endNanoseconds),
      showsAiBadge: timelineClip.showsToolMark,
      isDashed: false,
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
    notifyListeners();
    if (jobId.isEmpty) {
      _timeline = JobTimeline.empty;
      _attachments = const [];
      _bars = const [];
      _frameMarks.clear();
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
      final marks = loadMockVideoFrameMarks();
      _attachments = await _listHistoryWorkAttachmentsUseCase.execute(
        jobId: jobId,
      );
      _bars = [
        ..._chain(_attachments, WorkAttachmentType.video),
        ..._chain(_attachments, WorkAttachmentType.audio),
      ];
      _frameMarks
        ..clear()
        ..addAll(await marks);
      _side = VideoMultimodalSide.assets;
    } catch (error) {
      _attachments = const [];
      _bars = const [];
      _frameMarks.clear();
      if (!_hasError) {
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
    _playheadSeconds = _playheadSeconds.clamp(0, spanSeconds);
    notifyListeners();
  }

  bool isBarHidden(String attachmentId) {
    return _hiddenAttachmentIds.contains(attachmentId);
  }

  void didChangeAssetsSearch(String query) {
    _assetsSearchQuery = query;
    notifyListeners();
  }

  void didReceiveVideoClock({
    required String mediaUrl,
    required double localSeconds,
    required double durationSeconds,
    required bool isPlaying,
  }) {
    final fittedChanged = _fitVideoDuration(mediaUrl, durationSeconds);
    final timelineStart = _timelineVideoStart(mediaUrl);
    if (timelineStart != null) {
      _followClock(
        startSeconds: timelineStart,
        localSeconds: localSeconds,
        isPlaying: isPlaying,
      );
      return;
    }
    TemporaryAttachmentBar? bar;
    for (final candidate in _bars) {
      if (candidate.isVideo && candidate.mediaUrl == mediaUrl) {
        bar = candidate;
        break;
      }
    }
    if (bar == null) {
      if (fittedChanged) {
        notifyListeners();
      }
      return;
    }
    _followClock(
      startSeconds: bar.startSeconds,
      localSeconds: localSeconds,
      isPlaying: isPlaying,
      notifyWhenIgnored: fittedChanged,
    );
  }

  void didSelectSampleClip(String clipId) {
    final timelineClip = _timelineClip(clipId);
    if (timelineClip == null) {
      return;
    }
    _selectedClipId = clipId;
    _side = VideoMultimodalSide.properties;
    didSeekToSeconds(secondsFromNanoseconds(timelineClip.startNanoseconds));
  }

  void didClearTimelineHint() {
    if (_timelineHint.isEmpty) {
      return;
    }
    _timelineHint = '';
    notifyListeners();
  }

  void didSendAsk(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }
    _askTurns.add(AskTurn(isUser: true, text: trimmed));
    _askTurns.add(
      const AskTurn(
        isUser: false,
        text: '이 화면에서는 질의 서버에 연결하지 않습니다. 아래 구간으로 이동할 수 있습니다.',
        citationStartSeconds: 1,
        citationEndSeconds: 3.5,
      ),
    );
    notifyListeners();
  }

  void didTapCitation(double startSeconds) {
    didSeekToSeconds(startSeconds);
  }

  void didSelectPaletteLabel(String name) {
    _selectedAudioLabel = name;
    _timelineHint = '';
    notifyListeners();
  }

  void didAddPaletteLabel(String sectionKey, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }
    for (final section in _paletteSections) {
      if (section.sectionKey == sectionKey) {
        section.names.add(trimmed);
        break;
      }
    }
    notifyListeners();
  }

  void didRenamePaletteLabel(
    String sectionKey,
    String oldName,
    String newName,
  ) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) {
      return;
    }
    for (final section in _paletteSections) {
      if (section.sectionKey != sectionKey) {
        continue;
      }
      final index = section.names.indexOf(oldName);
      if (index >= 0) {
        section.names[index] = trimmed;
      }
    }
    if (_selectedAudioLabel == oldName) {
      _selectedAudioLabel = trimmed;
    }
    notifyListeners();
  }

  void didDeletePaletteLabel(String sectionKey, String name) {
    for (final section in _paletteSections) {
      if (section.sectionKey == sectionKey) {
        section.names.remove(name);
      }
    }
    if (_selectedAudioLabel == name) {
      _selectedAudioLabel = '';
    }
    notifyListeners();
  }

  void didShowInference(String modelName) {
    _inferenceModelName = modelName;
    _inferencePhase = InferencePanelPhase.running;
    _isInferenceMinimized = false;
    notifyListeners();
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (_inferencePhase != InferencePanelPhase.running) {
        return;
      }
      _inferencePhase = InferencePanelPhase.done;
      notifyListeners();
    });
  }

  void didCancelInference() {
    if (_inferencePhase == InferencePanelPhase.hidden) {
      return;
    }
    _inferencePhase = InferencePanelPhase.failed;
    notifyListeners();
  }

  void didApplyInference() {
    _noticeText = '추론 결과 적용은 이 화면에서 서버에 저장하지 않습니다.';
    _inferencePhase = InferencePanelPhase.hidden;
    notifyListeners();
  }

  void didCloseInference() {
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

  void didTapToggleAsk() {
    _toggleSide(VideoMultimodalSide.ask);
  }

  void didTapToggleLabels() {
    _toggleSide(VideoMultimodalSide.labels);
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

  void didSeekToSeconds(double seconds) {
    _playheadSeconds = seconds.clamp(0, spanSeconds);
    _seekToken += 1;
    _ignoreClockUntil = DateTime.now().add(const Duration(milliseconds: 450));
    _isVideoPlaying = false;
    notifyListeners();
  }

  Future<void> didTapDeleteSelection() async {
    if (_selectedClipId.isEmpty) {
      return;
    }
    final clipId = _selectedClipId;
    if (_timelineClip(clipId) == null) {
      _selectedClipId = '';
      notifyListeners();
      return;
    }
    final didSave = await _commitServerWrite(
      () => _deleteClipUseCase.execute(clipId: clipId),
    );
    if (didSave) {
      _selectedClipId = '';
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
    );
  }

  Future<void> deleteTimelineTrack(String trackId) {
    return _commitServerWrite(
      () => _deleteTrackUseCase.execute(trackId: trackId),
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
    bool omitsKind = false,
    List<String> inputClipIds = const [],
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
        omitsKind: omitsKind,
        inputClipIds: inputClipIds,
      ),
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
    );
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
    );
    if (didSave) {
      _selectedClipId = '';
      notifyListeners();
    }
  }

  Future<void> didCreateTimelineClipOnTrack({
    required String trackId,
    required WorkAttachment attachment,
    required double startSeconds,
  }) async {
    if (!isServerTimelineTrack(trackId) || attachment.attachmentId.isEmpty) {
      return;
    }
    final startNs = nanosecondsFromSeconds(startSeconds);
    final endNs = nanosecondsFromSeconds(startSeconds + MIN_REGION_SECONDS);
    if (!isOpenNanosecondInterval(startNs, endNs)) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return;
    }
    await createTimelineClip(
      trackId: trackId,
      kind: _clipKindForAttachment(attachment),
      startNs: startNs,
      endNs: endNs,
      assetId: attachment.attachmentId,
    );
  }

  Future<void> didDropAsset({
    required String dragData,
    required String laneKey,
    required double startSeconds,
  }) {
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
    final didSave = await createTimelineClip(
      trackId: trackId,
      kind: TimelineClipKind.unspecified,
      omitsKind: true,
      startNs: startNs,
      endNs: endNs,
      description: '${labelForClip(anchor)} ↔ ${labelForClip(clip)}',
      inputClipIds: [anchor.clipId, clip.clipId],
    );
    if (didSave) {
      _isRelationMode = false;
      _relationAnchorClipId = '';
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

  Future<bool> _commitServerWrite(Future<void> Function() write) async {
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
    _wantsPlayback = !_isVideoPlaying;
    _playbackToken += 1;
    notifyListeners();
  }

  void didTapToggleLaneMenu() {
    _isLaneMenuOpen = !_isLaneMenuOpen;
    notifyListeners();
  }

  void didTapAddMarker() {
    _markerSeconds.add(_playheadSeconds);
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

  bool _fitVideoDuration(String mediaUrl, double durationSeconds) {
    if (durationSeconds <= 0) {
      return false;
    }
    final videos = [
      for (final bar in _bars)
        if (bar.isVideo) bar,
    ];
    final index = videos.indexWhere((bar) => bar.mediaUrl == mediaUrl);
    if (index < 0) {
      return false;
    }
    final currentLength = videos[index].endSeconds - videos[index].startSeconds;
    final stillProvisional =
        (currentLength - PROVISIONAL_BAR_SECONDS).abs() < 0.25;
    if (!stillProvisional || (currentLength - durationSeconds).abs() < 0.25) {
      return false;
    }
    var cursor = videos.first.startSeconds;
    final fitted = <TemporaryAttachmentBar>[];
    for (var i = 0; i < videos.length; i++) {
      final source = videos[i];
      final length = i == index
          ? durationSeconds
          : source.endSeconds - source.startSeconds;
      fitted.add(
        source.copyWith(startSeconds: cursor, endSeconds: cursor + length),
      );
      cursor += length;
    }
    _bars = [
      ...fitted,
      for (final bar in _bars)
        if (!bar.isVideo) bar,
    ];
    return true;
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
