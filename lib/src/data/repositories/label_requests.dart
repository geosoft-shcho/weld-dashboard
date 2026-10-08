import '../../domain/entities/label_vocab.dart';
import '../datasources/generated/google/protobuf/field_mask.pb.dart';
import '../datasources/generated/mediatag/compose/v1/compose.pb.dart'
    as compose_pb;
import 'proto_id.dart';

compose_pb.ListLabelVocabsRequest buildListLabelVocabsRequest() {
  return compose_pb.ListLabelVocabsRequest();
}

List<LabelSection> labelSectionsFrom(List<compose_pb.LabelVocab> vocabs) {
  final sections = <LabelSection>[];
  for (final vocab in vocabs) {
    if (vocab.key.isEmpty) {
      continue;
    }
    final chips = <LabelChip>[];
    for (final value in vocab.values) {
      final chip = labelChipFrom(value);
      if (chip != null) {
        chips.add(chip);
      }
    }
    sections.add(LabelSection(vocabKey: vocab.key, chips: chips));
  }
  return sections;
}

LabelChip? labelChipFrom(compose_pb.LabelValue value) {
  if (value.deprecated) {
    return null;
  }
  final valueId = idText(value.valueId);
  if (valueId.isEmpty) {
    return null;
  }
  return LabelChip(valueId: valueId, name: value.name);
}

compose_pb.CreateLabelValueRequest buildCreateLabelValueRequest({
  required String vocabKey,
  required String name,
}) {
  final trimmed = name.trim();
  if (vocabKey.isEmpty || trimmed.isEmpty) {
    throw const LabelException('라벨 이름을 입력하세요.');
  }
  return compose_pb.CreateLabelValueRequest(vocabKey: vocabKey, name: trimmed);
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
