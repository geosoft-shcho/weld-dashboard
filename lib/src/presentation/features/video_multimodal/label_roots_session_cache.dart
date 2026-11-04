import '../../../domain/entities/label_vocab.dart';

/// 프로세스 내 라벨 트리 캐시. 멀티모달 재진입 시 ListLabels를 생략한다.
class LabelRootsSessionCache {
  LabelRootsSessionCache._();

  static List<LabelNode>? _roots;

  static List<LabelNode>? get roots => _roots;

  static bool get hasRoots => _roots != null;

  static void put(List<LabelNode> roots) {
    _roots = List<LabelNode>.unmodifiable(roots);
  }

  static void clear() {
    _roots = null;
  }
}
