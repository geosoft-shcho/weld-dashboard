# 프론트 proto 공유 안내

## 문서 이력

| 일자 | 수정자 | 수정 내용 |
|---|---|---|
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
- `ClipProvenance.input_clip_ids`는 없앴다(저장한 적이 없는 칸이었다). 클립끼리 잇는 것은 **관계 클립**으로 한다 — `CreateClip`에 `kind = RELATION`, 구간(`timeline_start_ns`·`timeline_end_ns`), `relation`(`from_clip_id`·`to_clip_id`)을 보낸다. 관계 종류는 태그처럼 `label_value_id`(라벨 값, 선택)로 고른다. "이 구간에서 from이 to와 관련 있다"는 뜻이고, from 클립의 구간 전체면 그 값을 그대로 넣는다. `source`는 비운다. 두 클립은 같은 작업의 것이어야 한다. 다른 클립처럼 트랙에 놓이므로 같은 트랙에서는 구간이 겹칠 수 없다(관계용 트랙을 따로 두고, 겹치면 트랙을 하나 더 쓴다). 고치기·지우기는 `UpdateClip`(구간, `label_value_id`, 설명)·`DeleteClip`이고, 잇는 클립을 지우면 관계 클립도 지워진다. 관계 종류용 어휘는 따로 없다 — 라벨 어휘(`LabelService`)에 관계 종류용 어휘를 하나 만들어 쓴다(키 `relation`을 권한다 — 태그 화면은 그 트리를 빼고, 관계 화면은 그 트리만 보여 준다).

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
| `google.protobuf.Struct` | 일반 JSON 객체다. `Asset.properties`, `ClipSource.locator`, `Section.fields`는 kind별로 필요한 키만 읽는다. |
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
- 같은 트랙의 Clip 구간은 겹칠 수 없다. `FAILED_PRECONDITION`이면 저장을 성공으로 간주하지 않는다.
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
- `Timeline.embedded_at`, `Clip.embedded_at`: 현재 서버가 채우지 않는다.
- `Asset.source_path`: 내부 원본 경로이므로 화면 표시나 다운로드 URL로 사용하지 않는다.

## 공유할 때 함께 적을 값

아래 네 값만 이 문서와 proto 묶음에 덧붙여 전달한다.

```text
mediatag 기준 커밋:
API base URL: http://192.168.100.3:33210
허용된 프론트 origin: *
인증 방식:
```
