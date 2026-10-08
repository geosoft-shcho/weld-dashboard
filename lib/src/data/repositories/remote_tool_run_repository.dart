import 'package:connectrpc/connect.dart';

import '../../domain/entities/tool_run.dart';
import '../../domain/repositories/tool_run_repository.dart';
import '../datasources/generated/mediatag/tool/v1/tool.pb.dart' as tool_pb;
import '../datasources/remote/media_tag_data_source.dart';
import 'proto_id.dart';
import 'tool_run_requests.dart';

class RemoteToolRunRepository implements ToolRunRepository {
  RemoteToolRunRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<List<InferenceTool>> listEnabledTools() {
    return _call(
      emptyMessage: '도구 목록을 불러오지 못했습니다.',
      call: () async {
        final response = await _mediaTag.toolService.listTools(
          tool_pb.ListToolsRequest(),
        );
        return enabledInferenceTools(response.tools);
      },
    );
  }

  @override
  Future<List<ToolRunSnapshot>> listJobRuns({required String jobId}) {
    if (protoIdOrNull(jobId) == null) {
      return Future.value(const []);
    }
    return _call(
      emptyMessage: '실행 목록을 불러오지 못했습니다.',
      call: () async {
        final response = await _mediaTag.toolService.listRuns(
          buildListJobRunsRequest(jobId),
        );
        return [for (final run in response.runs) toolRunSnapshotFrom(run)];
      },
    );
  }

  @override
  Future<ToolRunSnapshot> startRun({
    required String toolId,
    required ToolRunTargetKind kind,
    required String targetId,
  }) {
    return _call(
      emptyMessage: '도구를 실행하지 못했습니다.',
      call: () async {
        final response = await _mediaTag.toolService.startRun(
          buildStartRunRequest(toolId: toolId, kind: kind, targetId: targetId),
        );
        return toolRunSnapshotFrom(response.run);
      },
    );
  }

  @override
  Future<ToolRunSnapshot> getRun({required String runId}) {
    return _call(
      emptyMessage: '실행 상태를 불러오지 못했습니다.',
      call: () async {
        final response = await _mediaTag.toolService.getRun(
          buildGetRunRequest(runId),
        );
        return toolRunSnapshotFrom(response.run);
      },
    );
  }

  @override
  Future<ToolRunSnapshot> cancelRun({required String runId}) {
    return _call(
      emptyMessage: '실행을 취소하지 못했습니다.',
      call: () async {
        final response = await _mediaTag.toolService.cancelRun(
          buildCancelRunRequest(runId),
        );
        return toolRunSnapshotFrom(response.run);
      },
    );
  }

  Future<T> _call<T>({
    required String emptyMessage,
    required Future<T> Function() call,
  }) async {
    try {
      return await call();
    } on ConnectException catch (error) {
      final message = error.message.trim();
      throw ToolRunException(message.isEmpty ? emptyMessage : message);
    } on ToolRunException {
      rethrow;
    }
  }
}
