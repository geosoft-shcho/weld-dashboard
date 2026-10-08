import '../entities/label_vocab.dart';

abstract class LabelRepository {
  Future<List<LabelSection>> listSections();

  Future<LabelChip> createValue({
    required String vocabKey,
    required String name,
  });

  Future<LabelChip> renameValue({
    required String valueId,
    required String name,
  });

  Future<void> deprecateValue({required String valueId});
}
