import '../entities/work_attachment.dart';
import '../entities/work_detail_catalog.dart';

abstract class WorkDetailRepository {
  Future<WorkDetailCatalog> loadCatalog({String jobId = ''});

  /// [jobId]가 비어 있으면 첨부를 조회하지 않는다.
  Future<List<WorkAttachment>> listAttachments({String jobId = ''});

  /// 작업의 공사 번호. 없거나 0이면 빈 문자열.
  Future<String> loadProjectId({required String jobId});
}
