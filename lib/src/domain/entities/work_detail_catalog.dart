import 'work_attachment.dart';
import 'work_history_item.dart';

class WorkDetailCatalog {
  const WorkDetailCatalog({required this.items, required this.attachments});

  final List<WorkHistoryItem> items;
  final List<WorkAttachment> attachments;
}
