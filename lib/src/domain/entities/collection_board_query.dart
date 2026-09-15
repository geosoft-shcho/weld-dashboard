import 'connection_status.dart';
import 'kpi_card_kind.dart';
import 'timeline_view_kind.dart';

class CollectionBoardQuery {
  const CollectionBoardQuery({
    required this.selectedDate,
    required this.startMinutes,
    required this.endMinutes,
    required this.snapshotAt,
    required this.projectIds,
    required this.isUnassignedOnly,
    required this.workerIds,
    required this.lineNames,
    required this.equipmentIds,
    required this.connectionStatuses,
    required this.selectedKpiCard,
    required this.doesShowDisconnectedOrErrorOnly,
    required this.refreshIntervalSeconds,
    required this.selectedEquipmentId,
    required this.viewKind,
    required this.zoomHours,
    required this.selectedEventId,
  });

  static final DateTime DEFAULT_SNAPSHOT_AT = DateTime(2026, 9, 7, 9, 50);

  factory CollectionBoardQuery.initial() {
    return CollectionBoardQuery(
      selectedDate: DateTime(2026, 9, 7),
      startMinutes: 0,
      endMinutes: 1440,
      snapshotAt: DEFAULT_SNAPSHOT_AT,
      projectIds: const [],
      isUnassignedOnly: false,
      workerIds: const [],
      lineNames: const [],
      equipmentIds: const [],
      connectionStatuses: const [],
      selectedKpiCard: KpiCardKind.none,
      doesShowDisconnectedOrErrorOnly: false,
      refreshIntervalSeconds: 0,
      selectedEquipmentId: '',
      viewKind: TimelineViewKind.auto,
      zoomHours: 24,
      selectedEventId: '',
    );
  }

  final DateTime selectedDate;
  final int startMinutes;
  final int endMinutes;
  final DateTime snapshotAt;
  final List<String> projectIds;
  final bool isUnassignedOnly;
  final List<String> workerIds;
  final List<String> lineNames;
  final List<String> equipmentIds;
  final List<ConnectionStatus> connectionStatuses;
  final KpiCardKind selectedKpiCard;
  final bool doesShowDisconnectedOrErrorOnly;
  final int refreshIntervalSeconds;
  final String selectedEquipmentId;
  final TimelineViewKind viewKind;
  final double zoomHours;
  final String selectedEventId;

  bool get doesHaveInvalidTimeRange => startMinutes >= endMinutes;

  CollectionBoardQuery copyWith({
    DateTime? selectedDate,
    int? startMinutes,
    int? endMinutes,
    DateTime? snapshotAt,
    List<String>? projectIds,
    bool? isUnassignedOnly,
    List<String>? workerIds,
    List<String>? lineNames,
    List<String>? equipmentIds,
    List<ConnectionStatus>? connectionStatuses,
    KpiCardKind? selectedKpiCard,
    bool? doesShowDisconnectedOrErrorOnly,
    int? refreshIntervalSeconds,
    String? selectedEquipmentId,
    TimelineViewKind? viewKind,
    double? zoomHours,
    String? selectedEventId,
  }) {
    return CollectionBoardQuery(
      selectedDate: selectedDate ?? this.selectedDate,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      snapshotAt: snapshotAt ?? this.snapshotAt,
      projectIds: projectIds ?? this.projectIds,
      isUnassignedOnly: isUnassignedOnly ?? this.isUnassignedOnly,
      workerIds: workerIds ?? this.workerIds,
      lineNames: lineNames ?? this.lineNames,
      equipmentIds: equipmentIds ?? this.equipmentIds,
      connectionStatuses: connectionStatuses ?? this.connectionStatuses,
      selectedKpiCard: selectedKpiCard ?? this.selectedKpiCard,
      doesShowDisconnectedOrErrorOnly:
          doesShowDisconnectedOrErrorOnly ??
          this.doesShowDisconnectedOrErrorOnly,
      refreshIntervalSeconds:
          refreshIntervalSeconds ?? this.refreshIntervalSeconds,
      selectedEquipmentId: selectedEquipmentId ?? this.selectedEquipmentId,
      viewKind: viewKind ?? this.viewKind,
      zoomHours: zoomHours ?? this.zoomHours,
      selectedEventId: selectedEventId ?? this.selectedEventId,
    );
  }
}
