import '../../domain/entities/equipment.dart';
import '../../domain/entities/joint.dart';
import '../../domain/entities/work_history_catalog.dart';
import '../../domain/entities/work_history_page.dart';
import '../../domain/entities/work_history_query.dart';
import '../../domain/entities/work_history_item.dart';
import '../../domain/entities/work_order.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/work_history_repository.dart';
import '../datasources/generated/dashboard_service.pb.dart' as pb;
import '../datasources/remote/dashboard_service_data_source.dart';

class RemoteWorkHistoryRepository implements WorkHistoryRepository {
  RemoteWorkHistoryRepository(this._source);

  final DashboardServiceDataSource _source;

  @override
  Future<WorkHistoryCatalog> loadMasters() async {
    final workOrders = await _source.client.listWorkOrders(
      pb.ListWorkOrdersRequest(),
    );
    final joints = await _source.client.listJoints(pb.ListJointsRequest());
    final workers = await _source.client.listWorkers(pb.ListWorkersRequest());
    final equipments = await _source.client.listEquipment(
      pb.ListEquipmentRequest(),
    );
    return WorkHistoryCatalog(
      items: const [],
      workOrders: [
        for (final item in workOrders.items)
          WorkOrder(
            workOrderId: item.workOrderId,
            workOrderNo: item.workOrderNo,
            title: item.title,
          ),
      ],
      joints: [
        for (final item in joints.items)
          Joint(
            jointId: item.jointId,
            jointNo: item.jointNo,
            jointName: item.name,
            workOrderId: item.workOrderId,
          ),
      ],
      workers: [
        for (final item in workers.items)
          Worker(workerId: item.workerId, workerName: item.workerName),
      ],
      equipments: [
        for (final item in equipments.items)
          Equipment(
            equipmentId: item.equipmentId,
            equipmentName: item.equipmentName,
            lineName: item.lineName,
          ),
      ],
    );
  }

  @override
  Future<WorkHistoryPage> listPage({
    required WorkHistoryQuery query,
    required int limit,
    required int offset,
  }) async {
    final response = await _source.client.listWorkHistory(
      _request(query, limit: limit, offset: offset),
    );
    return WorkHistoryPage(
      items: [for (final item in response.items) workHistoryItemFrom(item)],
      totalCount: response.totalCount,
    );
  }

  @override
  Future<WorkHistoryCatalog> loadCatalog({WorkHistoryQuery? query}) async {
    final masters = await loadMasters();
    final page = await listPage(
      query: query ?? WorkHistoryQuery.initial(),
      limit: 0,
      offset: 0,
    );
    return WorkHistoryCatalog(
      items: page.items,
      workOrders: masters.workOrders,
      joints: masters.joints,
      workers: masters.workers,
      equipments: masters.equipments,
    );
  }

  pb.ListWorkHistoryRequest _request(
    WorkHistoryQuery query, {
    required int limit,
    required int offset,
  }) {
    return pb.ListWorkHistoryRequest(
      commonKey: query.commonKey,
      workOrderId: query.workOrderId,
      jointId: query.jointId,
      workerId: query.workerId,
      equipmentId: query.equipmentId,
      from: query.fromDate == null ? '' : _date(query.fromDate!),
      to: query.toDate == null ? '' : _date(query.toDate!),
      limit: limit,
      offset: offset,
    );
  }

  String _date(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

WorkHistoryItem workHistoryItemFrom(pb.WorkHistory item) {
  return WorkHistoryItem(
    historyId: item.historyId,
    commonKey: item.commonKey,
    workOrderId: item.workOrderId,
    workOrderNo: item.workOrderNo,
    title: item.title,
    jointId: item.jointId,
    jointNo: item.jointNo,
    jointName: item.jointName,
    workerId: item.workerId,
    workerName: item.workerName,
    equipmentId: item.equipmentId,
    equipmentName: item.equipmentName,
    workedAt: DateTime.parse(item.workedAt),
    passCount: item.passCount,
    attachmentCount: item.attachmentCount,
  );
}
