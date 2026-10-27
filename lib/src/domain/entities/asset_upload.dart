import 'camera_recording.dart';

class AssetUploadResult {
  const AssetUploadResult({
    required this.assetId,
    required this.fileName,
    required this.runId,
    this.warnings = const [],
    this.duplicateAssetIds = const [],
  });

  final String assetId;
  final String fileName;
  final String runId;
  final List<String> warnings;
  final List<String> duplicateAssetIds;
}

/// 다건 올리기 대기열 한 줄 상태(안내 §4.4).
enum AssetUploadItemStatus {
  waiting,
  uploading,
  failed,
  registered,
  postprocessQueued,
  postprocessRunning,
  completed,
  postprocessFailed,
}

extension AssetUploadItemStatusLabel on AssetUploadItemStatus {
  String get label {
    switch (this) {
      case AssetUploadItemStatus.waiting:
        return '대기';
      case AssetUploadItemStatus.uploading:
        return '업로드 중';
      case AssetUploadItemStatus.failed:
        return '실패';
      case AssetUploadItemStatus.registered:
        return '등록됨';
      case AssetUploadItemStatus.postprocessQueued:
        return '후처리 대기';
      case AssetUploadItemStatus.postprocessRunning:
        return '처리 중';
      case AssetUploadItemStatus.completed:
        return '완료';
      case AssetUploadItemStatus.postprocessFailed:
        return '후처리 실패';
    }
  }
}

/// 다건 올리기 한 파일 입력(파일별 metadata).
class AssetUploadQueueEntry {
  const AssetUploadQueueEntry({
    required this.localId,
    required this.file,
    this.timeOrigin,
    this.subject = '',
    this.situation = '',
  });

  final String localId;
  final CameraRecordingFile file;
  final DateTime? timeOrigin;
  final String subject;
  final String situation;
}

/// 다건 올리기 진행 중·끝난 뒤 한 줄 스냅샷.
class AssetUploadQueueItem {
  const AssetUploadQueueItem({
    required this.localId,
    required this.fileName,
    required this.status,
    this.message = '',
    this.result,
    this.progressPercent = 0,
  });

  final String localId;
  final String fileName;
  final AssetUploadItemStatus status;
  final String message;
  final AssetUploadResult? result;
  final double progressPercent;

  List<String> get warnings => result?.warnings ?? const [];

  AssetUploadQueueItem copyWith({
    AssetUploadItemStatus? status,
    String? message,
    AssetUploadResult? result,
    double? progressPercent,
  }) {
    return AssetUploadQueueItem(
      localId: localId,
      fileName: fileName,
      status: status ?? this.status,
      message: message ?? this.message,
      result: result ?? this.result,
      progressPercent: progressPercent ?? this.progressPercent,
    );
  }
}

class AssetUploadBatchResult {
  const AssetUploadBatchResult({
    required this.items,
  });

  final List<AssetUploadQueueItem> items;

  List<AssetUploadResult> get succeeded {
    return [
      for (final item in items)
        if (item.result != null) item.result!,
    ];
  }

  bool get hasSuccess => succeeded.isNotEmpty;

  List<String> get warningNotes {
    final notes = <String>[];
    for (final item in items) {
      final result = item.result;
      if (result == null) {
        continue;
      }
      for (final warning in result.warnings) {
        notes.add('${result.fileName}: $warning');
      }
      for (final id in result.duplicateAssetIds) {
        notes.add('${result.fileName}: 같은 내용의 에셋 $id가 이미 있습니다');
      }
      if (item.status == AssetUploadItemStatus.postprocessFailed &&
          item.message.isNotEmpty) {
        notes.add('${item.fileName}: ${item.message}');
      }
    }
    return notes;
  }

  List<String> get failureNotes {
    return [
      for (final item in items)
        if (item.status == AssetUploadItemStatus.failed)
          '${item.fileName}: ${item.message.isEmpty ? '실패' : item.message}',
    ];
  }
}

class AssetUploadException implements Exception {
  const AssetUploadException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AssetUploadFormat {
  const AssetUploadFormat({
    required this.label,
    required this.extensions,
    required this.steps,
    required this.timeOriginRequired,
  });

  final String label;
  final List<String> extensions;
  final List<String> steps;
  final bool timeOriginRequired;
}

class AssetUploadFormats {
  const AssetUploadFormats({required this.formats, required this.maxBytes});

  final List<AssetUploadFormat> formats;
  final int maxBytes;

  AssetUploadFormat? formatOf(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    for (final format in formats) {
      if (format.extensions.contains(extension)) {
        return format;
      }
    }
    return null;
  }
}
