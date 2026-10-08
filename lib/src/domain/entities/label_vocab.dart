class LabelChip {
  const LabelChip({required this.valueId, required this.name});

  final String valueId;
  final String name;
}

class LabelSection {
  const LabelSection({required this.vocabKey, required this.chips});

  final String vocabKey;
  final List<LabelChip> chips;
}

class LabelException implements Exception {
  const LabelException(this.message);

  final String message;

  @override
  String toString() => message;
}
