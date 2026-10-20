import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/worker.dart';
import '../../../domain/entities/worker_kind.dart';
import '../../../domain/use_cases/list_worker_lookup_use_case.dart';

enum WorkerKindFilter { all, master, general, robot, unknown }

class WorkerLookupViewModel extends ChangeNotifier {
  WorkerLookupViewModel({
    required ListWorkerLookupUseCase listWorkerLookupUseCase,
  }) : _listWorkerLookupUseCase = listWorkerLookupUseCase;

  final ListWorkerLookupUseCase _listWorkerLookupUseCase;

  String _queryText = '';
  WorkerKindFilter _kind = WorkerKindFilter.all;
  bool _includeInactive = false;
  List<Worker> _workers = const [];
  String _nextPageToken = '';
  int _totalCount = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;
  Timer? _queryDebounce;

  String get queryText => _queryText;
  WorkerKindFilter get kind => _kind;
  bool get includeInactive => _includeInactive;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  int get totalCount => _totalCount;
  bool get doesHaveMore => _nextPageToken.isNotEmpty;

  List<Worker> get visibleWorkers {
    return [
      for (final worker in _workers)
        if ((_includeInactive || !worker.isInactive) && _matchesKind(worker))
          worker,
    ];
  }

  Future<void> load() => _reload(reset: true);

  Future<void> didScrollNearEnd() async {
    if (_isLoading || _isLoadingMore || _nextPageToken.isEmpty) {
      return;
    }
    await _reload(reset: false);
  }

  void didChangeQueryText(String value) {
    if (_queryText == value) {
      return;
    }
    _queryText = value;
    notifyListeners();
    _queryDebounce?.cancel();
    _queryDebounce = Timer(const Duration(milliseconds: 400), () {
      _reload(reset: true);
    });
  }

  void didSelectKind(WorkerKindFilter kind) {
    if (_kind == kind) {
      return;
    }
    _kind = kind;
    notifyListeners();
  }

  void didToggleIncludeInactive(bool value) {
    if (_includeInactive == value) {
      return;
    }
    _includeInactive = value;
    notifyListeners();
  }

  Future<void> _reload({required bool reset}) async {
    final version = reset ? ++_loadVersion : _loadVersion;
    if (reset) {
      _isLoading = true;
      _isLoadingMore = false;
      _hasError = false;
      _errorMessage = '';
      notifyListeners();
    } else {
      _isLoadingMore = true;
      notifyListeners();
    }
    try {
      final page = await _listWorkerLookupUseCase.execute(
        includeInactive: true,
        query: _queryText,
        pageToken: reset ? '' : _nextPageToken,
      );
      if (version != _loadVersion) {
        return;
      }
      _workers = reset ? page.items : [..._workers, ...page.items];
      _nextPageToken = page.nextPageToken;
      _totalCount = page.totalCount;
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      if (reset) {
        _workers = const [];
        _nextPageToken = '';
        _totalCount = 0;
      }
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  bool _matchesKind(Worker worker) {
    switch (_kind) {
      case WorkerKindFilter.all:
        return true;
      case WorkerKindFilter.master:
        return worker.workerKind == WorkerKind.master;
      case WorkerKindFilter.general:
        return worker.workerKind == WorkerKind.general;
      case WorkerKindFilter.robot:
        return worker.workerKind == WorkerKind.robot;
      case WorkerKindFilter.unknown:
        return worker.workerKind == WorkerKind.unknown;
    }
  }

  @override
  void dispose() {
    _queryDebounce?.cancel();
    _loadVersion++;
    super.dispose();
  }
}

String workerNameCell(Worker worker) {
  if (worker.isInactive) {
    return '${worker.workerName} · 숨김';
  }
  return worker.workerName;
}
