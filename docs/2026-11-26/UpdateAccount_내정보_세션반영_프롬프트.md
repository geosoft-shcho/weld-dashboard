# UpdateAccount 후 내정보 세션 반영

## 목표
`AccountService.UpdateAccount`로 **지금 로그인한 계정**을 고치면 `AuthSessionViewModel`의 `AuthUser`가 갱신되어 `_MyAccountInfoDialog`·타이틀바 표시 이름이 바뀐 값(표시 이름·역할·권한)을 보여 준다.

## 먼저 읽을 것
1. `remote_auth_repository.dart` `restoreSession` — 이미 `GetCurrentAccount`
2. `auth_session_view_model.dart` `restore()` — `_isRestoring`이면 앱 전체가 ProgressRing
3. `accounts_admin_view_model.dart` / `accounts_admin_screen.dart` `updateAccount` 성공 지점

## 현재 상태
- `AuthUser`는 로그인·앱 기동 `restore` 때만 채워짐
- UpdateAccount 성공 후 계정 목록만 `load()` — 세션 `_user`는 그대로라 내정보가 옛값

## 바꿀 것
1. `AuthRepository` + `RemoteAuthRepository` — `refreshCurrentAccount()` (`restoreSession`과 동일 재사용 가능)
2. `AuthSessionViewModel.refreshCurrentAccount()` — `_isRestoring` 없이 `_user` 갱신. null이면 `_user = null`
3. `accounts_admin_screen.dart` — 자기 `accountId` Update 성공 후 `refreshCurrentAccount()`
4. 본 프롬프트 저장 후 구현

## 유지할 것
- `restore()` 기동 플로우·`_AuthGate`
- UpdateAccount 본 API·계정 목록 reload
- 다른 계정 수정 시 세션 미갱신

## 이번 작업에서 만들지 않음
- `UpdateRole` 후 세션 갱신
- 내정보 다이얼로그 열 때마다 무조건 새로고침
- 이벤트 버스·새 추상 계층

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- 자기 계정 수정 후 내정보·타이틀바 반영
- 다른 계정 수정 시 내정보 불변
- refresh 중 앱 전체 ProgressRing 없음
