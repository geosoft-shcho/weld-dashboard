import '../../domain/entities/tool_run.dart';
import '../datasources/generated/mediatag/asset/v1/asset.pbenum.dart';
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

String inferenceToolSummary(tool_pb.Tool tool) {
  final pattern = _patternLabel(tool.pattern);
  final inputs = _inputKindsLabel(tool.supportedInputKinds);
  final unit = _unitLabel(tool.unit);
  final dispatch = _dispatchLabel(tool.dispatch);
  final model = [
    if (tool.remoteModelName.trim().isNotEmpty)
      'model ${tool.remoteModelName.trim()}',
    if (tool.toolVersion.trim().isNotEmpty)
      'version ${tool.toolVersion.trim()}',
  ].join(' · ');
  final traits = [
    if (pattern.isNotEmpty) 'pattern $pattern',
    if (tool.payloadKind.trim().isNotEmpty)
      'payload ${tool.payloadKind.trim()}',
    if (inputs.isNotEmpty) 'input $inputs',
    if (unit.isNotEmpty) 'unit $unit',
    if (dispatch.isNotEmpty) 'dispatch $dispatch',
  ].join(' · ');
  final lines = <String>[
    [
      'id ${idText(tool.toolId)}',
      if (tool.endpoint.trim().isNotEmpty) 'endpoint ${tool.endpoint.trim()}',
    ].join(' · '),
    if (model.isNotEmpty) model,
    if (traits.isNotEmpty) traits,
  ];
  return lines.join('\n');
}

String _patternLabel(tool_pb.ToolPattern pattern) {
  if (pattern == tool_pb.ToolPattern.TOOL_PATTERN_PUSH) {
    return 'push';
  }
  if (pattern == tool_pb.ToolPattern.TOOL_PATTERN_PULL) {
    return 'pull';
  }
  return '';
}

String _unitLabel(tool_pb.ToolUnit unit) {
  if (unit == tool_pb.ToolUnit.TOOL_UNIT_FRAME) {
    return 'frame';
  }
  if (unit == tool_pb.ToolUnit.TOOL_UNIT_SECOND) {
    return 'second';
  }
  return '';
}

String _dispatchLabel(tool_pb.ToolDispatch dispatch) {
  if (dispatch == tool_pb.ToolDispatch.TOOL_DISPATCH_MANDATORY) {
    return 'mandatory';
  }
  if (dispatch == tool_pb.ToolDispatch.TOOL_DISPATCH_ON_DEMAND) {
    return 'on demand';
  }
  return '';
}

String _inputKindsLabel(Iterable<AssetKind> kinds) {
  final labels = <String>[];
  for (final kind in kinds) {
    final label = _assetKindLabel(kind);
    if (label.isNotEmpty) {
      labels.add(label);
    }
  }
  return labels.join(', ');
}

String _assetKindLabel(AssetKind kind) {
  if (kind == AssetKind.ASSET_KIND_VIDEO) {
    return 'video';
  }
  if (kind == AssetKind.ASSET_KIND_AUDIO) {
    return 'audio';
  }
  if (kind == AssetKind.ASSET_KIND_IMAGE) {
    return 'image';
  }
  if (kind == AssetKind.ASSET_KIND_DOCUMENT) {
    return 'document';
  }
  if (kind == AssetKind.ASSET_KIND_POSE) {
    return 'pose';
  }
  if (kind == AssetKind.ASSET_KIND_SUBTITLE) {
    return 'subtitle';
  }
  if (kind == AssetKind.ASSET_KIND_TIMESERIES) {
    return 'timeseries';
  }
  if (kind == AssetKind.ASSET_KIND_POINTCLOUD) {
    return 'pointcloud';
  }
  if (kind == AssetKind.ASSET_KIND_OCR_JSON) {
    return 'ocr json';
  }
  if (kind == AssetKind.ASSET_KIND_REGION) {
    return 'region';
  }
  return '';
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
    enabled.add(
      InferenceTool(
        toolId: toolId,
        name: tool.name,
        summary: inferenceToolSummary(tool),
      ),
    );
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
