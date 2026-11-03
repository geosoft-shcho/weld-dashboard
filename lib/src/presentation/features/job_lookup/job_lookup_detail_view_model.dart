import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/asset_upload.dart';
import '../../../domain/entities/camera_recording.dart';
import '../../../domain/entities/equipment.dart';
import '../../../domain/entities/job_detail.dart';
import '../../../domain/entities/work_history_catalog.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_project_filter.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/entities/worker.dart';
import '../../../domain/entities/worker_kind.dart';
import '../../../domain/use_cases/job_admin_use_case.dart';
import '../../../domain/use_cases/list_asset_lookup_page_use_case.dart';
import '../../../domain/use_cases/list_upload_formats_use_case.dart';
import '../../../domain/use_cases/upload_asset_queue_use_case.dart';
import '../../../domain/use_cases/upload_asset_use_case.dart';
import '../../../domain/use_cases/list_job_passes_use_case.dart';
import '../../../domain/use_cases/load_work_history_masters_use_case.dart';

enum JobLookupDetailTab { info, passes, attachments }

class JobLookupDetailViewModel extends ChangeNotifier {
  JobLookupDetailViewModel({
    required this.jobId,
    required ListJobPassesUseCase listJobPassesUseCase,
    required ListAssetLookupPageUseCase listAssetLookupPageUseCase,
    required JobAdminUseCase jobAdminUseCase,
    required LoadWorkHistoryMastersUseCase loadWorkHistoryMastersUseCase,
    required ListUploadFormatsUseCase listUploadFormatsUseCase,
    required UploadAssetUseCase uploadAssetUseCase,
    required UploadAssetQueueUseCase uploadAssetQueueUseCase,
  }) : _listJobPassesUseCase = listJobPassesUseCase,
       _listAssetLookupPageUseCase = listAssetLookupPageUseCase,
       _jobAdminUseCase = jobAdminUseCase,
       _loadWorkHistoryMastersUseCase = loadWorkHistoryMastersUseCase,
       _listUploadFormatsUseCase = listUploadFormatsUseCase,
       _uploadAssetUseCase = uploadAssetUseCase,
       _uploadAssetQueueUseCase = uploadAssetQueueUseCase;

  final String jobId;
  final ListJobPassesUseCase _listJobPassesUseCase;
  final ListAssetLookupPageUseCase _listAssetLookupPageUseCase;
  final JobAdminUseCase _jobAdminUseCase;
  final LoadWorkHistoryMastersUseCase _loadWorkHistoryMastersUseCase;
  final ListUploadFormatsUseCase _listUploadFormatsUseCase;
  final UploadAssetUseCase _uploadAssetUseCase;
  final UploadAssetQueueUseCase _uploadAssetQueueUseCase;

  WorkHistoryItem? _job;
  JobDetail? _detail;
  WorkHistoryCatalog? _masters;
  List<JobPassDetail> _passes = const [];
  List<AssetLookupRow> _attachments = const [];
  JobLookupDetailTab _tab = JobLookupDetailTab.info;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _didLoadAttachments = false;
  bool _isLoadingAttachments = false;
  String _attachmentsNextPageToken = '';
  bool _isLoadingMoreAttachments = false;
  int _attachmentsTotalCount = 0;
  int _attachmentsMoreVersion = 0;

  static const int attachmentsPageSize = WorkHistoryQuery.BATCH_SIZE;

  WorkHistoryItem? get job => _job;
  JobDetail? get detail => _detail;
  List<WorkHistoryProjectFilter> get projects => _masters?.projects ?? const [];
  List<Worker> get workers => _masters?.workers ?? const [];
  List<JobPassDetail> get passes => _passes;
  List<AssetLookupRow> get attachments => _attachments;
  List<Equipment> get equipment => _masters?.equipments ?? const [];
  bool get doesHaveMoreAttachments => _attachmentsNextPageToken.isNotEmpty;
  bool get isLoadingAttachments => _isLoadingAttachments;
  bool get isLoadingMoreAttachments => _isLoadingMoreAttachments;
  bool get didLoadAttachments => _didLoadAttachments;
  int get attachmentTotalCount => _attachmentsTotalCount > 0
      ? _attachmentsTotalCount
      : (_detail?.attachmentCount ?? _job?.attachmentCount ?? 0);

  /// 올리기 다이얼로그용 — 잠긴 작업 하나와 그 패스들.
  List<WorkHistoryItem> get uploadJobs {
    final job = _job;
    if (job == null) return const [];
    return [
      WorkHistoryItem(
        jobId: job.jobId,
        jobKey: job.jobKey,
        commonKey: job.commonKey,
        projectNo: job.projectNo,
        unitNo: job.unitNo,
        itemCode: job.itemCode,
        itemName: job.itemName,
        jointNo: job.jointNo,
        hasReport: job.hasReport,
        workerId: job.workerId,
        workerName: job.workerName,
        workerKind: job.workerKind,
        equipmentId: job.equipmentId,
        equipmentName: job.equipmentName,
        workedAt: job.workedAt,
        passCount: job.passCount,
        attachmentCount: job.attachmentCount,
        passes: [
          for (final pass in _passes)
            JobPassOption(
              passId: pass.passId,
              passNo: pass.passNo,
              startedAt: pass.startedAt,
              endedAt: pass.endedAt,
            ),
        ],
      ),
    ];
  }

  JobLookupDetailTab get tab => _tab;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      await Future.wait([
        _loadMasters(),
        _loadJobDetail(),
      ]);
      if (_job == null) {
        _hasError = true;
        _errorMessage = '작업을 찾지 못했습니다.';
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _job = null;
      _passes = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMasters() async {
    try {
      _masters = await _loadWorkHistoryMastersUseCase.execute();
    } catch (_) {
      _masters = null;
    }
  }

  Future<void> _loadJobDetail() async {
    try {
      final detail = await _jobAdminUseCase.getJobDetail(jobId: jobId);
      _applyDetail(detail);
    } catch (_) {
      final options = await _listJobPassesUseCase.execute(jobId: jobId);
      _passes = [
        for (final pass in options)
          JobPassDetail(
            passId: pass.passId,
            passNo: pass.passNo,
            kind: PassKind.unknown,
            startedAt: pass.startedAt,
            endedAt: pass.endedAt,
          ),
      ];
    }
  }

  Future<void> didSelectTab(JobLookupDetailTab tab) async {
    if (_tab == tab) {
      return;
    }
    _tab = tab;
    notifyListeners();
    if (tab == JobLookupDetailTab.attachments && !_didLoadAttachments) {
      await _loadAttachments();
      notifyListeners();
    }
  }

  Future<void> _loadAttachments() async {
    _attachmentsMoreVersion++;
    _attachmentsNextPageToken = '';
    _isLoadingMoreAttachments = false;
    _isLoadingAttachments = true;
    notifyListeners();
    try {
      final page = await _listAssetLookupPageUseCase.execute(
        kindCode: '',
        query: '',
        equipmentId: '',
        unattachedOnly: false,
        jobId: jobId,
        pageSize: attachmentsPageSize,
        pageToken: '',
      );
      _attachments = page.rows;
      _attachmentsNextPageToken = page.nextPageToken;
      if (page.totalCount > 0) {
        _attachmentsTotalCount = page.totalCount;
      }
      _didLoadAttachments = true;
      _syncAttachmentCountToDetail();
    } catch (error) {
      _errorMessage = error.toString();
      _attachments = const [];
      _attachmentsNextPageToken = '';
    } finally {
      _isLoadingAttachments = false;
      notifyListeners();
    }
  }

  Future<void> didScrollAttachmentsNearEnd() async {
    if (!doesHaveMoreAttachments ||
        _isLoading ||
        _isLoadingMoreAttachments ||
        !_didLoadAttachments) {
      return;
    }
    final version = ++_attachmentsMoreVersion;
    final pageToken = _attachmentsNextPageToken;
    _isLoadingMoreAttachments = true;
    notifyListeners();
    try {
      final page = await _listAssetLookupPageUseCase.execute(
        kindCode: '',
        query: '',
        equipmentId: '',
        unattachedOnly: false,
        jobId: jobId,
        pageSize: attachmentsPageSize,
        pageToken: pageToken,
      );
      if (version != _attachmentsMoreVersion) {
        return;
      }
      final existing = {for (final row in _attachments) row.assetId};
      _attachments = [
        ..._attachments,
        for (final row in page.rows)
          if (!existing.contains(row.assetId)) row,
      ];
      _attachmentsNextPageToken = page.nextPageToken;
      if (page.totalCount > 0) {
        _attachmentsTotalCount = page.totalCount;
      }
    } catch (_) {
      // 이어 받기 실패는 이미 받은 목록을 유지한다.
    } finally {
      if (version == _attachmentsMoreVersion) {
        _isLoadingMoreAttachments = false;
        notifyListeners();
      }
    }
  }

  Future<JobDetail> updateJob(JobEditDraft draft) async {
    final original = _detail;
    if (original == null) throw StateError('작업 상세가 없습니다.');
    final updated = await _jobAdminUseCase.updateJob(
      original: original,
      draft: draft,
    );
    _applyDetail(_withPreservedAttachmentCount(updated));
    notifyListeners();
    return updated;
  }

  Future<void> deleteJob() {
    return _jobAdminUseCase.deleteJob(jobId: jobId);
  }

  Future<void> createPass(PassEditDraft draft) async {
    await _jobAdminUseCase.createPass(jobId: jobId, draft: draft);
    await _reloadDetail();
  }

  Future<void> updatePass(JobPassDetail original, PassEditDraft draft) async {
    await _jobAdminUseCase.updatePass(original: original, draft: draft);
    await _reloadDetail();
  }

  Future<void> deletePass(String passId) async {
    await _jobAdminUseCase.deletePass(passId: passId);
    await _reloadDetail();
  }

  Future<void> attachAsset({
    required String assetId,
    required String passId,
  }) async {
    await _jobAdminUseCase.attachAsset(
      jobId: jobId,
      assetId: assetId,
      passId: passId,
    );
    await _reloadAttachments();
  }

  Future<void> changeAttachmentPass({
    required String assetId,
    required String passId,
  }) async {
    await _jobAdminUseCase.attachAsset(
      jobId: jobId,
      assetId: assetId,
      passId: passId,
    );
    await _reloadAttachments();
  }

  Future<void> detachAsset(String assetId) async {
    await _jobAdminUseCase.detachAsset(jobId: jobId, assetId: assetId);
    await _reloadAttachments();
  }

  Future<void> _reloadDetail() async {
    final updated = await _jobAdminUseCase.getJobDetail(jobId: jobId);
    _applyDetail(_withPreservedAttachmentCount(updated));
    notifyListeners();
  }

  Future<void> _reloadAttachments() async {
    _didLoadAttachments = false;
    await _loadAttachments();
    notifyListeners();
  }

  void _syncAttachmentCountToDetail() {
    final detail = _detail;
    if (detail == null) {
      return;
    }
    final count = _attachmentsTotalCount > 0
        ? _attachmentsTotalCount
        : detail.attachmentCount;
    if (count == detail.attachmentCount) {
      return;
    }
    _applyDetail(
      JobDetail(
        jobId: detail.jobId,
        jobKey: detail.jobKey,
        commonKey: detail.commonKey,
        projectId: detail.projectId,
        projectNo: detail.projectNo,
        unitNo: detail.unitNo,
        itemCode: detail.itemCode,
        itemName: detail.itemName,
        jointNo: detail.jointNo,
        jobName: detail.jobName,
        itemNo: detail.itemNo,
        operationNo: detail.operationNo,
        material: detail.material,
        outerDiameterMm: detail.outerDiameterMm,
        thicknessMm: detail.thicknessMm,
        workerId: detail.workerId,
        workerName: detail.workerName,
        startedAt: detail.startedAt,
        endedAt: detail.endedAt,
        reportSetId: detail.reportSetId,
        activeReportSetId: detail.activeReportSetId,
        hasReport: detail.hasReport,
        attachmentCount: count,
        passes: detail.passes,
      ),
    );
  }

  JobDetail _withPreservedAttachmentCount(JobDetail updated) {
    final count = _attachmentsTotalCount > 0
        ? _attachmentsTotalCount
        : (_detail?.attachmentCount ?? updated.attachmentCount);
    if (count == updated.attachmentCount) {
      return updated;
    }
    return JobDetail(
      jobId: updated.jobId,
      jobKey: updated.jobKey,
      commonKey: updated.commonKey,
      projectId: updated.projectId,
      projectNo: updated.projectNo,
      unitNo: updated.unitNo,
      itemCode: updated.itemCode,
      itemName: updated.itemName,
      jointNo: updated.jointNo,
      jobName: updated.jobName,
      itemNo: updated.itemNo,
      operationNo: updated.operationNo,
      material: updated.material,
      outerDiameterMm: updated.outerDiameterMm,
      thicknessMm: updated.thicknessMm,
      workerId: updated.workerId,
      workerName: updated.workerName,
      startedAt: updated.startedAt,
      endedAt: updated.endedAt,
      reportSetId: updated.reportSetId,
      activeReportSetId: updated.activeReportSetId,
      hasReport: updated.hasReport,
      attachmentCount: count,
      passes: updated.passes,
    );
  }

  void _applyDetail(JobDetail detail) {
    _detail = detail;
    _passes = detail.passes;
    final old = _job;
    _job = WorkHistoryItem(
      jobId: detail.jobId,
      jobKey: detail.jobKey,
      commonKey: detail.commonKey,
      projectNo: detail.projectNo,
      unitNo: detail.unitNo,
      itemCode: detail.itemCode,
      itemName: detail.itemName,
      jointNo: detail.jointNo,
      hasReport: detail.hasReport,
      workerId: detail.workerId,
      workerName: detail.workerName.isEmpty
          ? (old?.workerName ?? '')
          : detail.workerName,
      workerKind: old?.workerKind ?? WorkerKind.unknown,
      equipmentId: old?.equipmentId ?? '',
      equipmentName: old?.equipmentName ?? '',
      workedAt: detail.startedAt,
      passCount: detail.passes.length,
      attachmentCount: detail.attachmentCount,
      passes: old?.passes ??
          [
            for (final pass in detail.passes)
              JobPassOption(
                passId: pass.passId,
                passNo: pass.passNo,
                startedAt: pass.startedAt,
                endedAt: pass.endedAt,
              ),
          ],
    );
  }

  Future<AssetUploadFormats> loadUploadFormats() {
    return _listUploadFormatsUseCase.execute();
  }

  Future<CameraRecordingFile?> pickUploadFile() {
    return _uploadAssetUseCase.pickFile();
  }

  Future<List<CameraRecordingFile>> pickUploadFiles() {
    return _uploadAssetUseCase.pickFiles();
  }

  Future<AssetUploadResult> uploadAssetFile({
    required String jobId,
    required String passId,
    required String equipmentId,
    required DateTime? timeOrigin,
    required CameraRecordingFile file,
    String subject = '',
    String situation = '',
  }) {
    return _uploadAssetUseCase.uploadFile(
      jobId: jobId,
      passId: passId,
      equipmentId: equipmentId,
      timeOrigin: timeOrigin,
      file: file,
      subject: subject,
      situation: situation,
    );
  }

  Future<AssetUploadBatchResult> uploadAssetQueue({
    required String jobId,
    required String passId,
    required String equipmentId,
    required List<AssetUploadQueueEntry> entries,
    required void Function(AssetUploadQueueItem item) onItemUpdated,
    String subject = '',
    String situation = '',
  }) {
    return _uploadAssetQueueUseCase.execute(
      jobId: jobId,
      passId: passId,
      equipmentId: equipmentId,
      entries: entries,
      onItemUpdated: onItemUpdated,
      subject: subject,
      situation: situation,
    );
  }

  Future<AssetUploadQueueItem> retryPostprocess({
    required String assetId,
    required AssetUploadQueueItem base,
    required void Function(AssetUploadQueueItem item) onItemUpdated,
  }) {
    return _uploadAssetQueueUseCase.retryPostprocess(
      assetId: assetId,
      base: base,
      onItemUpdated: onItemUpdated,
    );
  }

  Future<void> didFinishUpload() async {
    await _reloadAttachments();
  }

  String passLabelOf(AssetLookupRow row) {
    if (row.attachmentPassId.isEmpty) {
      return '—';
    }
    if (row.attachmentPassId == jobCommonPassToken) {
      return '공용';
    }
    for (final pass in _passes) {
      if (pass.passId == row.attachmentPassId) {
        return '${pass.passNo}패스';
      }
    }
    return row.attachmentPassId;
  }
}
