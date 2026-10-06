import 'package:fluent_ui/fluent_ui.dart';

import '../../domain/entities/latest_pass_profile_target.dart';
import '../../domain/entities/latest_quality_issue_target.dart';
import 'app_navigation_port.dart';
import 'app_route_state.dart';

enum WorkHistoryStack {
  list,
  detail,
  videoMultimodal,
  passProfile,
  qualityIssue,
}

enum _RouteWriteMode { go, push, replace, pop, none }

class AppCoordinator extends ChangeNotifier {
  static const int COLLECTION_PANE_INDEX = 0;
  static const int WORK_HISTORY_PANE_INDEX = 1;
  static const int PASS_PROFILE_PANE_INDEX = 2;
  static const int QUALITY_ISSUE_PANE_INDEX = 3;

  AppNavigationPort? _navigation;
  bool _isApplyingRoute = false;

  int _selectedPaneIndex = 0;
  WorkHistoryStack _workHistoryStack = WorkHistoryStack.list;
  final List<WorkHistoryStack> _stackHistory = [];
  String _historyCommonKey = '';
  String _jobId = '';
  String _passId = '';
  String _linkId = '';
  String _pendingHistoryEquipmentId = '';
  String _pendingHistoryWorkerId = '';

  LatestPassProfileTarget? _latestPassProfile;
  LatestQualityIssueTarget? _latestQualityIssue;

  String _panePassCommonKey = '';
  String _panePassJobId = '';
  String _panePassPassId = '';
  String _paneQualityCommonKey = '';
  String _paneQualityJobId = '';
  String _paneQualityPassId = '';
  String _paneQualityLinkId = '';
  DateTime _lastDataUpdatedAt = DateTime.now();

  int get selectedPaneIndex => _selectedPaneIndex;
  WorkHistoryStack get workHistoryStack => _workHistoryStack;
  String get historyCommonKey => _historyCommonKey;
  String get jobId => _jobId;
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
  String get panePassJobId => _panePassJobId;
  String get panePassPassId => _panePassPassId;
  String get paneQualityCommonKey => _paneQualityCommonKey;
  String get paneQualityJobId => _paneQualityJobId;
  String get paneQualityPassId => _paneQualityPassId;
  String get paneQualityLinkId => _paneQualityLinkId;
  DateTime get lastDataUpdatedAt => _lastDataUpdatedAt;

  /// 브라우저 탭에 붙는 현재 화면 이름.
  String get pageTitle {
    switch (_selectedPaneIndex) {
      case PASS_PROFILE_PANE_INDEX:
        return '패스별 파라미터 프로파일';
      case QUALITY_ISSUE_PANE_INDEX:
        return '품질 이슈 연계';
      case WORK_HISTORY_PANE_INDEX:
        return _workHistoryPageTitle;
      case COLLECTION_PANE_INDEX:
      default:
        return '수집 모니터링';
    }
  }

  String get _workHistoryPageTitle {
    switch (_workHistoryStack) {
      case WorkHistoryStack.list:
        return '작업 이력 조회';
      case WorkHistoryStack.detail:
        if (_jobId.isEmpty) {
          return '작업 상세';
        }
        return '작업 상세 $_jobId';
      case WorkHistoryStack.videoMultimodal:
        return '비디오 멀티모달';
      case WorkHistoryStack.passProfile:
        return '패스별 파라미터 프로파일';
      case WorkHistoryStack.qualityIssue:
        return '품질 이슈 연계';
    }
  }

  /// 수집 모니터링 등 화면 데이터 재조회가 끝난 시각을 타이틀바에 반영한다.
  void didRefreshDashboardData([DateTime? updatedAt]) {
    _lastDataUpdatedAt = updatedAt ?? DateTime.now();
    notifyListeners();
  }

  bool get isPassProfilePaneSelected =>
      _selectedPaneIndex == PASS_PROFILE_PANE_INDEX;
  bool get isQualityIssuePaneSelected =>
      _selectedPaneIndex == QUALITY_ISSUE_PANE_INDEX;

  void attachNavigation(AppNavigationPort navigation) {
    _navigation = navigation;
  }

  /// Called by the router on browser back/forward and every location match.
  void didApplyRoute(AppRouteState state) {
    if (_matchesRouteState(state)) {
      return;
    }
    _isApplyingRoute = true;
    _applyRouteState(state);
    _isApplyingRoute = false;
    notifyListeners();
  }

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
    var didChangePane = false;
    if (_selectedPaneIndex == PASS_PROFILE_PANE_INDEX && passProfile == null) {
      _selectedPaneIndex = COLLECTION_PANE_INDEX;
      didChangePane = true;
    }
    if (_selectedPaneIndex == QUALITY_ISSUE_PANE_INDEX &&
        qualityIssue == null) {
      _selectedPaneIndex = COLLECTION_PANE_INDEX;
      didChangePane = true;
    }
    notifyListeners();
    if (didChangePane) {
      _publishLocation(_RouteWriteMode.go);
    }
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
        _publishLocation(_RouteWriteMode.go);
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
    _publishLocation(_RouteWriteMode.go);
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
      _publishLocation(_RouteWriteMode.go);
      return;
    }
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    notifyListeners();
    _publishLocation(_RouteWriteMode.go);
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
    _publishLocation(_RouteWriteMode.go);
  }

  void didTapBackFromPassProfile(BuildContext context) {
    if (isPassProfilePaneSelected) {
      didTapBackToWorkHistory(context);
      return;
    }
    _popOrGoToPrevious();
  }

  void didTapBackFromQualityIssue(BuildContext context) {
    if (isQualityIssuePaneSelected) {
      didTapBackToWorkHistory(context);
      return;
    }
    _popOrGoToPrevious();
  }

  void didTapLeaveWorkDetailToPassProfile(
    BuildContext context, {
    required String commonKey,
    required String jobId,
  }) {
    didTapOpenPassProfile(commonKey: commonKey, jobId: jobId);
  }

  void didTapLeaveWorkDetailToQualityIssue(
    BuildContext context, {
    required String commonKey,
    required String jobId,
  }) {
    didTapOpenQualityIssue(commonKey: commonKey, jobId: jobId, viaDetail: true);
  }

  void didTapOpenVideoMultimodal(BuildContext context) {
    if (_jobId.isEmpty) {
      return;
    }
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    if (_workHistoryStack == WorkHistoryStack.videoMultimodal) {
      notifyListeners();
      _publishLocation(_RouteWriteMode.replace);
      return;
    }
    _pushWorkHistoryStack(WorkHistoryStack.videoMultimodal);
    notifyListeners();
    _publishLocation(_RouteWriteMode.push);
  }

  void didTapBackFromVideoMultimodal(BuildContext context) {
    _popOrGoToPrevious();
  }

  void didTapOpenWorkDetail(BuildContext context, {required String jobId}) {
    _jobId = jobId;
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    _pushWorkHistoryStack(WorkHistoryStack.detail);
    notifyListeners();
    _publishLocation(_RouteWriteMode.push);
  }

  void didTapOpenPassProfile({
    required String commonKey,
    String jobId = '',
    String? passId,
    String? linkId,
  }) {
    if (commonKey.isEmpty) {
      return;
    }
    _historyCommonKey = commonKey;
    if (jobId.isNotEmpty) {
      _jobId = jobId;
    }
    _passId = passId ?? '';
    _linkId = linkId ?? '';
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    if (_workHistoryStack == WorkHistoryStack.passProfile) {
      notifyListeners();
      _publishLocation(_RouteWriteMode.replace);
      return;
    }
    if (_workHistoryStack == WorkHistoryStack.qualityIssue &&
        previousWorkHistoryStack == WorkHistoryStack.passProfile) {
      _popWorkHistoryStack();
      notifyListeners();
      _publishLocation(_RouteWriteMode.replace);
      return;
    }
    _pushWorkHistoryStack(WorkHistoryStack.passProfile);
    notifyListeners();
    _publishLocation(_RouteWriteMode.push);
  }

  void didTapOpenQualityIssue({
    required String commonKey,
    String jobId = '',
    String? passId,
    String? linkId,
    bool viaDetail = false,
  }) {
    if (commonKey.isEmpty) {
      return;
    }
    _historyCommonKey = commonKey;
    if (jobId.isNotEmpty) {
      _jobId = jobId;
    }
    _passId = passId ?? '';
    _linkId = linkId ?? '';
    _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
    if (_workHistoryStack == WorkHistoryStack.qualityIssue) {
      notifyListeners();
      _publishLocation(_RouteWriteMode.replace);
      return;
    }
    _pushWorkHistoryStack(WorkHistoryStack.qualityIssue);
    notifyListeners();
    _publishLocation(_RouteWriteMode.push, qualityViaDetail: viaDetail);
  }

  void didTapOpenLatestPassProfile() {
    if (!canOpenLatestPassProfile) {
      return;
    }
    _applyLatestPassProfileKeys();
    _selectedPaneIndex = PASS_PROFILE_PANE_INDEX;
    _resetWorkHistoryToList();
    notifyListeners();
    _publishLocation(_RouteWriteMode.go);
  }

  void didTapOpenLatestQualityIssue() {
    if (!canOpenLatestQualityIssue) {
      return;
    }
    _applyLatestQualityIssueKeys();
    _selectedPaneIndex = QUALITY_ISSUE_PANE_INDEX;
    _resetWorkHistoryToList();
    notifyListeners();
    _publishLocation(_RouteWriteMode.go);
  }

  void didTapOpenQualityIssueFromPane({
    required String commonKey,
    String jobId = '',
    String? passId,
    String? linkId,
  }) {
    if (commonKey.isEmpty) {
      return;
    }
    _paneQualityCommonKey = commonKey;
    if (jobId.isNotEmpty) {
      _paneQualityJobId = jobId;
    }
    _paneQualityPassId = passId ?? '';
    _paneQualityLinkId = linkId ?? '';
    _selectedPaneIndex = QUALITY_ISSUE_PANE_INDEX;
    _resetWorkHistoryToList();
    notifyListeners();
    _publishLocation(_RouteWriteMode.push);
  }

  void didTapOpenPassProfileFromPane({
    required String commonKey,
    String jobId = '',
    String? passId,
  }) {
    if (commonKey.isEmpty) {
      return;
    }
    _panePassCommonKey = commonKey;
    if (jobId.isNotEmpty) {
      _panePassJobId = jobId;
    }
    _panePassPassId = passId ?? '';
    _selectedPaneIndex = PASS_PROFILE_PANE_INDEX;
    _resetWorkHistoryToList();
    notifyListeners();
    _publishLocation(_RouteWriteMode.go);
  }

  void _popOrGoToPrevious() {
    final navigation = _navigation;
    if (navigation != null && navigation.canPop) {
      _publishLocation(_RouteWriteMode.pop);
      return;
    }
    _popWorkHistoryStack();
    notifyListeners();
    _publishLocation(_RouteWriteMode.go);
  }

  void _applyLatestPassProfileKeys() {
    final target = _latestPassProfile;
    if (target == null) {
      _clearPanePassKeys();
      return;
    }
    _panePassCommonKey = target.commonKey;
    _panePassJobId = target.jobId;
    _panePassPassId = '';
  }

  void _applyLatestQualityIssueKeys() {
    final target = _latestQualityIssue;
    if (target == null) {
      _clearPaneQualityKeys();
      return;
    }
    _paneQualityCommonKey = target.commonKey;
    _paneQualityJobId = target.jobId;
    _paneQualityPassId = target.passId;
    _paneQualityLinkId = target.linkId;
  }

  void _clearPanePassKeys() {
    _panePassCommonKey = '';
    _panePassJobId = '';
    _panePassPassId = '';
  }

  void _clearPaneQualityKeys() {
    _paneQualityCommonKey = '';
    _paneQualityJobId = '';
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

  AppRouteState _currentRouteState({bool qualityViaDetail = false}) {
    switch (_selectedPaneIndex) {
      case PASS_PROFILE_PANE_INDEX:
        return AppRouteState(
          pane: AppPane.pass,
          commonKey: _panePassCommonKey,
          jobId: _panePassJobId,
          passId: _panePassPassId,
        );
      case QUALITY_ISSUE_PANE_INDEX:
        return AppRouteState(
          pane: AppPane.quality,
          commonKey: _paneQualityCommonKey,
          jobId: _paneQualityJobId,
          passId: _paneQualityPassId,
          linkId: _paneQualityLinkId,
        );
      case WORK_HISTORY_PANE_INDEX:
        final viaDetail =
            qualityViaDetail ||
            (_workHistoryStack == WorkHistoryStack.qualityIssue &&
                previousWorkHistoryStack == WorkHistoryStack.detail);
        return AppRouteState(
          pane: AppPane.history,
          stack: _workHistoryStack,
          jobId: _jobId,
          commonKey: _historyCommonKey,
          passId: _passId,
          linkId: _linkId,
          qualityViaDetail: viaDetail,
        );
      case COLLECTION_PANE_INDEX:
      default:
        return const AppRouteState(pane: AppPane.collection);
    }
  }

  bool _matchesRouteState(AppRouteState state) {
    switch (state.pane) {
      case AppPane.collection:
        return _selectedPaneIndex == COLLECTION_PANE_INDEX &&
            _workHistoryStack == WorkHistoryStack.list;
      case AppPane.pass:
        if (_selectedPaneIndex != PASS_PROFILE_PANE_INDEX) {
          return false;
        }
        if (state.commonKey.isEmpty) {
          return true;
        }
        return state.commonKey == _panePassCommonKey &&
            state.jobId == _panePassJobId &&
            state.passId == _panePassPassId;
      case AppPane.quality:
        if (_selectedPaneIndex != QUALITY_ISSUE_PANE_INDEX) {
          return false;
        }
        if (state.commonKey.isEmpty) {
          return true;
        }
        return state.commonKey == _paneQualityCommonKey &&
            state.jobId == _paneQualityJobId &&
            state.passId == _paneQualityPassId &&
            state.linkId == _paneQualityLinkId;
      case AppPane.history:
        if (_selectedPaneIndex != WORK_HISTORY_PANE_INDEX) {
          return false;
        }
        if (state.stack != _workHistoryStack) {
          return false;
        }
        switch (state.stack) {
          case WorkHistoryStack.list:
            return true;
          case WorkHistoryStack.detail:
          case WorkHistoryStack.videoMultimodal:
            return state.jobId == _jobId;
          case WorkHistoryStack.passProfile:
            return state.commonKey == _historyCommonKey &&
                state.jobId == _jobId &&
                state.passId == _passId;
          case WorkHistoryStack.qualityIssue:
            final viaDetail =
                previousWorkHistoryStack == WorkHistoryStack.detail;
            return state.commonKey == _historyCommonKey &&
                state.jobId == _jobId &&
                state.passId == _passId &&
                state.linkId == _linkId &&
                state.qualityViaDetail == viaDetail;
        }
    }
  }

  void _applyRouteState(AppRouteState state) {
    switch (state.pane) {
      case AppPane.collection:
        _selectedPaneIndex = COLLECTION_PANE_INDEX;
        _resetWorkHistoryToList();
      case AppPane.pass:
        _selectedPaneIndex = PASS_PROFILE_PANE_INDEX;
        _resetWorkHistoryToList();
        if (state.commonKey.isNotEmpty) {
          _panePassCommonKey = state.commonKey;
          _panePassJobId = state.jobId;
          _panePassPassId = state.passId;
        } else {
          _applyLatestPassProfileKeys();
        }
      case AppPane.quality:
        _selectedPaneIndex = QUALITY_ISSUE_PANE_INDEX;
        _resetWorkHistoryToList();
        if (state.commonKey.isNotEmpty) {
          _paneQualityCommonKey = state.commonKey;
          _paneQualityJobId = state.jobId;
          _paneQualityPassId = state.passId;
          _paneQualityLinkId = state.linkId;
        } else {
          _applyLatestQualityIssueKeys();
        }
      case AppPane.history:
        _selectedPaneIndex = WORK_HISTORY_PANE_INDEX;
        _jobId = state.jobId;
        _historyCommonKey = state.commonKey;
        _passId = state.passId;
        _linkId = state.linkId;
        _rebuildStackHistory(
          state.stack,
          qualityViaDetail: state.qualityViaDetail,
        );
    }
  }

  void _rebuildStackHistory(
    WorkHistoryStack stack, {
    required bool qualityViaDetail,
  }) {
    _stackHistory.clear();
    _workHistoryStack = stack;
    switch (stack) {
      case WorkHistoryStack.list:
        _clearDrilldownKeys();
      case WorkHistoryStack.detail:
        _stackHistory.add(WorkHistoryStack.list);
      case WorkHistoryStack.videoMultimodal:
        _stackHistory.add(WorkHistoryStack.list);
        _stackHistory.add(WorkHistoryStack.detail);
      case WorkHistoryStack.passProfile:
        _stackHistory.add(WorkHistoryStack.list);
        if (_jobId.isNotEmpty) {
          _stackHistory.add(WorkHistoryStack.detail);
        }
      case WorkHistoryStack.qualityIssue:
        _stackHistory.add(WorkHistoryStack.list);
        if (_jobId.isNotEmpty) {
          _stackHistory.add(WorkHistoryStack.detail);
        }
        if (!qualityViaDetail) {
          _stackHistory.add(WorkHistoryStack.passProfile);
        }
    }
  }

  void _publishLocation(_RouteWriteMode mode, {bool qualityViaDetail = false}) {
    if (_isApplyingRoute || mode == _RouteWriteMode.none) {
      return;
    }
    final navigation = _navigation;
    if (navigation == null) {
      return;
    }
    if (mode == _RouteWriteMode.pop) {
      if (navigation.canPop) {
        navigation.pop();
      }
      return;
    }
    final location = _currentRouteState(
      qualityViaDetail: qualityViaDetail,
    ).toLocation();
    if (_normalizeLocation(navigation.currentLocation) ==
        _normalizeLocation(location)) {
      return;
    }
    switch (mode) {
      case _RouteWriteMode.go:
        navigation.go(location);
      case _RouteWriteMode.push:
        navigation.push(location);
      case _RouteWriteMode.replace:
        navigation.replace(location);
      case _RouteWriteMode.pop:
      case _RouteWriteMode.none:
        break;
    }
  }

  String _normalizeLocation(String location) {
    if (location.isEmpty) {
      return '/';
    }
    final uri = Uri.parse(location);
    final path = uri.path.isEmpty ? '/' : uri.path;
    if (!uri.hasQuery) {
      return path;
    }
    final sorted = Map<String, String>.from(uri.queryParameters);
    final keys = sorted.keys.toList()..sort();
    final query = keys.map((key) => '$key=${sorted[key]}').join('&');
    return '$path?$query';
  }
}
