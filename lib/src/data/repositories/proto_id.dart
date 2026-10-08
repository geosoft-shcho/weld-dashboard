import 'package:fixnum/fixnum.dart';

/// 화면·도메인의 시스템 ID는 십진 문자열이다. 0과 빈 값은 없다.
Int64? protoIdOrNull(String id) {
  if (id.isEmpty || id == '0') {
    return null;
  }
  return Int64.parseInt(id);
}

Int64 protoId(String id) => protoIdOrNull(id) ?? Int64.ZERO;

String idText(Int64 id) {
  if (id == Int64.ZERO) {
    return '';
  }
  return id.toString();
}

List<Int64> protoIds(Iterable<String> ids) {
  final values = <Int64>[];
  for (final id in ids) {
    final value = protoIdOrNull(id);
    if (value != null) {
      values.add(value);
    }
  }
  return values;
}
