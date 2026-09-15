import 'package:fluent_ui/fluent_ui.dart';

class AppCoordinator extends ChangeNotifier {
  static const int COLLECTION_PANE_INDEX = 0;
  static const int WORK_HISTORY_PANE_INDEX = 1;
  static const int PASS_PROFILE_PANE_INDEX = 2;
  static const int QUALITY_ISSUE_PANE_INDEX = 3;

  int _selectedPaneIndex = 0;
  String _historyCommonKey = '';
  String _historyId = '';
  String _pendingHistoryEquipmentId = '';
  String _pendingHistoryWorkerId = '';
  bool _isWorkDetailOpen = false;

  int get selectedPaneIndex => _selectedPaneIndex;
  String get historyCommonKey => _historyCommonKey;
  String get historyId => _historyId;
  String get pendingHistoryEquipmentId => _pendingHistoryEquipmentId;
  String get pendingHistoryWorkerId => _pendingHistoryWorkerId;
  bool get isWorkDetailOpen => _isWorkDetailOpen;

  void didSelectPane(int index) {
    if (index == _selectedPaneIndex) {
      if (!_isWorkDetailOpen) {
        return;
      }
      _isWorkDetailOpen = false;
      notifyListeners();
      return;
    }
    _isWorkDetailOpen = false;
    _selectedPaneIndex = index;
    notifyListeners();
  }

  void didTapOpenWorkHistory({
    required String equipmentId,
    String workerId = '',
  }) {
    _pendingHistoryEquipmentId = equipmentId;
    _pendingHistoryWorkerId = workerId;
    _isWorkDetailOpen = false;
    if (_selectedPaneIndex == WORK_HISTORY_PANE_INDEX) {
      notifyListeners();
      return;
    }
    didSelectPane(WORK_HISTORY_PANE_INDEX);
  }

  void didConsumePendingHistoryFilter() {
    if (_pendingHistoryEquipmentId.isEmpty && _pendingHistoryWorkerId.isEmpty) {
      return;
    }
    _pendingHistoryEquipmentId = '';
    _pendingHistoryWorkerId = '';
    notifyListeners();
  }

  void didTapBackToWorkHistory(BuildContext context) {
    _isWorkDetailOpen = false;
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    notifyListeners();
  }

  void didTapLeaveWorkDetailToPassProfile(
    BuildContext context, {
    required String commonKey,
    required String historyId,
  }) {
    _isWorkDetailOpen = false;
    didTapOpenPassProfile(commonKey: commonKey, historyId: historyId);
  }

  void didTapLeaveWorkDetailToQualityIssue(
    BuildContext context, {
    required String commonKey,
    required String historyId,
  }) {
    _isWorkDetailOpen = false;
    didTapOpenQualityIssue(commonKey: commonKey, historyId: historyId);
  }

  void didTapOpenWorkDetail(BuildContext context, {required String historyId}) {
    _historyId = historyId;
    _isWorkDetailOpen = true;
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    notifyListeners();
  }

  void didTapOpenPassProfile({
    required String commonKey,
    required String historyId,
  }) {
    _historyCommonKey = commonKey;
    _historyId = historyId;
    didSelectPane(PASS_PROFILE_PANE_INDEX);
  }

  void didTapOpenQualityIssue({
    required String commonKey,
    required String historyId,
  }) {
    _historyCommonKey = commonKey;
    _historyId = historyId;
    didSelectPane(QUALITY_ISSUE_PANE_INDEX);
  }
}
