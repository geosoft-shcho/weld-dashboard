import 'package:flutter/foundation.dart';

import '../entities/asset_upload.dart';
import '../entities/tool_run.dart';
import '../entities/upload_trace.dart';
import '../repositories/asset_upload_repository.dart';
import '../repositories/tool_run_repository.dart';
import '../repositories/trace_repository.dart';

/// 파일마다 `POST /assets`를 따로 호출하고, 등록 뒤 Trace 또는 `GetRun`으로 후처리를 잇는다.
class UploadAssetQueueUseCase {
  const UploadAssetQueueUseCase(
    this._uploadRepository,
    this._toolRunRepository,
    this._traceRepository,
  );

  static const int maxConcurrent = 3;

  final AssetUploadRepository _uploadRepository;
  final ToolRunRepository _toolRunRepository;
  final TraceRepository _traceRepository;

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
      if (result.traceId.isNotEmpty) {
        if (kDebugMode) {
          debugPrint('[upload] wait=Trace traceId=${result.traceId}');
        }
        await _waitForTrace(
          traceId: result.traceId,
          base: base.copyWith(result: result),
          publish: publish,
        );
        return;
      }
      if (result.runId.isEmpty) {
        if (kDebugMode) {
          debugPrint('[upload] wait=done (no traceId/runId)');
        }
        publish(
          base.copyWith(
            status: AssetUploadItemStatus.completed,
            result: result,
          ),
        );
        return;
      }
      if (kDebugMode) {
        debugPrint('[upload] wait=Run runId=${result.runId}');
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

  /// 후처리 실패 뒤 `RetryPostprocess`로 다시 걸고 `GetRun`으로 이어 본다.
  Future<AssetUploadQueueItem> retryPostprocess({
    required String assetId,
    required AssetUploadQueueItem base,
    required void Function(AssetUploadQueueItem item) onItemUpdated,
  }) async {
    var latest = base;
    void publish(AssetUploadQueueItem item) {
      latest = item;
      onItemUpdated(item);
    }

    try {
      final runId = await _uploadRepository.retryPostprocess(assetId: assetId);
      final queued = base.copyWith(
        status: AssetUploadItemStatus.postprocessQueued,
        message: '',
        result: AssetUploadResult(
          assetId: base.result?.assetId ?? assetId,
          fileName: base.result?.fileName ?? base.fileName,
          runId: runId,
          traceId: base.result?.traceId ?? '',
          warnings: base.result?.warnings ?? const [],
          duplicateAssetIds: base.result?.duplicateAssetIds ?? const [],
        ),
        progressPercent: 0,
      );
      publish(queued);
      await _waitForPostprocess(runId: runId, base: queued, publish: publish);
      return latest;
    } catch (error) {
      final failed = base.copyWith(
        status: AssetUploadItemStatus.postprocessFailed,
        message: error.toString(),
      );
      publish(failed);
      return failed;
    }
  }

  Future<void> _waitForTrace({
    required String traceId,
    required AssetUploadQueueItem base,
    required void Function(AssetUploadQueueItem item) publish,
  }) async {
    UploadTraceStatus? lastLogged;
    while (true) {
      final trace = await _traceRepository.getTrace(traceId: traceId);
      if (trace.status != lastLogged) {
        lastLogged = trace.status;
        if (kDebugMode) {
          debugPrint(
            '[upload] GetTrace traceId=$traceId '
            'status=${trace.status.name} lastEvent=${trace.lastEvent}',
          );
        }
      }
      switch (trace.status) {
        case UploadTraceStatus.running:
          final run = trace.run;
          final isQueued = run?.status == ToolRunStatus.queued;
          publish(
            base.copyWith(
              status: isQueued
                  ? AssetUploadItemStatus.postprocessQueued
                  : AssetUploadItemStatus.postprocessRunning,
              progressPercent: _traceProgress(trace),
              message: _traceMessage(trace),
            ),
          );
        case UploadTraceStatus.done:
          publish(base.copyWith(status: AssetUploadItemStatus.completed));
          return;
        case UploadTraceStatus.failed:
          publish(
            base.copyWith(
              status: AssetUploadItemStatus.postprocessFailed,
              message: trace.errorMessage.isEmpty
                  ? '파일 후처리에 실패했습니다.'
                  : trace.errorMessage,
            ),
          );
          return;
      }
      await Future<void>.delayed(const Duration(seconds: 1));
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
            base.copyWith(
              status: AssetUploadItemStatus.postprocessQueued,
              message: _postprocessQueuedMessage(run),
            ),
          );
        case ToolRunStatus.running:
          publish(
            base.copyWith(
              status: AssetUploadItemStatus.postprocessRunning,
              progressPercent: run.progressPercent,
              message: '',
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

  double _traceProgress(TraceSnapshot trace) {
    if (trace.progressPercent > 0) {
      return trace.progressPercent;
    }
    return trace.run?.progressPercent ?? 0;
  }

  String _traceMessage(TraceSnapshot trace) {
    final run = trace.run;
    if (run != null && run.status == ToolRunStatus.queued) {
      final wait = _postprocessQueuedMessage(run);
      if (trace.lastEvent.isEmpty) {
        return wait;
      }
      return '${trace.lastEvent} · $wait';
    }
    return trace.lastEvent;
  }

  String _postprocessQueuedMessage(ToolRunSnapshot run) {
    final detail = run.queueWaitLabel;
    if (detail.isEmpty) {
      return '후처리 대기';
    }
    return '후처리 대기 · $detail';
  }
}
