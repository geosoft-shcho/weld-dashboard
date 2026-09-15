import 'collection_assignment.dart';
import 'collection_event.dart';
import 'collection_status.dart';
import 'equipment.dart';
import 'project.dart';
import 'worker.dart';

class CollectionCatalog {
  const CollectionCatalog({
    required this.equipments,
    required this.projects,
    required this.workers,
    required this.assignments,
    required this.statuses,
    required this.events,
    required this.snapshotAt,
  });

  final List<Equipment> equipments;
  final List<Project> projects;
  final List<Worker> workers;
  final List<CollectionAssignment> assignments;
  final List<CollectionStatus> statuses;
  final List<CollectionEvent> events;
  final DateTime snapshotAt;

  Equipment? equipmentById(String equipmentId) {
    for (final equipment in equipments) {
      if (equipment.equipmentId == equipmentId) {
        return equipment;
      }
    }
    return null;
  }

  Project? projectById(String projectId) {
    for (final project in projects) {
      if (project.projectId == projectId) {
        return project;
      }
    }
    return null;
  }

  Worker? workerById(String workerId) {
    for (final worker in workers) {
      if (worker.workerId == workerId) {
        return worker;
      }
    }
    return null;
  }

  CollectionStatus? statusByEquipmentId(String equipmentId) {
    for (final status in statuses) {
      if (status.equipmentId == equipmentId) {
        return status;
      }
    }
    return null;
  }

  List<CollectionAssignment> assignmentsForEquipment(String equipmentId) {
    return assignments
        .where((assignment) => assignment.equipmentId == equipmentId)
        .toList();
  }
}
