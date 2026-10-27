import '../entities/asset_upload.dart';
import '../entities/tool_run.dart';
import '../repositories/asset_upload_repository.dart';
import '../repositories/tool_run_repository.dart';

/// 파일마다 `POST /assets`를 따로 호출하고, 등록 뒤 `GetRun`으로 후처리를 잇는다(§4.4).
class UploadAssetQueueUseCase {
  const UploadAssetQueueUseCase(this._uploadRepository, this._toolRunRepository);

  static const int maxConcurrent = 3;

  final AssetUploadRepository _uploadRepository;
  final ToolRunRepository _toolRunRepository;

  Future<AssetUploadBatchResult> execute({
    required String jobId,
    required String passId,
    required String equipmentId,
    required List<AssetUploadQueueEntry> entries,
    required void Function(AssetUploadQueueItem item) onItemUpdated,
    String subject = '',
    String situation = '',
    int concurrency = maxConcurrent,
  }) async {
    if (entries.isEmpty) {
      throw const AssetUploadException('올릴 파일을 고르세요.');
    }
    final limit = concurrency < 1 ? 1 : concurrency;
    final items = <String, AssetUploadQueueItem>{
      for (final entry in entries)
        entry.localId: AssetUploadQueueItem(
          localId: entry.localId,
          fileName: entry.file.fileName,
          status: AssetUploadItemStatus.waiting,
        ),
    };

    void publish(AssetUploadQueueItem item) {
      items[item.localId] = item;
      onItemUpdated(item);
    }

    var nextIndex = 0;
    Future<void> worker() async {
      while (true) {
        final index = nextIndex++;
        if (index >= entries.length) {
          return;
        }
        await _uploadOne(
          entry: entries[index],
          jobId: jobId,
          passId: passId,
          equipmentId: equipmentId,
          subject: subject,
          situation: situation,
          publish: publish,
        );
      }
    }

    final workerCount = limit < entries.length ? limit : entries.length;
    await Future.wait([
      for (var i = 0; i < workerCount; i++) worker(),
    ]);

    return AssetUploadBatchResult(items: [
      for (final entry in entries) items[entry.localId]!,
    ]);
  }

  Future<void> _uploadOne({
    required AssetUploadQueueEntry entry,
    required String jobId,
    required String passId,
    required String equipmentId,
    required String subject,
    required String situation,
    required void Function(AssetUploadQueueItem item) publish,
  }) async {
    final base = AssetUploadQueueItem(
      localId: entry.localId,
      fileName: entry.file.fileName,
      status: AssetUploadItemStatus.uploading,
    );
    publish(base);
    try {
      final result = await _uploadRepository.uploadFile(
        jobId: jobId,
        passId: passId,
        equipmentId: equipmentId,
        timeOrigin: entry.timeOrigin,
        file: entry.file,
        subject: entry.subject.isEmpty ? subject : entry.subject,
        situation: entry.situation.isEmpty ? situation : entry.situation,
        onProgress: (percent) {
          publish(
            base.copyWith(
              status: AssetUploadItemStatus.uploading,
              progressPercent: percent,
            ),
          );
        },
      );
      publish(
        base.copyWith(
          status: AssetUploadItemStatus.registered,
          result: result,
          progressPercent: 100,
        ),
      );
      if (result.runId.isEmpty) {
        publish(
          base.copyWith(
            status: AssetUploadItemStatus.completed,
            result: result,
          ),
        );
        return;
      }
      await _waitForPostprocess(
        runId: result.runId,
        base: base.copyWith(result: result),
        publish: publish,
      );
    } catch (error) {
      publish(
        base.copyWith(
          status: AssetUploadItemStatus.failed,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _waitForPostprocess({
    required String runId,
    required AssetUploadQueueItem base,
    required void Function(AssetUploadQueueItem item) publish,
  }) async {
    while (true) {
      final run = await _toolRunRepository.getRun(runId: runId);
      switch (run.status) {
        case ToolRunStatus.queued:
          publish(
            base.copyWith(status: AssetUploadItemStatus.postprocessQueued),
          );
        case ToolRunStatus.running:
          publish(
            base.copyWith(
              status: AssetUploadItemStatus.postprocessRunning,
              progressPercent: run.progressPercent,
            ),
          );
        case ToolRunStatus.succeeded:
          publish(base.copyWith(status: AssetUploadItemStatus.completed));
          return;
        case ToolRunStatus.failed:
          publish(
            base.copyWith(
              status: AssetUploadItemStatus.postprocessFailed,
              message: run.errorMessage.isEmpty
                  ? '파일 후처리에 실패했습니다.'
                  : run.errorMessage,
            ),
          );
          return;
        case ToolRunStatus.canceled:
          publish(
            base.copyWith(
              status: AssetUploadItemStatus.postprocessFailed,
              message: '파일 후처리가 취소되었습니다.',
            ),
          );
          return;
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }
}
