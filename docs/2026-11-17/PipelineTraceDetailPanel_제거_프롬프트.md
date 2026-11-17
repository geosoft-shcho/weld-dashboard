# PipelineTraceDetailPanel 제거

## 목표
선택 시 옆 패널 `PipelineTraceDetailPanel`을 제거하고, 하단은 `PipelineTraceList`만 둔다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_tab_body.dart`
4. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_detail_panel.dart`
5. 없음

## 현재 상태
- 탭 본문 하단 Row에 목록 + 선택 시 DetailPanel이 붙는다.

## 바꿀 것
1. `pipeline_trace_tab_body`에서 DetailPanel import·배치 제거. 하단은 목록만.
2. `pipeline_trace_detail_panel.dart` 파일 삭제.
3. 패널 전용으로만 쓰이던 UI 참조가 없으면 정리. ViewModel GetTrace 선택·폴링은 유지(스테퍼·목록 선택용).
4. `./scripts/agent_check.sh` 통과.

## 유지할 것
- 목록 선택, 스테퍼, 하단 선택 요약 한 줄(있으면)

## 이번 작업에서 만들지 않음
- 새 상세 UI, 레이아웃 전면 재설계

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
- 여정 선택 시 옆 상세 패널이 더 이상 나타나지 않는다
