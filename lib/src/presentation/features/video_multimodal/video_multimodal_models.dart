import '../../../domain/entities/ask_answer.dart';

enum VideoMultimodalSide { none, assets, properties, ask, labels }

class CreatedClipNotice {
  const CreatedClipNotice({required this.kindLabel, required this.body});

  final String kindLabel;
  final String body;
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
    this.hasLabel = false,
  });

  final String clipId;
  final String laneKey;
  final String laneLabel;
  final String text;
  double startSeconds;
  double endSeconds;
  final bool showsAiBadge;
  final bool isDashed;
  final bool hasLabel;
}

class AskTurn {
  const AskTurn({
    required this.isUser,
    required this.text,
    this.citations = const [],
  });

  final bool isUser;
  final String text;
  final List<AskCitation> citations;
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

enum InferencePanelPhase { hidden, queued, running, failed }

