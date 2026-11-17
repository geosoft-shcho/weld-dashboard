# ListTraces 고정 로그 영역

## 목표
`PipelineTraceGraphView` 아래 ListTraces 목록(+선택 상세)이 화면 남은 높이로 늘었다 줄었다 하지 않고, **고정 높이 로그 패널**처럼 보이게 한다. 내부만 스크롤한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_tab_body.dart`
4. 없음

## 현재 상태
- 목록 `Row`가 `Expanded`라 그래프 높이에 따라 목록 영역이 늘어나고 줄어든다.

## 바꿀 것
1. 목록(+상세)을 `Expanded` 대신 **고정 높이** `SizedBox`로 둔다(로그 느낌, 내부 ListView 스크롤 유지).
2. 스테퍼는 남는 위쪽 공간을 쓰고, 넘치면 그 영역만 스크롤되게 한다.
3. `./scripts/agent_check.sh` 통과.

## 유지할 것
- 칩·그래프·목록·상세 위젯 자체 동작, 폴링

## 이번 작업에서 만들지 않음
- 목록 행 UI 재디자인, ViewModel 변경

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
- 창/스테퍼 높이가 바뀌어도 목록 패널 높이는 일정하다
