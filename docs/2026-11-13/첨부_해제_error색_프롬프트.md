# 첨부 해제 버튼 error 색

## 목표
`job_attachment_tab.dart` 첨부 해제 버튼의 `Colors.red`를 앱 공통 에러색으로 교체한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/job_lookup/widgets/job_attachment_tab.dart`
4. `lib/src/presentation/core/themes/app_theme.dart`

## 현재 상태
- `ButtonStyle.backgroundColor`에 `Colors.red`를 쓴다.
- `AppTheme.STATUS_ERROR` (`0xFFE85D5D`)가 있다. 파일은 이미 `app_theme.dart`를 import한다.

## 바꿀 것
1. `Colors.red` → `AppTheme.STATUS_ERROR` (backgroundColor 유지)

## 유지할 것
- 버튼 동작·라벨·나머지 스타일

## 이번 작업에서 만들지 않음
- 다른 화면 Colors.red 일괄 교체, foreground/background 정책 변경

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- 첨부 해제 버튼이 `AppTheme.STATUS_ERROR`를 쓴다
