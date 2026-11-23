import '../entities/collected_node.dart';
import '../entities/collection_summary.dart';
import '../repositories/collection_catalog_repository.dart';

class GetCollectionSummaryUseCase {
  GetCollectionSummaryUseCase(this._repository);

  final CollectionCatalogRepository _repository;

  Future<CollectionSummaryLoad> execute({
    CollectedNodePath? parent,
    String workerId = '',
  }) {
    return _repository.getCollectionSummary(
      parent: parent,
      workerId: workerId,
    );
  }
}
