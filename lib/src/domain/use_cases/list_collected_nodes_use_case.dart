import '../entities/collected_node.dart';
import '../repositories/collection_catalog_repository.dart';

class ListCollectedNodesUseCase {
  ListCollectedNodesUseCase(this._repository);

  final CollectionCatalogRepository _repository;

  Future<List<CollectedNode>> execute(
    CollectedNodePath parent, {
    DateTime? from,
    DateTime? to,
    CollectedTimeBasis basis = CollectedTimeBasis.work,
    CollectedSegmentUnit segmentUnit = CollectedSegmentUnit.job,
    String workerId = '',
  }) {
    return _repository.listCollectedNodes(
      parent,
      from: from,
      to: to,
      basis: basis,
      segmentUnit: segmentUnit,
      workerId: workerId,
    );
  }
}
