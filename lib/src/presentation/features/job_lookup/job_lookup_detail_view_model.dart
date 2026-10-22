import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/job_detail.dart';
import '../../../domain/entities/work_history_catalog.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/entities/work_history_project_filter.dart';
import '../../../domain/entities/worker.dart';
import '../../../domain/use_cases/job_admin_use_case.dart';
import '../../../domain/use_cases/list_asset_lookup_page_use_case.dart';
import '../../../domain/use_cases/list_job_passes_use_case.dart';
import '../../../domain/use_cases/load_work_detail_catalog_use_case.dart';
import '../../../domain/use_cases/load_work_history_masters_use_case.dart';
import '../../../domain/use_cases/query_work_detail_use_case.dart';

enum JobLookupDetailTab { info, passes, attachments }

class JobLookupDetailViewModel extends ChangeNotifier {
  JobLookupDetailViewModel({
    required this.jobId,
    required LoadWorkDetailCatalogUseCase loadWorkDetailCatalogUseCase,
    required QueryWorkDetailUseCase queryWorkDetailUseCase,
    required ListJobPassesUseCase listJobPassesUseCase,
    required ListAssetLookupPageUseCase listAssetLookupPageUseCase,
    required JobAdminUseCase jobAdminUseCase,
    required LoadWorkHistoryMastersUseCase loadWorkHistoryMastersUseCase,
  }) : _loadWorkDetailCatalogUseCase = loadWorkDetailCatalogUseCase,
       _queryWorkDetailUseCase = queryWorkDetailUseCase,
       _listJobPassesUseCase = listJobPassesUseCase,
       _listAssetLookupPageUseCase = listAssetLookupPageUseCase,
       _jobAdminUseCase = jobAdminUseCase,
       _loadWorkHistoryMastersUseCase = loadWorkHistoryMastersUseCase;
  final String jobId;
  final LoadWorkDetailCatalogUseCase _loadWorkDetailCatalogUseCase;
  final QueryWorkDetailUseCase _queryWorkDetailUseCase;
  final ListJobPassesUseCase _listJobPassesUseCase;
  final ListAssetLookupPageUseCase _listAssetLookupPageUseCase;
  final JobAdminUseCase _jobAdminUseCase;
  final LoadWorkHistoryMastersUseCase _loadWorkHistoryMastersUseCase;

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

  WorkHistoryItem? get job => _job;
  JobDetail? get detail => _detail;
  List<WorkHistoryProjectFilter> get projects => _masters?.projects ?? const [];
  List<Worker> get workers => _masters?.workers ?? const [];
  List<JobPassDetail> get passes => _passes;
  List<AssetLookupRow> get attachments => _attachments;

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
      final catalog = await _loadWorkDetailCatalogUseCase.execute(jobId: jobId);
      final detail = _queryWorkDetailUseCase.execute(
        catalog: catalog,
        jobId: jobId,
      );
      _job = detail.job;
      try {
        _masters = await _loadWorkHistoryMastersUseCase.execute();
      } catch (_) {
        _masters = null;
      }
      try {
        _detail = await _jobAdminUseCase.getJobDetail(jobId: jobId);
        _passes = _detail!.passes;
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
      if (_job == null) {
        _hasError = true;
        _errorMessage = '작업을 찾지 못했습니다.';
      }
      if (_tab == JobLookupDetailTab.attachments) {
        await _loadAttachments();
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
    try {
      final page = await _listAssetLookupPageUseCase.execute(
        kindCode: '',
        query: '',
        equipmentId: '',
        unattachedOnly: false,
        jobId: jobId,
        pageSize: 200,
        pageToken: '',
      );
      _attachments = page.rows;
      _didLoadAttachments = true;
    } catch (error) {
      _errorMessage = error.toString();
      _attachments = const [];
    }
  }

  Future<JobDetail> updateJob(JobEditDraft draft) async {
    final original = _detail;
    if (original == null) throw StateError('작업 상세가 없습니다.');
    final updated = await _jobAdminUseCase.updateJob(
      original: original,
      draft: draft,
    );
    _applyDetail(updated);
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
    _applyDetail(updated);
    notifyListeners();
  }

  Future<void> _reloadAttachments() async {
    _didLoadAttachments = false;
    await _loadAttachments();
    final detail = _detail;
    if (detail != null) {
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
          hasReport: detail.hasReport,
          attachmentCount: _attachments.length,
          passes: detail.passes,
        ),
      );
    }
    notifyListeners();
  }

  void _applyDetail(JobDetail detail) {
    _detail = detail;
    _passes = detail.passes;
    final old = _job;
    if (old == null) return;
    _job = WorkHistoryItem(
      jobId: detail.jobId,
      jobKey: detail.jobKey,
      commonKey: detail.commonKey,
      projectNo: detail.projectNo,
      unitNo: detail.unitNo,
      itemCode: detail.itemCode,
      itemName: detail.itemName,
      jointNo: detail.jointNo,
      hasReport: old.hasReport,
      workerId: detail.workerId,
      workerName: detail.workerName.isEmpty
          ? old.workerName
          : detail.workerName,
      workerKind: old.workerKind,
      equipmentId: old.equipmentId,
      equipmentName: old.equipmentName,
      workedAt: detail.startedAt,
      passCount: detail.passes.length,
      attachmentCount: detail.attachmentCount,
      passes: old.passes,
    );
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
