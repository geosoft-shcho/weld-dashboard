# ID 숫자 전환 안내

tacit-db와 mediatag API의 시스템 ID를 글자(조합 값·접두어 + ULID·UUID)에서 DB가 매기는 숫자로 바꾸는 변경을 정리한다.
정본 아님. 키·테이블의 정본은 `공통키 및 작업 타임라인 통합 설계.md`, 이름 규칙은 `docs/로컬규칙/식별자 이름 규칙.md`다.

## 문서 이력

| 일자 | 수정자 | 수정 내용 |
|---|---|---|
| 2026-10-08 | geosoft-Server | 운영 DB·서버에 적용함(이관 1~6, 2026-10-08 08:37) |
| 2026-10-08 | geosoft-Server | `worker_code`는 2026-10-08에 다시 없앰(이관 5, `업로드·기준정보 수정안.md` 1단계) — 쓰는 곳이 없었음. `job.item_abbr`도 함께 삭제 |
| 2026-10-07 | geosoft-Server | 작업이 공사를 `project_id`로 가리키게 함(`job.project_no` 삭제) — 공사에 ID가 생겼는데 작업만 글자로 가리키는 것이 어긋나서 |
| 2026-10-07 | geosoft-Server | 공사에도 숫자 ID(`project_id`)를 둠 — 공사만 예외로 남기지 않으려고. 작업·성적서의 연결 값은 공사 번호 그대로. 이관 스크립트 4 |
| 2026-10-07 | geosoft-Server | 작업자·장비 ID도 숫자로 — 이름은 `_id`인데 값이 사람이 정한 글자라 규칙과 어긋나 있었음. 옛 값은 `worker_code`·`equipment_code`로 남기고 이관 스크립트 3을 더함 |
| 2026-10-07 | geosoft-Server | 나머지 시스템 ID(에셋·클립·트랙·라벨 값·성적서 세트·문서·도구·도구 실행)도 숫자로 넓히고, 도구 실행의 대상 칸(`target_id`)을 종류별 칸 셋으로 나눔 — ID 형식을 하나로 통일하려고. 파일 이름을 `작업·패스 ID 숫자 전환 안내.md`에서 바꿈 |
| 2026-10-07 | geosoft-Server | 처음 작성 — 작업 ID가 공사·호기·품목·이음부를 조합한 글자라 그 값을 고치면 ID와 실제 값이 어긋나는 문제를 풀려고, 작업·패스 ID는 숫자로 바꾸고 조합 값은 `job_key`로 분리 |

## 한눈에

**2026-10-08 08:37에 운영 DB와 서버에 적용했다**(이관 1~6, 그 뒤 `smoke_rpc.py` 73건 실패 없음). 프런트는 새 proto로 맞춰야 한다 —
ID 타입이 전부 바뀌었다. 적용 전 덤프는 `/mnt/nas_aic/tacit/backups/tacit-db_2026-10-08_pre-numeric-ids.dump`.

| 무엇 | 전 | 후 |
|---|---|---|
| 작업 ID `job_id` | 글자 `JOB-TP129_05-LD-A-ELA01-20251203_F2B9` | 숫자 `128`(DB가 매김, 뜻 없음) |
| 사람이 읽는 작업 값 | `job_id`가 겸함 | `job_key`(글자, 형식은 옛 `job_id` 그대로) |
| 패스 ID `pass_id` | 글자 `{job_id}-P01` | 숫자 |
| 에셋·클립·트랙·라벨 값·성적서 세트·문서·도구 ID | 글자 `ast_<ULID>`·`clp_…`·`trk_…`·`lv_…`·`rpt_…`·`dcm_…`·`tol_…` | 숫자 |
| 도구 실행 ID `run_id` | UUID | 숫자 |
| proto 타입 | `string` | `int64` |
| 도구 실행의 대상 | `target_id` 한 칸(글자, 접두어로 종류 구분) | `target`의 `job_id`·`asset_id`·`clip_id` 중 하나 |
| 작업자·장비 ID `worker_id`·`equipment_id` | 글자 `W-DEV-01`·`DEMO-DEPTH-FRONT` | 숫자. 장비의 옛 값은 `equipment_code`. 작업자의 옛 값(`worker_code`)은 이관 5에서 없앴다(`backup.worker_code_20261008`) |
| 공사 | `project_no`(글자)가 기본 키, 작업이 이 값으로 공사를 가리킴 | 숫자 `project_id`가 기본 키이고 작업도 `project_id`로 가리킨다. `project_no`는 공사 표의 유일 칸으로 남는다 |
| 라벨 어휘 `key` | 글자 | 그대로(§7) |

## 1. 왜 바꾸나

작업 ID는 `JOB-{공사}_{호기}-{품목}-{이음부}-{날짜}_{해시}`로, 작업의 속성을 조합한 값이었다. 화면에서 공사·호기·품목·
이음부를 고칠 수 있게 하려니 두 길밖에 없었다.

- ID를 그대로 두면 ID에 적힌 글자와 실제 값이 어긋난다(호기를 06으로 고쳐도 ID에는 `_05-`가 남는다).
- ID를 다시 만들면 그 작업을 가리키는 모든 행과 밖에 나간 ID가 함께 바뀌어야 한다.

식별과 표시를 한 값이 겸해서 생기는 문제라, 둘을 나눴다. 식별은 뜻 없는 숫자(`job_id`)가 하고, 사람이 읽는 조합 값은
`job_key`로 두어 속성을 고치면 다시 계산한다.

나머지 ID는 이 문제가 없었지만(뜻 없는 ULID·UUID) 형식을 하나로 맞추려고 함께 바꿨다. 속도 때문은 아니다 — 가장 큰 표가
2만 행 안팎이라 타입에 따른 차이는 재지지 않는다.

## 2. 식별자 이름 규칙

`docs/로컬규칙/식별자 이름 규칙.md`에 정했다. 요약하면 시스템 키는 `[엔터티]_id`(자동 증가 숫자), 조합 값은 `_key`, 분류 값은
`_code`, 문서에 적힌 번호와 순서는 `_no`다. 숫자는 표마다 따로 세므로 작업 128과 에셋 128은 서로 상관없고, 값만으로는
종류를 알 수 없다 — 필드 이름으로 구분한다.

## 3. DB 변경

| 대상 | 전 | 후 |
|---|---|---|
| `tacit.job.job_id`, `tacit.pass.pass_id` | text | bigint(자동 증가) |
| `tacit.job.job_key` | 없음 | text, 필수, 유일. 옛 `job_id` 값 |
| `tacit.asset.asset_id`, `tacit.clip.clip_id`, `tacit.track.track_id`, `tacit.label_value.value_id`, `tacit.tool.tool_id`, `doc.report_set.report_set_id`, `doc.document.document_id` | text | bigint(자동 증가) |
| `tacit.tool_run.run_id` | uuid | bigint(자동 증가) |
| `tacit.worker.worker_id`, `tacit.equipment.equipment_id`(와 `job.worker_id`·`asset.equipment_id`) | text | bigint(자동 증가) |
| `tacit.equipment.equipment_code` | 없음 | text, 유일, 없어도 됨. 옛 ID 값 |
| 위 ID를 가리키는 칸(이름이 `…job_id`·`…pass_id`·`…asset_id`·`…clip_id`·`…track_id`·`…value_id`·`…report_set_id`·`…document_id`·`…tool_id`·`…run_id`로 끝나는 칸) | text·uuid | bigint, 값은 새 번호 |
| `tacit.tool_run.target_id` | text(접두어로 종류 구분, FK 없음) | 없앰. `job_id`·`asset_id`·`clip_id` 칸 셋(FK), 많아야 하나만 채움 |
| `tacit.asset_provenance.parameters`의 `target_id` | 글자 ID | `asset_id` 또는 `clip_id`(숫자) |

- 옛 ID는 `backup.id_map_20261007(entity, old_id, new_id)`에 남는다(작업은 `job.job_key`가 옛 ID다). 로그나 저장해 둔 주소의
  옛 ID를 찾을 때 쓴다.
- 도구 실행의 대상을 지우면 그 칸만 비고 실행 기록은 남는다(`ON DELETE SET NULL`). 전에는 FK가 없어 없는 ID가 그대로
  남았고, 이관 때 이미 없는 대상을 가리키던 실행은 대상 칸이 모두 빈다.
- FK는 49개에서 52개가 된다(도구 실행의 대상 칸 셋). 그 밖의 FK·유일 제약·인덱스는 그대로다.
- `asset_provenance.parameters`의 `tacit_tag_asset_id`는 옛 tacit-tag 시스템의 ID라 그대로 둔다.

## 4. proto 변경

ID 필드는 이름과 번호를 그대로 두고 타입만 `string`에서 `int64`로 바꿨다. 예외는 도구 실행의 대상이다.

| proto | 바뀌는 것 |
|---|---|
| `work.proto` | `job_id`·`pass_id`·`comparison_pass_id`·`asset_id`(파형의 표준화 Asset)·`worker_id`·`equipment_id`. 새 필드 `Job.job_key`·`Equipment.equipment_code`. `Worker.worker_code`(5)·`Job.item_abbr`(7)는 없앴다(번호 `reserved`). 새 RPC는 `공사·작업·패스 관리와 업로드 안내.md` |
| `asset.proto` | `asset_id`·`parent_asset_id`·`job_id`·`pass_id`·`equipment_id`·`Provenance.run_id`·`tool_id` |
| `compose.proto` | `job_id`·`pass_id`·`track_id`·`clip_id`·`label_value_id`·`value_id`·`parent_value_id`·`ClipSource.asset_id`·`ClipProvenance.run_id`·`tool_id`·`input_clip_ids`·`LabelRef.value_id` |
| `report.proto` | `report_set_id`·`job_id`·`source_asset_id`·`split_asset_id`·`JointQuality.job_ids` |
| `tool.proto` | `tool_id`·`run_id`·`output_asset_ids`. `target_id`(글자)는 없어지고 `RunTarget target`이 생김 — `ToolRun.target`(17번), `StartRunRequest.target`(4번), `ListRunsRequest.target`(2번). 옛 번호는 `reserved` |

```proto
// 도구를 돌리는 대상. 셋 중 하나만 채운다.
message RunTarget {
  oneof target {
    int64 job_id = 1;   // 그 작업의 타임라인 전체
    int64 asset_id = 2;
    int64 clip_id = 3;
  }
}
```

`external_job_id`(외부 시스템이 붙인 값)와 `project_no`는 `string` 그대로다.

## 5. 프런트에서 바꿀 것

- **타입**: proto를 다시 받아 코드를 새로 생성한다. Connect JSON에서 `int64`는 문자열로 오간다(`"jobId": "128"`). 생성 코드에
  따라 `bigint`나 문자열로 받는다. 요청은 문자열·숫자 둘 다 받는다. ID는 계산하지 않는 값이니 `number`로 바꾸지 않는다.
- **"없음" 값**: 빈 문자열 대신 0이다. 예: `AttachAssetRequest.pass_id = 0`은 작업 공용, `ReportSet.job_id = 0`은 작업에 직접
  매칭되지 않음, `Provenance.parent_asset_id = 0`은 부모 없음, `Clip.label_value_id = 0`은 라벨 없음.
- **종류 구분**: 접두어(`ast_`, `clp_`)가 없어졌다. 같은 숫자라도 필드가 다르면 다른 것이니, ID를 한 변수·한 맵에 섞어 담지 않는다.
- **화면 표시**: 작업을 글자로 보여 주던 곳은 `job_id` 대신 `Job.job_key`를 쓴다. `job_key`는 공사·호기·품목·이음부를 고치면
  바뀌므로 저장하거나 주소에 넣지 않는다. 저장·주소에는 `job_id`를 쓴다.
- **저장해 둔 옛 ID**: 주소나 로컬 저장소에 남은 글자 ID는 더 이상 조회되지 않는다.
- **도구 실행**: `StartRun`·`ListRuns`는 `target`에 대상을 넣는다. 작업 전체면 `{"target": {"jobId": "128"}}`, 에셋이면
  `{"target": {"assetId": "5012"}}`, 클립이면 `{"target": {"clipId": "880"}}`다. `MANUAL`은 클립이나 에셋, `AUTO_TAGGING`은
  작업만 받는다. 응답 `ToolRun.target`이 비어 있으면 대상이 지워진 실행이다.
- **파일 주소**: `/assets/{asset_id}/content`, `/clips/{clip_id}/content`의 ID도 숫자다(`/assets/5012/content`).
- **수집 현황**: `CollectionPath.job_id`·`pass_id`가 숫자다. 받은 `path`를 그대로 돌려보내는 방식이면 코드 재생성만 하면 된다.
  작업 노드의 형제 순서는 `job_key` 순, 패스는 패스 번호 순으로 전과 같다.

## 6. 이관과 확인

이관 스크립트는 넷이고 순서대로 돌린다. 각각 한 트랜잭션이라 중간에 실패하면 아무것도 바뀌지 않는다. 새로 만드는 DB는
`init.sql`에 반영돼 있다.

| 순서 | 파일(`sub-services/tacit-db/`) | 내용 |
|---|---|---|
| 1 | `migrate_20261007_job_pass_id.sql` | 작업·패스 ID, `job_key` |
| 2 | `migrate_20261007_2_remaining_ids.sql` | 나머지 ID, 도구 실행의 대상 칸, 옛 ID 대조표 |
| 3 | `migrate_20261007_3_worker_equipment_ids.sql` | 작업자·장비 ID, `worker_code`·`equipment_code` |
| 4 | `migrate_20261007_4_project_id_job_name.sql` | 공사 ID, 작업의 공사 연결을 `project_id`로, 작업 이름, 패스 구간 겹침 금지 제약 |
| 5 | `migrate_20261008_5_column_cleanup.sql` | 안 쓰는 칸 `worker.worker_code`·`job.item_abbr` 삭제(옛 값은 `backup`에) |
| 6 | `migrate_20261008_6_project_item.sql` | 품목 기준정보 표 `project_item`, `job.project_item_id` |
| 7 | `migrate_20261008_7_job_item_columns.sql` | 작업의 `unit_no`·`item_code`·`item_name` 삭제(2026-10-08 09:01 운영 적용) |
| 8 | `migrate_20261008_8_run_attempt_count.sql` | 도구 실행의 시도 횟수 `tool_run.attempt_count`(2026-10-08 09:40 운영 적용) |

번호는 작업은 시작 시각 순, 패스는 작업·패스 번호 순, 나머지는 옛 ID 순(ULID라 만든 순서), 도구 실행은 만든 시각 순으로 매긴다.

확인은 운영 DB를 통째로 복사한 사본(`tacit_mig`)에서 했다. 마지막에는 운영 DB를 새로 복사해 이관 1~4를 파일 그대로 차례로 돌려
다시 확인했다(작업의 공사·작업자, 에셋의 장비 연결이 이관 전과 같고, 결과가 새 `init.sql`과 칸·제약·인덱스까지 같다).

| 확인 | 결과 |
|---|---|
| 행 수(작업 388, 패스 819, 에셋 19,661, 첨부 18,729, 트랙 4,996, 클립 17,179, 세트 102, 문서 529) | 이관 전후 같음 |
| 연결 관계 18종(첨부·부모 에셋·provenance·클립의 트랙/출처/라벨·세트와 문서·섹션·확인 표시·도구 실행의 도구와 대상 등, 옛 ID로 되돌려 대조) | 이관 전후 같음 |
| 이관한 사본과 새 `init.sql`로 만든 DB의 칸·제약 | 같음 |
| mediatag `go test ./...`(사본에 붙임) | 통과 |
| 임시 서버를 사본에 붙여 `scripts/smoke_rpc.py --db tacit_mig` | 70개 중 실패 0(쓰기 RPC를 더한 뒤) |
| `scripts/report_jobs.sql` 다시 실행 | TP129 작업 106건 그대로 |
| `devseed_clean.sql` → `devseed_combo.sql` → `devseed.sql` | 예시 데이터가 이관 전과 같은 구조로 다시 만들어짐. `devseed.sql`은 두 번 돌려도 같음 |

함께 바뀐 것:

- **ID 발급**: 서버·적재기가 ID를 미리 만들지 않고 넣으면서 DB가 매긴 번호를 받는다. `ingest.NewID`(ULID 생성)는 없앴다.
- **적재기**: 같은 작업은 `job_key`로, 같은 패스는 `(job_id, pass_no)`로, 같은 도구는 이름으로, 장비는 코드로 찾는다. 다시 돌려도 같은
  행을 갱신한다. 타임라인 트랙 이름은 전처럼 장비 코드를 쓴다(`DEMO-ACTIONCAM · actioncam`).
- **외부 도구 계약**: STT·포즈·pdf-to-text의 proto는 ID 칸이 글자다. 우리 번호를 십진수로 실어 보내고(`"assets/5012"`, 콜백의
  `job_id = "47"`), 돌아온 값을 숫자로 읽는다. 외부 계약 자체는 바꾸지 않았다.
- **결과 파일 이름**: 도구 결과 JSON은 `<입력 이름>_run<실행 번호>.json`이다(전에는 UUID 앞 8자).
- **개발용 시드**: 복제 행의 ID는 번호를 미리 받아(`nextval`) 넣는다. 예시 에셋은 저장 경로 `devseed/…`로, 예시 도구는
  이름과 주소로 알아본다. 기록(`devseed.marked`)의 키는 작업·타임라인은 `job_key`, 나머지는 번호다. 다시 만들면 복제 파일의
  이름이 바뀌어 `devseed_combo.sh`가 하드 링크를 새로 만들고, 옛 이름의 링크는 남는다(지워도 된다).

적용 순서: DB 덤프 → 서버 중지 → 이관 스크립트 1, 2, 3, 4 → 새 서버 빌드·시작 → `smoke_rpc.py`. 되돌리려면 덤프를 복원하고 옛
바이너리를 띄운다. 적용 전에는 새 코드(서버 빌드, `night_load.sh`, `devseed*.sql`, `report_jobs.sql`)를 운영 DB에 돌리지 않는다.

## 7. 남은 것

- 운영 DB·서버 적용(프런트와 날짜를 맞춘 뒤).
- 공사 번호(`project_no`) 자체를 고치는 기능은 없다. 작업은 이제 `project_id`로 공사를 가리키므로 공사 표의 한 줄만 고치면 되지만,
  공사 번호가 들어간 `common_key`·`job_key`(그 공사의 모든 작업)와 성적서 세트의 `common_key`를 함께 다시 만들어야 한다.
- 성적서 표(`doc.*`)의 `project_no`는 문서에 찍힌 값을 옮긴 칸이라 그대로다(공사 표와 FK로 이어져 있지 않다).
- 라벨 어휘 `key`는 사람이 정한 글자가 기본 키인 채로 남아 있다.
- 공사·작업·패스의 수정·삭제와 에셋 업로드는 `공사·작업·패스 관리와 업로드 안내.md`에 따로 정리했다.
- `엔티티.md`의 ID 설명(`ast_<ULID>` 등)은 작성 당시 기록으로 두었다. 지금 형식은 이 문서와 스키마 지도가 기준이다.
