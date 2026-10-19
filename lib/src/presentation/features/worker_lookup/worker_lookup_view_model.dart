import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/worker.dart';
import '../../../domain/entities/worker_kind.dart';
import '../../../domain/use_cases/load_work_history_masters_use_case.dart';

enum WorkerKindFilter { all, master, general, robot, unknown }

class WorkerLookupViewModel extends ChangeNotifier {
  WorkerLookupViewModel({
    required LoadWorkHistoryMastersUseCase loadWorkHistoryMastersUseCase,
  }) : _loadWorkHistoryMastersUseCase = loadWorkHistoryMastersUseCase;

  final LoadWorkHistoryMastersUseCase _loadWorkHistoryMastersUseCase;

  String _queryText = '';
  WorkerKindFilter _kind = WorkerKindFilter.all;
  bool _includeInactive = false;
  List<Worker> _workers = const [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;

  String get queryText => _queryText;
  WorkerKindFilter get kind => _kind;
  bool get includeInactive => _includeInactive;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  List<Worker> get visibleWorkers {
    final query = _queryText.trim().toLowerCase();
    return [
      for (final worker in _workers)
        if ((_includeInactive || !worker.isInactive) &&
            _matchesKind(worker) &&
            (query.isEmpty || _matchesQuery(worker, query)))
          worker,
    ];
  }

  Future<void> load() async {
    final version = ++_loadVersion;
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      final catalog = await _loadWorkHistoryMastersUseCase.execute();
      if (version != _loadVersion) {
        return;
      }
      _workers = catalog.workers;
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      _workers = const [];
    } finally {
      if (version == _loadVersion) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void didChangeQueryText(String value) {
    if (_queryText == value) {
      return;
    }
    _queryText = value;
    notifyListeners();
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

  bool _matchesQuery(Worker worker, String query) {
    return worker.workerName.toLowerCase().contains(query) ||
        worker.employeeNo.toLowerCase().contains(query) ||
        worker.description.toLowerCase().contains(query);
  }

  @override
  void dispose() {
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
