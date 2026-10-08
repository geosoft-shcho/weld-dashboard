import '../entities/label_vocab.dart';
import '../repositories/label_repository.dart';

class LabelUseCase {
  LabelUseCase(this._repository);

  final LabelRepository _repository;

  Future<List<LabelSection>> listSections() {
    return _repository.listSections();
  }

  Future<LabelChip> createValue({
    required String vocabKey,
    required String name,
  }) {
    final trimmed = name.trim();
    if (vocabKey.isEmpty || trimmed.isEmpty) {
      throw const LabelException('라벨 이름을 입력하세요.');
    }
    return _repository.createValue(vocabKey: vocabKey, name: trimmed);
  }

  Future<LabelChip> renameValue({
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
