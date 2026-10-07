//
//  Generated code. Do not modify.
//  source: mediatag/tool/v1/tool.proto
//

import "package:connectrpc/connect.dart" as connect;
import "tool.pb.dart" as mediatagtoolv1tool;

abstract final class ToolService {
  /// Fully-qualified name of the ToolService service.
  static const name = 'mediatag.tool.v1.ToolService';

  static const listTools = connect.Spec(
    '/$name/ListTools',
    connect.StreamType.unary,
    mediatagtoolv1tool.ListToolsRequest.new,
    mediatagtoolv1tool.ListToolsResponse.new,
  );

  static const createTool = connect.Spec(
    '/$name/CreateTool',
    connect.StreamType.unary,
    mediatagtoolv1tool.CreateToolRequest.new,
    mediatagtoolv1tool.CreateToolResponse.new,
  );

  /// 도구 전체 교체. tool.tool_id 필수
  static const updateTool = connect.Spec(
    '/$name/UpdateTool',
    connect.StreamType.unary,
    mediatagtoolv1tool.UpdateToolRequest.new,
    mediatagtoolv1tool.UpdateToolResponse.new,
  );

  /// 실행 이력이 있으면 FailedPrecondition — 대신 enabled=false로 끈다.
  static const deleteTool = connect.Spec(
    '/$name/DeleteTool',
    connect.StreamType.unary,
    mediatagtoolv1tool.DeleteToolRequest.new,
    mediatagtoolv1tool.DeleteToolResponse.new,
  );

  /// trigger는 MANUAL(Clip 하나 재계산 또는 Asset에 대한 요청)·AUTO_TAGGING(Timeline 전체)만 받는다.
  /// ASSET_UPLOADED는 서버(적재기)가 등록 시점에 스스로 만든다. 내장 도구(endpoint가 빈 도구, 예: audio-extract)는
  /// 서버가 바로 실행하고, 외부 도구는 디스패처가 생길 때까지 queued로 남는다. 결과는 GetRun(wait_for_terminal)의
  /// output_asset_ids.
  static const startRun = connect.Spec(
    '/$name/StartRun',
    connect.StreamType.unary,
    mediatagtoolv1tool.StartRunRequest.new,
    mediatagtoolv1tool.StartRunResponse.new,
  );

  static const getRun = connect.Spec(
    '/$name/GetRun',
    connect.StreamType.unary,
    mediatagtoolv1tool.GetRunRequest.new,
    mediatagtoolv1tool.GetRunResponse.new,
  );

  /// 화면 재진입 시 진행 중 실행 복구용. 짧은 폴링으로 주기 호출한다.
  static const listRuns = connect.Spec(
    '/$name/ListRuns',
    connect.StreamType.unary,
    mediatagtoolv1tool.ListRunsRequest.new,
    mediatagtoolv1tool.ListRunsResponse.new,
  );

  static const cancelRun = connect.Spec(
    '/$name/CancelRun',
    connect.StreamType.unary,
    mediatagtoolv1tool.CancelRunRequest.new,
    mediatagtoolv1tool.CancelRunResponse.new,
  );
}
