# Trace 새로고침 바인더 빌드 중 notify 오류

## 목표
`!_dirty` 렌더링 assertion을 없앤다. `didChangeDependencies`에서 Trace `applyRefreshInterval`→`notifyListeners`가 빌드 중에 돌지 않게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `collection_monitoring_screen.dart` `_TraceRefreshIntervalBinder`
4. 없음

## 현재 상태
- 바인더가 `didChangeDependencies`에서 바로 `applyRefreshInterval`을 호출해 `refresh`→`notifyListeners`가 InheritedProvider 빌드 중에 발생한다.

## 바꿀 것
1. 주기 적용을 `addPostFrameCallback`으로 미룬다(mounted 확인).
2. `./scripts/agent_check.sh` 통과.

## 유지할 것
- 주기 동기화·새로고침 버튼 동작

## 이번 작업에서 만들지 않음
- 폴링 정책 재설계

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과 (`dart analyze`)
- 관련 테스트가 있으면 `./scripts/agent_check.sh <test 경로…>` 통과
- 수집 모니터링 화면 진입 시 `!_dirty` assertion이 나지 않는다
