//
//  Generated code. Do not modify.
//  source: mediatag/tool/v1/tool.proto
//

import "package:connectrpc/connect.dart" as connect;
import "tool.pb.dart" as mediatagtoolv1tool;
import "tool.connect.spec.dart" as specs;

extension type ToolServiceClient (connect.Transport _transport) {
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

  /// 도구 전체 교체. tool.tool_id 필수
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

  /// 실행 이력이 있으면 FailedPrecondition — 대신 enabled=false로 끈다.
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

  /// trigger는 MANUAL(Clip 하나 재계산 또는 Asset에 대한 요청)·AUTO_TAGGING(Timeline 전체)만 받는다.
  /// ASSET_UPLOADED는 서버(적재기)가 등록 시점에 스스로 만든다. 내장 도구(endpoint가 빈 도구, 예: audio-extract)는
  /// 서버가 바로 실행하고, 외부 도구는 디스패처가 생길 때까지 queued로 남는다. 결과는 GetRun(wait_for_terminal)의
  /// output_asset_ids.
  Future<mediatagtoolv1tool.StartRunResponse> startRun(
    mediatagtoolv1tool.StartRunRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ToolService.startRun,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagtoolv1tool.GetRunResponse> getRun(
    mediatagtoolv1tool.GetRunRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ToolService.getRun,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// 화면 재진입 시 진행 중 실행 복구용. 짧은 폴링으로 주기 호출한다.
  Future<mediatagtoolv1tool.ListRunsResponse> listRuns(
    mediatagtoolv1tool.ListRunsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ToolService.listRuns,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<mediatagtoolv1tool.CancelRunResponse> cancelRun(
    mediatagtoolv1tool.CancelRunRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ToolService.cancelRun,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
