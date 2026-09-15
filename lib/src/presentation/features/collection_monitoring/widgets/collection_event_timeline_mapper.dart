import 'package:flutter/material.dart';
import 'package:neon_timeline_flutter/timeline_v16.dart' hide TimelineViewKind;

import '../../../../domain/entities/collection_board_query.dart';
import '../../../../domain/entities/collection_board_row.dart';
import '../../../../domain/entities/collection_event.dart';
import '../../../../domain/entities/connection_status.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart' show AppTheme;

class CollectionEventPlannerAdapter
    extends NeonPlannerEntryAdapter<CollectionEvent> {
  const CollectionEventPlannerAdapter();

  @override
  Object idOf(CollectionEvent entry) => entry.eventId;

  @override
  DateTime startOf(CollectionEvent entry) => entry.eventAt;

  @override
  DateTime endOf(CollectionEvent entry) {
    final endedAt = entry.endedAt;
    if (!endedAt.isAfter(entry.eventAt)) {
      return entry.eventAt.add(const Duration(seconds: 1));
    }
    return endedAt;
  }

  @override
  NeonPlannerEntryPresentation presentationOf(CollectionEvent entry) {
    return NeonPlannerEntryPresentation(
      title: '${entry.connectionStatus.label} · ${entry.windowLabel}',
      subtitle: entry.equipmentName,
      metadata:
          '수신 ${DashboardFormatters.count(entry.receivedCount)} · 유실 ${DashboardFormatters.percent(entry.lossRatePercent)}',
      semanticLabel:
          '${entry.equipmentName} ${entry.connectionStatus.label} ${entry.windowLabel}',
      icon: Icons.sensors,
      kind: NeonPlannerEntryKind.standard,
      accentColor: CollectionEventTimelineMapper.colorOf(entry),
    );
  }
}

class CollectionEventTimelineMapper {
  static const CollectionEventPlannerAdapter PLANNER_ADAPTER =
      CollectionEventPlannerAdapter();

  static const double HOUR_PX = 48;

  static Color colorOf(CollectionEvent event) {
    if (event.isLossWarning) {
      return AppTheme.STATUS_WARN;
    }
    if (event.isDesynced) {
      return AppTheme.STATUS_DESYNC;
    }
    switch (event.connectionStatus) {
      case ConnectionStatus.connected:
        return AppTheme.STATUS_OK;
      case ConnectionStatus.disconnected:
        return AppTheme.STATUS_OFF;
      case ConnectionStatus.error:
        return AppTheme.STATUS_ERROR;
    }
  }

  static TimelineStatus statusOf(CollectionEvent event) {
    if (event.connectionStatus == ConnectionStatus.error ||
        event.isLossWarning) {
      return TimelineStatus.error;
    }
    if (event.connectionStatus == ConnectionStatus.disconnected) {
      return TimelineStatus.disabled;
    }
    if (event.isDesynced) {
      return TimelineStatus.pending;
    }
    return TimelineStatus.active;
  }

  static TimelineEntry<CollectionEvent> entryOf(CollectionEvent event) {
    final durationSec = event.durationSec < 1 ? 1 : event.durationSec;
    return TimelineEntry<CollectionEvent>(
      id: event.eventId,
      value: event,
      start: event.eventAt,
      duration: Duration(seconds: durationSec),
      status: statusOf(event),
      color: colorOf(event),
      semanticLabel:
          '${event.equipmentName} ${event.connectionStatus.label} ${event.windowLabel}',
      draggable: false,
      resourceIds: {event.equipmentId},
    );
  }

  static TimelineResource resourceOf(CollectionBoardRow row) {
    return TimelineResource(
      id: row.equipmentId,
      label: row.equipmentName,
      subtitle: '${row.equipmentId} · ${row.lineName}',
    );
  }

  static double pixelsPerMinute(double zoomHours) {
    final hours = zoomHours <= 0 ? 24.0 : zoomHours;
    return (HOUR_PX * (24 / hours)) / 60;
  }

  static int startHourOf(CollectionBoardQuery query) {
    return (query.startMinutes ~/ 60).clamp(0, 23);
  }

  static int endHourOf(CollectionBoardQuery query) {
    final start = startHourOf(query);
    final end = ((query.endMinutes + 59) ~/ 60).clamp(start + 1, 24);
    return end;
  }
}
