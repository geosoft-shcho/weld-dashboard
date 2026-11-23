# 수집 현황 KPI · 타임라인 변경 안내 (work.proto · trace.proto · 업로드)

## 문서 이력

| 일자 | 수정자 | 수정 내용 |
|---|---|---|
| 2026-11-18 | geosoft-Server | 커버리지는 응답에 온 종류를 그대로 그리기(셀 종류는 서버가 정하고 바뀔 수 있음) |
| 2026-11-18 | geosoft-Server | 용접시간(`weld_duration_seconds`, 패스 구간 합) 카드 추가, 커버리지 분모를 용접시간으로. 타임라인 권장 동작(위 단계는 작업 단위, 작업 단계 · 확대 시 패스 단위). 끝 없는 작업은 점 |
| 2026-11-19 | geosoft-Server | KPI 카드 값은 새 RPC `GetCollectionSummary`로(전체 현황을 고정으로 보여 주기로 함 — FE 답). `ListCollectionNodesResponse.summary`는 뺌 |
| 2026-11-19 | geosoft-Server | 옛 장비 · 작업자 보기 값을 deprecated로 받아 공사 보기로 답함 — 깨지는 변경 없앰(화면을 옮기는 동안) |
| 2026-11-19 | geosoft-Server | 코멘트 임베딩(`comment_count` · `embedded_comment_count`, 16 · 17) — 임베딩 카드에 클립 · 메타와 함께 |
| 2026-11-19 | geosoft-Server | 메타 임베딩 카드(`attached_asset_count` · `embedded_attached_asset_count`, 14 · 15) |
| 2026-11-19 | geosoft-Server | 임베딩: 끝난 것은 `embedded_at >= updated_at`만, 50ms 이하 클립은 대상에서 뺌, 적재 추적에 `embed.started` · `failed` · `skipped` 이벤트(AI 서버 답 반영) |
| 2026-11-18 | geosoft-Server | 처음 작성 — FE 문의(KPI 카드를 서버 집계 필드로)에 대한 변경. mediatag `feat/collection-kpi`(배포 전), tacit-db 이관 42 |

## 한눈에

KPI 카드는 이제 서버가 센 값에 바인딩만 하면 됩니다. 새 RPC `GetCollectionSummary`를 화면을 열 때 한 번 부르세요. `ListCollectionNodes` 응답에서 화면이 직접 계산하던 코드는 지워 주세요.
유실률 · 지연 · 시각 동기 카드도 지웁니다. 이 셋은 장비가 계속 데이터를 보낸다는 가정의 목업 값이었고, 지금처럼 파일을 올리는 구조에서는 서버가 셀 근거가 없습니다.

**수집 현황의 장비 · 작업자 보기를 없앴습니다.** 공사 보기(`COLLECTION_VIEW_PROJECT`)로 옮기고, 작업자는 필터(`worker_id`)로 주세요.
옮기는 동안 화면이 깨지지 않게 옛 값(`COLLECTION_VIEW_EQUIPMENT` · `WORKER`)은 deprecated로 남겨 두었습니다 — 옛 값으로 부르면 서버가 **공사 보기로 답하고**
노드 `path.view`는 보낸 값 그대로 돌려줍니다(받은 path를 parent로 돌려보내면 그대로 이어짐). 맨 위 단계가 장비 대신 공사로 보일 뿐 오류는 없습니다.
옮기신 뒤 알려 주시면 옛 값을 지웁니다(그때 proto를 한 번 더 드립니다). proto는 지금 다시 받아 새 필드 · RPC를 쓰시면 됩니다.

| 무엇 | 전 | 후 |
|---|---|---|
| 트리 | 장비(또는 작업자) → 공사 → 품목 → 작업 → 파일 | **공사 → 품목 → 작업 → 파일** (`COLLECTION_VIEW_PROJECT`, 비워도 공사 보기) |
| 작업자 | 트리의 첫 단계 | 요청 `worker_id` 필터 |
| 파일 없는 작업 | 안 보임(집계가 파일에서 시작) | **보임** — 노드 · 막대 · 작업 수에 들어감 |
| KPI | 화면이 자식 노드 값을 더해 계산 | 새 RPC `WorkService.GetCollectionSummary`(전체 현황, 중복 없이 셈) |
| 적재 진행 · 실패 | 없음 | `TraceService.ListTraces`의 `total_count` |
| 날짜별 파일 수 · 용량 | 없음 | 새 RPC `WorkService.ListAssetCounts` |
| 파일 기록 시각 | 이미지 · PDF · JSON은 빌 수 있었음 | 비지 않음(출처를 함께 남김) |

## 1. `ListCollectionNodes`

```proto
message ListCollectionNodesRequest {
  CollectionPath parent = 1;   // view = COLLECTION_VIEW_PROJECT(비워도 됨). 루트는 level 비움
  ...                          // start_offset_ns · end_offset_ns · basis · segment_unit 그대로
  int64 worker_id = 6;         // 새로 — 그 작업자의 작업만(0이면 전체)
}

message ListCollectionNodesResponse {
  repeated CollectionNode nodes = 1; // 그대로(노드마다 summary도 그대로)
}

// 새 RPC — KPI 카드
rpc GetCollectionSummary(GetCollectionSummaryRequest) returns (GetCollectionSummaryResponse);
message GetCollectionSummaryRequest {
  CollectionPath parent = 1; // 비우면 전체 현황 — 카드는 이렇게 부르면 됩니다
  int64 worker_id = 2;       // 0이면 전체
}
message GetCollectionSummaryResponse {
  CollectionSummary summary = 1;
}
```

- 트리 단계는 공사(`COLLECTION_LEVEL_PROJECT`) → 품목(`ITEM`) → 작업(`JOB`) → 파일입니다. `CollectionPath`에서 `equipment_id` · `worker_id`(3 · 4)는 지웠습니다.
- KPI 카드는 `GetCollectionSummary`를 **parent를 비워** 화면을 열 때 한 번 부르면 됩니다(전체 현황). 운영 크기에서 1초 가까이 걸리니 노드를 열 때마다 부르지 마세요. `parent` · `worker_id`를 주면 그 범위만 셉니다(규칙은 `ListCollectionNodes`와 같음).
- **자식 노드의 `summary`를 더해 전체를 만들지 마세요.** 파일 하나가 여러 작업에 붙어 있으면 두 번 셉니다.
- `worker_id`를 주면 작업에 붙지 않은 파일("미지정" 노드)은 빠집니다. 그런 파일에는 작업자가 없습니다.
- 파일 없는 작업 노드는 `has_children = false`입니다.
- **끝 시각이 없는 작업**(시작만 있는 작업 — 예: 성적서에서 만든 TP129 이음부 작업)은 `started_at = ended_at`인 길이 0 구간으로 옵니다. 타임라인에 점(◆ 등)으로 그려 주세요. 작업시간 · 커버리지에는 들어가지 않습니다.
- **조건을 바꾸면 열린 줄을 모두 다시 불러 주세요.** 위 노드 막대는 늘 아래 노드 막대를 덮습니다. 하지만 트리를 단계마다 따로 부르기 때문에, `basis` · `segment_unit` · `worker_id`를 바꾼 뒤 일부만 다시 부르면 위아래 조건이 섞입니다.

### KPI 카드 바인딩

```proto
message CollectionSummary {
  int64 asset_count = 1;              // 파일 수
  int64 total_size_bytes = 2;         // 용량
  ...
  int64 job_count = 6;                // 작업 수(파일 없는 작업 포함)
  int64 work_duration_seconds = 7;    // 작업시간 합(초). 종료 시각이 없는 작업은 빠짐
  int64 job_without_asset_count = 8;  // 파일이 하나도 없는 작업
  int64 clip_count = 9;               // 임베딩 대상 클립(장비가 기록한 영상 · 음성 · 센서 · 포즈, 50ms 넘는 것)
  int64 embedded_clip_count = 10;     // 그중 지금 내용까지 임베딩이 끝난 것(임베딩 뒤 고친 클립은 빠짐)
  int64 time_unverified_asset_count = 11; // 시각 확인 필요(아래 §4)
  repeated KindCoverage coverage = 12;    // 기록 커버리지(종류별) — 용접시간 중 기록이 덮은 초
  int64 weld_duration_seconds = 13;       // 용접시간(초): 패스 구간 합, 패스가 없는 작업은 작업 구간
  int64 attached_asset_count = 14;        // 메타 임베딩 대상: 작업 × 파일 쌍(파일 하나가 두 작업에 붙으면 2)
  int64 embedded_attached_asset_count = 15; // 그중 지금 내용까지 임베딩된 것(파일 · 첨부를 고친 뒤는 빠짐)
  int64 comment_count = 16;                 // 코멘트 임베딩 대상: 아래 작업에 달린 코멘트(작업 없는 코멘트는 범위 밖)
  int64 embedded_comment_count = 17;        // 그중 지금 내용(본문 + STT 자막)까지 임베딩된 것
}
message KindCoverage {
  mediatag.asset.v1.AssetKind kind = 1;
  int64 covered_seconds = 2;
}
```

| 카드 | 값 |
|---|---|
| 파일 수 · 용량 | `asset_count` · `total_size_bytes` |
| 작업 수 · 작업시간 | `job_count` · `work_duration_seconds` — 작업이 열려 있던 시간(시작~끝) |
| 용접시간 | `weld_duration_seconds` — 패스 구간 합(패스가 없는 작업은 작업 구간) |
| 자료 없는 작업 | `job_without_asset_count` |
| 임베딩 진행 | `embedded_clip_count / clip_count` — 클립을 고치면 AI 서버가 다음 회차(1분 안팎)에 다시 할 때까지 잠깐 줄어듭니다. AI 서버가 임베딩하지 않는 50ms 이하 클립은 분모에서 뺍니다. 깊이(pointcloud)는 타임라인에 놓지 않아(브라우저가 그리지 못하는 16비트 원본 — `타임라인 그리기와 재생 안내.md` §5.2) 여기 안 나옵니다. 메타 임베딩에는 나옵니다 |
| 메타 임베딩 | `embedded_attached_asset_count / attached_asset_count` — AI 서버는 작업에 붙은 파일마다 메타 문서(파일명 · 종류 · 설비 · 작업 정보)를 만듭니다. 작업에 안 붙은 파일은 검색되지 않습니다<br>**배포 직후에는 0%로 보입니다.** 완료 시각 칸(`job_asset.embedded_at`)을 이번에 새로 만들어, AI 서버가 메타 임베딩 완료 통지를 보내기 시작해야 채워집니다(운영 사본 시험: 0 / 17,666). 그때까지 이 카드는 숨기거나 "집계 준비 중"으로 보여 주세요. AI 서버가 옮기면 따로 알려 드립니다 |
| 코멘트 임베딩 | `embedded_comment_count / comment_count` — AI 서버는 코멘트마다 본문 + STT 자막으로 문서 하나를 만듭니다. STT 자막이 나중에 생기면 다시 임베딩될 때까지 잠깐 줄어듭니다. 메타와 마찬가지로 **배포 직후 0%**(AI 서버가 코멘트 완료 통지를 보내기 시작해야 채워짐) |
| 시각 확인 필요 | `time_unverified_asset_count` |
| 기록 커버리지(종류별) | `coverage[k].covered_seconds / weld_duration_seconds` — 용접하는 동안 그 종류의 기록이 덮은 비율. 클립이 없는 종류는 목록에 없음(= 0%) |
| 적재 진행 · 실패 | §2 |

- 커버리지는 작업마다 클립 구간을 합친 뒤 **용접 구간**(시각이 있는 패스들, 패스가 없으면 작업 구간)과 겹친 길이를 셉니다. 패스 사이 쉬는 시간의 기록은 세지 않습니다. 도구가 만든 결과(STT 자막 · 포즈 추출)는 세지 않습니다.
- **커버리지 카드는 응답 `coverage`에 온 종류를 그대로 그려 주세요**(종류를 화면에 고정하지 말 것). 어떤 종류를 셀지는 서버가 정하고 나중에 바뀔 수 있습니다 — 지금은 영상 · 음성 · 센서(timeseries) · 포즈. 깊이(pointcloud)는 타임라인에 놓지 않아 나오지 않습니다(나중에 놓게 되면 서버가 바로 셉니다). 종류 이름은 `AssetKind`로 오고, 클립이 없는 종류는 목록에 없습니다(= 0%).
- 운영 값(이관 44 뒤 사본, 11-18): 작업시간 약 2,000시간, 용접시간 264시간, 커버리지 영상 83% · 센서 88% · 포즈 80% · 음성 약 0%.
- 업로드 직후에는 후처리가 클립을 놓기 전이라 커버리지가 잠깐 낮게 보일 수 있습니다. 정상입니다.

### 타임라인 단위 (권장)

막대 단위는 요청 `segment_unit`으로 고릅니다(서버는 그대로). 패스 단위 막대와 커버리지는 같은 구간 규칙(패스, 없으면 작업)을 써서 화면과 숫자가 맞습니다.

| 볼 때 | `segment_unit` | 막대 |
|---|---|---|
| 공사 · 품목 단계, 몇 주 ~ 몇 달 축 | `SEGMENT_UNIT_JOB`(기본) | 작업 시작~끝 — "언제 작업했나" |
| 작업 단계로 내려가거나 시간 단위로 확대 | `SEGMENT_UNIT_PASS` | 패스 구간들 — "실제로 언제 용접했나", 패스 사이 빈 시간이 보임 |

자동으로 바꾸든 토글로 두든 화면에서 정해 주세요. 끝이 없는 작업은 어느 단위든 점입니다.

## 2. 적재 진행 · 실패 — `ListTracesResponse.total_count`

```proto
message ListTracesResponse {
  repeated Trace traces = 1;
  string next_page_token = 2;
  int64 total_count = 3; // 새로 — 조건(status · asset_id · trace_ids)에 맞는 전체 건수(쪽 넘김과 상관없음)
}
```

`status = TRACE_STATUS_RUNNING`과 `TRACE_STATUS_FAILED`로 `page_size = 1` 요청을 두 번 보내고 `total_count`만 보세요.

- 늘 **전체** 건수입니다. 등록 전에 실패한 업로드는 공사 · 작업에 이어지지 않아, 트리 선택이나 작업자 필터로 나눌 수 없습니다.
- 11-17 배포부터 쌓인 업로드만 셉니다.

### 임베딩 이벤트(적재 추적)

업로드 한 건의 추적(`GetTrace`)에 AI 서버의 임베딩 통지가 이벤트로 붙습니다. 클립에 새 칸은 없습니다(끝났는지는 지금처럼 `Clip.embedded_at`).

| 이벤트 | 상태 | 뜻 | 추적 상태 |
|---|---|---|---|
| `embed.started` | started | AI 서버가 이번 회차에 그 클립을 골랐음 — "임베딩 중" | running |
| `embed.done` | ok | 끝(지금도 있음) | running, 기다리는 클립이 다 빠지면 `done.searchable` → done |
| `embed.failed` | failed | 회차 실패(`error_code` · `error_message`) | failed — 다음 회차에 `embed.started`가 오면 running으로 돌아옴 |
| `embed.skipped` | skipped | 대상 아님(`detail.reason`: `too_short` · `zero_length` · `no_content` · `no_job`) | 기다림에서 빠짐 |

- 추적은 11-17 이후 업로드에만 있습니다. 그 전 클립과 화면에서 만든 태그 · 영역 클립은 `embedded_at`만 봅니다.
- AI 서버가 멈췄는지는 이벤트로 알 수 없습니다(한 회차가 오래 걸릴 수 있음). AI 서버 상태 확인은 따로 요청해 두었습니다.

## 3. 날짜별 파일 수 · 용량 — `ListAssetCounts` (새 RPC)

```proto
rpc ListAssetCounts(ListAssetCountsRequest) returns (ListAssetCountsResponse);

enum AssetTimeBasis {
  ASSET_TIME_BASIS_UNSPECIFIED = 0; // = COLLECTED
  ASSET_TIME_BASIS_COLLECTED = 1;   // 수집(적재) 시각 — 서버가 받은 날
  ASSET_TIME_BASIS_RECORDED = 2;    // 기록 시각 — 기록을 시작한 날
}
message ListAssetCountsRequest {
  AssetTimeBasis basis = 1;
  CollectionPath parent = 2;          // ListCollectionNodes와 같은 값
  int64 worker_id = 3;                // ListCollectionNodes와 같은 값
  google.protobuf.Timestamp from = 4; // [from, to). 비면 처음 / 끝까지
  google.protobuf.Timestamp to = 5;
}
message AssetCount {
  string date = 1;                      // "2026-09-21"(한국 시각 날짜)
  mediatag.asset.v1.AssetKind kind = 2;
  int64 asset_count = 3;
  int64 total_size_bytes = 4;
}
message ListAssetCountsResponse {
  repeated AssetCount counts = 1; // 날짜 · 종류 순. 0인 칸은 없음
}
```

- 트리에서 고른 노드의 `parent`와 작업자 필터를 그대로 넘기면 됩니다. 날짜별 값을 모두 더하면 같은 조건의 `GetCollectionSummary` `asset_count` · `total_size_bytes`와 같습니다.
- 수집 시각과 기록 시각 기준을 나란히 그리면 늦게 올라온 자료가 보입니다(예: 9/3에 기록한 자료가 9/10에 들어옴). 지연 카드는 이 그래프가 대신합니다.
- 하루 단위입니다. 주 단위로 보려면 화면에서 더해 주세요.

## 4. 업로드: `fileModifiedAt`, 기록 시각은 비지 않음

업로드 `metadata` JSON에 **`fileModifiedAt`(RFC 3339, 선택)**을 더했습니다. **모든 업로드에 브라우저 `File.lastModified`를 담아 보내 주세요.**

```js
metadata: JSON.stringify({ ...기존값, fileModifiedAt: new Date(file.lastModified).toISOString() })
```

이미지 · PDF · JSON처럼 시간 자료가 아닌 파일의 기록 시각은 아래 순서로 정해집니다. 시간 자료(영상 · 음성 · 센서 · 포즈 · 깊이)는 지금과 같습니다(`timeOrigin` 또는 파일 안 시각, 없으면 400).

1. `timeOrigin`(사람이 입력)
2. 같은 내용(sha256)의 사본에 이미 있는 기록 시각
3. 파일 안 시각: 사진 EXIF 촬영 시각, PDF 작성일. 후처리가 읽어서 4 · 5를 올려 씁니다
4. `fileModifiedAt`
5. 서버가 받은 시각

어디서 왔는지는 `Asset.properties.upload.time_source`에 남습니다.

| 값 | 뜻 | 시각 확인 필요 |
|---|---|---|
| 없음 | 사람이 입력한 `timeOrigin`(또는 그것을 물려받음) · 센서 파일 안 절대 시각 | 아니요 |
| `creation_time` | 영상 · 음성에 적힌 촬영 시각(기기 시계) | 예 |
| `exif` · `pdf_created` | 사진 촬영 시각 · PDF 작성일 | 예 |
| `file_modified` | `fileModifiedAt` | 예 |
| `collected` | 서버가 받은 시각 | 예 |

PDF 작성일은 PDF를 만든(스캔 · 내보내기) 시각입니다. 검사일이나 작업 시각이 아닐 수 있습니다.

## 5. 지울 것(화면)

- 유실률 · 지연 · 시각 동기 카드
- 장비 · 작업자 보기 전환. 작업자는 필터로, 장비 보기는 없습니다
- `ListCollectionNodes` 자식 값을 더해 KPI를 계산하던 코드
