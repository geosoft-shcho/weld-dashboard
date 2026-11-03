import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/asset_upload.dart';
import 'package:weld_dashboard/src/domain/entities/camera_recording.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/repositories/asset_upload_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/tool_run_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/upload_asset_queue_use_case.dart';

void main() {
  test('retryPostprocess calls RetryPostprocess then GetRun until succeeded', () async {
    final upload = _FakeUploadRepository(runId: '91');
    final tools = _FakeToolRunRepository(
      snapshots: [
        const ToolRunSnapshot(
          runId: '91',
          toolId: '9',
          status: ToolRunStatus.queued,
          errorMessage: '',
        ),
        const ToolRunSnapshot(
          runId: '91',
          toolId: '9',
          status: ToolRunStatus.running,
          errorMessage: '',
          progressPercent: 40,
        ),
        const ToolRunSnapshot(
          runId: '91',
          toolId: '9',
          status: ToolRunStatus.succeeded,
          errorMessage: '',
          progressPercent: 100,
        ),
      ],
    );
    final useCase = UploadAssetQueueUseCase(upload, tools);
    final updates = <AssetUploadItemStatus>[];

    final result = await useCase.retryPostprocess(
      assetId: '128',
      base: const AssetUploadQueueItem(
        localId: 'row-1',
        fileName: 'take.webm',
        status: AssetUploadItemStatus.postprocessFailed,
        message: '이전 실패',
        result: AssetUploadResult(
          assetId: '128',
          fileName: 'take.webm',
          runId: '77',
        ),
      ),
      onItemUpdated: (item) => updates.add(item.status),
    );

    expect(upload.retryAssetIds, ['128']);
    expect(tools.getRunIds, ['91', '91', '91']);
    expect(updates, [
      AssetUploadItemStatus.postprocessQueued,
      AssetUploadItemStatus.postprocessQueued,
      AssetUploadItemStatus.postprocessRunning,
      AssetUploadItemStatus.completed,
    ]);
    expect(result.status, AssetUploadItemStatus.completed);
    expect(result.result?.runId, '91');
    expect(result.message, isEmpty);
  });

  test('retryPostprocess failure stays postprocessFailed with message', () async {
    final upload = _FakeUploadRepository(
      error: const AssetUploadException('다시 걸 수 없음'),
    );
    final tools = _FakeToolRunRepository(snapshots: const []);
    final useCase = UploadAssetQueueUseCase(upload, tools);
    final updates = <AssetUploadQueueItem>[];

    final result = await useCase.retryPostprocess(
      assetId: '128',
      base: const AssetUploadQueueItem(
        localId: 'row-1',
        fileName: 'take.webm',
        status: AssetUploadItemStatus.postprocessFailed,
        result: AssetUploadResult(
          assetId: '128',
          fileName: 'take.webm',
          runId: '77',
        ),
      ),
      onItemUpdated: updates.add,
    );

    expect(upload.retryAssetIds, ['128']);
    expect(tools.getRunIds, isEmpty);
    expect(result.status, AssetUploadItemStatus.postprocessFailed);
    expect(result.message, contains('다시 걸 수 없음'));
    expect(updates.single.status, AssetUploadItemStatus.postprocessFailed);
  });
}

class _FakeUploadRepository implements AssetUploadRepository {
  _FakeUploadRepository({this.runId = '', this.error});

  final String runId;
  final AssetUploadException? error;
  final List<String> retryAssetIds = [];

  @override
  Future<String> retryPostprocess({required String assetId}) async {
    retryAssetIds.add(assetId);
    final thrown = error;
    if (thrown != null) {
      throw thrown;
    }
    return runId;
  }

  @override
  Future<AssetUploadFormats> listUploadFormats() {
    throw UnimplementedError();
  }

  @override
  Future<CameraRecordingFile?> pickFile() {
    throw UnimplementedError();
  }

  @override
  Future<List<CameraRecordingFile>> pickFiles() {
    throw UnimplementedError();
  }

  @override
  Future<AssetUploadResult> registerUploaded({
    required String uploadId,
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    String subject = '',
    String situation = '',
    String fallbackFileName = '',
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AssetUploadResult> upload({
    required String jobId,
    required DateTime timeOrigin,
    required CameraRecordingFile file,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AssetUploadResult> uploadFile({
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    required CameraRecordingFile file,
    String subject = '',
    String situation = '',
    void Function(double progressPercent)? onProgress,
  }) {
    throw UnimplementedError();
  }
}

class _FakeToolRunRepository implements ToolRunRepository {
  _FakeToolRunRepository({required this.snapshots});

  final List<ToolRunSnapshot> snapshots;
  final List<String> getRunIds = [];
  var _index = 0;

  @override
  Future<ToolRunSnapshot> getRun({required String runId}) async {
    getRunIds.add(runId);
    if (_index >= snapshots.length) {
      return snapshots.last;
    }
    return snapshots[_index++];
  }

  @override
  Future<ToolRunSnapshot> cancelRun({required String runId}) {
    throw UnimplementedError();
  }

  @override
  Future<List<InferenceTool>> listEnabledTools({bool includeDisabled = false}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ToolRunSnapshot>> listJobRuns({required String jobId}) {
    throw UnimplementedError();
  }

  @override
  Future<ToolRunSnapshot> startRun({
    required String toolId,
    required ToolRunTargetKind kind,
    required String targetId,
  }) {
    throw UnimplementedError();
  }
}
