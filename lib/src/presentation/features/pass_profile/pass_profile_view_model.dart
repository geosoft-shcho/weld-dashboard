import 'package:flutter/foundation.dart';

import '../../../domain/entities/pass_profile_board.dart';
import '../../../domain/entities/pass_waveform_catalog.dart';
import '../../../domain/use_cases/load_pass_waveform_catalog_use_case.dart';
import '../../../domain/use_cases/query_pass_profile_use_case.dart';

class PassProfileViewModel extends ChangeNotifier {
  PassProfileViewModel({
    required LoadPassWaveformCatalogUseCase loadPassWaveformCatalogUseCase,
    required QueryPassProfileUseCase queryPassProfileUseCase,
    required this.commonKey,
    required this.historyId,
    String passId = '',
  }) : _loadPassWaveformCatalogUseCase = loadPassWaveformCatalogUseCase,
       _queryPassProfileUseCase = queryPassProfileUseCase,
       _passId = passId;

  final LoadPassWaveformCatalogUseCase _loadPassWaveformCatalogUseCase;
  final QueryPassProfileUseCase _queryPassProfileUseCase;
  final String commonKey;
  final String historyId;

  PassWaveformCatalog? _catalog;
  PassProfileBoard? _board;
  String _passId;
  String _masterProfileId = '';
  bool _showMaster = true;
  bool _showBeginner = true;
  bool _showRobot = true;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  PassProfileBoard? get board => _board;
  bool get showMaster => _showMaster;
  bool get showBeginner => _showBeginner;
  bool get showRobot => _showRobot;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

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
    _masterProfileId = '';
    _applyQuery();
    notifyListeners();
  }

  void didSelectMasterProfile(String masterProfileId) {
    if (_masterProfileId == masterProfileId) {
      return;
    }
    _masterProfileId = masterProfileId;
    _applyQuery();
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
    _board = _queryPassProfileUseCase.execute(
      catalog: catalog,
      commonKey: commonKey,
      historyId: historyId,
      passId: _passId,
      masterProfileId: _masterProfileId,
    );
    final board = _board;
    if (board != null) {
      _passId = board.selectedPass?.passId ?? _passId;
      _masterProfileId = board.selectedMasterProfileId;
    }
  }
}
