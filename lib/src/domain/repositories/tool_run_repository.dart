import '../entities/tool_run.dart';

abstract class ToolRunRepository {
  Future<List<InferenceTool>> listEnabledTools();

  Future<List<ToolRunSnapshot>> listJobRuns({required String jobId});

  Future<ToolRunSnapshot> startRun({
    required String toolId,
    required ToolRunTargetKind kind,
    required String targetId,
  });

  Future<ToolRunSnapshot> getRun({required String runId});

  Future<ToolRunSnapshot> cancelRun({required String runId});
}
