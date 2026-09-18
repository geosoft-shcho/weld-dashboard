import 'package:fluent_ui/fluent_ui.dart';

import '../../domain/entities/latest_pass_profile_target.dart';
import '../../domain/entities/latest_quality_issue_target.dart';

enum WorkHistoryStack {
  list,
  detail,
  passProfile,
  qualityIssue,
}

class AppCoordinator extends ChangeNotifier {
  static const int COLLECTION_PANE_INDEX = 0;
  static const int WORK_HISTORY_PANE_INDEX = 1;
  static const int PASS_PROFILE_PANE_INDEX = 2;
  static const int QUALITY_ISSUE_PANE_INDEX = 3;

  int _selectedPaneIndex = 0;
  WorkHistoryStack _workHistoryStack = WorkHistoryStack.list;
  final List<WorkHistoryStack> _stackHistory = [];
  String _historyCommonKey = '';
  String _historyId = '';
  String _passId = '';
  String _linkId = '';
  String _pendingHistoryEquipmentId = '';
  String _pendingHistoryWorkerId = '';

  LatestPassProfileTarget? _latestPassProfile;
  LatestQualityIssueTarget? _latestQualityIssue;

  String _panePassCommonKey = '';
  String _panePassHistoryId = '';
  String _panePassPassId = '';
  String _paneQualityCommonKey = '';
  String _paneQualityHistoryId = '';
  String _paneQualityPassId = '';
  String _paneQualityLinkId = '';

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

  LatestPassProfileTarget? get latestPassProfile => _latestPassProfile;
  LatestQualityIssueTarget? get latestQualityIssue => _latestQualityIssue;
  bool get canOpenLatestPassProfile => _latestPassProfile != null;
  bool get canOpenLatestQualityIssue => _latestQualityIssue != null;

  String get panePassCommonKey => _panePassCommonKey;
  String get panePassHistoryId => _panePassHistoryId;
  String get panePassPassId => _panePassPassId;
  String get paneQualityCommonKey => _paneQualityCommonKey;
  String get paneQualityHistoryId => _paneQualityHistoryId;
  String get paneQualityPassId => _paneQualityPassId;
  String get paneQualityLinkId => _paneQualityLinkId;

  bool get isPassProfilePaneSelected =>
      _selectedPaneIndex == PASS_PROFILE_PANE_INDEX;
  bool get isQualityIssuePaneSelected =>
      _selectedPaneIndex == QUALITY_ISSUE_PANE_INDEX;

  void didApplyLatestPaneCandidates({
    LatestPassProfileTarget? passProfile,
    LatestQualityIssueTarget? qualityIssue,
  }) {
    _latestPassProfile = passProfile;
    _latestQualityIssue = qualityIssue;
    if (passProfile != null && _panePassCommonKey.isEmpty) {
      _applyLatestPassProfileKeys();
    }
    if (qualityIssue != null && _paneQualityCommonKey.isEmpty) {
      _applyLatestQualityIssueKeys();
    }
    if (passProfile == null) {
      _clearPanePassKeys();
    }
    if (qualityIssue == null) {
      _clearPaneQualityKeys();
    }
    if (_selectedPaneIndex == PASS_PROFILE_PANE_INDEX && passProfile == null) {
      _selectedPaneIndex = COLLECTION_PANE_INDEX;
    }
    if (_selectedPaneIndex == QUALITY_ISSUE_PANE_INDEX &&
        qualityIssue == null) {
      _selectedPaneIndex = COLLECTION_PANE_INDEX;
    }
    notifyListeners();
  }

  void didSelectPane(int index) {
    if (index == PASS_PROFILE_PANE_INDEX && !canOpenLatestPassProfile) {
      return;
    }
    if (index == QUALITY_ISSUE_PANE_INDEX && !canOpenLatestQualityIssue) {
      return;
    }
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
    if (index == PASS_PROFILE_PANE_INDEX) {
      _applyLatestPassProfileKeys();
    }
    if (index == QUALITY_ISSUE_PANE_INDEX) {
      _applyLatestQualityIssueKeys();
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
    if (isPassProfilePaneSelected) {
      didTapBackToWorkHistory(context);
      return;
    }
    _popWorkHistoryStack();
    notifyListeners();
  }

  void didTapBackFromQualityIssue(BuildContext context) {
    if (isQualityIssuePaneSelected) {
      didTapBackToWorkHistory(context);
      return;
    }
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

  void didTapOpenLatestPassProfile() {
    if (!canOpenLatestPassProfile) {
      return;
    }
    _applyLatestPassProfileKeys();
    _selectedPaneIndex = PASS_PROFILE_PANE_INDEX;
    _resetWorkHistoryToList();
    notifyListeners();
  }

  void didTapOpenLatestQualityIssue() {
    if (!canOpenLatestQualityIssue) {
      return;
    }
    _applyLatestQualityIssueKeys();
    _selectedPaneIndex = QUALITY_ISSUE_PANE_INDEX;
    _resetWorkHistoryToList();
    notifyListeners();
  }

  void didTapOpenQualityIssueFromPane({
    required String commonKey,
    String historyId = '',
    String? passId,
    String? linkId,
  }) {
    if (commonKey.isEmpty) {
      return;
    }
    _paneQualityCommonKey = commonKey;
    if (historyId.isNotEmpty) {
      _paneQualityHistoryId = historyId;
    }
    _paneQualityPassId = passId ?? '';
    _paneQualityLinkId = linkId ?? '';
    _selectedPaneIndex = QUALITY_ISSUE_PANE_INDEX;
    _resetWorkHistoryToList();
    notifyListeners();
  }

  void didTapOpenPassProfileFromPane({
    required String commonKey,
    String historyId = '',
    String? passId,
  }) {
    if (commonKey.isEmpty) {
      return;
    }
    _panePassCommonKey = commonKey;
    if (historyId.isNotEmpty) {
      _panePassHistoryId = historyId;
    }
    _panePassPassId = passId ?? '';
    _selectedPaneIndex = PASS_PROFILE_PANE_INDEX;
    _resetWorkHistoryToList();
    notifyListeners();
  }

  void _applyLatestPassProfileKeys() {
    final target = _latestPassProfile;
    if (target == null) {
      _clearPanePassKeys();
      return;
    }
    _panePassCommonKey = target.commonKey;
    _panePassHistoryId = target.historyId;
    _panePassPassId = '';
  }

  void _applyLatestQualityIssueKeys() {
    final target = _latestQualityIssue;
    if (target == null) {
      _clearPaneQualityKeys();
      return;
    }
    _paneQualityCommonKey = target.commonKey;
    _paneQualityHistoryId = target.historyId;
    _paneQualityPassId = target.passId;
    _paneQualityLinkId = target.linkId;
  }

  void _clearPanePassKeys() {
    _panePassCommonKey = '';
    _panePassHistoryId = '';
    _panePassPassId = '';
  }

  void _clearPaneQualityKeys() {
    _paneQualityCommonKey = '';
    _paneQualityHistoryId = '';
    _paneQualityPassId = '';
    _paneQualityLinkId = '';
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
