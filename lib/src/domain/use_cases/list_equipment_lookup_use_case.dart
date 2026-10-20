import '../entities/equipment.dart';
import '../entities/lookup_page.dart';
import '../repositories/equipment_lookup_repository.dart';

class ListEquipmentLookupUseCase {
  ListEquipmentLookupUseCase(this._repository);

  final EquipmentLookupRepository _repository;

  static const int defaultPageSize = 50;

  Future<LookupPage<Equipment>> executePage({
    bool includeInactive = false,
    String query = '',
    String pageToken = '',
    int pageSize = defaultPageSize,
  }) {
    return _repository.listEquipment(
      includeInactive: includeInactive,
      query: query,
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }

  /// 콤보용 — next_page_token을 따라 전부.
  Future<List<Equipment>> execute({bool includeInactive = false}) async {
    final items = <Equipment>[];
    var token = '';
    do {
      final page = await executePage(
        includeInactive: includeInactive,
        pageToken: token,
        pageSize: 200,
      );
      items.addAll(page.items);
      token = page.nextPageToken;
    } while (token.isNotEmpty);
    return items;
  }
}
