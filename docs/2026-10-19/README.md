# 프론트 proto 공유 안내

## 문서 이력

| 일자 | 수정자 | 수정 내용 |
|---|---|---|
| 2026-10-19 | geosoft-Server | 성적서 PDF 파생 트리가 여러 단이 됨(원본 → 묶음 → 문서별 PDF → OCR · 그림) — 칸은 그대로, `parent_asset_id` 값만 바뀜("2026-10-19에 바뀐 것" 아래) |
| 2026-10-19 | geosoft-Server | `MergeAssets`(중복 합치기, `dry_run`) 추가("2026-10-19에 바뀐 것" 아래). 추가만 |
| 2026-10-19 | geosoft-Server | 중복 정리 — `ListDuplicateAssets` 판정 · 결정 · 사본별 참조 수, `ResolveDuplicateGroup`, 업로드 응답 `duplicateOf`("2026-10-19에 바뀐 것" 아래). 추가만 |
| 2026-10-19 | geosoft-Server | **깨지는 변경** — 작업자 `team` 삭제, `is_master` · `master_only`를 작업자 종류 `worker_type`(명장 · 일반 · 로봇)으로 바꿈("2026-10-19에 바뀐 것" 맨 위) |
| 2026-10-19 | geosoft-Server | 도구 실행 대기열 보기 추가("2026-10-19에 바뀐 것") — `GetQueue`, `ToolRun.queue_position`·`queue_length`를 채움, `ToolRun.started_at`, 외부 도구는 서버마다 한 건씩. 추가만, 운영 적용 전 |
| 2026-10-19 | geosoft-Server | 2026-10-15의 도구 실행 변경(`tool.proto` 주석)을 "2026-10-15에 바뀐 것"에 늦게 적음 — 연결 안 된 도구는 바로 FAILED, 클립 대상 실행 |
| 2026-10-19 | geosoft-Server | 작업자 사번 · 비고 · 숨김, 장비 비고 · 숨김("2026-10-19에 바뀐 것" 아래). 추가만, 2026-10-19 운영 적용 |
| 2026-10-19 | geosoft-Server | 관리 화면 첫 묶음 추가("2026-10-19에 바뀐 것" 아래) — `DeleteProjectItem`, `ListJobs.asset_id`, `ListAssets` 찾기 필터, `Asset.display`, `ListJobFilters` 개수. 추가만 |
| 2026-10-19 | geosoft-Server | 시점 태그·수치 태그·라벨 `code`/`unit`·패스 종류 추가("2026-10-19에 바뀐 것") — 추가만, 2026-10-19 운영 적용 |
| 2026-10-15 | geosoft-Server | 태그 클립에 `source`(근거 영상)를 넣을 수 있게 됨("2026-10-15에 바뀐 것") |
| 2026-10-15 | geosoft-Server | `Clip.embedded_at`을 서버가 채움("2026-10-15에 바뀐 것") — 임베딩 목업, 마지막 수정 뒤 약 6초에 반영. `Timeline.embedded_at`은 그대로 비어 있음. 2026-10-15 운영 적용 |
| 2026-10-14 | geosoft-Server | 도구 쪽 변경을 모음("2026-10-14에 바뀐 것") — `ToolRun.progress_percent`·`estimated_remaining_seconds`가 welding-pose·torch-pose에서도 채워짐, `Tool.description`(한글 설명) 추가, 가짜 도구 정리와 도구 번호 변경(asset-postprocess 16→9, Qwen3-VL-32B 13→10). 2026-10-14 운영 적용 |
| 2026-10-13 | geosoft-Server | 타임라인 편집·재생 쪽 변경을 모음("2026-10-13에 바뀐 것") — 같은 트랙 겹침 허용, 소스 구간 검사, `ClipSource.asset_duration_ns`·`asset_start_time_ns`, `Asset.properties.start_time_ns`, 포즈 검출이 없으면 클립 없음. 화면 쪽 기준은 `타임라인 그리기와 재생 안내.md`로 따로 정리해 함께 전달한다(2026-10-13 운영 적용) |
| 2026-10-13 | geosoft-Server | `GetClip`에 `include_target` 추가 — 도구가 만든 클립의 실행 대상(`target_clip`·`target_asset`)을 한 번에 받는다(2026-10-13 운영 적용, 추가만) |
| 2026-10-12 | geosoft-Server | `GetClip` 추가(클립 하나를 번호로, `include_assets`면 가리키는 Asset도), `ClipProvenance.target_kind`·`target_id` 추가 — 도구가 만든 클립만 읽어도 무엇을 대상으로 돌린 실행인지 알 수 있게(2026-10-12 운영 적용, 추가만) |
| 2026-10-12 | geosoft-Server | `ClipSource.locator` 모양을 kind별로 정함 — `pdf`는 쪽 안의 박스를 받고, 서버가 모양을 검사한다(2026-10-12 운영 적용) |
| 2026-10-08 | geosoft-Server | 라벨을 한 그루의 트리로 — `ListLabelVocabs`·`CreateLabelVocab`·`vocab_key` 삭제, `ListLabels` 추가 |
| 2026-10-08 | geosoft-Server | 라벨 트리 — 값 아래에 값(`LabelValue.parent_value_id`), `LabelVocab`의 상위 필드 삭제 |
| 2026-10-08 | geosoft-Server | 클립 사이의 관계(관계 클립 `kind = RELATION`, `Clip.relation`, 종류는 라벨 값) 추가, `ClipProvenance.input_clip_ids` 삭제(운영 적용 전) |
| 2026-10-08 | geosoft-Server | `ListTools`는 켜진 도구만(`include_disabled`), `UpdateTool`은 `update_mask` 부분 수정으로 바뀜 |
| 2026-10-08 | geosoft-Server | ID 숫자 전환이 운영에 적용됐음을 반영, `parent_asset_id` 설명을 숫자 기준으로 고침 |
| 2026-10-07 | geosoft-Server | ID가 숫자(`int64`)로 바뀜 — 접두어 글자 ID 설명과 예시를 고치고 `ID 숫자 전환 안내.md`를 가리킴. 운영 적용 전 |
| 2026-10-07 | geosoft-Server | 성적서 세트 조회에 섹션 종류 둘 추가 — `SECTION_KIND_SURFACE_TREATMENT`(7)·`SECTION_KIND_PAINT`(8). 기존 칸은 그대로(추가만) |
| 2026-10-06 | geosoft-Server | 에셋 트리 — `Provenance.input_asset_ids`(배열)를 `parent_asset_id`(하나)로 바꾸고 `Asset.child_count`·`ListAssets` 부모 필터 추가. 부모가 하나로 정해져 원본 아래 파생을 트리로 보여줄 수 있게 됨 |
| 2026-10-01 | geosoft-Server | `GetPassWaveform` 비교는 패스끼리만(`comparison_pass_id`, `comparison_job_id` 삭제·칸 번호 변경), `normalize = DTW` 추가 |
| 2026-10-01 | geosoft-shcho | 수집 현황 `ListCollectionNodes` 사용법(path 이어 보내기, basis, 작업 노드 이름, 세는 범위) 추가 |
| 2026-10-01 | geosoft-Server | 기존 DashboardService에서 mediatag v1으로 옮길 때의 RPC 대응표와 화면별 전환 흐름 추가 |
| 2026-10-01 | geosoft-Server | 기존 `/apps/tacit-tag` 미디어 컴포즈 흐름과 새 `MediaComposeService`의 대응 관계·차이 추가 |
| 2026-10-01 | geosoft-Server | 개발 중에는 모든 프론트 origin을 허용하도록 CORS 값을 `*`로 명시 |
| 2026-10-01 | geosoft-Server | 파일 중복 정리용 `ListDuplicateAssets`를 초기 프론트 연동 범위에서 제외 |
| 2026-10-01 | geosoft-Server | 당장 화면에서 쓰지 않는 성적서 목록 조회를 프론트 연동 범위에서 제외 |
| 2026-10-01 | geosoft-Server | 프론트 공유용 서버 주소를 `192.168.100.3:33210`으로 명시 |
| 2026-10-01 | geosoft-Server | mediatag v1 proto를 프론트에서 사용할 때 필요한 계약 범위와 호출 규칙을 공유하기 위해 최초 작성 |

## 공유 대상

정본은 `mediatag/proto/mediatag/` 아래의 다음 파일이다. 전달받은 사본보다 저장소의 최신 파일을
우선하며, 연동 기준 커밋을 함께 공유한다.

| 파일 | 서비스 | 화면에서 맡는 역할 |
|---|---|---|
| `work/v1/work.proto` | `WorkService` | 공사·작업·패스·작업자·장비 조회, 수집 현황, 파형 비교 |
| `asset/v1/asset.proto` | `AssetService` | 파일 메타데이터·작업 첨부 조회와 파일 연결 |
| `compose/v1/compose.proto` | `MediaComposeService`, `LabelService` | 타임라인·트랙·클립 편집과 라벨 어휘 |
| `report/v1/report.proto` | `ReportService` | 검사 성적서·검수 항목 조회와 보정 |
| `tool/v1/tool.proto` | `ToolService` | 처리 도구 목록, 실행 요청과 진행 상태 |

`faivv/`, `bytestream/`, `tacittag/`, `tacit/pdftotext/`는 서버 간 연동 계약이므로 프론트의
일반 화면 연동 대상이 아니다.

타임라인에 클립을 놓고, 그리고, 재생하는 방법은 `타임라인 그리기와 재생 안내.md`에 따로 정리했다(함께 전달).
그 문서는 화면 구성(§9) → 한 작업으로 끝까지 따라가는 예시(§8) → 규칙(§1~§7, §10) 순으로 읽으면 빠르다.

## 2026-10-19에 바뀐 것

**깨지는 변경 — 프론트가 고쳐야 한다(작업자).** 팀을 없애고, 명장 여부를 로봇까지 담는 작업자 종류로 바꿨다.

| 없어진 필드 | 대신 |
|---|---|
| `Worker.team`(3) | 없음(필요한 내용은 `Worker.description` 비고에) |
| `Worker.is_master`(4) | `Worker.worker_type`(9) — `WORKER_TYPE_MASTER`(명장) · `GENERAL`(일반) · `ROBOT`(로봇) · `UNSPECIFIED`(모름) |
| `JobSummary.is_master`(3) | `JobSummary.worker_type`(8) |
| `PassWaveform.is_master`(5) | `PassWaveform.worker_type`(7) |
| `ListJobsRequest.master_only`(5) | `ListJobsRequest.worker_type`(16) — `MASTER`면 예전 "명장만" |
| `UpdateWorker` 마스크 `team` · `is_master` | `worker_type` |

운영 값은 true → 명장, false → 일반, 빈 값 → 모름으로 옮겼다. 옛 번호는 `reserved`라 옛 코드가 보내도 무시된다(오류는 안 나지만 값이 저장되지 않는다).

모두 칸을 더한 것이라 지금 화면은 그대로 돈다(`compose.proto`·`work.proto`).

- **시점 태그**: 태그만 `timeline_start_ns = timeline_end_ns`(길이 0)로 만들 수 있다. 다른 종류는 여전히 start < end. 그리는 법은 `타임라인 그리기와 재생 안내.md` §3.
- **수치 태그**: `Clip.value`(double, 선택) — 태그에만 넣을 수 있다(그 밖은 InvalidArgument). 라벨에 `unit`이 있으면 값이 필수다. 고치기는 `UpdateClip`의 마스크 `value`.
- **라벨 `code`·`unit`**: `LabelValue.code`(기계용 이름, 영문으로 시작·영문·숫자·밑줄, 같은 부모 아래 유일 — 겹치면 AlreadyExists)·`unit`(예: `mm`). `CreateLabelValue`에서 주고, `UpdateLabelValue` 마스크 `code`·`unit`으로 고친다. 이미 정한 `code`는 못 바꾸고(비어 있으면 채울 수 있음), 그 라벨을 쓰는 클립이 있으면 `unit`을 못 바꾼다(둘 다 FailedPrecondition).
- **패스 종류**: `Pass.pass_type`(`PASS_TYPE_ROOT`·`HOT`·`FILL`·`CAP`, 0이면 모름). `CreatePass`·`CreateJob`의 passes·`UpdatePass`(마스크 `pass_type`)로 넣는다.

관리 화면(공사 · 작업 · 에셋 · 작업자 · 장비 탭) 쪽 — 화면 흐름은 `관리 화면 구성과 서버 추가 안내.md` §5(함께 전달). 모두 추가만이다(`work.proto` · `asset.proto`).

- **`DeleteProjectItem(project_item_id)`**: 품목 배정 지우기. 그 배정을 쓰는 작업이 있으면 FailedPrecondition, 없는 번호면 NotFound.
- **`ListJobsRequest.asset_id`**: 그 에셋이 직접 첨부된 작업만. 부모만 붙은 파생은 찾지 않는다.
- **`ListAssetsRequest`**: `file_name`(부분 일치, 대소문자 무시) · `equipment_id`(그 장비가 기록한 것) · `unattached_only`(어느 작업에도 첨부되지 않은 것).
- **`Asset.display`**(응답 전용): 화면에 보일 `[label, value]` 줄 — 순서대로 그리면 된다. 값이 없는 줄은 빠지고, 맨 끝은 크기. 기계가 읽을 값은 지금처럼 `properties`.
- **`ListJobFilters` 개수**: `ProjectFilter.job_count`, `worker_job_counts` · `equipment_job_counts` · `equipment_asset_counts`(id → 수, 0은 빠짐). `ListJobs`의 `total_count`와 같은 수라 목록 행마다 세지 않아도 된다. 장비의 `equipment_asset_counts`가 0이 아니면 지우기를 끈다.

작업자 · 장비 칸(`work.proto`, 추가만 — 화면 쪽 설명은 `관리 화면 구성과 서버 추가 안내.md` §5.10):

- **`Worker.employee_no`**(사번, 선택, 겹치면 AlreadyExists) · **`description`**(비고) · **`inactive`**(숨김). `Equipment.description` · `inactive`. 고치기는 `UpdateWorker` · `UpdateEquipment`의 마스크에 같은 이름.
- **숨김은 고르는 목록에서만**: `ListWorkers` · `ListEquipment`는 숨긴 것을 빼고, `include_inactive = true`면 전부(관리 탭은 이것으로). `ListJobFilters`는 지난 작업 찾기용이라 숨긴 것도 준다 — `inactive`면 흐리게. 맡은 작업 · 기록한 에셋에는 그대로 보인다.

도구 실행 대기열(`tool.proto`, 추가만 — 2026-10-19 운영 적용):

- **`GetQueue()`**: 서버 전체에서 기다리는(QUEUED) · 도는(RUNNING) 실행 전부(오래된 것부터)와 `local_workers`(내장 도구를 동시에 돌리는 워커 수, 지금 2). 큐 모니터링 화면에서 몇 초마다 부른다. 끝난 실행은 지금처럼 `ListRuns`.
- **대기열**: 내장 도구 하나(`asset-postprocess` · `audio-extract` · `pdf-to-text` — `local_workers`개까지 동시에)와 외부 도구 서버(endpoint)마다 하나(STT · 포즈 — 서버마다 한 건씩). 서버마다 따로 줄을 서서, 바쁜 서버를 기다리는 실행보다 뒤에 들어온 다른 서버의 실행이 먼저 RUNNING이 될 수 있다. 도구별 개수는 `runs`를 `tool_id` · `status`로 묶어 센다.
- **소식 없는 외부 실행**: 2시간 동안 진행 신호가 없으면 FAILED(`error_code = timeout`) — 그 서버의 다음 실행이 나간다.
- **`ToolRun.queue_position` · `queue_length`**: 이제 채워진다(전에는 늘 0). 같은 대기열(내장 도구, 또는 같은 외부 도구 서버)에서의 순번(1부터)과 기다리는 수, QUEUED가 아니면 0. `StartRun` · `GetRun` · `ListRuns` 응답에도 들어 있어 "앞에 3건" 같은 표시를 따로 세지 않아도 된다.
- **`ToolRun.started_at`**: RUNNING일 때 돌기 시작한 시각. 기다린 시간은 `started_at − created_at`(기다리는 중이면 지금 − `created_at`), 돈 시간은 지금 − `started_at`. 진행 신호를 주지 않는 외부 도구(STT)는 비어 있다 — 그때는 `updated_at`을 본다.

에셋 중복 정리(`asset.proto`, 추가만 — 화면 흐름은 `관리 화면 구성과 서버 추가 안내.md` §5.4):

- **`ListDuplicateAssets`**: 묶음마다 `mergeable`(합칠 수 있나)과 못 합치는 이유 `reason`을 서버가 판정한다 — 화면이 같은 조건을 따로 들지 않는다. `members`는 `assets`와 같은 순서에 사본마다 참조 수(`refs`: 첨부 · 클립 · 파생 · 성적서 · 도구 실행)와 붙은 작업(`job_ids`) — 기준은 참조가 가장 많은 것을 기본으로 고른다.
- **기본 목록이 줄었다**: 사본마다 기록 시각이 다른 묶음(예시 공사 사본 약 394묶음)과 정리한 묶음은 뺀다. 보려면 `include_time_shifted` · `include_resolved`. 정리한 묶음이라도 그 뒤 같은 내용이 또 들어오면 다시 뜨고, 그 사본이 `new_asset_ids`에 있다.
- **`ResolveDuplicateGroup(sha256, member_asset_ids, keep_asset_id)`**: [그대로 두기]. 화면이 본 사본(`member_asset_ids`)이 지금 묶음과 다르면 FailedPrecondition — 다시 불러와서 보여 준다. 결정은 `DuplicateGroup.resolution`.
- **`MergeAssets(keep_asset_id, merge_asset_ids, dry_run)`**: [기준 n으로 합치기]. 먼저 `dry_run = true`로 불러 `moved`(첨부 · 클립 · 파생 · 성적서 · 도구 실행 수)를 확인 창에 보이고, 확인하면 `dry_run = false`로 다시 부른다. 사본 행과 파일이 지워진다(되돌릴 수 없음). `mergeable`이 아닌 묶음은 FailedPrecondition. 같은 작업에 패스가 다르게 붙어 있었으면 `warnings`에 적힌다. 합친 묶음은 `resolution = MERGED`가 된다.
- **올릴 때(`POST /assets`)**: 같은 내용이 이미 있으면 등록은 그대로 하고 `warnings`에 알리며 `duplicateOf`(번호 글자 배열)를 준다. 정리한 묶음이면 기준 번호 하나.

성적서 PDF 파생 트리(칸은 그대로, 값만 바뀜 — `관리 화면 구성과 서버 추가 안내.md` §5.8):

- 원본 PDF의 파생이 이제 **여러 단**이다: 원본 → 묶음 PDF(세트 구간) → 문서별 PDF → OCR JSON · 잘라 낸 그림. 전에는 모두 원본 바로 아래였다. 에셋 트리는 `child_count > 0`이면 `ListAssets(parent_asset_id)`로 한 단씩 펼치면 된다(단마다 같다). 작업에 첨부된 묶음 PDF를 펼치면 그 문서들이 나온다.

## 2026-10-15에 바뀐 것

2026-10-15에 운영 서버에 적용했다. 칸은 그대로이고 값만 채워진다.

| 무엇이 | 어떻게 | 화면이 할 일 |
|---|---|---|
| `Clip.embedded_at` | 검색 색인 반영을 마친 시각. 지금은 목업이라 벡터는 만들지 않고 시각만 채운다. 대상은 `confirmed` 타임라인의 클립 중 사람이 놓았거나(`provenance` 없음) 검수된(`reviewed`) 것. 마지막 수정 뒤 5초 대기 + 처리시간(1초 + 글자수 ÷ 100 × 0.5초)이 **실제로 지난 뒤** 그때 시각으로 채운다(보통 6초, 긴 자막 14초 안팎) | 비어 있거나 `updated_at`보다 이르면 "반영 대기", 아니면 "반영됨"으로 보여 준다. 수정 직후 몇 초 뒤 다시 읽으면 바뀐다 |
| `Timeline.embedded_at` | 그대로 비어 있다(무엇을 임베딩할지 미정) | 쓰지 않는다 |
| 태그 클립의 `source` | `kind = TAG`에도 `source`를 넣을 수 있다(선택, 전에는 InvalidArgument). 라벨은 그대로 필수. 근거 영상이 다른 작업의 것이면 서버가 이 작업에 첨부한다. `RELATION`은 그대로 source 없음 | RAG 근거에 좋아요·싫어요·코멘트를 남길 때 `source`에 근거 영상(숫자 `asset_id`)과 구간(`start_ns`·`end_ns`, 영상 자신의 시간축)을 넣는다. 읽을 때는 `GetClip(include_assets=true)`의 `asset`으로 받는다(`target_*`는 도구가 만든 클립용이라 비어 있다) |
| 도구 실행(`tool.proto` 주석) | 돌릴 수 없는 실행은 바로 `FAILED` — 처리 서버가 연결 안 된 도구면 `error_code = not_connected`, 소리 없는 영상에 faster-whisper STT면 `invalid_target`. `MANUAL`로 pdf-to-text는 PDF 클립에, audio-extract는 영상 클립에도 돌린다. STT · 포즈를 클립에 돌리면 결과를 그 클립이 있는 작업에만, 그 클립 위치 기준으로 놓는다(Asset에 돌리면 지금처럼 촬영 시각 기준) | 실행 직후 `FAILED`면 `error_code`에 맞는 문구를 보인다 |

## 2026-10-14에 바뀐 것

모두 2026-10-14 14:20에 운영 서버와 운영 DB에 적용했다. 칸은 추가만 있고 바뀌거나 없어진 것은 없다. **도구 번호는 바뀌었다.**

| 무엇이 | 어떻게 | 화면이 할 일 |
|---|---|---|
| 실행 진행률 | `ToolRun.progress_percent`(0~100)·`estimated_remaining_seconds`(남은 초)가 welding-pose·torch-pose 실행에서도 채워진다(전에는 늘 0). 서버가 2초마다 도구에 처리 프레임 수를 물어 갱신한다 | 실행 중(`RUNNING`)일 때 진행 막대와 남은 시간을 보여 준다. 남은 시간 0은 "알 수 없음" |
| `GetRun(wait_for_terminal)` | 그대로. 끝나거나 상한(기본 30초)이 될 때까지 붙잡고 있다가 응답한다 | 진행률을 더 자주 보이려면 `wait_for_terminal=false`로 몇 초마다 부른다. 서버 재시작 때 대기 연결이 끊길 수 있으니(502 등) 1~2초 뒤 다시 부른다 |
| `Tool.description` | 새 칸(12). 무엇을 하는 도구인지 한글 설명. `CreateTool`·`UpdateTool`(`update_mask`에 `description`)로 고칠 수 있다 | 도구 목록·실행 화면에서 `name` 옆이나 아래에 보여 준다 |
| 도구 번호 | 개발용 가짜 도구 4개(구간 임베딩·Pose Bridge·용접선 검출·게이트웨이 STT)를 지우고 번호를 당겼다. **asset-postprocess 16 → 9, Qwen3-VL-32B 13 → 10**. 1~8은 그대로 | 도구 번호를 코드에 적어 두었다면 바꾼다. 목록은 `ListTools(include_disabled=true)`로 받는다 |
| 포즈 실행 시간 | 그대로. 클립을 대상으로 돌려도 도구에는 영상 파일 전체를 보낸다(결과를 놓을 때만 클립 구간을 쓴다) | 앞부분이 잘린 클립이면 클립 길이보다 오래 걸릴 수 있다 |

## 2026-10-13에 바뀐 것

모두 2026-10-13에 운영 서버와 운영 DB에 적용했다. 칸 번호가 바뀌거나 없어진 것은 없다.

| 무엇이 | 어떻게 | 화면이 할 일 |
|---|---|---|
| 같은 트랙의 클립 겹침 | **허용**. `CreateClip`·`UpdateClip`이 겹쳐도 받는다(전에는 `FAILED_PRECONDITION`) | 겹친 클립은 트랙 안에서 줄을 나눠 그린다. 겹침을 피하려고 트랙을 새로 만들 필요가 없다 |
| 자동 배치 | 그대로. 서버가 놓는 클립(적재·도구 결과)은 겹치지 않게 옆 트랙에 놓인다 | 없음 |
| 소스 구간 검사 | `source.start_ns`·`end_ns`가 `0 ≤ start ≤ end ≤ Asset 길이`를 벗어나면 `INVALID_ARGUMENT`. 끝이 100ms 이내로 넘으면 서버가 Asset 길이로 맞춘다 | 보내기 전에 한계를 지킨다. 응답의 `clip`으로 화면 값을 바꿔 끼운다(끝이 맞춰졌을 수 있다) |
| `ClipSource.asset_duration_ns` | 새 칸(5), 읽기 전용. 소스 전체 길이 | 자를 수 있는 한계로 쓴다. `video.duration`은 쓰지 않는다 |
| `ClipSource.asset_start_time_ns` | 새 칸(6), 읽기 전용. 파일에 적힌 첫 시각 | `video.currentTime = (asset_start_time_ns + Asset 축 위치) ÷ 1e9`. 비어 있으면 0 |
| `Asset.properties.start_time_ns` | 영상·음성에 새 값. 위 칸의 원본 | 클립이 아닌 Asset을 바로 재생할 때 쓴다 |
| 포즈 결과 | 검출된 사람이 없으면(`status: "empty"`) 결과 파일만 남기고 **클립을 만들지 않는다** | 실행이 성공했는데 포즈 클립이 없을 수 있다 |
| `Delete*` 주석 | 지우는 방식(행을 실제로 지움)을 주석 첫 문장에 적었다. 동작은 그대로 | 없음 |

**파일 첫 시각은 꼭 처리해야 한다.** 운영 DB의 영상 6,658개 가운데 3,843개(58%)가 첫 프레임 시각이 0이 아니다(5.0초~428.6초).
처리하지 않으면 그 영상들이 엉뚱한 위치에서 재생되고 길이도 길게 나온다. 깊이 영상의 85~90%, 액션캠의 59%가 해당한다.

**같은 값이 한 응답에 두 번 올 수 있다.** `GetTimeline(include_assets=true)`와 `GetClip(include_assets=true)`는 소스 길이와 파일 첫 시각을
클립(`source.asset_duration_ns`·`asset_start_time_ns`)과 Asset(`duration_ns`·`properties.start_time_ns`) 양쪽에 싣는다.
클립 쪽 값은 저장된 것이 아니라 읽을 때마다 Asset에서 가져오므로 서로 다를 수 없다. 재생·자르기 계산에는 클립 쪽을 쓰고,
Asset은 해상도·fps·파일 주소(`content_url`)를 볼 때 쓴다.

## 접속 방법

- 프로토콜: Connect(JSON 또는 protobuf). 브라우저에서 HTTP/1.1로 직접 호출할 수 있다.
- API 기본 주소: `http://192.168.100.3:33210`
- 허용 origin: `*`(개발 중 전체 허용)
- RPC 경로: `POST /<package>.<Service>/<RPC>`
- 파일 조회: 응답의 `Asset.content_url`을 사용한다. `asset_id`만 있으면
  `GET /assets/{asset_id}/content`도 사용할 수 있다.
- 영상·음성 등 파일 응답은 Range 요청을 지원한다.

예를 들어 작업 목록은 다음 경로로 호출한다.

```text
POST /mediatag.work.v1.WorkService/ListJobs
Content-Type: application/json

{"projectNo":"TP129","pageSize":50}
```

운영 주소와 인증 방식은 별도로 전달받는다. 현재 계약에는 사용자 인증·권한 정보가 없으므로
인증이 붙기 전 서버를 사내망 밖에 공개하지 않는다.

## 먼저 연결할 조회 흐름

1. `ListProjects`, `ListWorkers`, `ListEquipment`로 필터 선택지를 가져온다.
2. `ListJobs`로 작업 목록을 조회하고, 선택한 작업은 `GetJob`으로 연다.
3. 편집 화면은 `GetTimeline(include_assets=true)`로 타임라인·트랙·클립·파일 메타데이터를 한 번에 받는다.
4. 작업 첨부는 `ListJobAssets`로 조회한다.
5. 처리 도구 화면은 `ListTools`와 `ListRuns`로 복구하고, 실행 중인 건만 `GetRun`으로 갱신한다.
   `ListTools`는 켜진 도구만 준다. 꺼진 도구까지(관리 화면, 실행 이력의 도구 이름 찾기) 받으려면 `include_disabled`를 켠다.
   도구를 켜고 끄는 것은 `UpdateTool`에 `update_mask: enabled` — 마스크에 든 칸만 바뀐다(마스크가 없으면 `InvalidArgument`).

`ListJobs`, `ListAssets`, `ListTimelines`는 `next_page_token`이 빌 때까지
다음 페이지를 요청한다. 클라이언트에서 임의로 토큰을 해석하지 않는다.

## 기존 tacit-tag 미디어 컴포즈와의 관계

화면 흐름은 `/apps/tacit-tag`에서 사용하던 프로젝트 → 레이어 → 구간 편집과 유사하다. 용어와
저장 단위가 다음처럼 바뀌었다.

| 기존 tacit-tag | mediatag v1 | 설명 |
|---|---|---|
| Project | Job + Timeline | 별도 편집 프로젝트를 만들지 않고 수집된 작업 1건을 편집 단위로 사용 |
| `GetProjectTree(include_assets=true)` | `GetTimeline(include_assets=true)` | 편집 화면 진입 시 전체 트리와 참조 Asset을 한 번에 조회 |
| LayerDocument | Track | 타임라인의 한 행 |
| LayerSegment | Clip | 트랙 위 시간 구간 또는 태그 |
| 전역 Asset | Asset | 원본·파생 파일을 ID로 참조하고 바이트는 `content_url`로 조회 |
| Layer 팔레트의 문자열 label | `LabelService`의 공통 라벨·`label_value_id` | 공사·트랙마다 같은 문자열을 중복 생성하지 않음 |
| InferenceModel/InferenceJob | Tool/ToolRun | AI 외에 음성 추출 같은 처리 도구도 같은 실행 흐름 사용 |

프론트의 기본 동작은 다음과 같다.

1. `ListJobs` 또는 `ListTimelines`에서 작업을 고른다.
2. `GetTimeline(job_id, include_assets=true)`로 Timeline, Track, Clip, Asset을 한 번에 불러온다.
3. Track은 `CreateTrack`, `UpdateTrack`, `DeleteTrack`으로 편집한다.
4. 기존 LayerSegment 편집과 같은 방식으로 Clip을 `CreateClip`, `UpdateClip`, `DeleteClip`한다.
5. 자동 처리는 `StartRun`으로 요청하고 `GetRun` 또는 `ListRuns`로 상태를 갱신한 뒤 타임라인을 다시 조회한다.

클립 하나만 다시 읽을 때는 `GetClip(clip_id)`를 쓴다. `include_assets=true`를 주면 그 클립의 `source`가 가리키는 Asset 메타가 `asset`에 실린다(`source`가 없는 tag·relation 클립이면 비어 있다). 없는 번호는 `NOT_FOUND`다.

도구가 만든 클립(`provenance`가 있는 클립)에는 그 실행의 대상이 실린다 — `provenance.target_kind`와 `provenance.target_id`다. `ToolRun.target`과 같은 값이라 실행을 따로 조회하지 않아도 된다.

| `target_kind` | `target_id`의 뜻 |
|---|---|
| `CLIP_TARGET_KIND_CLIP` | 대상 클립의 `clip_id` |
| `CLIP_TARGET_KIND_ASSET` | 대상 파일의 `asset_id` |
| `CLIP_TARGET_KIND_UNSPECIFIED` | 대상이 지워짐(`target_id`는 0) |

대상까지 한 번에 받으려면 `GetClip(clip_id, include_target=true)`를 쓴다. 포즈 클립을 골라 그 영상을 재생하는 화면이면 `include_assets`와 함께 주어 네 칸을 한 번에 받는다.

| 응답 칸 | 내용 |
|---|---|
| `clip` | 고른 클립(예: POSE) |
| `asset` | `include_assets`일 때 그 클립의 파일(예: 포즈 JSON) |
| `target_clip` | `include_target`이고 대상이 클립일 때 그 클립(예: VIDEO). 대상이 Asset이면 비어 있다 |
| `target_asset` | `include_target`일 때 대상 파일 — 대상이 클립이면 `target_clip.source`가 가리키는 Asset, 대상이 Asset이면 그 Asset |

재생할 파일은 늘 `target_asset`에서 찾는다. 대상은 한 단계만 따라가므로 `target_clip.kind`가 기대한 종류인지 확인한다. 사람이 놓은 클립이거나 대상이 지워졌으면 오류 없이 두 칸이 비어 있다.

번호는 종류마다 따로 세므로 반드시 `target_kind`를 먼저 보고 `target_id`를 쓴다. 이 두 칸은 읽기 전용이다(서버가 채우고, 요청에 넣어도 무시한다).

동작은 유사하지만 기존 계약을 이름만 바꿔 호출하면 안 된다.

- Project 생성 단계가 없다. Job은 적재기가 만들고, Timeline은 처음 편집할 때 서버가 자동 생성한다.
- `GetProjectTree`의 여러 LayerDocument가 `GetTimeline`의 `tracks[]`와 `clips[]`로 평탄화됐다.
  Clip은 `track_id`로 Track에 묶어 화면에서 그룹화한다.
- 기존 `SaveLayer`처럼 레이어 전체를 교체하지 않는다. Track과 Clip을 건별로 수정하고
  `update_mask`에는 바꾼 필드만 넣는다.
- 기존 revision CAS는 없다. 상태 변경만 `ChangeTimelineStatus(from_status, to_status)`로 충돌을 확인한다.
- 구간 단위는 초·프레임이 아니라 나노초이며, Clip 구간은 항상 `[start, end)`로 보낸다.
- Clip 하나는 Asset 하나를 가리킨다. 여러 Asset이 필요하면 Clip을 나누거나 파생 Asset으로 만든다.
- 기존 `ExtractAudioFromVideo`는 `ToolService.StartRun`에서 `audio-extract` 도구와 영상 `asset_id`를 사용한다.

## 기존 대시보드와의 관계

`sub-services/dashboard`의 `DashboardService`는 화면별 조회를 한 서비스에 모은 계약이고,
mediatag v1은 작업·파일·타임라인·성적서·도구 역할별 서비스로 나눈 계약이다. 신규 프론트는
아래 오른쪽 RPC를 사용한다.

| 기존 DashboardService RPC | mediatag v1 | 전환 상태 |
|---|---|---|
| `ListProjects` | `WorkService.ListProjects` | 이름은 같고 응답 타입 변경 |
| `ListWorkers` | `WorkService.ListWorkers` | 이름은 같고 응답 타입 변경 |
| `ListEquipment` | `WorkService.ListEquipment` | 이름은 같고 응답 타입 변경 |
| `ListWorkHistory` | `WorkService.ListJobs` | 작업 목록으로 대체. `history_id` 대신 `job_id` 사용 |
| `GetContext` | `WorkService.GetJob` | `common_key` 대표값 조회 대신 정확한 `job_id` 한 건 조회 |
| `ListPasses` | `WorkService.GetJob`의 `passes[]` | 작업 상세 응답에 통합 |
| `ListWorkAttachments` | `AssetService.ListJobAssets` | `history_id` 대신 `job_id`, 응답에 전체 Asset 메타 포함 |
| `GetPassWaveform` | `WorkService.GetPassWaveform` | 같은 화면 목적. 요청·응답은 새 proto 기준으로 변경 |
| `ListWaveformSeries` | 없음 | 화면에서 쓰지 않던 원본 테이블 전체 조회라 제거. 파형 화면은 `GetPassWaveform` 사용 |
| `ListCollectionAssignments` | 직접 대응 없음 | 배정표가 아니라 실제 수집 Asset 계층을 `ListCollectionNodes`로 조회 |
| `ListCollectionEvents` | `WorkService.ListCollectionNodes` | 이벤트 로그 대신 장비/작업자 → 공사 → 작업 → 패스 → Asset 계층 조회 |
| `ListEquipmentStatus` | 없음 | 연결 상태·손실률이 아니라 실제 저장된 Asset 현황을 보여주도록 범위 변경 |
| `ListWorkOrders` | 직접 대응 없음 | 별도 작업지시 목록을 두지 않고 `ListJobs`의 작업 필드와 필터 사용 |
| `ListJoints` | 직접 대응 없음 | 별도 조인트 목록을 두지 않고 `ListJobs`의 품목·공통키 필드 사용 |
| `ListQualityResults` | `ReportService.ListReportSets`, `GetReportSet` | 성적서 세트·섹션 구조로 대체. 당장 프론트 연동은 보류 |
| `ListQualityLinks` | 없음 | 파형 구간과 성적서 검사 항목 연결 방식은 새 s4 화면 설계 때 결정 |

화면별 초기 전환 흐름은 다음과 같다.

- 수집 현황: `ListCollectionAssignments` + `ListCollectionEvents` + `ListEquipmentStatus` 대신
  `ListCollectionNodes` 하나로 단계별 조회한다. 응답 노드의 `path`를 그대로 다음 요청의 `parent`로 보낸다.
  모든 노드에 `started_at`·`ended_at`이 있고 기준은 `basis`로 고른다(기본 작업 구간, `TIME_BASIS_COLLECTION`이면 실제 기록 구간).
  작업 노드 `label`은 표시용 이름("5호기 LEG DIAGONAL "F" · 9/16")이고 ID는 `path.job_id`다. 장비가 기록한 자료만 세며,
  STT·포즈 같은 도구 결과물은 `ListJobAssets`·타임라인에서 본다.
- 작업 목록: `ListWorkHistory` 대신 `ListJobs`를 사용한다.
- 작업 상세: `GetContext` + `ListPasses`를 각각 호출하지 않고 `GetJob` 한 번으로 받는다.
- 첨부: `ListWorkAttachments` 대신 `ListJobAssets`를 사용하고 파일은 `Asset.content_url`로 연다.
- 파형 비교: `GetPassWaveform`을 사용하고 `ListWaveformSeries`는 호출하지 않는다. 2026-10-01에 요청이 바뀌었다(비교는
  패스끼리만 `comparison_pass_id`, `normalize = DTW`, 칸 번호 변경) — `docs/설계/GetPassWaveform 변경 안내.md`.

## 에셋 트리(원본 아래 파생)

파일은 무엇으로 만들었는지(부모)를 하나씩 가진다. 원본은 부모가 없고, 표준화 파일·잘라 낸 PDF·포즈·자막 같은
파생은 `Asset.provenance.parent_asset_id`에 부모의 `asset_id`가 들어 있다.

| 하려는 일 | 방법 |
|---|---|
| 작업 화면에서 트리로 묶기 | `ListJobAssets` 결과에서 `provenance.parent_asset_id`가 같은 목록 안의 Asset이면 그 아래에 둔다. 부모가 목록에 없으면 뿌리로 둔다 |
| 펼칠 수 있는지 알기 | `Asset.child_count`가 0보다 크면 자식이 있다 |
| 자식 목록 받기 | `ListAssets(parent_asset_id=…)`. `page_size`·`page_token`·`kind`를 그대로 쓴다(성적서 PDF 하나에 자식이 190개까지 있다) |

- **바뀐 필드(호환 깨짐)**: `Provenance.input_asset_ids`(배열, JSON `inputAssetIds`)가 없어지고
  `parent_asset_id`(숫자 하나, JSON `parentAssetId`)가 생겼다. 부모가 없으면 0이다.
- 작업에 첨부된 것이 표준화 파일이나 잘라 낸 PDF면 그 파일이 뿌리로 보인다. 그 원본은 작업 첨부에 없다.
- 라벨은 한 그루의 트리다: `ListLabels`가 라벨 전부를 평평하게 주고 `parent_value_id`로 엮는다(0이면 맨 위 — 옛 어휘 `process_stage`·`speaker` 같은 분류가 맨 위 라벨이다). 라벨은 번호(`value_id`)로만 가리키고 이름은 겹쳐도 된다. 만들 때는 `CreateLabelValue`에 `name`과 (아래에 달려면) `parent_value_id`를 준다. `ListLabelVocabs`·`CreateLabelVocab`과 `vocab_key`(`LabelValue`·`LabelRef`·`CreateLabelValueRequest`)는 없앴다
- `ClipProvenance.input_clip_ids`는 없앴다(저장한 적이 없는 칸이었다). 클립끼리 잇는 것은 **관계 클립**으로 한다 — `CreateClip`에 `kind = RELATION`, 구간(`timeline_start_ns`·`timeline_end_ns`), `relation`(`from_clip_id`·`to_clip_id`)을 보낸다. 관계 종류는 태그처럼 `label_value_id`(라벨 값, 선택)로 고른다. "이 구간에서 from이 to와 관련 있다"는 뜻이고, from 클립의 구간 전체면 그 값을 그대로 넣는다. `source`는 비운다. 두 클립은 같은 작업의 것이어야 한다. 다른 클립처럼 트랙에 놓인다(관계용 트랙을 따로 두기를 권한다. 같은 트랙에서 구간이 겹쳐도 된다). 고치기·지우기는 `UpdateClip`(구간, `label_value_id`, 설명)·`DeleteClip`이고, 잇는 클립을 지우면 관계 클립도 지워진다. 관계 종류용 어휘는 따로 없다 — 라벨 어휘(`LabelService`)에 관계 종류용 어휘를 하나 만들어 쓴다(키 `relation`을 권한다 — 태그 화면은 그 트리를 빼고, 관계 화면은 그 트리만 보여 준다).

## 성적서 섹션: 표면처리·도장 검사

`GetReportSet`·`ListReportSets`의 섹션에 종류 둘이 늘었다(2026-10-07). 기존 종류와 칸은 바뀌지 않았다.

| 종류 | `fields`의 내용 |
|---|---|
| `SECTION_KIND_SURFACE_TREATMENT` | 표면처리 보고서 — 머리말(`part_name`·`part_no` …), 장소·전처리·온습도, `overall_result`, 배열 `anchor_profiles`(조도 확인 표의 줄) |
| `SECTION_KIND_PAINT` | 도장 검사 보고서 — 머리말, 사양·건도막 두께 합계, `overall_result`, 배열 `coats`(도장 회차 1~4: 사양·시공일·온습도·도료 두 줄·건도막 두께) |

- 이 두 문서는 한 장이 품목 여럿(`LEG DIAGONAL A.B.E`)을 묶는다. 그래서 **세트 셋이 같은 섹션을 돌려준다** — 품목 A·B·E의
  세트를 각각 열면 같은 표면처리·도장 검사가 나온다. `page_start`가 세트의 쪽 범위 밖(원본 PDF 끝 쪽)인 것도 정상이다.
- 세트의 잘라 낸 PDF(`split_asset_id`)에는 이 쪽이 들어 있지 않다. 원본 PDF(`source_asset_id`)를 `#page=N`으로 연다.
- 없는 세트도 많다(1·5호기와 Connection Beam에는 이 문서가 없다). 모르는 섹션 종류가 오면 건너뛰게 만들어 두면 다음에 종류가 늘어도 안전하다.
- 이 문서에 붙은 확인 칸도 `GetReportSet.reviews`에 함께 온다. 고치는 방법(`ResolveReview`)은 같다 — 한 번 고치면 세 세트에서 모두 고쳐진 것으로 보인다.

## 프론트 타입 처리 규칙

| proto 타입·표현 | 프론트 처리 |
|---|---|
| `int64`, `uint64` | JSON에서는 문자열로 올 수 있다. 나노초와 ID 성격 값은 `number`로 강제 변환하지 말고 생성 클라이언트의 타입 또는 `bigint`를 사용한다. |
| `google.protobuf.Timestamp` | protobuf JSON의 RFC 3339 문자열이다. 표시할 때만 사용자 시간대로 변환한다. |
| `optional` | 값이 없는 상태와 기본값을 구분한다. 예: `Track.visible`을 생략하면 생성 시 `true`다. |
| enum의 `*_UNSPECIFIED` | 선택하지 않음 또는 필터 없음이다. 화면의 실제 데이터 값으로 사용하지 않는다. |
| `google.protobuf.Struct` | 일반 JSON 객체다. `Asset.properties`, `ClipSource.locator`, `Section.fields`는 kind별로 필요한 키만 읽는다. `ClipSource.locator`는 모양이 정해져 있고 서버가 검사한다 — `pdf`: `{page}`·`{page, x, y, width, height}`·`{page_start, page_end}`, `image`: `{x, y, width, height}`, `pointcloud`: `{points: [[x,y,z], ...]}`(2D 좌표는 0~1 비율·좌상단 원점, 쪽은 1부터). 그 밖의 kind에 보내면 `InvalidArgument`다. PDF에서 글자나 문단을 고르게 해도 보낼 때는 그 사각형을 박스로 보낸다. |
| `google.protobuf.FieldMask` | 수정할 필드만 보낸다. JSON 표현은 쉼표로 구분한 lowerCamelCase 문자열이다. |
| `repeated` | 결과가 없으면 빈 배열로 취급한다. 순서 의미는 proto 주석을 따른다. |

시스템 ID(`job_id`, `asset_id`, `clip_id` 등)는 DB가 매기는 숫자(`int64`)다 — JSON에서는 문자열(`"128"`)로 오가고, 0은 "없음"이다.
표마다 따로 세므로 값만으로는 종류를 알 수 없다. 계산하지 말고 받은 값을 그대로 쓰며, 저장·재조회에는 URL 대신 ID를 사용한다.
바뀐 필드와 옮길 때 주의할 점은 `ID 숫자 전환 안내.md`에 있다(2026-10-08 운영 서버에 적용).

시간 구간은 별도 설명이 없으면 나노초 단위의 반열린 구간 `[start, end)`이다. 타임라인의 0은
`Job.started_at`, Asset 내부 시간의 0은 첫 샘플 또는 첫 프레임이다.

## 수정 요청 규칙

- `UpdateTimeline`, `UpdateTrack`, `UpdateClip`, `UpdateLabelValue`는 변경한 필드만
  `update_mask`에 넣는다. 화면에 보이지 않는 필드를 기본값으로 덮어쓰지 않는다.
- `ChangeTimelineStatus`는 화면이 조회한 현재 상태를 `from_status`로 보낸다. `ABORTED`면 최신
  타임라인을 다시 조회한 뒤 사용자에게 충돌을 알린다.
- 같은 트랙의 Clip 구간은 겹쳐도 된다(2026-10-13부터). 소스 구간이 Asset 길이를 넘으면 `INVALID_ARGUMENT`다.
- `UpdateClip`의 `source`는 통째로 바뀐다. 구간만 고쳐도 `asset_id`·`start_ns`·`end_ns`·`locator`를 모두 채워 보낸다(읽기 전용 두 칸은 빼도 된다).
- Clip을 만들면 해당 Asset은 작업에 자동 첨부된다. 별도의 `AttachAsset`을 먼저 호출할 필요가 없다.
- 삭제 RPC는 참조 중인 데이터에서 실패할 수 있다. 실패 사유를 숨기지 말고 서버 메시지를 표시한다.

예를 들어 타임라인 이름만 바꿀 때는 다음 형태다.

```json
{
  "timeline": {
    "jobId": "128",
    "name": "수정한 이름"
  },
  "updateMask": "name"
}
```

## 오류 처리

| 코드 | 의미 | 화면 처리 |
|---|---|---|
| `INVALID_ARGUMENT` | 요청 값이나 참조 관계가 잘못됨 | 입력값과 서버 메시지 표시 |
| `NOT_FOUND` | 대상이 없거나 이미 삭제됨 | 목록 또는 상세를 다시 조회 |
| `ALREADY_EXISTS` | 같은 식별자의 대상이 이미 있음 | 중복 생성하지 않고 기존 데이터 재조회 |
| `FAILED_PRECONDITION` | 참조 중이라 삭제 불가, Clip 구간 겹침 등 | 원인을 표시하고 현재 데이터 유지 |
| `ABORTED` | 상태가 다른 요청에서 먼저 변경됨 | 최신 데이터 재조회 후 재시도 여부 확인 |
| `UNIMPLEMENTED` | 아직 제공하지 않는 RPC | 기능을 노출하지 않음 |

네트워크 실패와 서버 오류는 자동으로 쓰기 요청을 반복하지 않는다. 재시도 전 최신 상태를 조회해
중복 생성 여부를 확인한다.

## 현재 사용하지 말아야 할 기능

- `ReportService.ListReportSets`: 당장 성적서 목록 화면에서 사용하지 않는다. 화면 요구가 생기면 연결한다.
- `AssetService.ListDuplicateAssets`: 운영자가 파일 중복을 정리하는 기능이므로 초기 프론트에서는 연결하지 않는다.
- `AssetService.ImportAssetFromSource`: 아직 구현되지 않았다.
- 외부 도구의 `StartRun`: 서버 설정이 완료되지 않으면 실행이 `QUEUED`에 머물 수 있다.
- `Timeline.embedded_at`: 현재 서버가 채우지 않는다(`Clip.embedded_at`은 채운다 — "2026-10-15에 바뀐 것").
- `Asset.source_path`: 내부 원본 경로이므로 화면 표시나 다운로드 URL로 사용하지 않는다.

## 공유할 때 함께 적을 값

아래 네 값만 이 문서와 proto 묶음에 덧붙여 전달한다.

```text
mediatag 기준 커밋:
API base URL: http://192.168.100.3:33210
허용된 프론트 origin: *
인증 방식:
```
