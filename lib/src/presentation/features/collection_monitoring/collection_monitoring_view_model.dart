import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/collected_node.dart';
import '../../../domain/entities/collection_board.dart';
import '../../../domain/entities/collection_board_query.dart';
import '../../../domain/entities/collection_summary.dart';
import '../../../domain/entities/kpi_card_kind.dart';
import '../../../domain/entities/timeline_view_kind.dart';
import '../../../domain/entities/worker.dart';
import '../../../domain/use_cases/get_collection_summary_use_case.dart';
import '../../../domain/use_cases/list_asset_counts_use_case.dart';
import '../../../domain/use_cases/list_collected_nodes_use_case.dart';
import '../../../domain/use_cases/list_project_lookup_use_case.dart';
import '../../../domain/use_cases/list_worker_lookup_use_case.dart';
import '../../../domain/use_cases/present_collection_nodes_use_case.dart';

class CollectionMonitoringViewModel extends ChangeNotifier {
  CollectionMonitoringViewModel({
    required ListCollectedNodesUseCase listCollectedNodesUseCase,
    required PresentCollectionNodesUseCase presentCollectionNodesUseCase,
    required ListProjectLookupUseCase listProjectLookupUseCase,
    required GetCollectionSummaryUseCase getCollectionSummaryUseCase,
    required ListAssetCountsUseCase listAssetCountsUseCase,
    required ListWorkerLookupUseCase listWorkerLookupUseCase,
    this.onAfterBoardLoaded,
  }) : _listCollectedNodesUseCase = listCollectedNodesUseCase,
       _presentCollectionNodesUseCase = presentCollectionNodesUseCase,
       _listProjectLookupUseCase = listProjectLookupUseCase,
       _getCollectionSummaryUseCase = getCollectionSummaryUseCase,
       _listAssetCountsUseCase = listAssetCountsUseCase,
       _listWorkerLookupUseCase = listWorkerLookupUseCase;

  final ListCollectedNodesUseCase _listCollectedNodesUseCase;
  final PresentCollectionNodesUseCase _presentCollectionNodesUseCase;
  final ListProjectLookupUseCase _listProjectLookupUseCase;
  final GetCollectionSummaryUseCase _getCollectionSummaryUseCase;
  final ListAssetCountsUseCase _listAssetCountsUseCase;
  final ListWorkerLookupUseCase _listWorkerLookupUseCase;
  final ValueChanged<DateTime>? onAfterBoardLoaded;

  CollectionBoardQuery _query = CollectionBoardQuery.initial();
  CollectedTimeBasis _basis = CollectedTimeBasis.work;
  CollectedSegmentUnit _segmentUnit = CollectedSegmentUnit.job;
  String _workerId = '';
  final List<CollectedNode> _ancestors = [];
  final Map<String, List<CollectedNode>> _nodesByParentKey = {};
  List<CollectedNode> _nodes = const [];
  CollectionBoard? _board;
  CollectionKpi _kpi = CollectionKpi.empty;
  List<AssetCountRow> _assetCounts = const [];
  AssetCountTimeBasis _assetCountBasis = AssetCountTimeBasis.collected;
  List<Worker> _workerOptions = const [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;
  Timer? _refreshTimer;

  CollectionBoardQuery get query => _query;
  CollectionBoard? get board => _board;
  CollectionKpi get kpi => _kpi;
  List<AssetCountRow> get assetCounts => List.unmodifiable(_assetCounts);
  AssetCountTimeBasis get assetCountBasis => _assetCountBasis;
  List<Worker> get workerOptions => List.unmodifiable(_workerOptions);
  String get workerId => _workerId;

  List<CollectedNode> get nodes => List.unmodifiable(_nodes);

  CollectedNode? get selectedNode {
    final nodeKey = _query.selectedEquipmentId.isNotEmpty
        ? _query.selectedEquipmentId
        : _query.selectedEventId;
    return _nodeByKey(nodeKey);
  }

  CollectedNode? _nodeByKey(String nodeKey) {
    if (nodeKey.isEmpty) {
      return null;
    }
    for (final node in _nodes) {
      if (node.nodeKey == nodeKey) {
        return node;
      }
    }
    return null;
  }

  CollectedNodeView get collectedView => CollectedNodeView.project;
  CollectedTimeBasis get timeBasis => _basis;
  CollectedSegmentUnit get segmentUnit => _segmentUnit;
  List<CollectedNode> get ancestors => List.unmodifiable(_ancestors);
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get doesHaveInvalidTimeRange => _query.doesHaveInvalidTimeRange;
  bool get isAutoRefreshOn => _query.refreshIntervalSeconds > 0;

  CollectedNodePath get currentParent =>
      _ancestors.isEmpty ? CollectedNodePath.root() : _ancestors.last.path;

  Future<void> loadBoard({bool doesReloadSummary = true}) async {
    final version = ++_loadVersion;
    final parent = currentParent;
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      if (_workerOptions.isEmpty) {
        final page = await _listWorkerLookupUseCase.execute();
        if (version != _loadVersion) {
          return;
        }
        _workerOptions = page.items;
      }
      final offsets = _offsetsOf(parent);
      final nodesFuture = _listCollectedNodesUseCase.execute(
        parent,
        startOffsetNs: offsets.$1,
        endOffsetNs: offsets.$2,
        basis: _basis,
        segmentUnit: _segmentUnit,
        workerId: _workerId,
      );
      final summaryFuture = doesReloadSummary
          ? _getCollectionSummaryUseCase.execute(workerId: _workerId)
          : Future<CollectionSummaryLoad?>.value(null);
      final countsFuture = _listAssetCountsUseCase.execute(
        parent: parent.level == CollectedNodeLevel.unspecified ? null : parent,
        workerId: _workerId,
        basis: _assetCountBasis,
      );
      final nodes = await nodesFuture;
      final summaryLoad = await summaryFuture;
      final counts = await countsFuture;
      if (version != _loadVersion) {
        return;
      }
      _nodesByParentKey[parent.key] = nodes;
      _nodes = nodes;
      _assetCounts = counts;
      if (summaryLoad != null) {
        _kpi = CollectionKpi(
          summary: summaryLoad.summary,
          runningTraceCount: summaryLoad.runningTraceCount,
          failedTraceCount: summaryLoad.failedTraceCount,
        );
      }
      _present();
      onAfterBoardLoaded?.call(DateTime.now());
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
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

  List<CollectedNode> nodesForLevel(CollectedNodeLevel level) {
    final parent = _parentListing(level);
    if (parent == null) {
      return const [];
    }
    return _nodesByParentKey[parent.key] ?? const [];
  }

  List<CollectedNode> cachedChildrenOf(CollectedNodePath parent) {
    return List.unmodifiable(_nodesByParentKey[parent.key] ?? const []);
  }

  Future<String?> resolveProjectId(String projectNo) async {
    if (projectNo.isEmpty) {
      return null;
    }
    final page = await _listProjectLookupUseCase.execute(query: projectNo);
    for (final project in page.items) {
      if (project.projectNo == projectNo && project.projectId.isNotEmpty) {
        return project.projectId;
      }
    }
    return null;
  }

  CollectedNode? ancestorAt(CollectedNodeLevel level) {
    for (final node in _ancestors) {
      if (node.path.level == level) {
        return node;
      }
    }
    return null;
  }

  void didSelectWorkerFilter(String? workerId) {
    final next = workerId ?? '';
    if (_workerId == next) {
      return;
    }
    _workerId = next;
    _clearTreeCache();
    loadBoard(doesReloadSummary: true);
  }

  void didSelectAssetCountBasis(AssetCountTimeBasis basis) {
    if (_assetCountBasis == basis) {
      return;
    }
    _assetCountBasis = basis;
    loadBoard(doesReloadSummary: false);
  }

  void didSelectTimeBasis(CollectedTimeBasis basis) {
    if (_basis == basis) {
      return;
    }
    _basis = basis;
    _clearTreeCache();
    loadBoard(doesReloadSummary: false);
  }

  void didSelectSegmentUnit(CollectedSegmentUnit segmentUnit) {
    if (_segmentUnit == segmentUnit) {
      return;
    }
    _segmentUnit = segmentUnit;
    _clearTreeCache();
    loadBoard(doesReloadSummary: false);
  }

  void didSelectLevelNode(CollectedNodeLevel level, String? nodeKey) {
    if (!_chain().contains(level)) {
      return;
    }
    if (nodeKey == null) {
      _ancestors.removeWhere((node) => !_isBefore(node.path.level, level));
      _applySegmentForLevel();
      loadBoard(doesReloadSummary: false);
      return;
    }
    CollectedNode? selected;
    for (final node in nodesForLevel(level)) {
      if (node.nodeKey == nodeKey) {
        selected = node;
        break;
      }
    }
    if (selected == null) {
      for (final node in _nodes) {
        if (node.nodeKey == nodeKey) {
          selected = node;
          break;
        }
      }
    }
    if (selected == null) {
      return;
    }
    if (!selected.hasChildren) {
      _query = _query.copyWith(selectedEquipmentId: selected.nodeKey);
      _present();
      notifyListeners();
      return;
    }
    _ancestors
      ..removeWhere((node) => !_isBefore(node.path.level, level))
      ..add(selected);
    _applySegmentForLevel();
    loadBoard(doesReloadSummary: false);
  }

  void didTapTimelineNode(String nodeKey) {
    CollectedNode? selected;
    for (final node in _nodes) {
      if (node.nodeKey == nodeKey) {
        selected = node;
        break;
      }
    }
    if (selected == null) {
      return;
    }
    final chosen = selected;
    if (!chosen.hasChildren) {
      didSelectRow(nodeKey);
      return;
    }
    didSelectLevelNode(chosen.path.level, chosen.nodeKey);
  }

  void didTapAncestor(int keepCount) {
    if (keepCount < 0) {
      return;
    }
    if (keepCount < _ancestors.length) {
      _ancestors.removeRange(keepCount, _ancestors.length);
    }
    _applySegmentForLevel();
    loadBoard(doesReloadSummary: false);
  }

  void didTapPreviousDate() {
    _query = _query.copyWith(
      selectedDate: _query.selectedDate.subtract(const Duration(days: 1)),
    );
    _applyDateWindow();
  }

  void didTapNextDate() {
    _query = _query.copyWith(
      selectedDate: _query.selectedDate.add(const Duration(days: 1)),
    );
    _applyDateWindow();
  }

  void didSelectDate(DateTime date) {
    _query = _query.copyWith(
      selectedDate: DateTime(date.year, date.month, date.day),
    );
    _applyDateWindow();
  }

  void didSelectStartTime(DateTime time) {
    _query = _query.copyWith(startMinutes: time.hour * 60 + time.minute);
    _applyDateWindow();
  }

  void didSelectEndTime(DateTime time) {
    final minutes = time.hour * 60 + time.minute;
    _query = _query.copyWith(endMinutes: minutes == 0 ? 1440 : minutes);
    _applyDateWindow();
  }

  void didSelectRefreshInterval(int seconds) {
    _query = _query.copyWith(refreshIntervalSeconds: seconds);
    _restartTimer();
    notifyListeners();
  }

  void didTapQuery() {
    loadBoard(doesReloadSummary: true);
  }

  void didTapReset() {
    _query = CollectionBoardQuery.initial();
    _basis = CollectedTimeBasis.work;
    _segmentUnit = CollectedSegmentUnit.job;
    _workerId = '';
    _assetCountBasis = AssetCountTimeBasis.collected;
    _ancestors.clear();
    _nodesByParentKey.clear();
    _nodes = const [];
    _kpi = CollectionKpi.empty;
    _assetCounts = const [];
    _restartTimer();
    loadBoard(doesReloadSummary: true);
  }

  void didTapReload() {
    loadBoard(doesReloadSummary: true);
  }

  void didTapKpiCard(KpiCardKind kind) {
    _query = _query.copyWith(
      selectedKpiCard: _query.selectedKpiCard == kind ? KpiCardKind.none : kind,
    );
    _present();
    notifyListeners();
  }

  void didSelectRow(String nodeKey) {
    _query = _query.copyWith(selectedEquipmentId: nodeKey);
    _present();
    notifyListeners();
  }

  void didSelectTimelineView(TimelineViewKind viewKind) {
    _query = _query.copyWith(viewKind: viewKind);
    _present();
    notifyListeners();
  }

  void didSelectZoom(double zoomHours) {
    _query = _query.copyWith(zoomHours: zoomHours);
    _present();
    notifyListeners();
  }

  void didSelectEvent(String eventId, String nodeKey) {
    _query = _query.copyWith(
      selectedEventId: eventId,
      selectedEquipmentId: nodeKey,
    );
    _present();
    notifyListeners();
  }

  void didDoubleTapEquipment(String nodeKey) {
    didTapTimelineNode(nodeKey);
  }

  void didTapProjectSection(String nodeKey) {
    didTapTimelineNode(nodeKey);
  }

  void didTapLineSection(String nodeKey) {
    didTapTimelineNode(nodeKey);
  }

  void didTapFactoryCrumb() {
    didTapAncestor(0);
  }

  void didTapProjectCrumb() {
    didTapAncestor(_ancestors.length > 1 ? 1 : 0);
  }

  void didTapLineCrumb() {
    didTapAncestor(_ancestors.isEmpty ? 0 : _ancestors.length - 1);
  }

  void didTapOpenDayView() {
    if (_query.selectedEquipmentId.isEmpty) {
      return;
    }
    _query = _query.copyWith(viewKind: TimelineViewKind.day);
    _present();
    notifyListeners();
  }

  @override
  void dispose() {
    _loadVersion++;
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _applyDateWindow() {
    if (currentParent.jobId.isNotEmpty) {
      loadBoard(doesReloadSummary: false);
      return;
    }
    _present();
    notifyListeners();
  }

  void _present() {
    _board = _presentCollectionNodesUseCase.execute(
      nodes: _nodes,
      query: _query,
      kpi: _kpi,
    );
    _query = _board!.query;
  }

  void _clearTreeCache() {
    _ancestors.clear();
    _nodesByParentKey.clear();
    _nodes = const [];
  }

  void _applySegmentForLevel() {
    final level = _ancestors.isEmpty
        ? CollectedNodeLevel.unspecified
        : _ancestors.last.path.level;
    _segmentUnit = level == CollectedNodeLevel.job
        ? CollectedSegmentUnit.pass
        : CollectedSegmentUnit.job;
  }

  (int?, int?) _offsetsOf(CollectedNodePath parent) {
    if (parent.jobId.isEmpty ||
        _ancestors.isEmpty ||
        _query.doesHaveInvalidTimeRange) {
      return (null, null);
    }
    final startedAt = _ancestors.last.startedAt;
    if (startedAt == null || _ancestors.last.path != parent) {
      return (null, null);
    }
    final day = _query.selectedDate;
    final start = DateTime(
      day.year,
      day.month,
      day.day,
    ).add(Duration(minutes: _query.startMinutes));
    final endMinutes = _query.endMinutes >= 1440 ? 1440 : _query.endMinutes;
    final end = DateTime(
      day.year,
      day.month,
      day.day,
    ).add(Duration(minutes: endMinutes));
    return (
      start.difference(startedAt).inMicroseconds * 1000,
      end.difference(startedAt).inMicroseconds * 1000,
    );
  }

  CollectedNodePath? _parentListing(CollectedNodeLevel level) {
    if (level == CollectedNodeLevel.project) {
      return CollectedNodePath.root();
    }
    final previous = _previousLevel(level);
    if (previous == null) {
      return null;
    }
    return ancestorAt(previous)?.path;
  }

  CollectedNodeLevel? _previousLevel(CollectedNodeLevel level) {
    final chain = _chain();
    final index = chain.indexOf(level);
    if (index <= 0) {
      return null;
    }
    return chain[index - 1];
  }

  bool _isBefore(CollectedNodeLevel level, CollectedNodeLevel boundary) {
    final chain = _chain();
    final levelIndex = chain.indexOf(level);
    final boundaryIndex = chain.indexOf(boundary);
    if (levelIndex < 0 || boundaryIndex < 0) {
      return false;
    }
    return levelIndex < boundaryIndex;
  }

  List<CollectedNodeLevel> _chain() {
    return const [
      CollectedNodeLevel.project,
      CollectedNodeLevel.item,
      CollectedNodeLevel.job,
    ];
  }

  void _restartTimer() {
    _refreshTimer?.cancel();
    if (!isAutoRefreshOn) {
      return;
    }
    _refreshTimer = Timer.periodic(
      Duration(seconds: _query.refreshIntervalSeconds),
      (_) => loadBoard(doesReloadSummary: true),
    );
  }
}
