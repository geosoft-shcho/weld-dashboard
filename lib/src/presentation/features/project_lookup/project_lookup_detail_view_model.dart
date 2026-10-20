import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/work_history_project_filter.dart';
import '../../../domain/use_cases/list_project_lookup_use_case.dart';

class ProjectLookupDetailViewModel extends ChangeNotifier {
  ProjectLookupDetailViewModel({
    required this.projectId,
    required ListProjectLookupUseCase listProjectLookupUseCase,
  }) : _listProjectLookupUseCase = listProjectLookupUseCase;

  final String projectId;
  final ListProjectLookupUseCase _listProjectLookupUseCase;

  WorkHistoryProjectFilter? _project;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  WorkHistoryProjectFilter? get project => _project;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      WorkHistoryProjectFilter? match;
      var token = '';
      do {
        final page = await _listProjectLookupUseCase.execute(pageToken: token);
        for (final project in page.items) {
          if (project.projectId == projectId) {
            match = project;
            break;
          }
        }
        if (match != null) {
          break;
        }
        token = page.nextPageToken;
      } while (token.isNotEmpty);
      _project = match;
      if (match == null) {
        _hasError = true;
        _errorMessage = '공사를 찾지 못했습니다.';
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = error.toString();
      _project = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
