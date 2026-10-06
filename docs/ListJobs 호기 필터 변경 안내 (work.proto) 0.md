# ListJobs 호기 필터 변경 안내 (work.proto)

## 문서 이력

| 일자 | 수정자 | 수정 내용 |
|---|---|---|
| 2026-10-02 | geosoft-Server | 호기·품목 목록을 `Project.units`에서 새 RPC `ListJobFilters`로 옮김 — 필터 드롭다운 값(공사·호기·품목·작업자·장비)을 한 번에 받게. `Project.units`는 전달 전이라 그대로 뺌 |
| 2026-10-02 | geosoft-Server | 응답 내용이 달라진 것 갱신 — 성적서 재추출로 TP129 작업의 재질·제품번호·공정번호와 성적서 섹션의 새 칸·결재(approvals)가 채워짐, 데모 셀 품목 이름·약어 |
| 2026-10-01 | geosoft-Server | 처음 작성 — 구 대시보드의 작업지시 필터 자리를 공사 → 호기 → 품목으로 대신하려고 호기 필터와 호기·품목 목록을 추가 |

## 한눈에

`mediatag/proto/mediatag/work/v1/work.proto`에 RPC 하나와 칸 하나가 **추가**됐습니다(mediatag 928e7f3·bac2219).
기존 메시지·칸은 그대로라 예전 proto로 만든 코드도 그대로 동작합니다. 새 기능을 쓰려면 proto를 다시 받아
코드를 새로 생성해 주세요.

| 무엇 | 전(2026-10-01 15:51에 전달한 work.proto zip) | 후 |
|---|---|---|
| 작업 목록의 호기 필터 | 없음(`common_key` 부분 일치로 우회) | `ListJobsRequest.unit_no` |
| 필터 드롭다운 값 | `ListProjects`·`ListWorkers`·`ListEquipment`를 따로 호출, 호기·품목 목록은 없음 | `ListJobFilters` 한 번 — 공사(호기·품목 포함)·작업자·장비 |

`ListProjects`·`ListWorkers`·`ListEquipment`와 수집 현황(`ListCollectionNodes`)은 바뀌지 않았습니다.

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
- 공사·호기·품목을 다 줘도 **작업이 하나라는 보장은 없습니다.** 같은 품목을 재작업하면 같은 조합에 날짜가 다른 작업이
  더 생깁니다(지금 데이터는 조합마다 1건). 응답은 목록으로 받고, 작업 하나를 열 때는 `GetJob(job_id)`를 씁니다.

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

## 요청·응답 예

```json
// ListJobFilters 응답(발췌)
{"projects": [
  {"project": {"projectNo": "DEMO", "projectName": "데모 셀 용접 데이터셋"},
   "units": [{"unitNo": "00", "itemCodes": ["P1050-1", "P1050-2", "P600-1", "P600-2", "P900-1", "P900-2"]}]},
  {"project": {"projectNo": "TP129", "projectName": "동원글로벌터미널부산 컨테이너크레인 제작설치 공사", "customer": "HD현대삼호"},
   "units": [
     {"unitNo": "01", "itemCodes": ["CB", "LD-A", "LD-B", "LD-C", "LD-E", "LD-F"]},
     {"unitNo": "02", "itemCodes": ["LD-A", "LD-B", "LD-C", "LD-D", "LD-E", "LD-F"]},
     {"unitNo": "03", "itemCodes": ["CB", "LD-A", "LD-B", "LD-C", "LD-D", "LD-E", "LD-F"]},
     {"unitNo": "04", "itemCodes": ["LD-A", "LD-B", "LD-C", "LD-D", "LD-E", "LD-F"]},
     {"unitNo": "05", "itemCodes": ["LD-A", "LD-B", "LD-C", "LD-D", "LD-E", "LD-F"]}]}],
 "workers": [{"workerId": "W-DEV-01", "workerName": "김명장(예시)", "team": "용접1팀", "isMaster": true}],
 "equipment": [{"equipmentId": "DEMO-ACTIONCAM"}]}

// ListJobs — TP129 5호기 전체(6건)
{"projectNo": "TP129", "unitNo": "05"}

// ListJobs — TP129 5호기의 LD-A(현재 1건, 재작업이 있으면 여러 건)
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
| `ListJobs`·`GetJob` (DEMO) | `thicknessMm`(600→9, 900→12, 1050→25), `itemName`(`600 파이프 1번`), `itemAbbr`(`P600`)가 채워짐 |
| `ListProjects` | TP129의 `customer`가 `HD현대삼호`로 채워짐 |
| `GetReportSet`(섹션 `fields`) | 섹션은 DB 칸 이름 그대로 내려가므로 새 칸이 키로 추가됨 — NDT: `ut_procedure_no`·`ut_thickness_size`·`ut_thickness_unit`·`mt_procedure_no`·`mt_inspector_agency`·`mt_particle_type_fluorescent`, 내압: `applied_code`. 전에 늘 비어 있던 `ut_test_method`·`ut_result_flag`·`ut_inspector_agency`·`mt_total_length_mm`·`mt_total_points`·치수 `applied_code_dimension`·`applied_code_straightness`도 채워짐 |
| `GetReportSet`(섹션 목록) | 결재 섹션(`SECTION_KIND_APPROVALS`)이 세트마다 하나 생김 — HSHI QM·감독원·NDT 검사자·승인자 이름. 도장·서명을 OCR로 읽은 값이라 오독이 섞여 있음(결재 칸 이미지는 전과 같이 따로 저장) |

## 적용 시점

서버가 새 코드로 다시 떠야 `ListJobFilters`와 `unit_no` 필터가 동작합니다. 그 전에는 `ListJobFilters`가 `unimplemented`(404)로
오고, `unitNo`를 보내도 오류 없이 무시되어 거르지 않은 목록이 옵니다.
