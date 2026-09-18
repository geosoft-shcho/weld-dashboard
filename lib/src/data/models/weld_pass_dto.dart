import '../../domain/entities/weld_pass.dart';

class WeldPassDto {
  const WeldPassDto({
    required this.passId,
    required this.commonKey,
    required this.passNo,
    required this.passName,
    required this.masterProfileId,
    required this.controlWorkerId,
  });

  factory WeldPassDto.fromRow(Map<String, String> row) {
    return WeldPassDto(
      passId: row['pass_id'] ?? '',
      commonKey: row['common_key'] ?? '',
      passNo: int.tryParse(row['pass_no'] ?? '') ?? 0,
      passName: row['pass_name'] ?? '',
      masterProfileId: row['master_profile_id'] ?? '',
      controlWorkerId: row['control_worker_id'] ?? '',
    );
  }

  final String passId;
  final String commonKey;
  final int passNo;
  final String passName;
  final String masterProfileId;
  final String controlWorkerId;

  WeldPass? toDomain() {
    if (passId.isEmpty || commonKey.isEmpty) {
      return null;
    }
    return WeldPass(
      passId: passId,
      commonKey: commonKey,
      passNo: passNo,
      passName: passName,
      masterProfileId: masterProfileId,
      controlWorkerId: controlWorkerId,
    );
  }
}
