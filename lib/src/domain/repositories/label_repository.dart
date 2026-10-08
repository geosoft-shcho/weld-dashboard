import '../entities/label_vocab.dart';

abstract class LabelRepository {
  Future<List<LabelNode>> listLabels();

  Future<LabelNode> createValue({
    required String name,
    String parentValueId = '',
  });

  Future<LabelNode> renameValue({
    required String valueId,
    required String name,
  });

  Future<void> deprecateValue({required String valueId});
}
