//
//  Generated code. Do not modify.
//  source: mediatag/tool/v1/tool.proto
//

import "package:connectrpc/connect.dart" as connect;
import "tool.pb.dart" as mediatagtoolv1tool;
import "tool.connect.spec.dart" as specs;

extension type ToolServiceClient (connect.Transport _transport) {
  /// 도구 목록. 기본은 켜진(enabled) 도구만 — 화면의 도구 고르기용. 꺼진 도구까지 받으려면 include_disabled를 켠다
  /// (도구 관리 화면, 실행 이력·클립 출처의 도구 이름 찾기).
  Future<mediatagtoolv1tool.ListToolsResponse> listTools(
    mediatagtoolv1tool.ListToolsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ToolService.listTools,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagtoolv1tool.CreateToolResponse> createTool(
    mediatagtoolv1tool.CreateToolRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ToolService.createTool,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 도구를 고친다(update_mask에 든 칸만 — 다른 수정 RPC와 같다). tool.tool_id 필수. 켜고 끄기는 update_mask "enabled".
  /// 고칠 수 있는 칸: name, endpoint, remote_model_name, tool_version, pattern, payload_kind, supported_input_kinds, unit,
  /// dispatch, enabled.
  Future<mediatagtoolv1tool.UpdateToolResponse> updateTool(
    mediatagtoolv1tool.UpdateToolRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ToolService.updateTool,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 행을 실제로 지운다(되돌릴 수 없음). 실행 이력이 있으면 FailedPrecondition — 대신 enabled=false로 끈다.
  /// 실행(StartRun · GetRun · ListRuns · CancelRun · GetQueue)은 mediatag.run.v1.RunService로 옮겼다(2026-11-16).
  Future<mediatagtoolv1tool.DeleteToolResponse> deleteTool(
    mediatagtoolv1tool.DeleteToolRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ToolService.deleteTool,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
