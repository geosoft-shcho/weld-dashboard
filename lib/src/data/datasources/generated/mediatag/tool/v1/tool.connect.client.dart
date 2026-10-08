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

  /// 도구 하나를 대상 하나에 돌려 달라고 요청한다. 실행 한 건을 만들어 대기열에 넣고 바로 돌려준다(status = QUEUED) —
  /// 끝날 때까지 기다리지 않는다. 결과는 GetRun(wait_for_terminal)으로 받고, 도구가 만든 파일은 output_asset_ids에 있다.
  ///   tool_id: 돌릴 도구(ListTools). target: 무엇에 돌릴지 — asset_id·clip_id·job_id 중 하나.
  ///   trigger: MANUAL(사람이 한 건을 돌림 — 대상은 Asset 하나 또는 Clip 하나), AUTO_TAGGING(작업의 타임라인 전체 — 대상은 작업).
  ///            ASSET_UPLOADED는 보내지 않는다 — 파일을 올릴 때 서버가 스스로 만드는 후처리 실행의 표시다(보내면 InvalidArgument).
  /// 내장 도구(audio-extract·asset-postprocess)는 서버 안 워커가, 외부 도구(STT·포즈)는 서버가 그 도구의 서버에 보내 실행한다.
  /// 어느 쪽이든 부르는 방법은 같다.
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
