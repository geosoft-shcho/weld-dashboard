import '../entities/job_draft.dart';
import '../entities/work_history_catalog.dart';
import '../entities/work_history_page.dart';
import '../entities/work_history_query.dart';

abstract class WorkHistoryRepository {
  /// 필터 드롭다운. 목록 행은 비운다.
  Future<WorkHistoryCatalog> loadMasters();

  /// [pageSize] <= 0 이면 next_page_token 이 빌 때까지 모두 받는다.
  Future<WorkHistoryPage> listPage({
    required WorkHistoryQuery query,
    required int pageSize,
    required String pageToken,
  });

  /// 마스터 + 필터 전체 행. 상세/로컬 소비자가 사용.
  Future<WorkHistoryCatalog> loadCatalog({WorkHistoryQuery? query});

  /// 작업(과 패스)을 만들고 새 `job_id`를 돌려준다.
  Future<String> createJob(JobDraft draft);
}
