# PipelineStageChips 단계 숨김 제거

## 목표
`PipelineStageChips`의 `isChecked`/체크박스로 단계를 숨기는 기능을 없애고, 칩은 건수·실패 표시만 한다. 스테퍼는 항상 같은 단계 집합을 보여 준다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_stage_chips.dart`
4. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
5. 없음

## 현재 상태
- 칩에 `Checkbox`가 있고 `didToggleStage`로 `_hiddenStageIds`를 바꾼다.
- `visibleStages`가 hidden을 걸러 스테퍼에서 단계가 사라진다.

## 바꿀 것
1. 칩에서 Checkbox·`isChecked`·`onChanged` 제거. 라벨·건수·실패 테두리만 유지.
2. ViewModel의 `_hiddenStageIds` / `isStageHidden` / `didToggleStage` 및 `visibleStages`의 hidden 필터 제거. `visibleStages`는 tool 표시 여부만 반영.
3. `./scripts/agent_check.sh` 통과.

## 유지할 것
- stageCounts·stageHasFailed·tool 단계 조건부 표시
- 스테퍼·목록·GetTrace 폴링

## 이번 작업에서 만들지 않음
- 칩을 선택/필터로 쓰는 새 동작
- 레이아웃(목록 높이) 변경

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
- 칩에 체크박스가 없고, 단계를 꺼도 스테퍼가 사라지지 않는다
