# GetQueue 앞줄 UI 제거

## 목표
적재 파이프라인 탭 본문에서 GetQueue 대기열 앞줄 UI(`_QueueFrontPanel`)를 제거한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_tab_body.dart`
3. 없음

## 현재 상태
- `doesShowQueueFront`일 때 `_QueueFrontPanel`을 그린다.
- 선택 요약 한 줄(파일명·lastEvent·wait)은 그대로 있다.

## 바꿀 것
1. `pipeline_trace_tab_body.dart`에서 `_QueueFrontPanel`·`_waitAgeLabel`·GetQueue 앞줄 표시 분기·불필요 import를 제거한다.

## 유지할 것
- 선택 요약 한 줄, 목록·칩·스테퍼
- ViewModel GetQueue 호출은 이번 범위 밖(요청은 UI 제거만)

## 이번 작업에서 만들지 않음
- VM·UseCase·테스트·검증 문서 일괄 정리
- 새 UI 대체

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
- 탭 본문에 대기열 앞줄 박스가 없다
