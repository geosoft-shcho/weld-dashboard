import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/project_item_draft.dart';
import '../../../domain/entities/work_history_project_filter.dart';
import '../../../domain/use_cases/create_project_items_use_case.dart';
import '../../../domain/use_cases/create_project_use_case.dart';
import '../../../domain/use_cases/list_project_lookup_use_case.dart';

class ProjectLookupViewModel extends ChangeNotifier {
  ProjectLookupViewModel({
    required ListProjectLookupUseCase listProjectLookupUseCase,
    required CreateProjectUseCase createProjectUseCase,
    required CreateProjectItemsUseCase createProjectItemsUseCase,
  }) : _listProjectLookupUseCase = listProjectLookupUseCase,
       _createProjectUseCase = createProjectUseCase,
       _createProjectItemsUseCase = createProjectItemsUseCase;

  final ListProjectLookupUseCase _listProjectLookupUseCase;
  final CreateProjectUseCase _createProjectUseCase;
  final CreateProjectItemsUseCase _createProjectItemsUseCase;

  String _queryText = '';
  bool _emptyJobsOnly = false;
  List<WorkHistoryProjectFilter> _projects = const [];
  String _nextPageToken = '';
  int _totalCount = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadVersion = 0;
  Timer? _queryDebounce;

  String get queryText => _queryText;
  bool get emptyJobsOnly => _emptyJobsOnly;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  int get totalCount => _totalCount;
  bool get doesHaveMore => _nextPageToken.isNotEmpty;

  List<WorkHistoryProjectFilter> get visibleProjects {
    if (!_emptyJobsOnly) {
      return _projects;
    }
    return [
      for (final project in _projects)
        if (project.jobCount == 0) project,
    ];
  }

  List<String> get projectNos => [
    for (final project in _projects) project.projectNo,
  ];

  Future<String> createProject({
    required String projectNo,
    required String projectName,
    required String siteName,
    required String customer,
  }) {
    return _createProjectUseCase.execute(
      projectNo: projectNo,
      projectName: projectName,
      siteName: siteName,
      customer: customer,
    );
  }

  Future<void> createProjectItems({
    required String projectId,
    required List<ProjectItemDraft> items,
  }) {
    return _createProjectItemsUseCase.execute(
      projectId: projectId,
      items: items,
    );
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

  void didToggleEmptyJobsOnly(bool value) {
    if (_emptyJobsOnly == value) {
      return;
    }
    _emptyJobsOnly = value;
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
      final page = await _listProjectLookupUseCase.execute(
        query: _queryText,
        pageToken: reset ? '' : _nextPageToken,
      );
      if (version != _loadVersion) {
        return;
      }
      _projects = reset ? page.items : [..._projects, ...page.items];
      _nextPageToken = page.nextPageToken;
      _totalCount = page.totalCount;
    } catch (error) {
      if (version != _loadVersion) {
        return;
      }
      _hasError = true;
      _errorMessage = error.toString();
      if (reset) {
        _projects = const [];
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

  @override
  void dispose() {
    _queryDebounce?.cancel();
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
