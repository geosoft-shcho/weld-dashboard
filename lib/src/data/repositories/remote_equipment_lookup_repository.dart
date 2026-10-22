import 'package:connectrpc/connect.dart';

import '../../domain/entities/equipment.dart';
import '../../domain/entities/lookup_page.dart';
import '../../domain/repositories/equipment_lookup_repository.dart';
import '../datasources/generated/mediatag/work/v1/work.pb.dart' as work_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';

class RemoteEquipmentLookupRepository implements EquipmentLookupRepository {
  RemoteEquipmentLookupRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<Equipment?> getEquipment({required String equipmentId}) async {
    final id = protoIdOrNull(equipmentId);
    if (id == null) {
      return null;
    }
    try {
      final response = await _mediaTag.workService.getEquipment(
        work_pb.GetEquipmentRequest(equipmentId: id),
      );
      if (!response.hasEquipment()) {
        return null;
      }
      final item = response.equipment;
      return Equipment(
        equipmentId: idText(item.equipmentId),
        equipmentName: item.equipmentName,
        equipmentCode: item.equipmentCode,
        description: item.description,
        isInactive: item.inactive,
        jobCount: response.jobCount,
        assetCount: response.assetCount,
      );
    } on ConnectException catch (error) {
      if (error.code == Code.notFound) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<LookupPage<Equipment>> listEquipment({
    required bool includeInactive,
    required String query,
    required int pageSize,
    required String pageToken,
  }) async {
    final request = work_pb.ListEquipmentRequest(
      includeInactive: includeInactive,
      pageSize: pageSize,
      pageToken: pageToken,
    );
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      request.query = trimmed;
    }
    final response = await _mediaTag.workService.listEquipment(request);
    return LookupPage(
      items: [
        for (final item in response.equipment)
          Equipment(
            equipmentId: idText(item.equipmentId),
            equipmentName: item.equipmentName,
            equipmentCode: item.equipmentCode,
            description: item.description,
            isInactive: item.inactive,
            jobCount: response.jobCounts[item.equipmentId] ?? 0,
            assetCount: response.assetCounts[item.equipmentId] ?? 0,
          ),
      ],
      nextPageToken: response.nextPageToken,
      totalCount: response.totalCount,
    );
  }
}
