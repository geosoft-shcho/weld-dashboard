# ListJobs 호기 필터 변경 안내 (work.proto)

## 문서 이력

| 일자 | 수정자 | 수정 내용 |
|---|---|---|
| 2026-10-02 | geosoft-Server | 패스 필터·목록 — `ListJobsRequest.pass_no`, `ListJobFilters`의 이음부마다 패스 번호(§3) |
| 2026-10-02 | geosoft-Server | 품질 결과 RPC `ListQualityResults`(report.proto) — 작업·이음부 기준 검사 판정과 UT·MT 표(§7) |
| 2026-10-02 | geosoft-Server | DEMO·TTAG·TP129도 이음부 구조로 — 작업 ID·품목 코드가 바뀜(§6). 예시 공사는 용접 작업자 4명이 2명씩 팀으로 |
| 2026-10-02 | geosoft-Server | 수집 현황(`ListCollectionNodes`)에 품목 단계 추가(공사 → 품목 → 작업), 이음부 필터 `ListJobsRequest.joint_no`, `ListJobFilters`에 품목별 이음부 목록 |
| 2026-10-02 | geosoft-Server | 이음부 단위 작업 — `Job.joint_no`, 작업 ID에 이음부, 성적서 세트가 품목(`common_key`)에 붙음(report.proto). 예시 데이터(EX001~EX006)를 이음부 단위로 다시 만듦 |
| 2026-10-02 | geosoft-Server | 호기·품목 목록을 `Project.units`에서 새 RPC `ListJobFilters`로 옮김 — 필터 드롭다운 값(공사·호기·품목·작업자·장비)을 한 번에 받게. `Project.units`는 전달 전이라 그대로 뺌 |
| 2026-10-02 | geosoft-Server | 응답 내용이 달라진 것 갱신 — 성적서 재추출로 TP129 작업의 재질·제품번호·공정번호와 성적서 섹션의 새 칸·결재(approvals)가 채워짐, 데모 셀 품목 이름·약어 |
| 2026-10-01 | geosoft-Server | 처음 작성 — 구 대시보드의 작업지시 필터 자리를 공사 → 호기 → 품목으로 대신하려고 호기 필터와 호기·품목 목록을 추가 |

## 한눈에

`mediatag/proto/mediatag/work/v1/work.proto`에 RPC 하나와 칸 둘, `report/v1/report.proto`에 칸 셋이 **추가**됐습니다
(mediatag 928e7f3·bac2219·341c5fe·920217d 외).
기존 메시지·칸은 그대로라 예전 proto로 만든 코드도 그대로 동작합니다. 새 기능을 쓰려면 proto를 다시 받아
코드를 새로 생성해 주세요.

| 무엇 | 전(2026-10-01 15:51에 전달한 work.proto zip) | 후 |
|---|---|---|
| 작업 목록의 호기 필터 | 없음(`common_key` 부분 일치로 우회) | `ListJobsRequest.unit_no` |
| 필터 드롭다운 값 | `ListProjects`·`ListWorkers`·`ListEquipment`를 따로 호출, 호기·품목 목록은 없음 | `ListJobFilters` 한 번 — 공사(호기·품목 포함)·작업자·장비 |
| 작업의 단위 | 품목 하나에 작업 하나 | 이음부마다 작업 하나일 수 있음 — `Job.joint_no`(§3) |
| 이음부 필터·목록 | 없음 | `ListJobsRequest.joint_no`, `ProjectUnit.items[].joint_nos`(§3) |
| 수집 현황 트리 | 장비·작업자 → 공사 → 작업 → 패스 | 장비·작업자 → 공사 → **품목** → 작업 → 패스(§5) — 기존 화면 수정 필요 |
| 품질 결과 | 없음(구 대시보드 `ListQualityResults`) | `ReportService.ListQualityResults`(§7) |
| 성적서 세트 | 작업 하나에 붙음(`ReportSet.job_id`) | 품목에 붙음(`ReportSet.common_key`) — report.proto(§4) |

`ListProjects`·`ListWorkers`·`ListEquipment`는 바뀌지 않았습니다. **수집 현황(`ListCollectionNodes`)은 단계가 하나 늘어 화면 수정이 필요합니다(§5).**

## 메시지

```proto
service WorkService {
  // 작업 목록(ListJobs) 필터의 드롭다운 값을 한 번에: 공사(호기·품목 포함)·작업자·장비.
  rpc ListJobFilters(ListJobFiltersRequest) returns (ListJobFiltersResponse);  // 추가
}

message ListJobFiltersRequest {}

message ListJobFiltersResponse {
  repeated ProjectFilter projects = 1; // project_no 오름차순
  repeated Worker workers = 2;         // ListWorkers와 같은 목록
  repeated Equipment equipment = 3;    // ListEquipment와 같은 목록
}

message ProjectFilter {
  Project project = 1;
  repeated ProjectUnit units = 2;  // unit_no 오름차순
}

message ProjectUnit {
  string unit_no = 1;              // 정규화값 '05'. 호기 구분이 없는 공사는 '00' 하나
  repeated string item_codes = 2;  // 그 호기 작업의 품목(정규화값), 오름차순
}

message ListJobsRequest {
  string project_no = 1;
  string common_key = 2;
  string item_code = 3;
  string unit_no = 11;              // 추가
  // 이하 그대로(worker_id·master_only·equipment_id·started_from·started_to·page_size·page_token)
}
```

## 바뀐 점

### 1. `ListJobsRequest.unit_no` — 호기로 거르기

- 완전 일치입니다. 값은 정규화된 두 자리 문자열(`"05"`)입니다.
- 다른 필터와 AND로 묶입니다. `project_no` + `unit_no` + `item_code`를 함께 주면 그 호기의 그 품목 작업만 옵니다.
- 비우면 거르지 않습니다.
- 공사·호기·품목을 다 주면 **그 품목의 이음부 작업들**(2~7건)이 옵니다. 이음부(`joint_no`)까지 줘도 재작업이 있으면
  날짜가 다른 작업이 더 있습니다. 응답은 목록으로 받고, 작업 하나를 열 때는 `GetJob(job_id)`를 씁니다.

### 2. `ListJobFilters` — 필터 드롭다운 값을 한 번에

- 화면을 열 때 한 번 부르면 공사·호기·품목·작업자·장비 목록이 다 옵니다. 인자는 없습니다.
- 공사마다 그 공사 작업에 실제로 쓰인 호기와, 호기마다 그 호기의 품목이 옵니다.
- **품목은 호기 아래에 묶여 있습니다.** 호기마다 품목이 달라서입니다 — TP129는 1호기에 `LD-D`가 없고 `CB`는 1·3호기에만 있습니다.
  공사 전체 품목을 한 목록으로 주면 없는 조합(1호기 + `LD-D`)을 고를 수 있습니다.
- 호기 구분이 없는 공사(DEMO·TTAG)는 `unit_no`가 `"00"`인 항목 하나만 옵니다. 화면에는 "0호기"로 보이거나 호기 드롭다운을
  숨겨도 됩니다.
- 호기·품목은 따로 저장하는 표가 없습니다. 조회할 때 작업에서 모으므로, 작업이 하나도 없는 호기·품목은 나오지 않습니다.
- 품목은 코드(`LD-A`)만 옵니다. 이름(`LEG DIAGONAL "A"`)은 작업 목록의 `item_name`에 있습니다.
- 작업자·장비는 등록된 전체입니다(작업이 없는 것도 포함) — `ListWorkers`·`ListEquipment`와 같습니다.

화면 흐름:

1. 화면을 열 때 `ListJobFilters`를 한 번 부른다.
2. 공사를 고르면 그 공사의 `units`로 호기 드롭다운을 채운다.
3. 호기를 고르면 그 호기의 `item_codes`로 품목 드롭다운을 채운다.
4. 고른 값을 `ListJobs`의 `project_no`·`unit_no`·`item_code`·`worker_id`·`equipment_id`에 넣어 요청한다.

### 3. `Job.joint_no` — 이음부 단위 작업

```proto
message Job {
  // … 기존 칸 그대로
  string joint_no = 16;   // 추가. 이음부 번호('DGT-ELA-01'). 비면 품목 전체 작업
}
```

- 이음부 = 원주 용접 한 둘레입니다. 품목 하나(`LD-A`)에 이음부가 2~6개 있고, 용접은 이음부마다 따로 합니다.
- 그래서 **같은 공사·호기·품목(같은 `common_key`)에 작업이 여러 건** 옵니다 — 이음부마다 하나, 재작업이 있으면 같은
  `joint_no`에 날짜가 다른 작업이 더 있습니다. 목록에서 작업을 구분해 보여 줄 때 `joint_no`를 함께 보여 주세요.
- 작업 ID에도 이음부가 들어갑니다: `JOB-EX001_01-LD-A-ELA01-20260901_55AD`(`DGT-ELA-01` → `ELA01`). ID는 지금처럼
  통째로 다루면 됩니다 — 잘라서 해석하지 말고 값은 `joint_no`·`common_key`·`started_at`에서 읽어 주세요.
- 모든 공사가 이음부 단위입니다(§6). `joint_no`가 빈 작업은 지금 없습니다.
- 이음부로 거르기: `ListJobsRequest.joint_no`(완전 일치, `"DGT-ELA-01"`). 이음부 번호는 품목 안에서만 유일하므로
  `project_no`·`unit_no`·`item_code`와 함께 주세요.
- 이음부 드롭다운 값: `ListJobFilters`의 호기 아래 `items`에 품목마다 이음부 목록이 옵니다. `item_codes`는 그대로 있고
  `items`는 같은 품목·같은 순서입니다. 이음부 단위 작업이 없는 품목은 `joint_nos`가 비어 있습니다(지금은 없음).

```proto
message ListJobsRequest {
  string joint_no = 12;            // 추가
}
message ProjectUnit {
  string unit_no = 1;
  repeated string item_codes = 2;
  repeated ProjectItem items = 3;  // 추가
}
message ProjectItem {
  string item_code = 1;
  repeated string joint_nos = 2;    // 'DGT-ELA-01', 오름차순
  repeated ProjectJoint joints = 3; // 추가. joint_nos와 같은 이음부·같은 순서 + 이음부마다 패스
}
message ProjectJoint {
  string joint_no = 1;
  repeated int32 pass_nos = 2;      // 그 이음부 작업들에 있는 패스 번호, 오름차순(1 = 초층)
}
```

- 패스로 거르기: `ListJobsRequest.pass_no = 13` — 그 번호의 패스가 있는 작업만 옵니다(`0`이면 거르지 않음). 예: `passNo: 4`면
  4패스까지 한 작업만. 패스 ID는 규칙대로 `{job_id}-P{pass_no:02}`이므로 받은 작업 ID로 `GetPassWaveform`을 바로 부를 수 있습니다.
- 패스 드롭다운 값: `joints[].pass_nos`. 같은 이음부에 재작업이 있으면 그 작업들의 패스 번호를 합친 것입니다.
  패스가 없는 작업(성적서에서 만든 TP129)은 `pass_nos`가 비어 있습니다.

### 4. 성적서 세트가 품목에 붙음 (report.proto)

```proto
message ReportSet {
  string job_id = 2;       // 매칭할 때 고른 작업. 품목에 직접 매칭했으면 비어 있다
  string common_key = 14;  // 추가. 이 세트가 속한 품목. job_id와 둘 다 비면 미매칭
}
message ListReportSetsRequest {
  string job_id = 1;       // 그 작업에 매칭된 세트 + 그 작업의 품목에 매칭된 세트
  string common_key = 2;   // 추가. 품목의 세트
}
message MatchReportSetRequest {
  string report_set_id = 1;
  string job_id = 2;       // 작업에 매칭
  string common_key = 3;   // 추가. 품목에 매칭(job_id가 비었을 때). 둘 다 비면 매칭 해제
}
```

- 성적서는 품목 단위 문서라, 그 품목의 이음부 작업 모두가 같은 세트를 봅니다.
- **`ListReportSets(job_id)`는 전과 같이 부르면 됩니다** — 그 작업의 품목에 붙은 세트가 옵니다. 다만 응답의
  `ReportSet.job_id`가 비어 있을 수 있으니(예시 공사는 모두 비어 있음) "이 세트가 이 작업 것인가"를 `job_id` 비교로
  판단하지 말아 주세요.
- 작업 목록의 `hasReport`도 품목 기준입니다 — 같은 품목의 이음부 작업은 모두 같은 값입니다.
- `MatchReportSet`은 `job_id`나 `common_key` 중 하나를 줍니다. 둘 다 비우면 매칭 해제입니다(전과 같음).

### 5. 수집 현황 트리에 품목 단계 (`ListCollectionNodes`) — 화면 수정 필요

```proto
enum CollectionLevel {
  // … 기존 값 그대로
  COLLECTION_LEVEL_ITEM = 6;   // 추가. 품목(호기+품목 = common_key). 단계 순서는 공사 다음
}
message CollectionPath {
  // … 기존 칸 그대로
  string common_key = 8;       // 추가. 품목 단계
}
```

| | 전 | 후 |
|---|---|---|
| 단계 | 장비·작업자 → 공사 → 작업 → 패스 → 파일 | 장비·작업자 → 공사 → **품목** → 작업 → 패스 → 파일 |
| 공사 노드의 자식 | 작업(`LEVEL_JOB`) | 품목(`LEVEL_ITEM`) |
| 작업 노드 이름 | `1호기 LEG DIAGONAL "A" · 9/1` | `DGT-ELA-01 · 9/1`(이음부가 없는 작업은 전과 같음) |

- 품목 = 호기 + 품목(`common_key`, 예 `EX001_01-LD-A`)이고 노드 이름은 `1호기 LEG DIAGONAL "A"`입니다. 성적서 한 벌이
  붙는 단위이고, 구 대시보드의 작업지시 자리에 해당합니다. 그 아래 작업은 이음부마다 하나입니다.
- **받은 `path`를 그대로 `parent`로 돌려보내는 방식이면 호출 코드는 그대로 됩니다.** 고칠 곳은 "공사의 자식은 작업"이라고
  가정한 부분입니다 — 단계 깊이로 행 종류를 정하거나, 공사 노드를 펼친 결과를 작업으로 다루는 코드.
  행 종류는 `path.level`로 판단해 주세요. 값 `6`은 번호만 뒤에 붙었고 순서는 공사(3)와 작업(4) 사이입니다.
- 품목 노드의 `summary.jobCount`·`workDurationSeconds`와 `startedAt`·`endedAt`은 공사 노드와 같은 방식입니다
  (그 아래 작업 수·작업 시간 합, 처음 시작~마지막 종료).
- 호기 구분이 없는 공사(DEMO·TTAG)도 품목 단계가 있습니다 — 품목 하나에 작업 하나라 자식이 하나입니다.
- 작업에 첨부 안 된 파일(장비별 보기)은 공사·품목·작업 "미지정" 아래에 있습니다(미지정 단계도 하나 늘었습니다).
- 작업자별 보기에서 두 작업자가 한 품목의 이음부를 나눠 했으면, 같은 품목 노드가 두 작업자 아래에 각각 나옵니다.

### 6. 기존 공사(DEMO·TTAG·TP129)의 작업 ID가 바뀜

proto 변경은 없고 데이터가 바뀌었습니다. **저장해 둔 작업 ID·패스 ID·공통키가 있으면 다시 받아야 합니다.**

| 공사 | 전 | 후 |
|---|---|---|
| DEMO | 품목 `P600-1`·`P600-2` …(6개), 품목마다 작업 1건. `JOB-DEMO_00-P600-1-20260915_9665` | 품목 `P600`·`P900`·`P1050`(3개), 품목마다 작업 2건(이음부 `01`·`02` = 파이프 번호). `JOB-DEMO_00-P600-01-20260915_2B80`. 공통키 `DEMO_00-P600` |
| TTAG | `JOB-TTAG_00-T01-20260925_BAEA` | `JOB-TTAG_00-T01-01-20260925_BAEA` — 이음부 정보가 없는 라벨링 프로젝트라 이음부는 자리 값 `01`. 공통키·품목 그대로 |
| TP129 | 품목마다 작업 1건(31건). `JOB-TP129_05-LD-A-20260618_…` | 성적서 UT 표의 이음부마다 작업 1건(106건). `JOB-TP129_05-LD-A-ELA01-20260618_EFF1`. 공통키·품목 그대로 |

- 패스 ID는 `{job_id}-P{nn}`이라 DEMO 패스 ID도 같이 바뀌었습니다. 패스·타임라인·클립·첨부 내용은 그대로입니다.
- TP129 작업은 성적서에서 거꾸로 만든 것이라 패스·타임라인이 없습니다(전과 같음). 같은 품목의 이음부 작업은 기간
  (`started_at`~`ended_at` = 그 품목 성적서의 첫 검사일~마지막 검사일)과 성적서가 같습니다.
- TP129 성적서 세트의 `job_id`는 이제 비어 있고 `common_key`로 품목에 붙어 있습니다(§4).

### 7. 품질 결과 — `ReportService.ListQualityResults`

구 대시보드의 `ListQualityResults` 자리입니다. 작업(이음부)을 주면 그 이음부의 품질 결과가, 품목만 주면 그 품목의
이음부 전체가 표로 옵니다.

```proto
rpc ListQualityResults(ListQualityResultsRequest) returns (ListQualityResultsResponse);

message ListQualityResultsRequest {
  string job_id = 1;      // 그 작업의 품목과 이음부(그 이음부 행만)
  string common_key = 2;  // 품목(job_id가 비었을 때)
  string joint_no = 3;    // common_key와 함께: 그 이음부 행만. 비우면 이음부 전체
}
message ListQualityResultsResponse { repeated QualityReport reports = 1; }  // 성적서 세트마다(보통 1개). 없으면 빈 목록

message QualityReport {
  string report_set_id = 1;
  string common_key = 2;
  string split_asset_id = 3;                  // 이 세트의 PDF
  repeated QualityInspection inspections = 4; // 검사 종류별: 취부 → 용접 외관 → 치수 → 기밀 → UT → MT
  repeated JointQuality joints = 5;           // 이음부 표
}
message QualityInspection {
  SectionKind kind = 1; string method = 2;    // NDT일 때 'UT' | 'MT'
  string report_no = 3; string report_date = 4; string result = 5;
  optional int32 page_start = 6; optional int32 page_end = 7;
  string agency = 8; repeated QualityCheck checks = 9;
}
message QualityCheck { string name = 1; string criterion = 2; string actual = 3; string result = 4; }
message JointQuality { string joint_no = 1; repeated string job_ids = 2; UtResult ut = 3; MtResult mt = 4; }
message UtResult { string thickness_mm = 1; optional double length_mm = 2; optional int32 probe_angle = 3;
                   string indication = 4; string evaluation = 5; string result = 6; string inspection_date = 7; }
message MtResult { optional double check_length_mm = 1; optional double indication_length_mm = 2;
                   string indication = 3; string result = 4; }
```

- **검사는 두 층입니다.** `inspections`는 검사 종류별 머리 정보와 판정이고, 취부·용접 외관·치수·기밀은 품목 전체에 대한
  것이라 이음부를 골라도 같은 값이 옵니다. `joints`는 이음부(확인번호)마다 UT·MT 결과 한 행입니다.
- **작업과의 연결은 `joints[].job_ids`입니다.** 그 이음부의 작업 ID(재작업이 있으면 여러 개)가 들어 있습니다.
- 이음부를 안 주면 **MT 표에만 있는 번호도 옵니다**(`ut` 없음, `job_ids` 비어 있음) — 원주 이음이 아닌 짧은 용접이고 UT
  대상이 아닙니다. 예: LD-A는 원주 이음 6행 + 짧은 용접 6행.
- 검사 쪽을 열려면 `split_asset_id` PDF에서 `page_start`(원본 PDF 기준 쪽)를 씁니다 — `GetReportSet`과 같은 규칙입니다.
- 성적서가 없는 작업(DEMO·TTAG, 예시 중 성적서를 뺀 품목)은 빈 목록, 없는 작업 ID는 `not_found`입니다.

구 대시보드와 다른 점:

| | 구 대시보드 | 지금 |
|---|---|---|
| 연결 단위 | 패스·구간(ms) — `ListQualityLinks` | 이음부(작업)까지. 성적서에 패스·위치 구분이 없어 구간 연결은 없음 |
| 미디어 | 스캔 PDF + 현장 영상 | 스캔 PDF만(`split_asset_id`) |
| 검사자 | 이름 | 검사 기관만(`agency`) — 이름은 도장·서명 OCR이라 `GetReportSet`의 결재 섹션에 원문으로 |
| 판정 | 판정 + 불량 요약 | 원문 판정(`Accept`·`Reject`·`No Indication`)과 지시 유무. OCR이 못 읽은 칸은 빈값 |

값은 OCR 원문이라 오독이 섞여 있습니다(기관명 `KOSTEC CO., TD`, 2호기 LD-F의 MT 길이 `1` 등).

```json
// 작업 하나 — 이음부 한 행
{"jobId": "JOB-EX002_01-LD-A-ERA02-20260903_C9EE"}
→ {"reports": [{"reportSetId": "rpt_…", "commonKey": "EX002_01-LD-A", "inspections": [ …6건… ],
    "joints": [{"jointNo": "DGT-ERA-02", "jobIds": ["JOB-EX002_01-LD-A-ERA02-20260903_C9EE"],
      "ut": {"thicknessMm": "12", "lengthMm": 2871, "probeAngle": 70, "indication": "NO RECORDABLE INDICATION", "inspectionDate": "2025-12-17"},
      "mt": {"checkLengthMm": 2871, "indication": "NO RECORDABLE INDICATION"}}]}]}

// 품목 전체 — 이음부 표
{"commonKey": "TP129_05-LD-A"}
```

## 요청·응답 예

```json
// ListJobFilters 응답(발췌)
{"projects": [
  {"project": {"projectNo": "DEMO", "projectName": "데모 셀 용접 데이터셋"},
   "units": [{"unitNo": "00", "itemCodes": ["P1050", "P600", "P900"],
              "items": [{"itemCode": "P1050", "jointNos": ["01", "02"]}, {"itemCode": "P600", "jointNos": ["01", "02"]},
                        {"itemCode": "P900", "jointNos": ["01", "02"]}]}]},
  {"project": {"projectNo": "TP129", "projectName": "동원글로벌터미널부산 컨테이너크레인 제작설치 공사", "customer": "HD현대삼호"},
   "units": [
     {"unitNo": "01", "itemCodes": ["CB", "LD-A", "LD-B", "LD-C", "LD-E", "LD-F"]},
     {"unitNo": "02", "itemCodes": ["LD-A", "LD-B", "LD-C", "LD-D", "LD-E", "LD-F"]},
     {"unitNo": "03", "itemCodes": ["CB", "LD-A", "LD-B", "LD-C", "LD-D", "LD-E", "LD-F"]},
     {"unitNo": "04", "itemCodes": ["LD-A", "LD-B", "LD-C", "LD-D", "LD-E", "LD-F"]},
     {"unitNo": "05", "itemCodes": ["LD-A", "LD-B", "LD-C", "LD-D", "LD-E", "LD-F"]}]}],
 "workers": [{"workerId": "W-DEV-01", "workerName": "김명장(예시)", "team": "용접1팀", "isMaster": true}],
 "equipment": [{"equipmentId": "DEMO-ACTIONCAM"}]}

// ListJobs — TP129 5호기 전체(20건 — 이음부마다 1건)
{"projectNo": "TP129", "unitNo": "05"}

// ListJobs — TP129 5호기의 LD-A(6건 — 이음부 6곳). jointNo까지 주면 1건(재작업이 있으면 여러 건)
{"projectNo": "TP129", "unitNo": "05", "itemCode": "LD-A"}
```

## proto는 그대로인데 응답 내용이 달라진 것

적재 규칙과 데이터를 고쳐(2026-10-01~02), 칸 모양은 같지만 값이 달라졌습니다.

| RPC | 달라진 값 |
|---|---|
| `GetTimeline` | 클립의 음수 위치가 없어짐(0점 앞은 소스 구간에서 잘림). 클립이 패스 구간 안으로 잘림. 깊이 영상·액션캠 길이가 실제 길이로(전에는 최대 432초 길게 놓임). 이어 찍은 액션캠 파일이 한 트랙에 이어서 놓임("(2)" 겹침 트랙 없음) |
| `GetTimeline` (공사 TTAG) | 클립에 `labelValueId`가 채워짐. 설명 앞의 `speaker_1: ` 접두어가 빠짐. `source.locator`가 비어 옴 |
| `ListLabelVocabs` | 어휘 `subtitle_label`·`pose_target`·`torch_target`(상위 = `pose_target`의 `Torch`)가 생기고 `speaker`에 `speaker_1` 값이 추가됨 |
| `ListJobs`·`GetJob` (TP129) | `thicknessMm`·`outerDiameterMm`(품목별), `material`(`SNT355A`)이 채워짐. `itemNo`가 A~F에서 성적서에 찍힌 값 `N/A`로 바뀜 — A~F는 제품번호가 아니라 품목 구분 글자였음(구분은 `itemCode`·`itemName`에 있음). `operationNo`도 `N/A` |
| `ListJobs`·`GetJob` (DEMO) | `thicknessMm`(600→9, 900→12, 1050→25), `itemName`(`600 파이프`), `itemAbbr`(`P600`)가 채워짐 |
| 전부 (예시 공사 EX001~EX006) | 작업이 이음부 단위로 바뀜 — 268건(9월 132, 10월 136), 작업 ID가 모두 새로 발급됨. 용접 작업자는 4명(2명씩 팀)이고 한 사람이 한 달 14~15일, 일하는 날에 이음부 2~3개를 차례로 한다(이음부 하나가 점심·밤을 넘겨 이어지기도 함). 10월분은 조회 시점보다 미래 날짜일 수 있음 |
| `ListProjects` | TP129의 `customer`가 `HD현대삼호`로 채워짐 |
| `GetReportSet`(섹션 `fields`) | 섹션은 DB 칸 이름 그대로 내려가므로 새 칸이 키로 추가됨 — NDT: `ut_procedure_no`·`ut_thickness_size`·`ut_thickness_unit`·`mt_procedure_no`·`mt_inspector_agency`·`mt_particle_type_fluorescent`, 내압: `applied_code`. 전에 늘 비어 있던 `ut_test_method`·`ut_result_flag`·`ut_inspector_agency`·`mt_total_length_mm`·`mt_total_points`·치수 `applied_code_dimension`·`applied_code_straightness`도 채워짐 |
| `GetReportSet`(섹션 목록) | 결재 섹션(`SECTION_KIND_APPROVALS`)이 세트마다 하나 생김 — HSHI QM·감독원·NDT 검사자·승인자 이름. 도장·서명을 OCR로 읽은 값이라 오독이 섞여 있음(결재 칸 이미지는 전과 같이 따로 저장) |

## 적용 시점

서버가 새 코드로 다시 떠야 `ListJobFilters`와 `unit_no` 필터, `joint_no`, 성적서의 `common_key`, 수집 현황의 품목 단계가 동작합니다. 그 전에는 `ListJobFilters`가 `unimplemented`(404)로
오고, `unitNo`를 보내도 오류 없이 무시되어 거르지 않은 목록이 옵니다.
