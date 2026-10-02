import '../entities/collected_node.dart';
import '../repositories/collection_catalog_repository.dart';

class ListCollectedNodesUseCase {
  ListCollectedNodesUseCase(this._repository);

  final CollectionCatalogRepository _repository;

  Future<List<CollectedNode>> execute(
    CollectedNodePath parent, {
    int? startOffsetNs,
    int? endOffsetNs,
    CollectedTimeBasis basis = CollectedTimeBasis.work,
  }) {
    return _repository.listCollectedNodes(
      parent,
      startOffsetNs: startOffsetNs,
      endOffsetNs: endOffsetNs,
      basis: basis,
    );
  }
}
