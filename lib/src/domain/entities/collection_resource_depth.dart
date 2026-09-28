import 'collection_board_query.dart';

/// Y축에 보이는 포함 단계. 부모가 정확히 1개일 때만 다음 자식으로 내려간다.
enum CollectionResourceDepth {
  project,
  line,
  equipment;

  static CollectionResourceDepth of(CollectionBoardQuery query) {
    if (query.lineNames.length == 1 || query.equipmentIds.length == 1) {
      return CollectionResourceDepth.equipment;
    }
    if (query.isUnassignedOnly || query.projectIds.length == 1) {
      return CollectionResourceDepth.line;
    }
    return CollectionResourceDepth.project;
  }

  String get headerLabel {
    switch (this) {
      case CollectionResourceDepth.project:
        return '프로젝트';
      case CollectionResourceDepth.line:
        return '라인';
      case CollectionResourceDepth.equipment:
        return '장비';
    }
  }
}
