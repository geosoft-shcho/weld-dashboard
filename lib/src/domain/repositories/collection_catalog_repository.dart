import '../entities/collected_node.dart';
import '../entities/collection_catalog.dart';
import '../entities/collection_board_query.dart';
import '../entities/collection_summary.dart';

abstract class CollectionCatalogRepository {
  Future<CollectionCatalog> loadCatalog({CollectionBoardQuery? query});

  Future<List<CollectedNode>> listCollectedNodes(
    CollectedNodePath parent, {
    DateTime? from,
    DateTime? to,
    CollectedTimeBasis basis = CollectedTimeBasis.work,
    CollectedSegmentUnit segmentUnit = CollectedSegmentUnit.job,
    String workerId = '',
  });

  Future<CollectionSummaryLoad> getCollectionSummary({
    CollectedNodePath? parent,
    String workerId = '',
    DateTime? from,
    DateTime? to,
  });

  Future<List<AssetCountRow>> listAssetCounts({
    CollectedNodePath? parent,
    String workerId = '',
    AssetCountTimeBasis basis = AssetCountTimeBasis.collected,
    DateTime? from,
    DateTime? to,
  });
}
