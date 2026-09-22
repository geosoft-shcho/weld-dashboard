import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/collection_board.dart';
import '../../../../domain/entities/connection_status.dart';
import '../../../../domain/entities/time_sync_status.dart';
import '../../../core/formatters/dashboard_formatters.dart';
import '../../../core/themes/app_theme.dart';
import '../../../navigation/app_coordinator.dart';
import '../collection_monitoring_view_model.dart';

class CollectionStatusTable extends StatefulWidget {
  const CollectionStatusTable({
    super.key,
    required this.viewModel,
    required this.board,
  });

  final CollectionMonitoringViewModel viewModel;
  final CollectionBoard board;

  @override
  State<CollectionStatusTable> createState() => _CollectionStatusTableState();
}

class _CollectionStatusTableState extends State<CollectionStatusTable> {
  static const Duration _doubleTapWindow = Duration(milliseconds: 400);

  String? _lastTapEquipmentId;
  DateTime? _lastTapAt;

  CollectionMonitoringViewModel get viewModel => widget.viewModel;
  CollectionBoard get board => widget.board;

  /// 첫 탭이 선택+rebuild를 일으켜 GestureDetector onDoubleTap이 끊기므로
  /// State에 시각을 두고 직접 더블클릭을 판정한다.
  void _didTapRow(String equipmentId) {
    final now = DateTime.now();
    final isDoubleTap =
        _lastTapEquipmentId == equipmentId &&
        _lastTapAt != null &&
        now.difference(_lastTapAt!) < _doubleTapWindow;
    if (isDoubleTap) {
      _lastTapEquipmentId = null;
      _lastTapAt = null;
      context.read<AppCoordinator>().didTapOpenWorkHistory(
        equipmentId: equipmentId,
      );
      return;
    }
    _lastTapEquipmentId = equipmentId;
    _lastTapAt = now;
    viewModel.didSelectRow(equipmentId);
  }

  @override
  Widget build(BuildContext context) {
    final query = viewModel.query;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                '실시간 수집 상태 · 스냅샷 ${DashboardFormatters.snapshot(query.snapshotAt)} · 창 ${board.kpi.windowLabel}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Checkbox(
              checked: query.doesShowDisconnectedOrErrorOnly,
              content: const Text('단절/오류만', style: TextStyle(fontSize: 12)),
              onChanged: (value) {
                viewModel.didToggleDisconnectedOrErrorOnly(value == true);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (board.rows.isEmpty)
          const InfoBar(
            title: Text('조건에 맞는 장비가 없습니다'),
            severity: InfoBarSeverity.warning,
          )
        else
          Table(
            border: TableBorder.all(color: const Color(0xFF3E424A)),
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.4),
              3: FlexColumnWidth(1.2),
              4: FlexColumnWidth(1.4),
              5: FlexColumnWidth(1.6),
            },
            children: [
              const TableRow(
                children: [
                  _HeaderCell('장비'),
                  _HeaderCell('연결 상태'),
                  _HeaderCell('데이터 수신 건수'),
                  _HeaderCell('유실률'),
                  _HeaderCell('시각 동기 상태'),
                  _HeaderCell('마지막 수신'),
                ],
              ),
              for (final row in board.rows) _dataRow(row),
            ],
          ),
        const SizedBox(height: 8),
        Text(
          '전체 장비 ${DashboardFormatters.count(board.kpi.equipmentCount)} · 연결 ${DashboardFormatters.count(board.kpi.connectedCount)} · 단절/오류 ${DashboardFormatters.count(board.kpi.disconnectedCount + board.kpi.errorCount)}',
        ),
      ],
    );
  }

  TableRow _dataRow(CollectionBoardRow row) {
    final isSelected = row.equipmentId == board.selectedEquipmentId;
    final background = isSelected
        ? AppTheme.ACCENT_STEEL.withValues(alpha: 0.18)
        : row.isDisconnectedOrError
        ? const Color(0xFF0C0D10)
        : const Color(0x00000000);
    void onPressed() => _didTapRow(row.equipmentId);

    return TableRow(
      decoration: BoxDecoration(color: background),
      children: [
        _TapCell(
          onPressed: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(row.equipmentName),
              Text(
                '${row.equipmentId} · ${row.lineName}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF8E949E)),
              ),
            ],
          ),
        ),
        _TapCell(
          onPressed: onPressed,
          child: Text(
            row.connectionStatus.label,
            style: TextStyle(color: _connectionColor(row.connectionStatus)),
          ),
        ),
        _TapCell(
          onPressed: onPressed,
          child: Text(
            '${DashboardFormatters.count(row.receivedCount)}  ${row.windowLabel}',
          ),
        ),
        _TapCell(
          onPressed: onPressed,
          child: Text(
            row.lossRatePercent == null
                ? '— 산출 불가'
                : DashboardFormatters.percent(row.lossRatePercent),
            style: TextStyle(
              fontWeight: row.isLossWarning ? FontWeight.w700 : FontWeight.w400,
              color: row.isLossWarning ? AppTheme.STATUS_WARN : null,
            ),
          ),
        ),
        _TapCell(
          onPressed: onPressed,
          child: Text(
            '${row.timeSyncStatus.label}${row.clockOffsetMs == null ? '' : ' (${row.clockOffsetMs}ms)'}',
            style: TextStyle(
              color: row.timeSyncStatus == TimeSyncStatus.synced
                  ? null
                  : AppTheme.STATUS_DESYNC,
            ),
          ),
        ),
        _TapCell(
          onPressed: onPressed,
          child: Text(DashboardFormatters.dateTime(row.lastReceivedAt)),
        ),
      ],
    );
  }

  Color _connectionColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return AppTheme.STATUS_OK;
      case ConnectionStatus.disconnected:
        return AppTheme.STATUS_OFF;
      case ConnectionStatus.error:
        return AppTheme.STATUS_ERROR;
    }
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _TapCell extends StatelessWidget {
  const _TapCell({required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Padding(padding: const EdgeInsets.all(8), child: child),
    );
  }
}
