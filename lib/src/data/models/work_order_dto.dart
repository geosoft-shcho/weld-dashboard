import '../../domain/entities/work_order.dart';

class WorkOrderDto {
  const WorkOrderDto({
    required this.workOrderId,
    required this.workOrderNo,
    required this.title,
  });

  factory WorkOrderDto.fromRow(Map<String, String> row) {
    return WorkOrderDto(
      workOrderId: row['work_order_id'] ?? '',
      workOrderNo: row['work_order_no'] ?? '',
      title: row['title'] ?? '',
    );
  }

  final String workOrderId;
  final String workOrderNo;
  final String title;

  WorkOrder toDomain() {
    return WorkOrder(
      workOrderId: workOrderId,
      workOrderNo: workOrderNo,
      title: title,
    );
  }
}
