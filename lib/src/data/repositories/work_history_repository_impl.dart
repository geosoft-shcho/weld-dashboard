import '../../domain/entities/equipment.dart';
import '../../domain/entities/joint.dart';
import '../../domain/entities/work_history_catalog.dart';
import '../../domain/entities/work_history_item.dart';
import '../../domain/entities/work_order.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/work_history_repository.dart';
import '../datasources/local/csv_asset_data_source.dart';
import '../models/equipment_dto.dart';
import '../models/joint_dto.dart';
import '../models/work_history_record_dto.dart';
import '../models/work_order_dto.dart';
import '../models/worker_dto.dart';

class WorkHistoryRepositoryImpl implements WorkHistoryRepository {
  WorkHistoryRepositoryImpl(this._csvAssetDataSource);

  final CsvAssetDataSource _csvAssetDataSource;

  @override
  Future<WorkHistoryCatalog> loadCatalog() async {
    final workOrderRows = await _csvAssetDataSource.loadWorkOrderRows();
    final jointRows = await _csvAssetDataSource.loadJointRows();
    final workerRows = await _csvAssetDataSource.loadWorkerRows();
    final equipmentRows = await _csvAssetDataSource.loadEquipmentRows();
    final historyRows = await _csvAssetDataSource.loadWorkHistoryRows();
    final passRows = await _csvAssetDataSource.loadPassRows();
    final attachmentRows = await _csvAssetDataSource.loadWorkAttachmentRows();
    final workOrders = [
      for (final row in workOrderRows) WorkOrderDto.fromRow(row).toDomain(),
    ];
    final joints = [
      for (final row in jointRows) JointDto.fromRow(row).toDomain(),
    ];
    final workers = [
      for (final row in workerRows) WorkerDto.fromRow(row).toDomain(),
    ];
    final equipments = [
      for (final row in equipmentRows) EquipmentDto.fromRow(row).toDomain(),
    ];
    final workOrdersById = {
      for (final workOrder in workOrders) workOrder.workOrderId: workOrder,
    };
    final jointsById = {for (final joint in joints) joint.jointId: joint};
    final workersById = {for (final worker in workers) worker.workerId: worker};
    final equipmentsById = {
      for (final equipment in equipments) equipment.equipmentId: equipment,
    };
    final passCountsByCommonKey = <String, int>{};
    for (final row in passRows) {
      final commonKey = row['common_key'] ?? '';
      if (commonKey.isEmpty) {
        continue;
      }
      passCountsByCommonKey[commonKey] =
          (passCountsByCommonKey[commonKey] ?? 0) + 1;
    }
    final attachmentCountsByHistoryId = <String, int>{};
    for (final row in attachmentRows) {
      final historyId = row['history_id'] ?? '';
      if (historyId.isEmpty) {
        continue;
      }
      attachmentCountsByHistoryId[historyId] =
          (attachmentCountsByHistoryId[historyId] ?? 0) + 1;
    }
    final items = [
      for (final row in historyRows)
        _itemFrom(
          WorkHistoryRecordDto.fromRow(row),
          workOrdersById: workOrdersById,
          jointsById: jointsById,
          workersById: workersById,
          equipmentsById: equipmentsById,
          passCountsByCommonKey: passCountsByCommonKey,
          attachmentCountsByHistoryId: attachmentCountsByHistoryId,
        ),
    ];
    return WorkHistoryCatalog(
      items: items,
      workOrders: workOrders,
      joints: joints,
      workers: workers,
      equipments: equipments,
    );
  }

  WorkHistoryItem _itemFrom(
    WorkHistoryRecordDto record, {
    required Map<String, WorkOrder> workOrdersById,
    required Map<String, Joint> jointsById,
    required Map<String, Worker> workersById,
    required Map<String, Equipment> equipmentsById,
    required Map<String, int> passCountsByCommonKey,
    required Map<String, int> attachmentCountsByHistoryId,
  }) {
    final workOrder = workOrdersById[record.workOrderId];
    final joint = jointsById[record.jointId];
    final worker = workersById[record.workerId];
    final equipment = equipmentsById[record.equipmentId];
    return WorkHistoryItem(
      historyId: record.historyId,
      commonKey: record.commonKey,
      workOrderId: record.workOrderId,
      workOrderNo: workOrder?.workOrderNo ?? record.workOrderId,
      title: workOrder?.title ?? '',
      jointId: record.jointId,
      jointNo: joint?.jointNo ?? record.jointId,
      jointName: joint?.jointName ?? '',
      workerId: record.workerId,
      workerName: worker?.workerName ?? record.workerId,
      equipmentId: record.equipmentId,
      equipmentName: equipment?.equipmentName ?? record.equipmentId,
      workedAt: record.workedAt,
      passCount: passCountsByCommonKey[record.commonKey] ?? 0,
      attachmentCount: attachmentCountsByHistoryId[record.historyId] ?? 0,
    );
  }
}
