class LabelNode {
  const LabelNode({
    required this.valueId,
    required this.name,
    this.parentValueId = '',
    this.children = const [],
  });

  final String valueId;
  final String name;
  final String parentValueId;
  final List<LabelNode> children;
}

class LabelException implements Exception {
  const LabelException(this.message);

  final String message;

  @override
  String toString() => message;
}

String labelNameFrom(List<LabelNode> nodes, String valueId) {
  for (final node in nodes) {
    if (node.valueId == valueId) {
      return node.name;
    }
    final nested = labelNameFrom(node.children, valueId);
    if (nested.isNotEmpty) {
      return nested;
    }
  }
  return '';
}

List<LabelNode> insertLabelNode(List<LabelNode> nodes, LabelNode created) {
  if (created.parentValueId.isEmpty) {
    return _upsertLabel(nodes, created);
  }
  final placed = _insertUnder(nodes, created);
  if (placed.inserted) {
    return placed.nodes;
  }
  return [
    ...placed.nodes,
    LabelNode(valueId: created.valueId, name: created.name),
  ];
}

List<LabelNode> renameLabelNode(
  List<LabelNode> nodes,
  String valueId,
  String name,
) {
  return [
    for (final node in nodes)
      if (node.valueId == valueId)
        LabelNode(
          valueId: node.valueId,
          name: name,
          parentValueId: node.parentValueId,
          children: node.children,
        )
      else
        LabelNode(
          valueId: node.valueId,
          name: node.name,
          parentValueId: node.parentValueId,
          children: renameLabelNode(node.children, valueId, name),
        ),
  ];
}

List<LabelNode> removeLabelNode(List<LabelNode> nodes, String valueId) {
  final cut = _cutLabel(nodes, valueId);
  return [
    ...cut.nodes,
    for (final node in cut.promoted)
      LabelNode(
        valueId: node.valueId,
        name: node.name,
        children: node.children,
      ),
  ];
}

List<LabelNode> _upsertLabel(List<LabelNode> nodes, LabelNode created) {
  var found = false;
  final next = <LabelNode>[];
  for (final node in nodes) {
    if (node.valueId == created.valueId) {
      next.add(
        LabelNode(
          valueId: created.valueId,
          name: created.name,
          parentValueId: created.parentValueId,
          children: node.children,
        ),
      );
      found = true;
    } else {
      next.add(node);
    }
  }
  if (!found) {
    next.add(created);
  }
  return next;
}

({List<LabelNode> nodes, bool inserted}) _insertUnder(
  List<LabelNode> nodes,
  LabelNode created,
) {
  final next = <LabelNode>[];
  var inserted = false;
  for (final node in nodes) {
    if (node.valueId == created.parentValueId) {
      next.add(
        LabelNode(
          valueId: node.valueId,
          name: node.name,
          parentValueId: node.parentValueId,
          children: _upsertLabel(node.children, created),
        ),
      );
      inserted = true;
      continue;
    }
    final below = _insertUnder(node.children, created);
    next.add(
      LabelNode(
        valueId: node.valueId,
        name: node.name,
        parentValueId: node.parentValueId,
        children: below.nodes,
      ),
    );
    inserted = inserted || below.inserted;
  }
  return (nodes: next, inserted: inserted);
}

({List<LabelNode> nodes, List<LabelNode> promoted}) _cutLabel(
  List<LabelNode> nodes,
  String valueId,
) {
  final kept = <LabelNode>[];
  final promoted = <LabelNode>[];
  for (final node in nodes) {
    if (node.valueId == valueId) {
      promoted.addAll(node.children);
      continue;
    }
    final below = _cutLabel(node.children, valueId);
    kept.add(
      LabelNode(
        valueId: node.valueId,
        name: node.name,
        parentValueId: node.parentValueId,
        children: below.nodes,
      ),
    );
    promoted.addAll(below.promoted);
  }
  return (nodes: kept, promoted: promoted);
}
