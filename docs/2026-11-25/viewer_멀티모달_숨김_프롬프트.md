# viewer 역할 멀티모달 진입 숨김

## 목표
`GetCurrentAccount`의 `roleId: 1` / `roleName: viewer` 계정이면 멀티모달 진입 UI가 보이지 않고, URL로 들어와도 상세로 되돌아간다.

## 먼저 읽을 것
1. `auth_user.dart` — 지금 `permissions.contains('timeline.edit')`만 봄. `roleId`/`roleName` 없음
2. `remote_auth_repository.dart` `_userFromAccount` — Account의 role 미매핑
3. 진입점(이미 `canAccessVideoMultimodal` 사용): work_history_table, work_detail_screen, job_lookup_detail_screen, job_attachment_tab, app_coordinator

## 현재 상태
- 멀티모달 버튼·메뉴·딥링크는 이미 `AuthSessionViewModel.canAccessVideoMultimodal`으로 가림
- 판정이 `timeline.edit` 권한만이라, viewer라도 그 권한이 있으면 버튼이 남음
- Account proto에는 `roleId`·`roleName`이 있으나 `AuthUser`에 안 실림

## 바꿀 것
1. `lib/src/domain/entities/auth_permission_policy.dart` — viewer면 false, 그 외 `timeline.edit`
2. `AuthUser`에 `roleId`·`roleName`, getter는 정책 함수
3. `RemoteAuthRepository._userFromAccount` 매핑
4. UI 진입점은 기존 getter 유지
5. `로그인_권한_남은작업.md` timeline.edit 멀티모달 항목 체크

## 유지할 것
- coordinator 딥링크 거부
- `account.manage` 셸 메뉴

## 이번 작업에서 만들지 않음
- P3 나머지 버튼 숨김, 역할 관리 UI, 서버 role 시드

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다. 정책은 순수 함수 파일 하나.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- viewer: 멀티모달 버튼 없음
- 비-viewer + timeline.edit: 버튼 유지
