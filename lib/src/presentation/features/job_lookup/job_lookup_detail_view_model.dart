import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/asset_lookup_row.dart';
import '../../../domain/entities/work_history_item.dart';
import '../../../domain/use_cases/list_job_asset_lookup_use_case.dart';
import '../../../domain/use_cases/list_job_passes_use_case.dart';
import '../../../domain/use_cases/load_work_detail_catalog_use_case.dart';
import '../../../domain/use_cases/query_work_detail_use_case.dart';

enum JobLookupDetailTab { info, passes, attachments }

class JobLookupDetailViewModel extends ChangeNotifier {
  JobLookupDetailViewModel({
    required this.jobId,
    required LoadWorkDetailCatalogUseCase loadWorkDetailCatalogUseCase,
    required QueryWorkDetailUseCase queryWorkDetailUseCase,
    required ListJobPassesUseCase listJobPassesUseCase,
    required ListJobAssetLookupUseCase listJobAssetLookupUseCase,
  }) : _loadWorkDetailCatalogUseCase = loadWorkDetailCatalogUseCase,
       _queryWorkDetailUseCase = queryWorkDetailUseCase,
       _listJobPassesUseCase = listJobPassesUseCase,
       _listJobAssetLookupUseCase = listJobAssetLookupUseCase;

  final String jobId;
  final LoadWorkDetailCatalogUseCase _loadWorkDetailCatalogUseCase;
  final QueryWorkDetailUseCase _queryWorkDetailUseCase;
  final ListJobPassesUseCase _listJobPassesUseCase;
  final ListJobAssetLookupUseCase _listJobAssetLookupUseCase;

  WorkHistoryItem? _job;
  List<JobPassOption> _passes = const [];
  List<AssetLookupRow> _attachments = const [];
  JobLookupDetailTab _tab = JobLookupDetailTab.info;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _didLoadAttachments = false;

  WorkHistoryItem? get job => _job;
  List<JobPassOption> get passes => _passes;
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
      _passes = await _listJobPassesUseCase.execute(jobId: jobId);
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
      _attachments = await _listJobAssetLookupUseCase.execute(
        jobId: jobId,
        passId: '',
      );
      _didLoadAttachments = true;
    } catch (error) {
      _errorMessage = error.toString();
      _attachments = const [];
    }
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
