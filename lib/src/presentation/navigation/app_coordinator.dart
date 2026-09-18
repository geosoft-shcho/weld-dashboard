import 'package:fluent_ui/fluent_ui.dart';

enum WorkHistoryStack {
  list,
  detail,
  passProfile,
  qualityIssue,
}

class AppCoordinator extends ChangeNotifier {
  static const int COLLECTION_PANE_INDEX = 0;
  static const int WORK_HISTORY_PANE_INDEX = 1;

  int _selectedPaneIndex = 0;
  WorkHistoryStack _workHistoryStack = WorkHistoryStack.list;
  final List<WorkHistoryStack> _stackHistory = [];
  String _historyCommonKey = '';
  String _historyId = '';
  String _passId = '';
  String _linkId = '';
  String _pendingHistoryEquipmentId = '';
  String _pendingHistoryWorkerId = '';

  int get selectedPaneIndex => _selectedPaneIndex;
  WorkHistoryStack get workHistoryStack => _workHistoryStack;
  String get historyCommonKey => _historyCommonKey;
  String get historyId => _historyId;
  String get passId => _passId;
  String get linkId => _linkId;
  String get pendingHistoryEquipmentId => _pendingHistoryEquipmentId;
  String get pendingHistoryWorkerId => _pendingHistoryWorkerId;
  bool get canPopWorkHistoryStack => _stackHistory.isNotEmpty;
  WorkHistoryStack? get previousWorkHistoryStack =>
      _stackHistory.isEmpty ? null : _stackHistory.last;

  void didSelectPane(int index) {
    if (index == _selectedPaneIndex) {
      if (_selectedPaneIndex == WORK_HISTORY_PANE_INDEX &&
          _workHistoryStack != WorkHistoryStack.list) {
        _resetWorkHistoryToList();
        notifyListeners();
      }
      return;
    }
    _selectedPaneIndex = index;
    if (index != WORK_HISTORY_PANE_INDEX) {
      _resetWorkHistoryToList();
    }
    notifyListeners();
  }

  void didTapOpenWorkHistory({
    required String equipmentId,
    String workerId = '',
  }) {
    _pendingHistoryEquipmentId = equipmentId;
    _pendingHistoryWorkerId = workerId;
    _resetWorkHistoryToList();
    if (_selectedPaneIndex == WORK_HISTORY_PANE_INDEX) {
      notifyListeners();
      return;
    }
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    notifyListeners();
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
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    _resetWorkHistoryToList();
    notifyListeners();
  }

  void didTapBackFromPassProfile(BuildContext context) {
    _popWorkHistoryStack();
    notifyListeners();
  }

  void didTapBackFromQualityIssue(BuildContext context) {
    _popWorkHistoryStack();
    notifyListeners();
  }

  void didTapLeaveWorkDetailToPassProfile(
    BuildContext context, {
    required String commonKey,
    required String historyId,
  }) {
    didTapOpenPassProfile(commonKey: commonKey, historyId: historyId);
  }

  void didTapLeaveWorkDetailToQualityIssue(
    BuildContext context, {
    required String commonKey,
    required String historyId,
  }) {
    didTapOpenQualityIssue(commonKey: commonKey, historyId: historyId);
  }

  void didTapOpenWorkDetail(BuildContext context, {required String historyId}) {
    _historyId = historyId;
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    _pushWorkHistoryStack(WorkHistoryStack.detail);
    notifyListeners();
  }

  void didTapOpenPassProfile({
    required String commonKey,
    String historyId = '',
    String? passId,
    String? linkId,
  }) {
    if (commonKey.isEmpty) {
      return;
    }
    _historyCommonKey = commonKey;
    if (historyId.isNotEmpty) {
      _historyId = historyId;
    }
    _passId = passId ?? '';
    _linkId = linkId ?? '';
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    if (_workHistoryStack == WorkHistoryStack.passProfile) {
      notifyListeners();
      return;
    }
    if (_workHistoryStack == WorkHistoryStack.qualityIssue &&
        previousWorkHistoryStack == WorkHistoryStack.passProfile) {
      _popWorkHistoryStack();
      notifyListeners();
      return;
    }
    _pushWorkHistoryStack(WorkHistoryStack.passProfile);
    notifyListeners();
  }

  void didTapOpenQualityIssue({
    required String commonKey,
    String historyId = '',
    String? passId,
    String? linkId,
  }) {
    if (commonKey.isEmpty) {
      return;
    }
    _historyCommonKey = commonKey;
    if (historyId.isNotEmpty) {
      _historyId = historyId;
    }
    _passId = passId ?? '';
    _linkId = linkId ?? '';
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    if (_workHistoryStack == WorkHistoryStack.qualityIssue) {
      notifyListeners();
      return;
    }
    _pushWorkHistoryStack(WorkHistoryStack.qualityIssue);
    notifyListeners();
  }

  void _pushWorkHistoryStack(WorkHistoryStack next) {
    if (_workHistoryStack == next) {
      return;
    }
    _stackHistory.add(_workHistoryStack);
    _workHistoryStack = next;
  }

  void _popWorkHistoryStack() {
    if (_stackHistory.isEmpty) {
      _resetWorkHistoryToList();
      return;
    }
    _workHistoryStack = _stackHistory.removeLast();
    if (_workHistoryStack == WorkHistoryStack.list) {
      _clearDrilldownKeys();
    }
  }

  void _resetWorkHistoryToList() {
    _workHistoryStack = WorkHistoryStack.list;
    _stackHistory.clear();
    _clearDrilldownKeys();
  }

  void _clearDrilldownKeys() {
    _historyCommonKey = '';
    _passId = '';
    _linkId = '';
  }
}
