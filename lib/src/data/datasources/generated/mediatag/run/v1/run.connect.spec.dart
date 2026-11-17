//
//  Generated code. Do not modify.
//  source: mediatag/run/v1/run.proto
//

import "package:connectrpc/connect.dart" as connect;
import "run.pb.dart" as mediatagrunv1run;

abstract final class RunService {
  /// Fully-qualified name of the RunService service.
  static const name = 'mediatag.run.v1.RunService';

  /// 도구 하나를 대상 하나에 돌려 달라고 요청한다. run을 큐에 넣고 바로 돌려준다(status = QUEUED) — 끝날 때까지 기다리지 않는다.
  /// 결과는 GetRun(wait_for_terminal)으로 받고, 도구가 만든 파일은 output_asset_ids에 있다.
  ///   tool_id: 돌릴 도구(ToolService.ListTools). target: asset_id · clip_id · job_id 중 하나.
  ///   trigger: MANUAL(사람이 한 건을 돌림 — Asset 하나 또는 Clip 하나), AUTO_TAGGING(작업의 타임라인 전체 — 대상은 작업).
  ///            ASSET_UPLOADED는 보내지 않는다 — 서버가 스스로 거는 실행의 표시다(보내면 InvalidArgument).
  ///   MANUAL 대상: pdf-to-text는 PDF 클립(원본 PDF를 다시 인식하고 세트를 다시 세운다 — 본인 품목이 있거나 작업이 고른 세트가 있으면
  ///   아무것도 지우지 않고 FAILED), audio-extract는 영상 Asset 또는 영상 클립(클립이면 원본 전체에서 뽑은 소리를 그 클립과 같은 구간에
  ///   오디오 클립으로 놓는다). STT를 클립에 돌리면 그 클립 구간만 인식하고 자막 클립을 그 클립 위치 기준으로 놓는다. Asset에 돌리면
  ///   그 파일이 붙은 작업마다 촬영 시각 기준으로 놓는다. 포즈도 같다.
  /// 돌릴 수 없는 run은 기록만 남기고 바로 FAILED로 돌려준다: 처리할 서버가 연결되지 않은 도구면 error_code = not_connected,
  /// 소리 없는 영상에 faster-whisper STT면 invalid_target.
  static const startRun = connect.Spec(
    '/$name/StartRun',
    connect.StreamType.unary,
    mediatagrunv1run.StartRunRequest.new,
    mediatagrunv1run.StartRunResponse.new,
  );

  static const getRun = connect.Spec(
    '/$name/GetRun',
    connect.StreamType.unary,
    mediatagrunv1run.GetRunRequest.new,
    mediatagrunv1run.GetRunResponse.new,
  );

  /// 대상 기준 run 목록(생성 순). 화면 재진입 시 진행 중 run 복구용으로 짧게 폴링한다.
  static const listRuns = connect.Spec(
    '/$name/ListRuns',
    connect.StreamType.unary,
    mediatagrunv1run.ListRunsRequest.new,
    mediatagrunv1run.ListRunsResponse.new,
  );

  static const cancelRun = connect.Spec(
    '/$name/CancelRun',
    connect.StreamType.unary,
    mediatagrunv1run.CancelRunRequest.new,
    mediatagrunv1run.CancelRunResponse.new,
  );

  /// 서버 전체 대기열 — 기다리는(QUEUED) · 도는(RUNNING) run 전부(단계 · 도구)와 대기열마다 동시 수. 큐 모니터링 화면용으로 짧게 폴링한다.
  /// 끝난 run은 ListRuns로 본다.
  static const getQueue = connect.Spec(
    '/$name/GetQueue',
    connect.StreamType.unary,
    mediatagrunv1run.GetQueueRequest.new,
    mediatagrunv1run.GetQueueResponse.new,
  );
}
