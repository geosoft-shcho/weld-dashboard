import '../entities/tool_run.dart';
import '../repositories/tool_run_repository.dart';

class ToolRunUseCase {
  ToolRunUseCase(this._repository);

  final ToolRunRepository _repository;

  Future<List<InferenceTool>> listEnabledTools() {
    return _repository.listEnabledTools();
  }

  Future<List<ToolRunSnapshot>> listJobRuns({required String jobId}) {
    if (jobId.isEmpty) {
      return Future.value(const []);
    }
    return _repository.listJobRuns(jobId: jobId);
  }

  /// 클립이나 에셋 한 건은 MANUAL, 작업 타임라인 전체는 AUTO_TAGGING.
  /// ASSET_UPLOADED는 서버가 업로드 때 붙이므로 화면은 보내지 않는다.
  Future<ToolRunSnapshot> start({
    required String toolId,
    required String jobId,
    required String clipId,
    required String assetId,
  }) {
    if (toolId.isEmpty) {
      throw const ToolRunException('도구를 고르지 않았습니다.');
    }
    if (clipId.isNotEmpty) {
      return _repository.startRun(
        toolId: toolId,
        kind: ToolRunTargetKind.clip,
        targetId: clipId,
      );
    }
    if (assetId.isNotEmpty) {
      return _repository.startRun(
        toolId: toolId,
        kind: ToolRunTargetKind.asset,
        targetId: assetId,
      );
    }
    if (jobId.isEmpty) {
      throw const ToolRunException('작업을 열지 못했습니다.');
    }
    return _repository.startRun(
      toolId: toolId,
      kind: ToolRunTargetKind.job,
      targetId: jobId,
    );
  }

  Future<ToolRunSnapshot> getRun({required String runId}) {
    if (runId.isEmpty) {
      throw const ToolRunException('실행을 찾지 못했습니다.');
    }
    return _repository.getRun(runId: runId);
  }

  Future<ToolRunSnapshot> cancel({required String runId}) {
    if (runId.isEmpty) {
      throw const ToolRunException('실행을 찾지 못했습니다.');
    }
    return _repository.cancelRun(runId: runId);
  }
}
