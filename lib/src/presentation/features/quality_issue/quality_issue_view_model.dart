import 'package:flutter/foundation.dart';

import '../../../domain/entities/pass_waveform_catalog.dart';
import '../../../domain/entities/quality_issue_board.dart';
import '../../../domain/entities/quality_media.dart';
import '../../../domain/entities/quality_media_tab.dart';
import '../../../domain/entities/quality_result_group.dart';
import '../../../domain/use_cases/load_pass_waveform_catalog_use_case.dart';
import '../../../domain/use_cases/query_quality_issue_use_case.dart';

class QualityIssueViewModel extends ChangeNotifier {
  QualityIssueViewModel({
    required LoadPassWaveformCatalogUseCase loadPassWaveformCatalogUseCase,
    required QueryQualityIssueUseCase queryQualityIssueUseCase,
    required this.commonKey,
    required this.historyId,
    String passId = '',
    String linkId = '',
  }) : _loadPassWaveformCatalogUseCase = loadPassWaveformCatalogUseCase,
       _queryQualityIssueUseCase = queryQualityIssueUseCase,
       _passId = passId,
       _linkId = linkId;

  final LoadPassWaveformCatalogUseCase _loadPassWaveformCatalogUseCase;
  final QueryQualityIssueUseCase _queryQualityIssueUseCase;
  final String commonKey;
  final String historyId;

  PassWaveformCatalog? _catalog;
  QualityIssueBoard? _board;
  String _passId;
  String _linkId;
  QualityMediaTab _selectedMediaTab = QualityMediaTab.pdf;
  int _selectedMediaIndex = 0;
  int? _pendingSeekToMs;
  int _seekToken = 0;
  bool _showMaster = false;
  bool _showBeginner = true;
  bool _showRobot = false;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;

  QualityIssueBoard? get board => _board;
  QualityMediaTab get selectedMediaTab => _selectedMediaTab;
  int get selectedMediaIndex => _selectedMediaIndex;
  int? get pendingSeekToMs => _pendingSeekToMs;
  int get seekToken => _seekToken;
  bool get showMaster => _showMaster;
  bool get showBeginner => _showBeginner;
  bool get showRobot => _showRobot;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  String get selectedLinkId => _linkId;

  Future<void> loadBoard() async {
    final version = ++_loadVersion;
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      final catalog = await _loadPassWaveformCatalogUseCase.execute(
        commonKey: commonKey,
        historyId: historyId,
        passId: _passId,
      );
      if (version != _loadVersion) return;
      _catalog = catalog;
      _applyQuery();
      final selectedPassId = _board?.selectedPass?.passId ?? '';
      final loadedPassId =
          catalog.waveformRows.firstOrNull?.passId ??
          catalog.passes.firstOrNull?.passId ??
          '';
      if (selectedPassId.isNotEmpty && selectedPassId != loadedPassId) {
        loadBoard();
      }
    } catch (error) {
      if (version != _loadVersion) return;
      _hasError = true;
      _errorMessage = error.toString();
      _board = null;
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
    _linkId = '';
    loadBoard();
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
      loadBoard();
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
            .where(
              (item) => item.type == _selectedMediaTab,
            )
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

  void _applyQuery() {
    final catalog = _catalog;
    if (catalog == null) {
      return;
    }
    final previousGroupId = _board?.selectedGroup?.qualityResultId;
    _board = _queryQualityIssueUseCase.execute(
      catalog: catalog,
      commonKey: commonKey,
      historyId: historyId,
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
      final fileCount =
          board.selectedGroup?.media
              .where((item) => item.type == tab)
              .length ??
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
      group?.media.any((item) => item.type == tab) ??
      false;

  @override
  void dispose() {
    _loadVersion++;
    super.dispose();
  }
}
