import 'package:flutter/foundation.dart';

import '../../../domain/entities/catalog_snapshot.dart';
import '../../../domain/entities/latest_pass_profile_target.dart';
import '../../../domain/entities/latest_quality_issue_target.dart';
import '../../../domain/entities/work_history_query.dart';
import '../../../domain/use_cases/list_work_history_page_use_case.dart';
import '../../../domain/use_cases/load_catalog_use_case.dart';
import '../../../domain/use_cases/resolve_latest_pass_profile_use_case.dart';
import '../../../domain/use_cases/resolve_latest_quality_issue_use_case.dart';

class ShellViewModel extends ChangeNotifier {
  ShellViewModel({
    required LoadCatalogUseCase loadCatalogUseCase,
    required ListWorkHistoryPageUseCase listWorkHistoryPageUseCase,
    required ResolveLatestPassProfileUseCase resolveLatestPassProfileUseCase,
    required ResolveLatestQualityIssueUseCase resolveLatestQualityIssueUseCase,
    required bool pdfrxReady,
  }) : _loadCatalogUseCase = loadCatalogUseCase,
       _listWorkHistoryPageUseCase = listWorkHistoryPageUseCase,
       _resolveLatestPassProfileUseCase = resolveLatestPassProfileUseCase,
       _resolveLatestQualityIssueUseCase = resolveLatestQualityIssueUseCase,
       _pdfrxReady = pdfrxReady;

  static const int LATEST_JOBS_PAGE_SIZE = 50;

  final LoadCatalogUseCase _loadCatalogUseCase;
  final ListWorkHistoryPageUseCase _listWorkHistoryPageUseCase;
  final ResolveLatestPassProfileUseCase _resolveLatestPassProfileUseCase;
  final ResolveLatestQualityIssueUseCase _resolveLatestQualityIssueUseCase;
  final bool _pdfrxReady;

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  CatalogSnapshot? _catalog;
  LatestPassProfileTarget? _latestPassProfile;
  LatestQualityIssueTarget? _latestQualityIssue;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  CatalogSnapshot? get catalog => _catalog;
  bool get pdfrxReady => _pdfrxReady;
  LatestPassProfileTarget? get latestPassProfile => _latestPassProfile;
  LatestQualityIssueTarget? get latestQualityIssue => _latestQualityIssue;

  Future<void> loadCatalog() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _latestPassProfile = null;
    _latestQualityIssue = null;
    notifyListeners();
    try {
      _catalog = await _loadCatalogUseCase.execute(pdfrxReady: _pdfrxReady);
      final page = await _listWorkHistoryPageUseCase.execute(
        query: WorkHistoryQuery.initial(),
        pageSize: LATEST_JOBS_PAGE_SIZE,
        pageToken: '',
      );
      _latestPassProfile = _resolveLatestPassProfileUseCase.execute(
        jobs: page.items,
      );
      _latestQualityIssue = _resolveLatestQualityIssueUseCase.execute(
        jobs: page.items,
      );
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _catalog = null;
      _latestPassProfile = null;
      _latestQualityIssue = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
