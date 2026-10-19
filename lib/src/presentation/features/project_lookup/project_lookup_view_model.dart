import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/work_history_project_filter.dart';
import '../../../domain/use_cases/load_work_history_masters_use_case.dart';

class ProjectLookupViewModel extends ChangeNotifier {
  ProjectLookupViewModel({
    required LoadWorkHistoryMastersUseCase loadWorkHistoryMastersUseCase,
  }) : _loadWorkHistoryMastersUseCase = loadWorkHistoryMastersUseCase;

  final LoadWorkHistoryMastersUseCase _loadWorkHistoryMastersUseCase;

  String _queryText = '';
  bool _emptyJobsOnly = false;
  List<WorkHistoryProjectFilter> _projects = const [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;

  String get queryText => _queryText;
  bool get emptyJobsOnly => _emptyJobsOnly;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  List<WorkHistoryProjectFilter> get visibleProjects {
    final query = _queryText.trim().toLowerCase();
    return [
      for (final project in _projects)
        if ((!_emptyJobsOnly || project.jobCount == 0) &&
            (query.isEmpty || _matches(project, query)))
          project,
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
      _projects = catalog.projects;
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      _projects = const [];
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

  void didToggleEmptyJobsOnly(bool value) {
    if (_emptyJobsOnly == value) {
      return;
    }
    _emptyJobsOnly = value;
    notifyListeners();
  }

  bool _matches(WorkHistoryProjectFilter project, String query) {
    if (_contains(project.projectNo, query) ||
        _contains(project.projectName, query) ||
        _contains(project.siteName, query) ||
        _contains(project.customer, query)) {
      return true;
    }
    for (final unit in project.units) {
      for (final code in unit.itemCodes) {
        if (_contains(code, query)) {
          return true;
        }
      }
      for (final item in unit.items) {
        if (_contains(item.itemCode, query) ||
            _contains(item.itemName, query)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _contains(String value, String query) {
    return value.toLowerCase().contains(query);
  }

  @override
  void dispose() {
    _loadVersion++;
    super.dispose();
  }
}

String projectSiteCustomer(WorkHistoryProjectFilter project) {
  final parts = <String>[
    if (project.siteName.isNotEmpty) project.siteName,
    if (project.customer.isNotEmpty) project.customer,
  ];
  if (parts.isEmpty) {
    return '—';
  }
  return parts.join(' · ');
}

String projectUnitsText(WorkHistoryProjectFilter project) {
  if (project.units.isEmpty) {
    return '—';
  }
  final unitCount = project.units.length;
  var itemCount = 0;
  for (final unit in project.units) {
    itemCount += unit.items.isEmpty ? unit.itemCodes.length : unit.items.length;
  }
  return '$unitCount호기 · $itemCount품목';
}
