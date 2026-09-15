import '../entities/work_detail_catalog.dart';

abstract class WorkDetailRepository {
  Future<WorkDetailCatalog> loadCatalog();
}
