import 'collection_board_query.dart';
import 'collection_board_row.dart';
import 'collection_timeline.dart';

export 'collection_board_row.dart';

class CollectionKpi {
  const CollectionKpi({
    required this.equipmentCount,
    required this.connectedCount,
    required this.disconnectedCount,
    required this.errorCount,
    required this.receivedCount,
    required this.windowLabel,
    required this.lossRateAverage,
    required this.lossWarningCount,
    required this.syncedCount,
    required this.delayedCount,
    required this.unsyncedCount,
  });

  final int equipmentCount;
  final int connectedCount;
  final int disconnectedCount;
  final int errorCount;
  final int receivedCount;
  final String windowLabel;
  final double? lossRateAverage;
  final int lossWarningCount;
  final int syncedCount;
  final int delayedCount;
  final int unsyncedCount;
}

class CollectionFilterOptions {
  const CollectionFilterOptions({
    required this.projects,
    required this.workers,
    required this.lineNames,
    required this.equipments,
  });

  final List<({String projectId, String projectName})> projects;
  final List<({String workerId, String workerName})> workers;
  final List<String> lineNames;
  final List<({String equipmentId, String equipmentName})> equipments;
}

class CollectionBoard {
  const CollectionBoard({
    required this.query,
    required this.kpi,
    required this.rows,
    required this.options,
    required this.selectedEquipmentId,
    required this.timeline,
  });

  final CollectionBoardQuery query;
  final CollectionKpi kpi;
  final List<CollectionBoardRow> rows;
  final CollectionFilterOptions options;
  final String selectedEquipmentId;
  final CollectionTimeline timeline;

  CollectionBoardRow? get selectedRow {
    for (final row in rows) {
      if (row.equipmentId == selectedEquipmentId) {
        return row;
      }
    }
    return null;
  }
}
