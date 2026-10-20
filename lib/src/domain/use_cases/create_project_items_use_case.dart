import '../entities/project_item_draft.dart';
import '../repositories/project_lookup_repository.dart';

class CreateProjectItemsUseCase {
  const CreateProjectItemsUseCase(this._repository);

  final ProjectLookupRepository _repository;

  Future<void> execute({
    required String projectId,
    required List<ProjectItemDraft> items,
  }) {
    return _repository.createProjectItems(projectId: projectId, items: items);
  }
}
