import 'package:connectrpc/connect.dart';

import '../../domain/entities/equipment.dart';
import '../../domain/entities/lookup_page.dart';
import '../../domain/repositories/equipment_lookup_repository.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
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

  @override
  Future<String> createEquipment({
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
  }) async {
    try {
      final response = await _mediaTag.workService.createEquipment(
        work_pb.CreateEquipmentRequest(
          equipment: work_pb.Equipment(
            equipmentName: equipmentName,
            equipmentCode: equipmentCode,
            description: description,
            inactive: isInactive,
          ),
        ),
      );
      return idText(response.equipment.equipmentId);
    } on ConnectException catch (error) {
      throw _equipmentWriteFailure(error);
    }
  }

  @override
  Future<void> updateEquipment({
    required String equipmentId,
    required String equipmentName,
    required String equipmentCode,
    required String description,
    required bool isInactive,
    required List<String> changedFields,
  }) async {
    final id = protoIdOrNull(equipmentId);
    if (id == null) {
      throw ArgumentError('장비 번호가 없습니다.');
    }
    try {
      await _mediaTag.workService.updateEquipment(
        work_pb.UpdateEquipmentRequest(
          equipment: work_pb.Equipment(
            equipmentId: id,
            equipmentName: equipmentName,
            equipmentCode: equipmentCode,
            description: description,
            inactive: isInactive,
          ),
          updateMask: FieldMask(paths: changedFields),
        ),
      );
    } on ConnectException catch (error) {
      throw _equipmentWriteFailure(error);
    }
  }

  @override
  Future<void> deleteEquipment({required String equipmentId}) async {
    final id = protoIdOrNull(equipmentId);
    if (id == null) {
      throw ArgumentError('장비 번호가 없습니다.');
    }
    try {
      await _mediaTag.workService.deleteEquipment(
        work_pb.DeleteEquipmentRequest(equipmentId: id),
      );
    } on ConnectException catch (error) {
      throw _equipmentWriteFailure(error);
    }
  }
}

Exception _equipmentWriteFailure(ConnectException error) {
  switch (error.code) {
    case Code.alreadyExists:
      return _WriteFailure('같은 장비 코드가 이미 있습니다.');
    case Code.failedPrecondition:
      return _WriteFailure('기록한 에셋이 있어 지울 수 없습니다. 안 쓰는 장비는 숨기세요.');
    default:
      return error;
  }
}

class _WriteFailure implements Exception {
  _WriteFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
