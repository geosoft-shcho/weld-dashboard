import '../../domain/entities/equipment.dart';
import '../../domain/repositories/equipment_lookup_repository.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

/// 에셋 조회 장비 콤보용. 개수·숨김은 ListJobFilters를 쓰는 장비 조회 화면이 담당한다.
class RemoteEquipmentLookupRepository implements EquipmentLookupRepository {
  RemoteEquipmentLookupRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<List<Equipment>> listEquipment() async {
    final filters = await _mediaTag.workService.listJobFilters(
      work_pb.ListJobFiltersRequest(),
    );
    return [
      for (final item in filters.equipment)
        Equipment(
          equipmentId: idText(item.equipmentId),
          equipmentName: item.equipmentName,
          equipmentCode: item.equipmentCode,
          lineName: item.lineName,
          description: item.description,
          isInactive: item.inactive,
          jobCount: filters.equipmentJobCounts[item.equipmentId] ?? 0,
        ),
    ];
  }
}
