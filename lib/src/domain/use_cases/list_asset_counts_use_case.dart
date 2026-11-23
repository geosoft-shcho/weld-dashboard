import '../entities/collected_node.dart';
import '../entities/collection_summary.dart';
import '../repositories/collection_catalog_repository.dart';

class ListAssetCountsUseCase {
  ListAssetCountsUseCase(this._repository);

  final CollectionCatalogRepository _repository;

  Future<List<AssetCountRow>> execute({
    CollectedNodePath? parent,
    String workerId = '',
    AssetCountTimeBasis basis = AssetCountTimeBasis.collected,
    DateTime? from,
    DateTime? to,
  }) {
    return _repository.listAssetCounts(
      parent: parent,
      workerId: workerId,
      basis: basis,
      from: from,
      to: to,
    );
  }
}
