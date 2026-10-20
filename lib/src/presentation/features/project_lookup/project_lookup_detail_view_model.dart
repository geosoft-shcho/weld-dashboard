import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entities/project_item_draft.dart';
import '../../../domain/entities/work_history_project_filter.dart';
import '../../../domain/use_cases/create_project_items_use_case.dart';
import '../../../domain/use_cases/delete_project_item_use_case.dart';
import '../../../domain/use_cases/delete_project_use_case.dart';
import '../../../domain/use_cases/list_project_lookup_use_case.dart';
import '../../../domain/use_cases/update_project_item_use_case.dart';
import '../../../domain/use_cases/update_project_use_case.dart';

class ProjectLookupDetailViewModel extends ChangeNotifier {
  ProjectLookupDetailViewModel({
    required this.projectId,
    required ListProjectLookupUseCase listProjectLookupUseCase,
    required UpdateProjectUseCase updateProjectUseCase,
    required DeleteProjectUseCase deleteProjectUseCase,
    required CreateProjectItemsUseCase createProjectItemsUseCase,
    required UpdateProjectItemUseCase updateProjectItemUseCase,
    required DeleteProjectItemUseCase deleteProjectItemUseCase,
  }) : _listProjectLookupUseCase = listProjectLookupUseCase,
       _updateProjectUseCase = updateProjectUseCase,
       _deleteProjectUseCase = deleteProjectUseCase,
       _createProjectItemsUseCase = createProjectItemsUseCase,
       _updateProjectItemUseCase = updateProjectItemUseCase,
       _deleteProjectItemUseCase = deleteProjectItemUseCase;

  final String projectId;
  final ListProjectLookupUseCase _listProjectLookupUseCase;
  final UpdateProjectUseCase _updateProjectUseCase;
  final DeleteProjectUseCase _deleteProjectUseCase;
  final CreateProjectItemsUseCase _createProjectItemsUseCase;
  final UpdateProjectItemUseCase _updateProjectItemUseCase;
  final DeleteProjectItemUseCase _deleteProjectItemUseCase;

  WorkHistoryProjectFilter? _project;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  WorkHistoryProjectFilter? get project => _project;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> updateBasicInfo({
    required String projectName,
    required String siteName,
    required String customer,
  }) async {
    final current = _project;
    if (current == null) {
      return;
    }
    final changedFields = [
      if (projectName != current.projectName) 'project_name',
      if (siteName != current.siteName) 'site_name',
      if (customer != current.customer) 'customer',
    ];
    if (changedFields.isEmpty) {
      throw ArgumentError('바뀐 칸이 없습니다.');
    }
    await _updateProjectUseCase.execute(
      projectId: projectId,
      projectName: projectName,
      siteName: siteName,
      customer: customer,
      changedFields: changedFields,
    );
    await load();
  }

  Future<void> deleteProject() async {
    await _deleteProjectUseCase.execute(projectId: projectId);
  }

  Future<void> addItems(List<ProjectItemDraft> items) async {
    await _createProjectItemsUseCase.execute(
      projectId: projectId,
      items: items,
    );
    await load();
  }

  Future<void> renameItem({
    required String projectItemId,
    required String itemName,
  }) async {
    await _updateProjectItemUseCase.execute(
      projectItemId: projectItemId,
      itemName: itemName,
    );
    await load();
  }

  Future<void> deleteItem({required String projectItemId}) async {
    await _deleteProjectItemUseCase.execute(projectItemId: projectItemId);
    await load();
  }

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
