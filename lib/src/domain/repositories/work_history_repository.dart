import '../entities/work_history_catalog.dart';
import '../entities/work_history_page.dart';
import '../entities/work_history_query.dart';

abstract class WorkHistoryRepository {
  /// 드롭다운 마스터(작업지시·조인트·작업자·장비). 목록 행은 비운다.
  Future<WorkHistoryCatalog> loadMasters();

  /// 서버(또는 동등 시뮬) 페이지. [limit] <= 0 이면 필터 전체.
  Future<WorkHistoryPage> listPage({
    required WorkHistoryQuery query,
    required int limit,
    required int offset,
  });

  /// 마스터 + 필터 전체 행(limit 없음). 상세/로컬 소비자가 사용.
  Future<WorkHistoryCatalog> loadCatalog({WorkHistoryQuery? query});
}
