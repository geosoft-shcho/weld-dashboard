class CollectionAssignment {
  const CollectionAssignment({
    required this.assignmentId,
    required this.equipmentId,
    required this.projectId,
    required this.workerId,
    required this.assignedFrom,
    required this.assignedTo,
  });

  final String assignmentId;
  final String equipmentId;
  final String projectId;
  final String workerId;
  final DateTime assignedFrom;
  final DateTime assignedTo;

  bool contains(DateTime instant) {
    return !instant.isBefore(assignedFrom) && instant.isBefore(assignedTo);
  }

  bool overlaps(DateTime rangeStart, DateTime rangeEnd) {
    return assignedFrom.isBefore(rangeEnd) && rangeStart.isBefore(assignedTo);
  }
}
