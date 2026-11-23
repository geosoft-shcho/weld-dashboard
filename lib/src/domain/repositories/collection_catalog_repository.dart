import '../entities/collected_node.dart';
import '../entities/collection_catalog.dart';
import '../entities/collection_board_query.dart';
import '../entities/collection_summary.dart';

abstract class CollectionCatalogRepository {
  Future<CollectionCatalog> loadCatalog({CollectionBoardQuery? query});

  Future<List<CollectedNode>> listCollectedNodes(
    CollectedNodePath parent, {
    int? startOffsetNs,
    int? endOffsetNs,
    CollectedTimeBasis basis = CollectedTimeBasis.work,
    CollectedSegmentUnit segmentUnit = CollectedSegmentUnit.job,
    String workerId = '',
  });

  Future<CollectionSummaryLoad> getCollectionSummary({
    CollectedNodePath? parent,
    String workerId = '',
  });

  Future<List<AssetCountRow>> listAssetCounts({
    CollectedNodePath? parent,
    String workerId = '',
    AssetCountTimeBasis basis = AssetCountTimeBasis.collected,
    DateTime? from,
    DateTime? to,
  });
}
