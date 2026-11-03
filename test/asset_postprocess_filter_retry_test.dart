import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/domain/entities/asset_lookup_row.dart';
import 'package:weld_dashboard/src/domain/entities/asset_upload.dart';
import 'package:weld_dashboard/src/domain/entities/camera_recording.dart';
import 'package:weld_dashboard/src/domain/entities/equipment.dart';
import 'package:weld_dashboard/src/domain/entities/job_draft.dart';
import 'package:weld_dashboard/src/domain/entities/lookup_page.dart';
import 'package:weld_dashboard/src/domain/entities/tool_run.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_catalog.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_page.dart';
import 'package:weld_dashboard/src/domain/entities/work_history_query.dart';
import 'package:weld_dashboard/src/domain/repositories/asset_lookup_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/asset_upload_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/equipment_lookup_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/tool_run_repository.dart';
import 'package:weld_dashboard/src/domain/repositories/work_history_repository.dart';
import 'package:weld_dashboard/src/domain/use_cases/get_asset_lookup_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_asset_lookup_page_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_equipment_lookup_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/list_work_history_page_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/retry_asset_postprocess_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/tool_run_use_case.dart';
import 'package:weld_dashboard/src/domain/use_cases/update_asset_use_case.dart';
import 'package:weld_dashboard/src/presentation/features/asset_lookup/asset_lookup_detail_view_model.dart';

void main() {
  test('ListAssetLookupPageUseCase passes postprocessStatusCode', () async {
    final repository = _RecordingAssetLookupRepository();
    final useCase = ListAssetLookupPageUseCase(repository);

    await useCase.execute(
      kindCode: '',
      query: '',
      equipmentId: '',
      unattachedOnly: false,
      postprocessStatusCode: 'failed',
      pageSize: 50,
      pageToken: '',
    );

    expect(repository.lastPostprocessStatusCode, 'failed');
  });

  test('detail retryPostprocess calls Retry then GetRun then reloads', () async {
    final upload = _FakeUploadRepository();
    final tools = _FakeToolRunRepository();
    final assets = _FakeAssetLookupRepository()
      ..asset = const AssetLookupRow(
        assetId: '23444',
        kindCode: 'timeseries',
        fileName: 'fail_postprocess_rpm.csv',
        equipmentId: '',
        sizeBytes: 87,
        durationNs: null,
        isDerived: false,
        isAttached: false,
        postprocess: AssetPostprocessSummary(
          runId: '1365',
          statusCode: 'failed',
          errorMessage: '숫자가 아님',
        ),
      );
    final viewModel = AssetLookupDetailViewModel(
      assetId: '23444',
      getAssetLookupUseCase: GetAssetLookupUseCase(assets),
      listWorkHistoryPageUseCase: ListWorkHistoryPageUseCase(
        _EmptyWorkHistoryRepository(),
      ),
      listEquipmentLookupUseCase: ListEquipmentLookupUseCase(
        _EmptyEquipmentRepository(),
      ),
      updateAssetUseCase: UpdateAssetUseCase(assets),
      retryAssetPostprocessUseCase: RetryAssetPostprocessUseCase(upload),
      toolRunUseCase: ToolRunUseCase(tools),
    );

    await viewModel.load();
    expect(viewModel.asset?.postprocess.isFailed, isTrue);

    assets.asset = const AssetLookupRow(
      assetId: '23444',
      kindCode: 'timeseries',
      fileName: 'fail_postprocess_rpm.csv',
      equipmentId: '',
      sizeBytes: 87,
      durationNs: null,
      isDerived: false,
      isAttached: false,
      postprocess: AssetPostprocessSummary(
        runId: '1371',
        statusCode: 'failed',
        errorMessage: '숫자가 아님',
      ),
    );

    final notice = await viewModel.retryPostprocess();

    expect(upload.retryAssetIds, ['23444']);
    expect(tools.getRunIds, ['1371']);
    expect(viewModel.asset?.postprocess.runId, '1371');
    expect(viewModel.isRetryingPostprocess, isFalse);
    expect(notice, isNotNull);
    expect(notice!.title, '후처리 실패');
    expect(notice.severity, InfoBarSeverity.error);
    expect(notice.message, contains('실행 1371'));
    expect(notice.message, contains('GetRun'));
    expect(notice.message, contains('재조회'));
    expect(notice.message, contains('숫자가 아님'));
  });

  test('detail retryPostprocess notice is success when GetRun succeeded', () async {
    final upload = _FakeUploadRepository();
    final tools = _FakeToolRunRepository(
      status: ToolRunStatus.succeeded,
      errorMessage: '',
    );
    final assets = _FakeAssetLookupRepository()
      ..asset = const AssetLookupRow(
        assetId: '1',
        kindCode: 'video',
        fileName: 'a.mp4',
        equipmentId: '',
        sizeBytes: 1,
        durationNs: null,
        isDerived: false,
        isAttached: false,
        postprocess: AssetPostprocessSummary(
          runId: '10',
          statusCode: 'failed',
          errorMessage: '이전 실패',
        ),
      );
    final viewModel = AssetLookupDetailViewModel(
      assetId: '1',
      getAssetLookupUseCase: GetAssetLookupUseCase(assets),
      listWorkHistoryPageUseCase: ListWorkHistoryPageUseCase(
        _EmptyWorkHistoryRepository(),
      ),
      listEquipmentLookupUseCase: ListEquipmentLookupUseCase(
        _EmptyEquipmentRepository(),
      ),
      updateAssetUseCase: UpdateAssetUseCase(assets),
      retryAssetPostprocessUseCase: RetryAssetPostprocessUseCase(upload),
      toolRunUseCase: ToolRunUseCase(tools),
    );
    await viewModel.load();
    assets.asset = const AssetLookupRow(
      assetId: '1',
      kindCode: 'video',
      fileName: 'a.mp4',
      equipmentId: '',
      sizeBytes: 1,
      durationNs: null,
      isDerived: false,
      isAttached: false,
      postprocess: AssetPostprocessSummary(
        runId: '1371',
        statusCode: 'succeeded',
      ),
    );

    final notice = await viewModel.retryPostprocess();

    expect(notice, isNotNull);
    expect(notice!.title, '후처리 완료');
    expect(notice.severity, InfoBarSeverity.success);
    expect(notice.message, contains('실행 1371'));
    expect(notice.message, contains('재조회 · 완료'));
  });
}

class _RecordingAssetLookupRepository implements AssetLookupRepository {
  String? lastPostprocessStatusCode;

  @override
  Future<AssetLookupPage> listAssets({
    required String kindCode,
    required String query,
    required String equipmentId,
    required bool unattachedOnly,
    String jobId = '',
    String projectId = '',
    String projectItemId = '',
    String workerId = '',
    String unitNo = '',
    String itemCode = '',
    String jointNo = '',
    int passNo = 0,
    bool sharedOnly = false,
    DateTime? startedFrom,
    DateTime? startedTo,
    String postprocessStatusCode = '',
    required int pageSize,
    required String pageToken,
  }) async {
    lastPostprocessStatusCode = postprocessStatusCode;
    return const AssetLookupPage(rows: [], nextPageToken: '');
  }

  @override
  Future<List<JobPassOption>> listJobPasses({required String jobId}) async =>
      const [];

  @override
  Future<AssetLookupRow?> getAsset({required String assetId}) async => null;

  @override
  Future<String> updateAsset({
    required String assetId,
    required String subject,
    required String situation,
    DateTime? recordedAt,
    required List<String> changedFields,
  }) async =>
      '';

  @override
  Future<String> readContent({required String url}) async => '';
}

class _FakeAssetLookupRepository implements AssetLookupRepository {
  AssetLookupRow? asset;

  @override
  Future<AssetLookupPage> listAssets({
    required String kindCode,
    required String query,
    required String equipmentId,
    required bool unattachedOnly,
    String jobId = '',
    String projectId = '',
    String projectItemId = '',
    String workerId = '',
    String unitNo = '',
    String itemCode = '',
    String jointNo = '',
    int passNo = 0,
    bool sharedOnly = false,
    DateTime? startedFrom,
    DateTime? startedTo,
    String postprocessStatusCode = '',
    required int pageSize,
    required String pageToken,
  }) async {
    return const AssetLookupPage(rows: [], nextPageToken: '');
  }

  @override
  Future<List<JobPassOption>> listJobPasses({required String jobId}) async =>
      const [];

  @override
  Future<AssetLookupRow?> getAsset({required String assetId}) async => asset;

  @override
  Future<String> updateAsset({
    required String assetId,
    required String subject,
    required String situation,
    DateTime? recordedAt,
    required List<String> changedFields,
  }) async =>
      '';

  @override
  Future<String> readContent({required String url}) async => '';
}

class _FakeUploadRepository implements AssetUploadRepository {
  final retryAssetIds = <String>[];

  @override
  Future<String> retryPostprocess({required String assetId}) async {
    retryAssetIds.add(assetId);
    return '1371';
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
  _FakeToolRunRepository({
    this.status = ToolRunStatus.failed,
    this.errorMessage = '숫자가 아님',
  });

  final ToolRunStatus status;
  final String errorMessage;
  final getRunIds = <String>[];

  @override
  Future<ToolRunSnapshot> getRun({required String runId}) async {
    getRunIds.add(runId);
    return ToolRunSnapshot(
      runId: runId,
      toolId: '9',
      status: status,
      errorMessage: errorMessage,
    );
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
    throw StateError('StartRun must not be called');
  }
}

class _EmptyWorkHistoryRepository implements WorkHistoryRepository {
  @override
  Future<WorkHistoryPage> listPage({
    required WorkHistoryQuery query,
    required int pageSize,
    required String pageToken,
  }) async {
    return const WorkHistoryPage(
      items: [],
      totalCount: 0,
      nextPageToken: '',
    );
  }

  @override
  Future<WorkHistoryCatalog> loadMasters() {
    throw UnimplementedError();
  }

  @override
  Future<WorkHistoryCatalog> loadCatalog({WorkHistoryQuery? query}) {
    throw UnimplementedError();
  }

  @override
  Future<String> createJob(JobDraft draft) {
    throw UnimplementedError();
  }
}

class _EmptyEquipmentRepository implements EquipmentLookupRepository {
  @override
  Future<LookupPage<Equipment>> listEquipment({
    required bool includeInactive,
    required String query,
    required int pageSize,
    required String pageToken,
  }) async {
    return const LookupPage(items: [], nextPageToken: '');
  }

  @override
  Future<Equipment?> getEquipment({required String equipmentId}) async => null;

  @override
  Future<String> createEquipment({
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateEquipment({
    required String equipmentId,
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
    required List<String> changedFields,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEquipment({required String equipmentId}) {
    throw UnimplementedError();
  }
}
