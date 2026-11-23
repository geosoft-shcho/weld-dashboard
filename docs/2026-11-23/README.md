# mediatag proto — 2026-11-23에 바뀐 것

지난 전달(2026-11-17, `a312819`) 이후 바뀐 proto만 넣었습니다. 서버는 2026-11-23 08:37에 운영에 반영했습니다.
**로그인 검사는 꺼 둔 상태**라 지금 화면은 고치지 않아도 그대로 돕니다(운영 화면에서 확인). 아래 순서대로 옮겨 주세요.

| 파일 | 바뀐 것 |
|---|---|
| `proto/mediatag/auth/v1/auth.proto` | **새 파일** — 로그인 · 계정 · 역할 · 서버 연동 토큰 |
| `proto/mediatag/work/v1/work.proto` | 수집 현황 KPI(`GetCollectionSummary` · `ListAssetCounts`), 공사 보기, 작성자 |
| `proto/mediatag/trace/v1/trace.proto` | `ListTracesResponse.total_count` |
| `proto/mediatag/asset/v1/asset.proto` · `compose/v1/compose.proto` · `report/v1/report.proto` | 작성자(`created_by` · `updated_by`) |
| `수집 현황 KPI · 타임라인 변경 안내.md` | 1번의 자세한 안내 |

`work` · `asset` · `compose` · `report` proto가 `mediatag/auth/v1/auth.proto`를 import합니다 — 다시 생성할 때 auth.proto도 같이 넣어 주세요.

## 1. 수집 현황 KPI · 공사 보기

자세한 내용은 같이 넣은 `수집 현황 KPI · 타임라인 변경 안내.md`에 있습니다. 요약:

- KPI 카드는 새 RPC `WorkService.GetCollectionSummary`(화면을 열 때 한 번)에 바인딩하고, `ListCollectionNodes` 자식 값을 더해 계산하던 코드는 지워 주세요.
- 유실률 · 지연 · 시각 동기 카드는 지웁니다(목업 값이라 서버가 셀 근거가 없음).
- 트리는 **공사 → 품목 → 작업 → 파일**(`COLLECTION_VIEW_PROJECT`)입니다. 장비 · 작업자 보기는 없앴고 작업자는 `worker_id` 필터로 주세요.
  지금 화면이 보내는 옛 값(`COLLECTION_VIEW_EQUIPMENT` · `WORKER`)은 공사 보기로 답합니다 — 그래서 지금은 장비 · 작업자 탭이 같은 공사 트리로 보입니다. 옮기신 뒤 알려 주시면 옛 값을 지웁니다.
- 적재 진행 · 실패 수는 `TraceService.ListTraces`의 `total_count`(page_size=1로 개수만), 날짜별 파일 수 · 용량은 새 RPC `WorkService.ListAssetCounts`.

## 2. 로그인 · 권한 (`auth.proto`, 새 파일)

서버는 준비됐고 검사만 꺼 둔 상태입니다. 화면이 아래를 갖추면 서버에서 켭니다(켜는 날은 따로 맞춥니다).

| RPC | 누가 | 화면 |
|---|---|---|
| `AuthService.Login` | 누구나 | 로그인 화면. 성공하면 쿠키(`mediatag_session`, 7일)가 붙음 |
| `AuthService.Logout` | 누구나 | 로그아웃 |
| `AuthService.GetCurrentAccount` | 로그인 | 화면이 뜰 때 한 번 — **401이면 로그인 화면으로** |
| `AuthService.ChangePassword` | 로그인 | 내 비밀번호 바꾸기(8~72바이트, 다른 세션은 끊김) |
| `AccountService.ListAccounts` · `CreateAccount` · `UpdateAccount` | `account.manage` | 계정 관리(지우지 않고 `inactive`로 막음, 비밀번호 재설정) |
| `AccountService.ListPermissions` · `ListRoles` · `CreateRole` · `UpdateRole` · `DeleteRole` | `account.manage` | 역할 관리(권한 체크 목록은 `ListPermissions`) |
| `AccountService.ListServiceTokens` · `CreateServiceToken` · `RevokeServiceToken` | `account.manage` | 서버 연동 토큰 관리(AI 서버용). **발급 응답의 토큰 원문은 한 번만 옴** — 복사할 수 있게 보여 주고 다시 보여 줄 방법은 없음 |

화면이 할 일:
- 로그인 화면, 뜰 때 `GetCurrentAccount`, 모든 호출의 **401 공통 처리**(로그인 화면으로).
- `Account.permissions`(권한 이름 배열)로 버튼 숨기기. 권한 이름과 설명은 `ListPermissions`.
- 계정 · 역할 · 서버 연동 토큰 관리 화면.
- **계정 관리(`AccountService`)는 로그인을 꺼 둔 지금도 로그인 + `account.manage`가 필요합니다.** 관리 화면을 시험하려면 먼저 로그인해야 합니다(관리자 계정은 따로 전달).

알아 둘 것:
- `tks.faivv.ai`에서 띄운 화면은 쿠키가 자동으로 실려 기존 호출 · 영상 · 업로드 코드는 그대로입니다.
- 다른 주소에서 띄운 개발 화면은 쿠키가 안 실립니다 — 개발 서버 프록시로 같은 출처를 만들거나, RPC에 `Authorization: Bearer <LoginResponse.token>`을 붙여 주세요(영상 태그는 헤더를 못 붙여 프록시 쪽을 권합니다).
- `X-Forwarded-For` 같은 헤더는 넣을 필요 없습니다.
- 같은 아이디로 5번 연달아 틀리면 1분 막힙니다. 없는 아이디와 틀린 비밀번호는 같은 오류입니다.

## 3. 작성자 — `created_by` · `updated_by` (응답 전용)

`Project` · `Worker` · `Equipment` · `Job` · `Pass` · `Asset` · `Comment` · `Timeline` · `Track` · `Clip` · `LabelValue` · `ReviewItem` 응답에
`mediatag.auth.v1.Author{account_id, display_name}`가 실립니다. 보내도 무시합니다.
**비어 있으면(null) 사람이 아닌 일**입니다 — 업로드 뒤 후처리, 도구 결과, 성적서 추출, 그리고 로그인 도입 전에 만든 행. 로그인을 켜기 전까지는 모두 비어 있습니다.
