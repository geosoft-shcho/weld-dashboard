import '../../domain/entities/project.dart';

class ProjectDto {
  const ProjectDto({required this.projectId, required this.projectName});

  factory ProjectDto.fromRow(Map<String, String> row) {
    return ProjectDto(
      projectId: row['project_id'] ?? '',
      projectName: row['project_name'] ?? '',
    );
  }

  final String projectId;
  final String projectName;

  Project toDomain() {
    return Project(projectId: projectId, projectName: projectName);
  }
}
