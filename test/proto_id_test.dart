import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weld_dashboard/src/data/datasources/generated/mediatag/work/v1/work.pb.dart';
import 'package:weld_dashboard/src/data/repositories/proto_id.dart';

void main() {
  test('empty system id stays off the request', () {
    expect(protoIdOrNull(''), isNull);
    expect(protoIdOrNull('0'), isNull);
    expect(idText(Int64.ZERO), '');
    expect(idText(protoId('128')), '128');

    final path = CollectionPath(
      view: CollectionView.COLLECTION_VIEW_EQUIPMENT,
      level: CollectionLevel.COLLECTION_LEVEL_UNSPECIFIED,
    );
    final json = path.toProto3Json();
    expect(json.toString().contains('equipmentId'), isFalse);
  });
}
