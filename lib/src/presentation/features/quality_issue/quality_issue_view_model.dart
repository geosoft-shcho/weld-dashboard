import 'package:flutter/foundation.dart';

import '../../../domain/entities/pass_waveform_catalog.dart';
import '../../../domain/entities/quality_issue_board.dart';
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
  bool _showMaster = false;
  bool _showBeginner = true;
  bool _showRobot = false;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  QualityIssueBoard? get board => _board;
  QualityMediaTab get selectedMediaTab => _selectedMediaTab;
  bool get showMaster => _showMaster;
  bool get showBeginner => _showBeginner;
  bool get showRobot => _showRobot;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  String get selectedLinkId => _linkId;

  Future<void> loadBoard() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      _catalog = await _loadPassWaveformCatalogUseCase.execute();
      _applyQuery();
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _board = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void didSelectPass(String passId) {
    if (_passId == passId) {
      return;
    }
    _passId = passId;
    _linkId = '';
    _applyQuery();
    notifyListeners();
  }

  void didSelectLink(String linkId) {
    if (_linkId == linkId) {
      return;
    }
    _linkId = linkId;
    final catalog = _catalog;
    if (catalog != null) {
      for (final link in catalog.links) {
        if (link.linkId == linkId) {
          _passId = link.passId;
          break;
        }
      }
    }
    _applyQuery();
    notifyListeners();
  }

  void didTapBand(String linkId) {
    if (_linkId == linkId) {
      return;
    }
    _linkId = linkId;
    _applyQuery();
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
    _board = _queryQualityIssueUseCase.execute(
      catalog: catalog,
      commonKey: commonKey,
      historyId: historyId,
      passId: _passId,
      linkId: _linkId,
    );
    final board = _board;
    if (board != null) {
      _passId = board.selectedPass?.passId ??
          board.selectedGroup?.passId ??
          _passId;
      _linkId = board.selectedLink?.linkId ?? _linkId;
      _selectedMediaTab = _resolveMediaTab(
        preferred: _selectedMediaTab,
        group: board.selectedGroup,
      );
    }
  }

  QualityMediaTab _resolveMediaTab({
    required QualityMediaTab preferred,
    required QualityResultGroup? group,
  }) {
    if (_isMediaTabAvailable(preferred, group)) {
      return preferred;
    }
    if (group?.doesHaveScanFile == true) {
      return QualityMediaTab.pdf;
    }
    if (group?.doesHaveVideoFile == true) {
      return QualityMediaTab.video;
    }
    return QualityMediaTab.pdf;
  }

  bool _isMediaTabAvailable(QualityMediaTab tab, QualityResultGroup? group) {
    switch (tab) {
      case QualityMediaTab.pdf:
        return group?.doesHaveScanFile == true;
      case QualityMediaTab.video:
        return group?.doesHaveVideoFile == true;
    }
  }
}
