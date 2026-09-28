class CollectionTimelineResource {
  const CollectionTimelineResource({
    required this.resourceId,
    required this.label,
    required this.subtitle,
    required this.selectionKey,
  });

  static const String UNASSIGNED_PROJECT_ID = 'none';

  static String projectResourceId(String projectId) => 'project:$projectId';

  static String lineResourceId(String lineName) => 'line:$lineName';

  static String equipmentResourceId(String equipmentId) =>
      'equipment:$equipmentId';

  final String resourceId;
  final String label;
  final String subtitle;
  final String selectionKey;
}
