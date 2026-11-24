import 'package:flutter/material.dart';
import 'package:neon_timeline_flutter/timeline_v16.dart' hide TimelineViewKind;

import '../../../../domain/entities/collection_board_query.dart';
import '../../../../domain/entities/collection_event.dart';
import '../../../../domain/entities/collection_resource_depth.dart';
import '../../../../domain/entities/collection_timeline_resource.dart';
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
    if (entry.isPoint) {
      return entry.eventAt.add(const Duration(minutes: 1));
    }
    final endedAt = entry.endedAt;
    if (!endedAt.isAfter(entry.eventAt)) {
      return entry.eventAt.add(const Duration(seconds: 1));
    }
    return endedAt;
  }

  @override
  NeonPlannerEntryPresentation presentationOf(CollectionEvent entry) {
    final title = entry.isPoint
        ? _pointTitle(entry)
        : '${entry.connectionStatus.label} · ${entry.windowLabel}';
    return NeonPlannerEntryPresentation(
      title: title,
      subtitle: entry.equipmentName,
      metadata:
          '수신 ${DashboardFormatters.count(entry.receivedCount)} · 유실 ${DashboardFormatters.percent(entry.lossRatePercent)}',
      semanticLabel: _semanticLabel(entry),
      icon: entry.isPoint ? Icons.diamond : Icons.sensors,
      kind: NeonPlannerEntryKind.standard,
      accentColor: CollectionEventTimelineMapper.colorOf(entry),
    );
  }

  static String _pointTitle(CollectionEvent entry) {
    final windowLabel = entry.windowLabel.trim();
    if (windowLabel.isEmpty || windowLabel == entry.equipmentName) {
      return '◆';
    }
    return '◆ $windowLabel';
  }

  static String _semanticLabel(CollectionEvent entry) {
    final windowLabel = entry.windowLabel.trim();
    final doesRepeatName =
        windowLabel.isEmpty || windowLabel == entry.equipmentName;
    if (entry.isPoint) {
      return doesRepeatName
          ? '${entry.equipmentName} 점'
          : '${entry.equipmentName} 점 $windowLabel';
    }
    if (doesRepeatName) {
      return '${entry.equipmentName} ${entry.connectionStatus.label}';
    }
    return '${entry.equipmentName} ${entry.connectionStatus.label} $windowLabel';
  }
}

class CollectionEventTimelineMapper {
  static const CollectionEventPlannerAdapter PLANNER_ADAPTER =
      CollectionEventPlannerAdapter();

  static const double HOUR_PX = 48;

  /// API summary.asset_count / asset 유무로만 정한 수집·기록 없음 색.
  static Color colorOf(CollectionEvent event) {
    switch (event.connectionStatus) {
      case ConnectionStatus.connected:
        return AppTheme.STATUS_OK;
      case ConnectionStatus.disconnected:
      case ConnectionStatus.error:
        // 기록 없음: 어두운 캔버스에서 회색보다 잘 보이게.
        return AppTheme.STATUS_WARN;
    }
  }

  static TimelineStatus statusOf(CollectionEvent event) {
    if (event.connectionStatus == ConnectionStatus.connected) {
      return TimelineStatus.active;
    }
    return TimelineStatus.disabled;
  }

  static TimelineEntry<CollectionEvent> entryOf(
    CollectionEvent event, {
    required String resourceId,
  }) {
    // 점(길이 0)도 레이아웃용으로 1분 폭을 쓰되, 표시는 ◆로 구분한다.
    final duration = event.isPoint
        ? const Duration(minutes: 1)
        : Duration(seconds: event.durationSec < 1 ? 1 : event.durationSec);
    return TimelineEntry<CollectionEvent>(
      id: event.eventId,
      value: event,
      start: event.eventAt,
      duration: duration,
      status: statusOf(event),
      color: colorOf(event),
      semanticLabel: CollectionEventPlannerAdapter._semanticLabel(event),
      draggable: false,
      resourceIds: {resourceId},
    );
  }

  static TimelineResource resourceOf(CollectionTimelineResource resource) {
    return TimelineResource(
      id: resource.resourceId,
      label: resource.label,
      subtitle: resource.subtitle,
    );
  }

  static double columnWidthOf(CollectionResourceDepth depth) {
    return depth == CollectionResourceDepth.equipment ? 176 : 220;
  }

  static double pixelsPerMinute(double zoomHours) {
    final hours = zoomHours <= 0 ? 24.0 : zoomHours;
    return (HOUR_PX * (24 / hours)) / 60;
  }

  /// Fits the time canvas to [canvasBudget] when wider than zoom density.
  ///
  /// `max(zoomPpm, fitPpm)`: stretch to remove empty viewport space; keep
  /// zoom-in scroll when zoom density already exceeds the budget.
  static double pixelsPerMinuteForViewport({
    required double zoomHours,
    required double canvasBudget,
    required int startHour,
    required int endHour,
  }) {
    final zoomPpm = pixelsPerMinute(zoomHours);
    if (!canvasBudget.isFinite || canvasBudget <= 0) {
      return zoomPpm;
    }
    final rangeMinutes = _rangeMinutes(startHour: startHour, endHour: endHour);
    final fitPpm = canvasBudget / rangeMinutes;
    return zoomPpm >= fitPpm ? zoomPpm : fitPpm;
  }

  static int rangeMinutesOf({required int startHour, required int endHour}) {
    return _rangeMinutes(startHour: startHour, endHour: endHour);
  }

  static int _rangeMinutes({required int startHour, required int endHour}) {
    final span = (endHour - startHour) * 60;
    return span < 1 ? 1 : span;
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
