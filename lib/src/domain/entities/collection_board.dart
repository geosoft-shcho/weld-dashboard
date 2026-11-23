import 'collection_board_query.dart';
import 'collection_board_row.dart';
import 'collection_summary.dart';
import 'collection_timeline.dart';
import 'connection_status.dart';

export 'collection_board_row.dart';

class CollectionKpi {
  const CollectionKpi({
    required this.summary,
    required this.runningTraceCount,
    required this.failedTraceCount,
  });

  static const empty = CollectionKpi(
    summary: CollectionSummary.empty,
    runningTraceCount: 0,
    failedTraceCount: 0,
  );

  final CollectionSummary summary;

  /// GetCollectionSummaryResponse.trace_running_count
  final int runningTraceCount;

  /// GetCollectionSummaryResponse.trace_failed_count
  final int failedTraceCount;
}

class CollectionFilterOptions {
  const CollectionFilterOptions({
    required this.projects,
    required this.workers,
    required this.lineNames,
    required this.equipments,
    this.connectionStatuses = const [],
  });

  final List<({String projectId, String projectName})> projects;
  final List<({String workerId, String workerName})> workers;
  final List<String> lineNames;
  final List<({String equipmentId, String equipmentName})> equipments;
  final List<ConnectionStatus> connectionStatuses;
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
