import '../../domain/entities/tool_run.dart';
import '../datasources/generated/mediatag/tool/v1/tool.pb.dart' as tool_pb;
import 'proto_id.dart';

tool_pb.StartRunRequest buildStartRunRequest({
  required String toolId,
  required ToolRunTargetKind kind,
  required String targetId,
}) {
  final tool = protoIdOrNull(toolId);
  final target = protoIdOrNull(targetId);
  if (tool == null || target == null) {
    throw const ToolRunException('대상을 찾지 못했습니다.');
  }
  switch (kind) {
    case ToolRunTargetKind.clip:
      return tool_pb.StartRunRequest(
        toolId: tool,
        trigger: tool_pb.RunTrigger.RUN_TRIGGER_MANUAL,
        target: tool_pb.RunTarget(clipId: target),
      );
    case ToolRunTargetKind.asset:
      return tool_pb.StartRunRequest(
        toolId: tool,
        trigger: tool_pb.RunTrigger.RUN_TRIGGER_MANUAL,
        target: tool_pb.RunTarget(assetId: target),
      );
    case ToolRunTargetKind.job:
      return tool_pb.StartRunRequest(
        toolId: tool,
        trigger: tool_pb.RunTrigger.RUN_TRIGGER_AUTO_TAGGING,
        target: tool_pb.RunTarget(jobId: target),
      );
  }
}

tool_pb.ListRunsRequest buildListJobRunsRequest(String jobId) {
  final id = protoIdOrNull(jobId);
  if (id == null) {
    throw const ToolRunException('작업을 열지 못했습니다.');
  }
  return tool_pb.ListRunsRequest(target: tool_pb.RunTarget(jobId: id));
}

tool_pb.GetRunRequest buildGetRunRequest(String runId) {
  final id = protoIdOrNull(runId);
  if (id == null) {
    throw const ToolRunException('실행을 찾지 못했습니다.');
  }
  return tool_pb.GetRunRequest(runId: id, waitForTerminal: true);
}

tool_pb.CancelRunRequest buildCancelRunRequest(String runId) {
  final id = protoIdOrNull(runId);
  if (id == null) {
    throw const ToolRunException('실행을 찾지 못했습니다.');
  }
  return tool_pb.CancelRunRequest(runId: id);
}

List<InferenceTool> enabledInferenceTools(Iterable<tool_pb.Tool> tools) {
  final enabled = <InferenceTool>[];
  for (final tool in tools) {
    if (!tool.enabled) {
      continue;
    }
    final toolId = idText(tool.toolId);
    if (toolId.isEmpty) {
      continue;
    }
    enabled.add(InferenceTool(toolId: toolId, name: tool.name));
  }
  return enabled;
}

ToolRunSnapshot toolRunSnapshotFrom(tool_pb.ToolRun run) {
  return ToolRunSnapshot(
    runId: idText(run.runId),
    toolId: idText(run.toolId),
    status: _statusFrom(run.status),
    errorMessage: run.errorMessage,
  );
}

ToolRunStatus _statusFrom(tool_pb.RunStatus status) {
  if (status == tool_pb.RunStatus.RUN_STATUS_QUEUED) {
    return ToolRunStatus.queued;
  }
  if (status == tool_pb.RunStatus.RUN_STATUS_RUNNING) {
    return ToolRunStatus.running;
  }
  if (status == tool_pb.RunStatus.RUN_STATUS_SUCCEEDED) {
    return ToolRunStatus.succeeded;
  }
  if (status == tool_pb.RunStatus.RUN_STATUS_CANCELED) {
    return ToolRunStatus.canceled;
  }
  return ToolRunStatus.failed;
}
