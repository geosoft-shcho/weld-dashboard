import '../entities/work_history_page.dart';
import '../entities/work_history_query.dart';
import '../repositories/work_history_repository.dart';

class ListWorkHistoryPageUseCase {
  ListWorkHistoryPageUseCase(this._repository);

  final WorkHistoryRepository _repository;

  Future<WorkHistoryPage> execute({
    required WorkHistoryQuery query,
    required int limit,
    required int offset,
  }) {
    return _repository.listPage(query: query, limit: limit, offset: offset);
  }
}
