# mediatag proto — 2026-11-17에 바뀐 것

mediatag `a312819` 기준이고, 지난 전달(`ced4274`) 뒤에 바뀐 것만 담았습니다. **운영에는 11-17 10:12에 배포했습니다.**
옛 `ToolService`의 실행 RPC는 지금 **404**가 납니다. 아래 1번부터 반영해 주세요.

들어 있는 파일: `run.proto`(새 파일) · `trace.proto`(새 파일) · `tool.proto` · `asset.proto`

## 1. 실행 RPC가 `ToolService`에서 `RunService`로 옮겨 갔습니다 (꼭 바꿔야 함)

| 예전(지금 404) | 지금 |
|---|---|
| `mediatag.tool.v1.ToolService/StartRun` | `mediatag.run.v1.RunService/StartRun` |
| `ToolService/GetRun` | `RunService/GetRun` |
| `ToolService/ListRuns` | `RunService/ListRuns` |
| `ToolService/CancelRun` | `RunService/CancelRun` |
| `ToolService/GetQueue` | `RunService/GetQueue` (응답 모양이 바뀜 — 3번) |

`ToolService`에는 도구 관리 RPC 넷만 남았습니다: `ListTools` · `CreateTool` · `UpdateTool` · `DeleteTool`.
요청 칸의 이름은 예전과 같습니다(`tool_id` · `trigger` · `target`, `run_id`, `wait_for_terminal` 등). 다만 번호가 바뀐 칸이 있습니다: `StartRunRequest.target` 4→3, `ListRunsRequest.target` 2→1. Connect JSON은 이름으로 주고받아서 상관없지만, 바이너리(proto)로 보낸다면 생성 코드를 다시 만들어야 합니다.

## 2. `ToolRun` 메시지가 `mediatag.run.v1.Run`으로 바뀌었습니다

enum도 옮겨 갔습니다: `RunStatus` · `RunTrigger` · `RunTarget`은 이제 `mediatag.run.v1` 패키지에 있습니다(값 이름은 같음).
필드 번호가 바뀌었으니 생성 코드를 다시 만들어 주세요.

| 칸 | 내용 |
|---|---|
| `tool_id` 또는 `stage` | 둘 중 하나만 옵니다(oneof). 도구 run이면 `tool_id`. 업로드 후처리 run이면 `stage = "postprocess"`이고 `tool_id`는 비어 있습니다 |
| `parent_run_id` (새 칸) | 후처리가 건 도구 run이면 그 후처리 run 번호입니다(성적서 PDF의 pdf-to-text). 아니면 0 |
| `trace_id` (새 칸) | 업로드 여정 번호입니다(4번). 수동 run과 코멘트 STT는 0 |
| `wait` (새 칸) | `QUEUED`일 때만 옵니다. 왜, 얼마나 기다리는지: `reason` · `ahead`(내 앞 수) · `running` · `workers` |
| 나머지 | 예전과 같은 뜻입니다: `status` · `error_code` · `error_message` · `queue` · `queue_position` · `queue_length` · `progress_percent` · `estimated_remaining_seconds` · `output_asset_ids` · `started_at` 등 |

`wait.reason` 값:
- `QUEUE_AHEAD`: 앞에 기다리는 run이 있습니다.
- `WORKERS_BUSY`: 앞은 비었지만 동시에 돌릴 자리가 다 찼습니다.
- `RETRY`: 실패하거나 중단돼서 다시 기다리는 중입니다.
- `DISPATCH_OFF`: 도구를 보내는 쪽이 꺼져 있습니다. 기다려도 시작하지 않습니다.

후처리(`asset-postprocess`)는 더 이상 도구가 아닙니다. `ListTools`에 나오지 않고, `StartRun`으로 돌릴 수도 없습니다.
다시 돌릴 때는 지금처럼 `AssetService.RetryPostprocess`를 씁니다.

## 3. `GetQueue` 응답이 대기열별로 바뀌었습니다

```json
{
  "queues": [
    {"queue": "http://218.153.121.121:50051", "workers": 1, "running": 1, "waiting": 1, "runs": [ /* Run, 오래된 것부터 */ ]},
    {"queue": "postprocess", "workers": 2, "running": 0, "waiting": 0, "runs": []},
    {"queue": "work", "workers": 2, "running": 0, "waiting": 0, "runs": []}
  ]
}
```

- 예전의 `runs` · `workers_by_queue` 두 칸은 없어지고 `queues[]` 하나가 되었습니다. 대기열 이름순으로 옵니다.
- `postprocess` · `work`는 비어 있어도 나옵니다. 외부 도구 서버(주소가 대기열 이름)는 run이 있을 때만 나옵니다.
- 기다린 시간은 따로 주지 않습니다. 지금 시각에서 `created_at`을 빼서 구해 주세요.

## 4. 새 서비스 `TraceService` — 업로드 한 건이 지금 어디까지 왔는지

업로드한 파일 하나가 받기 → 등록 → 후처리 → 임베딩(검색 가능)을 거치는 과정을 이벤트로 쌓아 보여 줍니다. 진행 화면은 1~2초마다 폴링하면 됩니다.

- `ListTraces`: 여정 목록이 새것부터 옵니다. `trace_ids`(다중 업로드 때 이번에 올린 것들) · `status`(진행 중만 보려면 `RUNNING`) · `asset_id`로 거를 수 있습니다.
- `GetTrace(trace_id)`: 여정 한 건과 이벤트 전부가 오래된 것부터 옵니다.

`Trace`에서 볼 칸:
- `status`: `RUNNING` · `DONE` · `FAILED`
- `last_event`: 마지막으로 지난 단계
- `progress_percent`: 파일을 받는 동안만 옵니다
- `run`: 지금 기다리거나 도는 run입니다. 대기열 이름은 `run.queue`에 있고, `GetQueue`에서 같은 이름의 대기열을 찾으면 앞에 선 run들이 보입니다.
- `embed_pending_clip_ids`: 임베딩을 기다리는 클립입니다.

이벤트 이름(`TraceEvent.name`)은 `단계.세부` 형식이고 바뀌지 않습니다. 전체 목록은 `trace.proto` 맨 위 주석에 있습니다.
- 정상으로 끝나면 `done.searchable`(검색 가능)로 끝납니다. 놓인 클립이 없는 파일(후처리가 없는 문서 등)은 `done.stored`로 끝납니다.
- 실패하면 그 이벤트의 `status = failed`와 `error_message`를 보면 됩니다.

## 5. 업로드에서 여정 번호 받기

| 업로드 방식 | 여정 번호가 오는 곳 |
|---|---|
| 이어 올리기(tus) | 시작(`POST`) 응답 헤더 **`Upload-Trace-Id`** (CORS로 읽을 수 있게 열어 두었습니다) |
| 한 번에 올리기(multipart `POST /assets`) · 등록 응답 | 응답 JSON의 **`traceId`** (글자) |

- metadata에 `publishedAt`(RFC 3339, 선택)을 새로 받습니다. 보내는 쪽이 자료를 내보낸 시각이고, 추적 화면에만 씁니다. `timeOrigin`과는 다른 값입니다.
- 지금 쓰고 있는 칸들은 바뀌지 않았습니다.

## 6. `asset.proto`

- `Asset.postprocess`: `PostprocessRun`에서 `mediatag.run.v1.Run`으로 바뀌었습니다. 요약 칸만 채웁니다(`run_id` · `stage` 또는 `tool_id` · `status` · `error_message`). 성적서 PDF는 pdf-to-text run이 마지막일 수 있습니다.
- `Comment.stt`: `Run`으로 바뀌었습니다(요약).
- `ListAssetsRequest.postprocess_status`: 타입이 `mediatag.run.v1.RunStatus`로 바뀌었습니다(값 이름 `RUN_STATUS_*`).
- `PostprocessRun` · `PostprocessStatus`는 지웠습니다.
