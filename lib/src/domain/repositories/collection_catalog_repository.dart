import '../entities/collected_node.dart';
import '../entities/collection_catalog.dart';
import '../entities/collection_board_query.dart';

abstract class CollectionCatalogRepository {
  Future<CollectionCatalog> loadCatalog({CollectionBoardQuery? query});

  Future<List<CollectedNode>> listCollectedNodes(
    CollectedNodePath parent, {
    int? startOffsetNs,
    int? endOffsetNs,
    CollectedTimeBasis basis = CollectedTimeBasis.work,
  });
}
