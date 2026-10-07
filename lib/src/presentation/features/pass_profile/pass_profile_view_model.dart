import 'package:flutter/foundation.dart';

import '../../../domain/entities/comparison_job_candidate.dart';
import '../../../domain/entities/pass_profile_board.dart';
import '../../../domain/entities/pass_waveform_catalog.dart';
import '../../../domain/entities/weld_pass.dart';
import '../../../domain/use_cases/list_comparison_jobs_use_case.dart';
import '../../../domain/use_cases/load_comparison_passes_use_case.dart';
import '../../../domain/use_cases/load_pass_waveform_catalog_use_case.dart';
import '../../../domain/use_cases/load_pass_waveform_use_case.dart';
import '../../../domain/use_cases/pair_comparison_pass.dart';
import '../../../domain/use_cases/query_pass_profile_use_case.dart';

class PassProfileViewModel extends ChangeNotifier {
  PassProfileViewModel({
    required LoadPassWaveformCatalogUseCase loadPassWaveformCatalogUseCase,
    required LoadPassWaveformUseCase loadPassWaveformUseCase,
    required ListComparisonJobsUseCase listComparisonJobsUseCase,
    required LoadComparisonPassesUseCase loadComparisonPassesUseCase,
    required QueryPassProfileUseCase queryPassProfileUseCase,
    required this.commonKey,
    required this.jobId,
    String passId = '',
  }) : _loadPassWaveformCatalogUseCase = loadPassWaveformCatalogUseCase,
       _loadPassWaveformUseCase = loadPassWaveformUseCase,
       _listComparisonJobsUseCase = listComparisonJobsUseCase,
       _loadComparisonPassesUseCase = loadComparisonPassesUseCase,
       _queryPassProfileUseCase = queryPassProfileUseCase,
       _passId = passId;

  final LoadPassWaveformCatalogUseCase _loadPassWaveformCatalogUseCase;
  final LoadPassWaveformUseCase _loadPassWaveformUseCase;
  final ListComparisonJobsUseCase _listComparisonJobsUseCase;
  final LoadComparisonPassesUseCase _loadComparisonPassesUseCase;
  final QueryPassProfileUseCase _queryPassProfileUseCase;
  final String commonKey;
  final String jobId;

  PassWaveformCatalog? _catalog;
  PassProfileBoard? _board;
  String _passId;
  String _comparisonJobId = '';
  List<ComparisonJobCandidate> _comparisonJobs = const [];
  List<WeldPass> _comparisonPasses = const [];
  String _comparisonNextPageToken = '';
  String _comparisonError = '';
  bool _isComparisonPageLoading = false;
  String _masterProfileId = '';
  String _normalize = 'raw';
  bool _showMaster = true;
  bool _showBeginner = true;
  bool _showRobot = true;
  bool _isLoading = false;
  bool _isSeriesLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _seriesError = '';
  int _loadVersion = 0;

  PassProfileBoard? get board => _board;
  String get selectedPassId => _passId;
  String get selectedComparisonJobId => _comparisonJobId;
  List<ComparisonJobCandidate> get comparisonJobs => _comparisonJobs;
  String get comparisonError => _comparisonError;
  String get selectedMasterProfileId => _masterProfileId;
  bool get showMaster => _showMaster;
  String get normalize => _normalize;
  bool get showBeginner => _showBeginner;
  bool get showRobot => _showRobot;
  bool get isLoading => _isLoading;
  bool get isSeriesLoading => _isSeriesLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  String get seriesError => _seriesError;

  Future<void> loadBoard() async {
    final version = ++_loadVersion;
    _isLoading = true;
    _isSeriesLoading = false;
    _hasError = false;
    _errorMessage = '';
    _seriesError = '';
    notifyListeners();
    try {
      final catalog = await _loadPassWaveformCatalogUseCase.execute(
        commonKey: commonKey,
        jobId: jobId,
        passId: _passId,
        normalize: _normalize,
      );
      if (version != _loadVersion) return;
      _catalog = catalog;
      _applyLoadedNormalize(catalog);
      _applyQuery();
      _clearComparison();
      _isLoading = false;
      notifyListeners();
      await _loadComparisonJobPage(version: version, pageToken: '');
    } catch (error) {
      if (version != _loadVersion) return;
      _hasError = true;
      _errorMessage = error.toString();
      _board = null;
      _clearComparison();
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void didSelectPass(String passId) {
    if (_passId == passId) {
      return;
    }
    _passId = passId;
    _masterProfileId = '';
    _reloadSeries();
  }

  Future<void> didSelectComparisonJob(String comparisonJobId) async {
    if (_comparisonJobId == comparisonJobId) {
      return;
    }
    _comparisonJobId = comparisonJobId;
    _comparisonError = '';
    if (comparisonJobId.isEmpty) {
      _comparisonPasses = const [];
      await _reloadSeries();
      return;
    }
    final version = ++_loadVersion;
    _isSeriesLoading = true;
    notifyListeners();
    try {
      final passes = await _loadComparisonPassesUseCase.execute(
        jobId: comparisonJobId,
      );
      if (version != _loadVersion) {
        return;
      }
      _comparisonPasses = passes;
    } catch (_) {
      if (version != _loadVersion) {
        return;
      }
      _comparisonPasses = const [];
      _comparisonError = '비교 작업을 불러오지 못했습니다.';
      await _reloadWaveform(version);
      return;
    }
    await _reloadWaveform(version);
  }

  Future<void> didOpenComparisonJobs() async {
    final pageToken = _comparisonNextPageToken;
    if (pageToken.isEmpty || _isComparisonPageLoading) {
      return;
    }
    _isComparisonPageLoading = true;
    final version = _loadVersion;
    try {
      await _loadComparisonJobPage(version: version, pageToken: pageToken);
    } finally {
      _isComparisonPageLoading = false;
      if (version == _loadVersion) {
        notifyListeners();
      }
    }
  }

  void didSelectMasterProfile(String masterProfileId) {
    if (_masterProfileId == masterProfileId) {
      return;
    }
    _masterProfileId = masterProfileId;
    _applyQuery();
    notifyListeners();
  }

  void didSelectNormalize(String normalize) {
    if (_normalize == normalize) {
      return;
    }
    _normalize = normalize;
    _reloadSeries();
  }

  Future<void> _reloadSeries() async {
    final version = ++_loadVersion;
    await _reloadWaveform(version);
  }

  Future<void> _reloadWaveform(int version) async {
    final catalog = _catalog;
    if (catalog == null) {
      return;
    }
    _isSeriesLoading = true;
    _seriesError = '';
    notifyListeners();
    final item = catalog.historyItems.firstOrNull;
    final comparisonPassId = _comparisonPasses.isEmpty
        ? ''
        : pairComparisonPassId(
            targetPasses: catalog.passes,
            selectedPassId: _passId,
            comparisonPasses: _comparisonPasses,
          );
    try {
      final series = await _loadPassWaveformUseCase.execute(
        passId: _passId,
        commonKey: item?.commonKey.isNotEmpty == true
            ? item!.commonKey
            : commonKey,
        workerId: item?.workerId ?? '',
        comparisonPassId: comparisonPassId,
        normalize: _normalize,
      );
      if (version != _loadVersion) {
        return;
      }
      _catalog = PassWaveformCatalog(
        passes: catalog.passes,
        waveformRows: series.rows,
        links: catalog.links,
        qualityGroups: catalog.qualityGroups,
        historyItems: catalog.historyItems,
        workers: catalog.workers,
        context: catalog.context,
        waveformNotice: series.notice,
        didFallBackToRaw: series.didFallBackToRaw,
      );
      _applyLoadedNormalize(_catalog!);
      _applyQuery();
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _seriesError = error.toString();
      _restoreSelectionFromBoard();
    } finally {
      if (version == _loadVersion) {
        _isSeriesLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _loadComparisonJobPage({
    required int version,
    required String pageToken,
  }) async {
    final contextData = _catalog?.context;
    if (contextData == null) {
      return;
    }
    try {
      final page = await _listComparisonJobsUseCase.execute(
        projectNo: contextData.projectNo,
        itemCode: contextData.itemCode,
        unitNo: contextData.unitNo,
        excludeJobId: jobId,
        pageToken: pageToken,
      );
      if (version != _loadVersion) {
        return;
      }
      final merged = pageToken.isEmpty
          ? <ComparisonJobCandidate>[]
          : [..._comparisonJobs];
      final seen = {for (final job in merged) job.jobId};
      for (final job in page.jobs) {
        if (seen.add(job.jobId)) {
          merged.add(job);
        }
      }
      _comparisonJobs = merged;
      _comparisonNextPageToken = page.nextPageToken;
    } catch (_) {
      if (version != _loadVersion || pageToken.isNotEmpty) {
        return;
      }
      _comparisonJobs = const [];
      _comparisonNextPageToken = '';
    }
  }

  void _clearComparison() {
    _comparisonJobId = '';
    _comparisonJobs = const [];
    _comparisonPasses = const [];
    _comparisonNextPageToken = '';
    _comparisonError = '';
  }

  void didTapToggleMaster(bool isOn) {
    _showMaster = isOn;
    notifyListeners();
  }

  void didTapToggleBeginner(bool isOn) {
    _showBeginner = isOn;
    notifyListeners();
  }

  void didTapToggleRobot(bool isOn) {
    _showRobot = isOn;
    notifyListeners();
  }

  void didTapReload() {
    loadBoard();
  }

  void _restoreSelectionFromBoard() {
    final board = _board;
    if (board == null) {
      return;
    }
    _passId = board.selectedPass?.passId ?? _passId;
    _masterProfileId = board.selectedMasterProfileId;
  }

  void _applyLoadedNormalize(PassWaveformCatalog catalog) {
    if (catalog.didFallBackToRaw) {
      _normalize = 'raw';
    }
  }

  void _applyQuery() {
    final catalog = _catalog;
    if (catalog == null) {
      return;
    }
    _board = _queryPassProfileUseCase.execute(
      catalog: catalog,
      commonKey: commonKey,
      jobId: jobId,
      passId: _passId,
      masterProfileId: _masterProfileId,
    );
    final board = _board;
    if (board != null) {
      _passId = board.selectedPass?.passId ?? _passId;
      _masterProfileId = board.selectedMasterProfileId;
    }
  }

  @override
  void dispose() {
    _loadVersion++;
    super.dispose();
  }
}
