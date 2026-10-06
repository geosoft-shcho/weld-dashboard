import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/report_set.dart';
import '../../../domain/entities/work_attachment.dart';
import '../../../domain/entities/work_attachment_type.dart';
import '../../../domain/entities/work_detail.dart';
import '../../../domain/entities/work_detail_catalog.dart';
import '../../../domain/entities/work_detail_tab.dart';
import '../../../domain/use_cases/get_report_set_use_case.dart';
import '../../../domain/use_cases/list_report_sets_use_case.dart';
import '../../../domain/use_cases/load_work_detail_catalog_use_case.dart';
import '../../../domain/use_cases/query_work_detail_use_case.dart';

class WorkDetailViewModel extends ChangeNotifier {
  WorkDetailViewModel({
    required LoadWorkDetailCatalogUseCase loadWorkDetailCatalogUseCase,
    required QueryWorkDetailUseCase queryWorkDetailUseCase,
    required ListReportSetsUseCase listReportSetsUseCase,
    required GetReportSetUseCase getReportSetUseCase,
    required this.jobId,
  }) : _loadWorkDetailCatalogUseCase = loadWorkDetailCatalogUseCase,
       _queryWorkDetailUseCase = queryWorkDetailUseCase,
       _listReportSetsUseCase = listReportSetsUseCase,
       _getReportSetUseCase = getReportSetUseCase;

  static const int VIDEO_DURATION_SECONDS = 12;
  static const int AUDIO_DURATION_SECONDS = 41;
  static const int PDF_PAGE_COUNT = 3;

  final LoadWorkDetailCatalogUseCase _loadWorkDetailCatalogUseCase;
  final QueryWorkDetailUseCase _queryWorkDetailUseCase;
  final ListReportSetsUseCase _listReportSetsUseCase;
  final GetReportSetUseCase _getReportSetUseCase;
  final String jobId;

  WorkDetailCatalog? _catalog;
  WorkDetail? _detail;
  WorkDetailTab _selectedTab = WorkDetailTab.overview;
  int _selectedFileIndex = 0;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<ReportSetSummary> _reportSets = const [];
  ReportSetDetail? _reportDetail;
  String _selectedReportSetId = '';
  int? _reportPdfPage;
  String _reportError = '';
  String _reportDetailError = '';
  bool _isReportDetailLoading = false;
  bool _isPlaying = false;
  double _positionSeconds = 0;
  int _pdfPageNumber = 1;
  double _pdfScale = 1;
  Timer? _ticker;

  WorkDetail? get detail => _detail;
  WorkDetailTab get selectedTab => _selectedTab;
  int get selectedFileIndex => _selectedFileIndex;
  List<ReportSetSummary> get reportSets => _reportSets;
  ReportSetDetail? get reportDetail => _reportDetail;
  String get selectedReportSetId => _selectedReportSetId;
  int? get reportPdfPage => _reportPdfPage;
  String get reportError => _reportError;
  String get reportDetailError => _reportDetailError;
  bool get isReportDetailLoading => _isReportDetailLoading;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get isPlaying => _isPlaying;
  double get positionSeconds => _positionSeconds;
  int get pdfPageNumber => _pdfPageNumber;
  double get pdfScale => _pdfScale;

  int get mediaDurationSeconds {
    if (_selectedTab == WorkDetailTab.video) {
      return VIDEO_DURATION_SECONDS;
    }
    if (_selectedTab == WorkDetailTab.audio) {
      return AUDIO_DURATION_SECONDS;
    }
    return 0;
  }

  List<WorkAttachment> get visibleAttachments {
    final detail = _detail;
    if (detail == null) {
      return const [];
    }
    final type = _selectedTab.attachmentType;
    if (type == null) {
      return detail.attachments;
    }
    return detail.attachmentsOf(type);
  }

  WorkAttachment? get selectedAttachment {
    final files = visibleAttachments;
    if (files.isEmpty) {
      return null;
    }
    final index = _selectedFileIndex.clamp(0, files.length - 1);
    return files[index];
  }

  Future<void> loadDetail() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _reportSets = const [];
    _reportDetail = null;
    _selectedReportSetId = '';
    _reportPdfPage = null;
    _reportError = '';
    _reportDetailError = '';
    notifyListeners();
    try {
      _catalog = await _loadWorkDetailCatalogUseCase.execute(jobId: jobId);
      _applyQuery();
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _detail = null;
      _isLoading = false;
      notifyListeners();
      return;
    }
    try {
      _reportSets = await _listReportSetsUseCase.execute(jobId: jobId);
    } catch (error) {
      _reportError = error.toString();
      _reportSets = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> didSelectReportSet(String reportSetId) async {
    if (reportSetId.isEmpty) {
      return;
    }
    _selectedReportSetId = reportSetId;
    _reportDetail = null;
    _reportPdfPage = null;
    _reportDetailError = '';
    _isReportDetailLoading = true;
    notifyListeners();
    try {
      final detail = await _getReportSetUseCase.execute(
        reportSetId: reportSetId,
      );
      if (_selectedReportSetId != reportSetId) {
        return;
      }
      _reportDetail = detail;
      _reportPdfPage = detail.sections.isEmpty
          ? null
          : detail.sections.first.splitPageStart;
    } catch (error) {
      if (_selectedReportSetId != reportSetId) {
        return;
      }
      _reportDetailError = error.toString();
    } finally {
      if (_selectedReportSetId == reportSetId) {
        _isReportDetailLoading = false;
        notifyListeners();
      }
    }
  }

  void didSelectReportSection(int? splitPageStart) {
    _reportPdfPage = splitPageStart;
    notifyListeners();
  }

  void didSelectTab(WorkDetailTab tab) {
    if (_selectedTab == tab) {
      return;
    }
    _stopPlayback();
    _selectedTab = tab;
    _selectedFileIndex = 0;
    _positionSeconds = 0;
    _pdfPageNumber = 1;
    _pdfScale = 1;
    notifyListeners();
  }

  void didSelectFileIndex(int index) {
    final files = visibleAttachments;
    if (files.isEmpty) {
      return;
    }
    final nextIndex = index.clamp(0, files.length - 1);
    if (nextIndex == _selectedFileIndex) {
      return;
    }
    _stopPlayback();
    _selectedFileIndex = nextIndex;
    _positionSeconds = 0;
    _pdfPageNumber = 1;
    _pdfScale = 1;
    notifyListeners();
  }

  void didTapJumpToAttachment(WorkAttachment attachment) {
    _stopPlayback();
    _selectedTab = _tabFor(attachment.fileType);
    final files = visibleAttachments;
    var index = 0;
    for (var i = 0; i < files.length; i++) {
      if (files[i].attachmentId == attachment.attachmentId) {
        index = i;
        break;
      }
    }
    _selectedFileIndex = index;
    _positionSeconds = 0;
    _pdfPageNumber = 1;
    _pdfScale = 1;
    notifyListeners();
  }

  void didTapPlayPause() {
    if (mediaDurationSeconds <= 0) {
      return;
    }
    if (_isPlaying) {
      _stopPlayback();
      notifyListeners();
      return;
    }
    _isPlaying = true;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _positionSeconds += 0.1;
      if (_positionSeconds >= mediaDurationSeconds) {
        _positionSeconds = mediaDurationSeconds.toDouble();
        _stopPlayback();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void didSeek(double seconds) {
    final duration = mediaDurationSeconds.toDouble();
    if (duration <= 0) {
      return;
    }
    _positionSeconds = seconds.clamp(0, duration);
    notifyListeners();
  }

  void didTapWaveform(double ratio) {
    didSeek(mediaDurationSeconds * ratio);
  }

  void didTapPdfPrevious() {
    if (_pdfPageNumber <= 1) {
      return;
    }
    _pdfPageNumber -= 1;
    notifyListeners();
  }

  void didTapPdfNext() {
    if (_pdfPageNumber >= PDF_PAGE_COUNT) {
      return;
    }
    _pdfPageNumber += 1;
    notifyListeners();
  }

  void didTapPdfZoomOut() {
    _pdfScale = (_pdfScale - 0.25).clamp(0.5, 3);
    notifyListeners();
  }

  void didTapPdfZoomIn() {
    _pdfScale = (_pdfScale + 0.25).clamp(0.5, 3);
    notifyListeners();
  }

  void didTapReload() {
    loadDetail();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _applyQuery() {
    final catalog = _catalog;
    if (catalog == null) {
      return;
    }
    _detail = _queryWorkDetailUseCase.execute(catalog: catalog, jobId: jobId);
  }

  void _stopPlayback() {
    _isPlaying = false;
    _ticker?.cancel();
    _ticker = null;
  }

  WorkDetailTab _tabFor(WorkAttachmentType type) {
    switch (type) {
      case WorkAttachmentType.image:
        return WorkDetailTab.image;
      case WorkAttachmentType.video:
        return WorkDetailTab.video;
      case WorkAttachmentType.pdf:
        return WorkDetailTab.pdf;
      case WorkAttachmentType.audio:
        return WorkDetailTab.audio;
      case WorkAttachmentType.text:
        return WorkDetailTab.text;
    }
  }
}
