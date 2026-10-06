import 'package:flutter/foundation.dart';

import '../../../domain/entities/comparison_job_candidate.dart';
import '../../../domain/entities/pass_waveform_catalog.dart';
import '../../../domain/entities/quality_issue_board.dart';
import '../../../domain/entities/quality_job_media.dart';
import '../../../domain/entities/quality_media.dart';
import '../../../domain/entities/quality_media_tab.dart';
import '../../../domain/entities/quality_result_group.dart';
import '../../../domain/entities/quality_result_report.dart';
import '../../../domain/entities/series_role.dart';
import '../../../domain/entities/waveform_row.dart';
import '../../../domain/entities/weld_pass.dart';
import '../../../domain/use_cases/get_report_set_use_case.dart';
import '../../../domain/use_cases/list_comparison_jobs_use_case.dart';
import '../../../domain/use_cases/list_quality_job_media_use_case.dart';
import '../../../domain/use_cases/list_quality_results_use_case.dart';
import '../../../domain/use_cases/load_comparison_passes_use_case.dart';
import '../../../domain/use_cases/load_pass_waveform_catalog_use_case.dart';
import '../../../domain/use_cases/load_pass_waveform_use_case.dart';
import '../../../domain/use_cases/pair_comparison_pass.dart';
import '../../../domain/use_cases/query_quality_issue_use_case.dart';

class QualityIssueViewModel extends ChangeNotifier {
  QualityIssueViewModel({
    required LoadPassWaveformCatalogUseCase loadPassWaveformCatalogUseCase,
    required LoadPassWaveformUseCase loadPassWaveformUseCase,
    required ListComparisonJobsUseCase listComparisonJobsUseCase,
    required LoadComparisonPassesUseCase loadComparisonPassesUseCase,
    required QueryQualityIssueUseCase queryQualityIssueUseCase,
    required ListQualityResultsUseCase listQualityResultsUseCase,
    required ListQualityJobMediaUseCase listQualityJobMediaUseCase,
    required GetReportSetUseCase getReportSetUseCase,
    required this.commonKey,
    required this.jobId,
    String passId = '',
    String linkId = '',
  }) : _loadPassWaveformCatalogUseCase = loadPassWaveformCatalogUseCase,
       _loadPassWaveformUseCase = loadPassWaveformUseCase,
       _listComparisonJobsUseCase = listComparisonJobsUseCase,
       _loadComparisonPassesUseCase = loadComparisonPassesUseCase,
       _queryQualityIssueUseCase = queryQualityIssueUseCase,
       _listQualityResultsUseCase = listQualityResultsUseCase,
       _listQualityJobMediaUseCase = listQualityJobMediaUseCase,
       _getReportSetUseCase = getReportSetUseCase,
       _passId = passId,
       _linkId = linkId;

  final LoadPassWaveformCatalogUseCase _loadPassWaveformCatalogUseCase;
  final LoadPassWaveformUseCase _loadPassWaveformUseCase;
  final ListComparisonJobsUseCase _listComparisonJobsUseCase;
  final LoadComparisonPassesUseCase _loadComparisonPassesUseCase;
  final QueryQualityIssueUseCase _queryQualityIssueUseCase;
  final ListQualityResultsUseCase _listQualityResultsUseCase;
  final ListQualityJobMediaUseCase _listQualityJobMediaUseCase;
  final GetReportSetUseCase _getReportSetUseCase;
  final String commonKey;
  final String jobId;

  PassWaveformCatalog? _catalog;
  QualityIssueBoard? _board;
  List<QualityResultReport> _qualityReports = const [];
  List<QualityScanPdf> _reportPdfs = const [];
  List<QualityJobMedia> _jobMedia = const [];
  String _selectedJobMediaId = '';
  String _focusedMediaId = '';
  String? _selectedReportSetId;
  int _reportPdfPage = 1;
  bool _didLoadQualityResults = false;
  String _passId;
  String _comparisonJobId = '';
  List<ComparisonJobCandidate> _comparisonJobs = const [];
  List<WeldPass> _comparisonPasses = const [];
  String _comparisonNextPageToken = '';
  String _comparisonError = '';
  bool _isComparisonPageLoading = false;
  String _linkId;
  QualityMediaTab _selectedMediaTab = QualityMediaTab.pdf;
  int _selectedMediaIndex = 0;
  int? _pendingSeekToMs;
  int _seekToken = 0;
  String _normalize = 'raw';
  bool _showMaster = false;
  bool _showBeginner = true;
  bool _showRobot = false;
  bool _isLoading = false;
  bool _isContentLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _contentError = '';
  int _loadVersion = 0;
  int _mediaLoadVersion = 0;

  QualityIssueBoard? get board => _board;
  List<QualityResultReport> get qualityReports => _qualityReports;
  List<QualityScanPdf> get reportPdfs => _reportPdfs;
  List<QualityJobMedia> get jobMedia => _jobMedia;
  String get selectedJobMediaId => _selectedJobMediaId;
  String get focusedMediaId => _focusedMediaId;
  String? get selectedReportSetId => _selectedReportSetId;
  int get reportPdfPage => _reportPdfPage;
  bool get didLoadQualityResults => _didLoadQualityResults;
  String get selectedPassId => _passId;
  String get selectedComparisonJobId => _comparisonJobId;
  List<ComparisonJobCandidate> get comparisonJobs => _comparisonJobs;
  String get comparisonError => _comparisonError;
  String get normalize => _normalize;
  String get waveformNotice => _catalog?.waveformNotice ?? '';
  QualityMediaTab get selectedMediaTab => _selectedMediaTab;
  int get selectedMediaIndex => _selectedMediaIndex;
  int? get pendingSeekToMs => _pendingSeekToMs;
  int get seekToken => _seekToken;
  bool get showMaster => _showMaster;
  bool get showBeginner => _showBeginner;
  bool get showRobot => _showRobot;
  bool get isLoading => _isLoading;
  bool get isContentLoading => _isContentLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  String get contentError => _contentError;
  String get selectedLinkId => _linkId;

  Future<void> loadBoard() {
    return _loadCatalog(isPageLoad: true);
  }

  Future<void> _reloadPassContent() {
    return _loadCatalog(isPageLoad: false);
  }

  Future<void> _loadCatalog({required bool isPageLoad}) async {
    final version = ++_loadVersion;
    if (isPageLoad) {
      _isLoading = true;
      _isContentLoading = false;
      _hasError = false;
      _errorMessage = '';
      _contentError = '';
      _didLoadQualityResults = false;
      _qualityReports = const [];
      _reportPdfs = const [];
      _selectedReportSetId = null;
      _reportPdfPage = 1;
      _jobMedia = const [];
      _selectedJobMediaId = '';
      _focusedMediaId = '';
      _clearComparison();
    } else {
      _isContentLoading = true;
      _contentError = '';
    }
    notifyListeners();
    try {
      if (isPageLoad) {
        _qualityReports = await _listQualityResultsUseCase.execute(
          jobId: jobId,
        );
        _didLoadQualityResults = jobId.isNotEmpty;
        if (version != _loadVersion) {
          return;
        }
        _reportPdfs = await _loadReportPdfs(_qualityReports);
        _selectFirstInspection();
      }
      final catalog = await _loadPassWaveformCatalogUseCase.execute(
        commonKey: commonKey,
        jobId: jobId,
        passId: _passId,
        normalize: _normalize,
      );
      if (version != _loadVersion) {
        return;
      }
      _catalog = catalog;
      _applyLoadedNormalize(catalog);
      if (isPageLoad) {
        _revealTargetSeries(catalog.waveformRows);
      }
      _applyQuery();
      if (isPageLoad) {
        final passId = _passIdForMedia();
        if (_passId.isEmpty && passId.isNotEmpty) {
          _passId = passId;
          _applyQuery();
        }
        await _loadJobMediaForPass(_passId);
        if (version != _loadVersion) {
          return;
        }
        _clearComparison();
        await _loadComparisonJobPage(version: version, pageToken: '');
      }
      final boardPassId = _board?.selectedPass?.passId ?? '';
      final loadedPassId =
          catalog.waveformRows.firstOrNull?.passId ??
          catalog.passes.firstOrNull?.passId ??
          '';
      if (boardPassId.isNotEmpty && boardPassId != loadedPassId) {
        if (isPageLoad) {
          loadBoard();
        } else {
          _reloadPassContent();
        }
      }
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      if (isPageLoad) {
        if (_didLoadQualityResults) {
          _contentError = error.toString();
        } else {
          _hasError = true;
          _errorMessage = error.toString();
          _board = null;
          _qualityReports = const [];
          _reportPdfs = const [];
          _selectedReportSetId = null;
          _clearComparison();
        }
      } else {
        _contentError = error.toString();
        _restoreSelectionFromBoard();
      }
    } finally {
      if (version == _loadVersion) {
        if (isPageLoad) {
          _isLoading = false;
        } else {
          _isContentLoading = false;
        }
        notifyListeners();
      }
    }
  }

  void didSelectInspection({
    required String reportSetId,
    required int? originalPage,
  }) {
    _selectInspection(reportSetId: reportSetId, originalPage: originalPage);
    notifyListeners();
  }

  void _selectFirstInspection() {
    for (final report in _qualityReports) {
      if (report.inspections.isEmpty) {
        continue;
      }
      final inspection = report.inspections.first;
      _selectInspection(
        reportSetId: report.reportSetId,
        originalPage: inspection.pageStart,
      );
      return;
    }
  }

  void _selectInspection({
    required String reportSetId,
    required int? originalPage,
  }) {
    final index = _reportPdfs.indexWhere(
      (pdf) => pdf.reportSetId == reportSetId,
    );
    if (index >= 0) {
      _selectedMediaIndex = index;
    }
    _selectedReportSetId = reportSetId;
    _focusedMediaId = 'report:$reportSetId';
    final setPageStart = index >= 0 ? _reportPdfs[index].setPageStart : null;
    _reportPdfPage = _pageInSplitPdf(originalPage, setPageStart);
    _selectedMediaTab = QualityMediaTab.pdf;
  }

  Future<List<QualityScanPdf>> _loadReportPdfs(
    List<QualityResultReport> reports,
  ) async {
    final pdfs = <QualityScanPdf>[];
    final seen = <String>{};
    for (final report in reports) {
      final reportSetId = report.reportSetId;
      if (reportSetId.isEmpty || !seen.add(reportSetId)) {
        continue;
      }
      try {
        final detail = await _getReportSetUseCase.execute(
          reportSetId: reportSetId,
        );
        pdfs.add(
          QualityScanPdf(
            reportSetId: detail.summary.reportSetId,
            url: detail.pdfUrl,
            setPageStart: detail.summary.pageStart,
          ),
        );
      } catch (_) {
        pdfs.add(
          QualityScanPdf(reportSetId: reportSetId, url: '', setPageStart: null),
        );
      }
    }
    return pdfs;
  }

  int _pageInSplitPdf(int? originalPage, int? setPageStart) {
    if (originalPage == null || setPageStart == null) {
      return 1;
    }
    final page = originalPage - setPageStart + 1;
    return page < 1 ? 1 : page;
  }

  void didSelectFocusedMedia(String focusedMediaId) {
    if (_focusedMediaId == focusedMediaId) {
      return;
    }
    if (focusedMediaId.startsWith('asset:')) {
      didSelectJobMedia(focusedMediaId.substring('asset:'.length));
      return;
    }
    if (!focusedMediaId.startsWith('report:')) {
      return;
    }
    final reportSetId = focusedMediaId.substring('report:'.length);
    if (_selectedReportSetId != reportSetId) {
      _reportPdfPage = 1;
    }
    _focusedMediaId = focusedMediaId;
    _selectedReportSetId = reportSetId;
    _selectedMediaTab = QualityMediaTab.pdf;
    notifyListeners();
  }

  void didSelectJobMedia(String assetId) {
    if (_selectedJobMediaId == assetId) {
      return;
    }
    for (final item in _jobMedia) {
      if (item.assetId == assetId) {
        _selectedJobMediaId = assetId;
        _focusedMediaId = 'asset:$assetId';
        notifyListeners();
        return;
      }
    }
  }

  void didSelectPass(String passId) {
    if (_passId == passId) {
      return;
    }
    _passId = passId;
    _linkId = '';
    _loadJobMediaForPass(passId);
    if (_comparisonPasses.isNotEmpty) {
      _reloadComparisonWaveform();
      return;
    }
    _reloadPassContent();
  }

  Future<void> didSelectComparisonJob(String comparisonJobId) async {
    if (_comparisonJobId == comparisonJobId) {
      return;
    }
    _comparisonJobId = comparisonJobId;
    _comparisonError = '';
    if (comparisonJobId.isEmpty) {
      _comparisonPasses = const [];
      await _reloadComparisonWaveform();
      return;
    }
    final version = ++_loadVersion;
    _isContentLoading = true;
    notifyListeners();
    try {
      final passes = await _loadComparisonPassesUseCase.execute(
        jobId: comparisonJobId,
      );
      if (version != _loadVersion) {
        return;
      }
      _comparisonPasses = passes;
      _showMaster = true;
    } catch (_) {
      if (version != _loadVersion) {
        return;
      }
      _comparisonPasses = const [];
      _comparisonError = '비교 작업을 불러오지 못했습니다.';
      await _reloadComparisonWaveformAt(version);
      return;
    }
    await _reloadComparisonWaveformAt(version);
  }

  void didSelectNormalize(String normalize) {
    if (_normalize == normalize) {
      return;
    }
    _normalize = normalize;
    _reloadComparisonWaveform();
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

  void didSelectLink(String linkId) {
    if (_linkId == linkId) {
      return;
    }
    _linkId = linkId;
    final previousPassId = _passId;
    final catalog = _catalog;
    if (catalog != null) {
      for (final link in catalog.links) {
        if (link.linkId == linkId) {
          _passId = link.passId;
          break;
        }
      }
    }
    if (_passId != previousPassId) {
      _loadJobMediaForPass(_passId);
      if (_comparisonPasses.isNotEmpty) {
        _reloadComparisonWaveform();
      } else {
        _reloadPassContent();
      }
    } else {
      _applyQuery();
      notifyListeners();
    }
  }

  void didTapBand(String linkId) {
    if (_linkId == linkId) {
      return;
    }
    _linkId = linkId;
    _applyQuery();
    notifyListeners();
  }

  void didTapWaveformTime(int timeMs) {
    final clamped = timeMs < 0 ? 0 : timeMs;
    _pendingSeekToMs = clamped;
    final group = _board?.selectedGroup;
    if (_isMediaTabAvailable(QualityMediaTab.video, group)) {
      _selectedMediaTab = QualityMediaTab.video;
      _seekToken++;
    }
    notifyListeners();
  }

  void didSelectMediaTab(QualityMediaTab tab) {
    if (_selectedMediaTab == tab) {
      return;
    }
    final group = _board?.selectedGroup;
    if (!_isMediaTabAvailable(tab, group)) {
      return;
    }
    _selectedMediaTab = tab;
    _selectedMediaIndex = 0;
    notifyListeners();
  }

  void didSelectMediaIndex(int index) {
    final files =
        _board?.selectedGroup?.media
            .where((item) => item.type == _selectedMediaTab)
            .toList() ??
        const <QualityMedia>[];
    if (index < 0 || index >= files.length || _selectedMediaIndex == index) {
      return;
    }
    _selectedMediaIndex = index;
    notifyListeners();
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

  Future<void> _reloadComparisonWaveform() async {
    final version = ++_loadVersion;
    await _reloadComparisonWaveformAt(version);
  }

  Future<void> _reloadComparisonWaveformAt(int version) async {
    final catalog = _catalog;
    if (catalog == null) {
      if (version == _loadVersion) {
        _isContentLoading = false;
        notifyListeners();
      }
      return;
    }
    _isContentLoading = true;
    _contentError = '';
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
      _contentError = error.toString();
      _restoreSelectionFromBoard();
    } finally {
      if (version == _loadVersion) {
        _isContentLoading = false;
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

  void _applyLoadedNormalize(PassWaveformCatalog catalog) {
    if (catalog.didFallBackToRaw) {
      _normalize = 'raw';
    }
  }

  String _passIdForMedia() {
    if (_passId.isNotEmpty) {
      return _passId;
    }
    WeldPass? first;
    for (final pass in _catalog?.passes ?? const <WeldPass>[]) {
      if (pass.passId.isEmpty) {
        continue;
      }
      if (first == null || pass.passNo < first.passNo) {
        first = pass;
      }
    }
    return first?.passId ?? '';
  }

  Future<void> _loadJobMediaForPass(String passId) async {
    final version = ++_mediaLoadVersion;
    _jobMedia = const [];
    _selectedJobMediaId = '';
    if (_focusedMediaId.startsWith('asset:')) {
      _focusedMediaId = '';
    }
    if (passId.isEmpty) {
      notifyListeners();
      return;
    }
    try {
      final media = await _listQualityJobMediaUseCase.execute(
        jobId: jobId,
        passId: passId,
      );
      if (version != _mediaLoadVersion) {
        return;
      }
      _jobMedia = media;
      _syncJobMediaSelection();
    } catch (_) {
      if (version != _mediaLoadVersion) {
        return;
      }
      _jobMedia = const [];
      _selectedJobMediaId = '';
      if (_focusedMediaId.startsWith('asset:')) {
        _focusedMediaId = '';
      }
    }
    notifyListeners();
  }

  void _syncJobMediaSelection() {
    if (_focusedMediaId.startsWith('report:')) {
      final reportSetId = _focusedMediaId.substring('report:'.length);
      for (final pdf in _reportPdfs) {
        if (pdf.reportSetId == reportSetId) {
          return;
        }
      }
    }
    if (_focusedMediaId.startsWith('asset:')) {
      final assetId = _focusedMediaId.substring('asset:'.length);
      for (final item in _jobMedia) {
        if (item.assetId == assetId) {
          _selectedJobMediaId = assetId;
          return;
        }
      }
    }
    if (_reportPdfs.isNotEmpty) {
      final reportSetId = _selectedReportSetId ?? _reportPdfs.first.reportSetId;
      _focusedMediaId = 'report:$reportSetId';
      _selectedJobMediaId = '';
      return;
    }
    final visible = _jobMedia;
    for (final item in visible) {
      if (item.assetId == _selectedJobMediaId) {
        _focusedMediaId = 'asset:${item.assetId}';
        return;
      }
    }
    QualityJobMedia? firstPdf;
    QualityJobMedia? firstVideo;
    for (final item in visible) {
      if (!item.isVideo && firstPdf == null) {
        firstPdf = item;
      } else if (item.isVideo && firstVideo == null) {
        firstVideo = item;
      }
    }
    _selectedJobMediaId = (firstPdf ?? firstVideo)?.assetId ?? '';
    _focusedMediaId = _selectedJobMediaId.isEmpty
        ? ''
        : 'asset:$_selectedJobMediaId';
  }

  void _revealTargetSeries(List<WaveformRow> rows) {
    for (final row in rows) {
      switch (row.seriesRole) {
        case SeriesRole.master:
          _showMaster = true;
        case SeriesRole.beginner:
          _showBeginner = true;
        case SeriesRole.robot:
          _showRobot = true;
      }
    }
  }

  void _clearComparison() {
    _comparisonJobId = '';
    _comparisonJobs = const [];
    _comparisonPasses = const [];
    _comparisonNextPageToken = '';
    _comparisonError = '';
  }

  void _restoreSelectionFromBoard() {
    final board = _board;
    if (board == null) {
      return;
    }
    _passId =
        board.selectedPass?.passId ?? board.selectedGroup?.passId ?? _passId;
    _linkId = board.selectedLink?.linkId ?? _linkId;
  }

  void _applyQuery() {
    final catalog = _catalog;
    if (catalog == null) {
      return;
    }
    final previousGroupId = _board?.selectedGroup?.qualityResultId;
    _board = _queryQualityIssueUseCase.execute(
      catalog: catalog,
      commonKey: commonKey,
      jobId: jobId,
      passId: _passId,
      linkId: _linkId,
    );
    final board = _board;
    if (board != null) {
      if (board.selectedGroup?.qualityResultId != previousGroupId) {
        _selectedMediaIndex = 0;
      }
      _passId =
          board.selectedPass?.passId ?? board.selectedGroup?.passId ?? _passId;
      _linkId = board.selectedLink?.linkId ?? _linkId;
      final tab = _resolveMediaTab(
        preferred: _selectedMediaTab,
        group: board.selectedGroup,
      );
      if (tab != _selectedMediaTab) {
        _selectedMediaIndex = 0;
      }
      _selectedMediaTab = tab;
      _syncJobMediaSelection();
      final fileCount =
          board.selectedGroup?.media.where((item) => item.type == tab).length ??
          0;
      if (_selectedMediaIndex >= fileCount) {
        _selectedMediaIndex = 0;
      }
    }
  }

  QualityMediaTab _resolveMediaTab({
    required QualityMediaTab preferred,
    required QualityResultGroup? group,
  }) {
    if (_isMediaTabAvailable(preferred, group)) {
      return preferred;
    }
    if (_isMediaTabAvailable(QualityMediaTab.pdf, group)) {
      return QualityMediaTab.pdf;
    }
    if (_isMediaTabAvailable(QualityMediaTab.video, group)) {
      return QualityMediaTab.video;
    }
    return QualityMediaTab.pdf;
  }

  bool _isMediaTabAvailable(QualityMediaTab tab, QualityResultGroup? group) =>
      group?.media.any((item) => item.type == tab) ?? false;

  @override
  void dispose() {
    _loadVersion++;
    _mediaLoadVersion++;
    super.dispose();
  }
}
