import '../entities/work_attachment.dart';
import '../entities/work_detail_catalog.dart';

abstract class WorkDetailRepository {
  Future<WorkDetailCatalog> loadCatalog({String historyId = ''});

  /// 임시. 요청에 historyId 가 없어 전체 목록을 받은 뒤 호출 측에서 거른다.
  Future<List<WorkAttachment>> listAttachments();
}
