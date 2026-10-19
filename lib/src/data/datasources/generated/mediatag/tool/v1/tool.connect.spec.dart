//
//  Generated code. Do not modify.
//  source: mediatag/tool/v1/tool.proto
//

import "package:connectrpc/connect.dart" as connect;
import "tool.pb.dart" as mediatagtoolv1tool;

abstract final class ToolService {
  /// Fully-qualified name of the ToolService service.
  static const name = 'mediatag.tool.v1.ToolService';

  /// 도구 목록. 기본은 켜진(enabled) 도구만 — 화면의 도구 고르기용. 꺼진 도구까지 받으려면 include_disabled를 켠다
  /// (도구 관리 화면, 실행 이력·클립 출처의 도구 이름 찾기).
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

  /// 도구를 고친다(update_mask에 든 칸만 — 다른 수정 RPC와 같다). tool.tool_id 필수. 켜고 끄기는 update_mask "enabled".
  /// 고칠 수 있는 칸: name, endpoint, remote_model_name, tool_version, pattern, payload_kind, supported_input_kinds, unit,
  /// dispatch, enabled.
  static const updateTool = connect.Spec(
    '/$name/UpdateTool',
    connect.StreamType.unary,
    mediatagtoolv1tool.UpdateToolRequest.new,
    mediatagtoolv1tool.UpdateToolResponse.new,
  );

  /// 행을 실제로 지운다(되돌릴 수 없음). 실행 이력이 있으면 FailedPrecondition — 대신 enabled=false로 끈다.
  static const deleteTool = connect.Spec(
    '/$name/DeleteTool',
    connect.StreamType.unary,
    mediatagtoolv1tool.DeleteToolRequest.new,
    mediatagtoolv1tool.DeleteToolResponse.new,
  );

  /// 도구 하나를 대상 하나에 돌려 달라고 요청한다. 실행 한 건을 만들어 대기열에 넣고 바로 돌려준다(status = QUEUED) —
  /// 끝날 때까지 기다리지 않는다. 결과는 GetRun(wait_for_terminal)으로 받고, 도구가 만든 파일은 output_asset_ids에 있다.
  ///   tool_id: 돌릴 도구(ListTools). target: 무엇에 돌릴지 — asset_id·clip_id·job_id 중 하나.
  ///   trigger: MANUAL(사람이 한 건을 돌림 — 대상은 Asset 하나 또는 Clip 하나), AUTO_TAGGING(작업의 타임라인 전체 — 대상은 작업).
  ///            ASSET_UPLOADED는 보내지 않는다 — 파일을 올릴 때 서버가 스스로 만드는 후처리 실행의 표시다(보내면 InvalidArgument).
  /// 내장 도구(audio-extract·asset-postprocess·pdf-to-text)는 서버 안 워커가, 외부 도구(STT·포즈)는 서버가 그 도구의
  /// 서버에 보내 실행한다. 어느 쪽이든 부르는 방법은 같다.
  ///   MANUAL 대상: pdf-to-text는 PDF 클립(원본 PDF를 추출 — 이미 성적서 세트가 있으면 already_exists),
  ///   audio-extract는 영상 Asset 또는 영상 클립(클립이면 원본 전체에서 뽑은 소리를 그 클립과 같은 구간에 오디오 클립으로 놓는다).
  ///   STT를 클립에 돌리면 그 클립 구간만 인식하고, 문장마다의 자막 클립을 그 클립이 있는 작업에만 그 클립 위치 기준으로
  ///   놓는다(클립을 옮겨 놓았어도 겹친다). Asset에 돌리면 그 파일이 붙은 작업마다 촬영 시각 기준으로 놓는다.
  ///   포즈도 같다 — 클립에 돌리면 결과 클립 하나를 그 클립과 같은 자리에 놓는다.
  /// 돌릴 수 없는 실행은 기록만 남기고 바로 FAILED로 돌려준다: 처리할 서버가 연결되지 않은 도구면 error_code = not_connected,
  /// 소리 없는 영상에 faster-whisper STT면 invalid_target(stt-fast 등 다른 STT는 그대로 보낸다).
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

  /// 서버 전체 대기열 — 기다리는(QUEUED)·도는(RUNNING) 실행 전부와 내장 도구 워커 수. 큐 모니터링 화면용으로 짧게 폴링한다.
  /// 대기열: 내장 도구 하나(asset-postprocess·audio-extract·pdf-to-text, 서버 안 워커 local_workers개가 동시에 돎)와 외부 도구
  /// 서버(endpoint)마다 하나(STT·포즈, 서버마다 한 건씩 보냄). 모두 오래된 것부터 꺼내지만 서버마다 따로라, 바쁜 서버를 기다리는
  /// 실행보다 뒤에 들어온 다른 서버의 실행이 먼저 시작할 수 있다. 끝난 실행은 ListRuns로 본다.
  static const getQueue = connect.Spec(
    '/$name/GetQueue',
    connect.StreamType.unary,
    mediatagtoolv1tool.GetQueueRequest.new,
    mediatagtoolv1tool.GetQueueResponse.new,
  );
}
