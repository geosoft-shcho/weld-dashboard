import 'package:flutter/foundation.dart';

import '../../../domain/entities/work_attachment.dart';
import '../../../domain/entities/work_attachment_type.dart';
import '../../../domain/use_cases/list_history_work_attachments_use_case.dart';

enum VideoMultimodalSide {
  none,
  assets,
  properties,
  ask,
  labels,
}

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

  TemporaryAttachmentBar copyWith({
    double? startSeconds,
    double? endSeconds,
  }) {
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
  PaletteSection({required this.sectionKey, required this.title, required this.names});

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
    required ListHistoryWorkAttachmentsUseCase listHistoryWorkAttachmentsUseCase,
    required this.historyId,
  }) : _listHistoryWorkAttachmentsUseCase = listHistoryWorkAttachmentsUseCase;

  static const double MIN_TIMELINE_HEIGHT = 280;
  static const double SIDE_WIDTH = 320;
  static const double DEFAULT_PIXELS_PER_SECOND = 80;
  static const double MIN_PIXELS_PER_SECOND = 20;
  static const double MAX_PIXELS_PER_SECOND = 160;
  static const double EMPTY_SPAN_SECONDS = 60;
  static const double PROVISIONAL_BAR_SECONDS = 10;
  static const double MIN_TRACK_WIDTH = 640;
  static const double MIN_CLIP_WIDTH = 6;
  static const double MIN_RELATION_CLIP_WIDTH = 32;
  static const double MIN_REGION_SECONDS = 0.1;

  final ListHistoryWorkAttachmentsUseCase _listHistoryWorkAttachmentsUseCase;
  final String historyId;

  double _pixelsPerSecond = DEFAULT_PIXELS_PER_SECOND;
  double _playheadSeconds = 0;
  int _seekToken = 0;
  VideoMultimodalSide _side = VideoMultimodalSide.none;
  bool _isLinkMode = false;
  bool _isLaneMenuOpen = false;
  bool _areAuxiliaryRowsHidden = false;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  final List<double> _markerSeconds = [];
  String _noticeText = '';
  List<WorkAttachment> _attachments = const [];
  List<TemporaryAttachmentBar> _bars = const [];
  final Set<String> _hiddenAttachmentIds = {};
  final Set<String> _hiddenLaneKeys = {};
  String _linkAnchorClipId = '';
  String _selectedAttachmentId = '';
  String _selectedClipId = '';
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
  final List<TimelineSampleClip> _sampleClips = [
    TimelineSampleClip(
      clipId: 'file-1',
      laneKey: 'saved_attachment',
      laneLabel: '첨부 파일',
      text: '사진',
      startSeconds: 7,
      endSeconds: 8.5,
      showsAiBadge: false,
      isDashed: false,
    ),
  ];
  final List<SampleLayerSummary> _sampleLayers = const [];

  double get pixelsPerSecond => _pixelsPerSecond;
  double get playheadSeconds => _playheadSeconds;
  int get seekToken => _seekToken;
  VideoMultimodalSide get side => _side;
  bool get isAssetsOpen => _side == VideoMultimodalSide.assets;
  bool get isPropertiesOpen => _side == VideoMultimodalSide.properties;
  bool get isAskOpen => _side == VideoMultimodalSide.ask;
  bool get isLabelsOpen => _side == VideoMultimodalSide.labels;
  bool get isLinkMode => _isLinkMode;
  bool get isLaneMenuOpen => _isLaneMenuOpen;
  bool get areAuxiliaryRowsHidden => _areAuxiliaryRowsHidden;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<double> get markerSeconds => List.unmodifiable(_markerSeconds);
  String get noticeText => _noticeText;
  bool get hasNotice => _noticeText.isNotEmpty;
  List<WorkAttachment> get attachments => List.unmodifiable(_attachments);

  List<TemporaryAttachmentBar> get visibleBars => [
    for (final bar in _bars)
      if (!_hiddenAttachmentIds.contains(bar.attachmentId)) bar,
  ];

  TemporaryAttachmentBar? get selectedBar {
    for (final bar in _bars) {
      if (bar.attachmentId == _selectedAttachmentId) {
        return bar;
      }
    }
    return null;
  }

  TemporaryAttachmentBar? get activeVideoBar {
    for (final bar in visibleBars) {
      if (!bar.isVideo) {
        continue;
      }
      if (_playheadSeconds >= bar.startSeconds &&
          _playheadSeconds < bar.endSeconds) {
        return bar;
      }
    }
    return null;
  }

  double get spanSeconds {
    var end = 0.0;
    for (final bar in visibleBars) {
      if (bar.endSeconds > end) {
        end = bar.endSeconds;
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
    return historyId;
  }

  void didReceiveWorkName(String workName) {
    _workName = workName.trim();
    notifyListeners();
  }
  bool get isVideoPlaying => _isVideoPlaying;
  bool get wantsPlayback => _wantsPlayback;
  int get playbackToken => _playbackToken;
  String get linkPrompt {
    if (!_isLinkMode) {
      return '';
    }
    if (_linkAnchorClipId.isEmpty) {
      return 'Link 모드 — 첫 번째 region을 클릭하세요';
    }
    return 'Link 모드 — 두 번째 region을 클릭하세요';
  }

  bool isLaneVisible(String laneKey) => !_hiddenLaneKeys.contains(laneKey);
  String get assetsSearchQuery => _assetsSearchQuery;
  String get timelineHint => _timelineHint;
  bool get hasTimelineHint => _timelineHint.isNotEmpty;
  String get selectedAudioLabel => _selectedAudioLabel;
  bool get canDeleteSelection => _selectedClipId.isNotEmpty;
  String get selectedClipId => _selectedClipId;
  InferencePanelPhase get inferencePhase => _inferencePhase;
  bool get isInferenceVisible => _inferencePhase != InferencePanelPhase.hidden;
  bool get isInferenceMinimized => _isInferenceMinimized;
  double get inferenceOffsetX => _inferenceOffsetX;
  double get inferenceOffsetY => _inferenceOffsetY;
  String get inferenceModelName => _inferenceModelName;
  List<AskTurn> get askTurns => List.unmodifiable(_askTurns);
  List<PaletteSection> get paletteSections => List.unmodifiable(_paletteSections);
  List<TimelineSampleClip> get sampleClips => List.unmodifiable(_sampleClips);
  List<SampleLayerSummary> get sampleLayers => List.unmodifiable(_sampleLayers);

  TimelineSampleClip? get selectedClip {
    for (final clip in _sampleClips) {
      if (clip.clipId == _selectedClipId) {
        return clip;
      }
    }
    return null;
  }

  double get trackWidth {
    final width = spanSeconds * _pixelsPerSecond;
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
    try {
      _attachments = await _listHistoryWorkAttachmentsUseCase.execute(
        historyId: historyId,
      );
      _bars = [
        ..._chain(_attachments, WorkAttachmentType.video),
        ..._chain(_attachments, WorkAttachmentType.audio),
      ];
      _side = VideoMultimodalSide.assets;
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _attachments = const [];
      _bars = const [];
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
    final expectedLocal = _playheadSeconds - bar.startSeconds;
    final clockSettled = (localSeconds - expectedLocal).abs() <= 0.35;
    if (DateTime.now().isBefore(_ignoreClockUntil) && !clockSettled) {
      if (fittedChanged) {
        notifyListeners();
      }
      return;
    }
    final next = (bar.startSeconds + localSeconds).clamp(0.0, spanSeconds);
    if ((next - _playheadSeconds).abs() < 0.03 && _isVideoPlaying == isPlaying) {
      return;
    }
    _playheadSeconds = next;
    _isVideoPlaying = isPlaying;
    notifyListeners();
  }

  void didSelectSampleClip(String clipId) {
    TimelineSampleClip? clip;
    for (final candidate in _sampleClips) {
      if (candidate.clipId == clipId) {
        clip = candidate;
        break;
      }
    }
    if (clip == null) {
      return;
    }
    _selectedClipId = clipId;
    _selectedAttachmentId = '';
    _side = VideoMultimodalSide.properties;
    if (clip.laneKey == 'audio_manual' || clip.laneKey == 'stt') {
      _selectedAudioLabel = clip.text;
    }
    didSeekToSeconds(clip.startSeconds);
  }

  void didAddManualClip(double startSeconds, double endSeconds) {
    final start = startSeconds < endSeconds ? startSeconds : endSeconds;
    final end = startSeconds < endSeconds ? endSeconds : startSeconds;
    if (end - start < MIN_REGION_SECONDS) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return;
    }
    if (_selectedAudioLabel.isEmpty) {
      _timelineHint = '오디오 구간 라벨을 먼저 선택하세요.';
      notifyListeners();
      return;
    }
    final clip = TimelineSampleClip(
      clipId: 'manual-${_sampleClips.length + 1}',
      laneKey: 'audio_manual',
      laneLabel: '수동 · 자막',
      text: _selectedAudioLabel,
      startSeconds: start,
      endSeconds: end,
      showsAiBadge: false,
      isDashed: false,
    );
    _sampleClips.add(clip);
    _selectedClipId = clip.clipId;
    _timelineHint = '';
    notifyListeners();
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

  void didRenamePaletteLabel(String sectionKey, String oldName, String newName) {
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
    TemporaryAttachmentBar? bar;
    for (final candidate in _bars) {
      if (candidate.attachmentId == attachmentId) {
        bar = candidate;
        break;
      }
    }
    if (bar == null) {
      return;
    }
    _selectedAttachmentId = attachmentId;
    _selectedClipId = '';
    _side = VideoMultimodalSide.properties;
    _isLaneMenuOpen = false;
    didSeekToSeconds(bar.startSeconds);
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

  void didTapZoomIn() {
    _setPixelsPerSecond(_pixelsPerSecond * 1.25);
  }

  void didTapZoomOut() {
    _setPixelsPerSecond(_pixelsPerSecond / 1.25);
  }

  void didTapSelectTool() {
    _isLinkMode = false;
    _linkAnchorClipId = '';
    _clearNotice();
    notifyListeners();
  }

  void didTapToggleLinkMode() {
    _isLinkMode = !_isLinkMode;
    _linkAnchorClipId = '';
    _noticeText = '';
    notifyListeners();
  }

  void didTapCancelLinkMode() {
    if (!_isLinkMode) {
      return;
    }
    _isLinkMode = false;
    _linkAnchorClipId = '';
    notifyListeners();
  }

  bool didTapClipForLink(String clipId) {
    if (!_isLinkMode || clipId.isEmpty) {
      return false;
    }
    if (_linkAnchorClipId.isEmpty) {
      _linkAnchorClipId = clipId;
      _selectedClipId = clipId;
      notifyListeners();
      return true;
    }
    if (_linkAnchorClipId == clipId) {
      return true;
    }
    final anchor = _clipById(_linkAnchorClipId);
    final next = _clipById(clipId);
    if (anchor != null && next != null) {
      final start = anchor.startSeconds < next.startSeconds
          ? anchor.startSeconds
          : next.startSeconds;
      final end = anchor.endSeconds > next.endSeconds
          ? anchor.endSeconds
          : next.endSeconds;
      _sampleClips.add(
        TimelineSampleClip(
          clipId: 'rel-${_sampleClips.length + 1}',
          laneKey: 'relation',
          laneLabel: '관계 설정',
          text: '${anchor.text} ↔ ${next.text}',
          startSeconds: start,
          endSeconds: end,
          showsAiBadge: false,
          isDashed: false,
        ),
      );
    }
    _isLinkMode = false;
    _linkAnchorClipId = '';
    _selectedClipId = clipId;
    notifyListeners();
    return true;
  }

  void didTapDeleteSelection() {
    if (_selectedClipId.isEmpty) {
      return;
    }
    _sampleClips.removeWhere((clip) => clip.clipId == _selectedClipId);
    _selectedClipId = '';
    notifyListeners();
  }

  void didResizeClip(String clipId, double startSeconds, double endSeconds) {
    final clip = _clipById(clipId);
    if (clip == null) {
      return;
    }
    if (clip.laneKey != 'stt' && clip.laneKey != 'audio_manual') {
      _timelineHint = '객체·포즈 구간은 이 타임라인에서 길이를 바꾸지 않습니다.';
      notifyListeners();
      return;
    }
    final start = startSeconds < endSeconds ? startSeconds : endSeconds;
    final end = startSeconds < endSeconds ? endSeconds : startSeconds;
    if (end - start < MIN_REGION_SECONDS) {
      _timelineHint = '구간이 너무 짧습니다.';
      notifyListeners();
      return;
    }
    clip.startSeconds = start.clamp(0.0, spanSeconds).toDouble();
    clip.endSeconds = end.clamp(0.0, spanSeconds).toDouble();
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

  void didDropSavedAttachment(String fileName, double seconds) {
    final start = seconds.clamp(0.0, spanSeconds).toDouble();
    _sampleClips.add(
      TimelineSampleClip(
        clipId: 'att-${_sampleClips.length + 1}',
        laneKey: 'saved_attachment',
        laneLabel: '첨부 파일',
        text: fileName,
        startSeconds: start,
        endSeconds: (start + 1.5).clamp(start, spanSeconds + 1.5).toDouble(),
        showsAiBadge: false,
        isDashed: false,
      ),
    );
    _timelineHint = '';
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

  TimelineSampleClip? _clipById(String clipId) {
    for (final clip in _sampleClips) {
      if (clip.clipId == clipId) {
        return clip;
      }
    }
    return null;
  }

  void didTapToggleLaneMenu() {
    _isLaneMenuOpen = !_isLaneMenuOpen;
    notifyListeners();
  }

  void didTapToggleAuxiliaryRows() {
    _areAuxiliaryRowsHidden = !_areAuxiliaryRowsHidden;
    const auxiliary = ['relation', 'saved_attachment'];
    if (_areAuxiliaryRowsHidden) {
      _hiddenLaneKeys.addAll(auxiliary);
    } else {
      _hiddenLaneKeys.removeAll(auxiliary);
    }
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
          fileTypeLabel: attachment.fileType.label,
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

  void _setPixelsPerSecond(double next) {
    _pixelsPerSecond = next.clamp(
      MIN_PIXELS_PER_SECOND,
      MAX_PIXELS_PER_SECOND,
    );
    notifyListeners();
  }

  void _clearNotice() {
    _noticeText = '';
  }

  bool _fitVideoDuration(String mediaUrl, double durationSeconds) {
    if (durationSeconds <= 0) {
      return false;
    }
    final videos = [for (final bar in _bars) if (bar.isVideo) bar];
    final index = videos.indexWhere((bar) => bar.mediaUrl == mediaUrl);
    if (index < 0) {
      return false;
    }
    final currentLength = videos[index].endSeconds - videos[index].startSeconds;
    if ((currentLength - durationSeconds).abs() < 0.25) {
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
    _bars = [...fitted, for (final bar in _bars) if (!bar.isVideo) bar];
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
