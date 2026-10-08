import '../entities/label_vocab.dart';
import '../repositories/label_repository.dart';

class LabelUseCase {
  LabelUseCase(this._repository);

  final LabelRepository _repository;

  Future<List<LabelNode>> listLabels() {
    return _repository.listLabels();
  }

  Future<LabelNode> createValue({
    required String name,
    String parentValueId = '',
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const LabelException('라벨 이름을 입력하세요.');
    }
    return _repository.createValue(name: trimmed, parentValueId: parentValueId);
  }

  Future<LabelNode> renameValue({
    required String valueId,
    required String name,
  }) {
    final trimmed = name.trim();
    if (valueId.isEmpty || trimmed.isEmpty) {
      throw const LabelException('라벨을 찾지 못했습니다.');
    }
    return _repository.renameValue(valueId: valueId, name: trimmed);
  }

  Future<void> deprecateValue({required String valueId}) {
    if (valueId.isEmpty) {
      throw const LabelException('라벨을 찾지 못했습니다.');
    }
    return _repository.deprecateValue(valueId: valueId);
  }
}
