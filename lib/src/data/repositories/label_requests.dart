import '../../domain/entities/label_vocab.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
import '../datasources/generated/mediatag/compose/v1/compose.pb.dart'
    as compose_pb;
import 'proto_id.dart';

compose_pb.ListLabelsRequest buildListLabelsRequest() {
  return compose_pb.ListLabelsRequest();
}

List<LabelNode> labelNodesFrom(List<compose_pb.LabelValue> labels) {
  final flat = <LabelNode>[];
  final ids = <String>{};
  for (final value in labels) {
    final node = labelNodeFrom(value);
    if (node == null) {
      continue;
    }
    flat.add(node);
    ids.add(node.valueId);
  }
  final childrenByParent = <String, List<LabelNode>>{};
  final roots = <LabelNode>[];
  for (final node in flat) {
    if (node.parentValueId.isEmpty || !ids.contains(node.parentValueId)) {
      roots.add(node);
    } else {
      childrenByParent.putIfAbsent(node.parentValueId, () => []).add(node);
    }
  }
  return [for (final root in roots) _withChildren(root, childrenByParent)];
}

LabelNode? labelNodeFrom(compose_pb.LabelValue value) {
  if (value.deprecated) {
    return null;
  }
  final valueId = idText(value.valueId);
  if (valueId.isEmpty) {
    return null;
  }
  return LabelNode(
    valueId: valueId,
    name: value.name,
    parentValueId: idText(value.parentValueId),
  );
}

LabelNode _withChildren(
  LabelNode node,
  Map<String, List<LabelNode>> childrenByParent,
) {
  final children = childrenByParent[node.valueId] ?? const <LabelNode>[];
  return LabelNode(
    valueId: node.valueId,
    name: node.name,
    parentValueId: node.parentValueId,
    children: [
      for (final child in children) _withChildren(child, childrenByParent),
    ],
  );
}

compose_pb.CreateLabelValueRequest buildCreateLabelValueRequest({
  required String name,
  String parentValueId = '',
}) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) {
    throw const LabelException('라벨 이름을 입력하세요.');
  }
  final parent = protoIdOrNull(parentValueId);
  if (parent == null) {
    return compose_pb.CreateLabelValueRequest(name: trimmed);
  }
  return compose_pb.CreateLabelValueRequest(
    name: trimmed,
    parentValueId: parent,
  );
}

compose_pb.UpdateLabelValueRequest buildRenameLabelValueRequest({
  required String valueId,
  required String name,
}) {
  final id = protoIdOrNull(valueId);
  final trimmed = name.trim();
  if (id == null || trimmed.isEmpty) {
    throw const LabelException('라벨을 찾지 못했습니다.');
  }
  return compose_pb.UpdateLabelValueRequest(
    value: compose_pb.LabelValue(valueId: id, name: trimmed),
    updateMask: FieldMask(paths: const ['name']),
  );
}

compose_pb.UpdateLabelValueRequest buildDeprecateLabelValueRequest(
  String valueId,
) {
  final id = protoIdOrNull(valueId);
  if (id == null) {
    throw const LabelException('라벨을 찾지 못했습니다.');
  }
  return compose_pb.UpdateLabelValueRequest(
    value: compose_pb.LabelValue(valueId: id, deprecated: true),
    updateMask: FieldMask(paths: const ['deprecated']),
  );
}
