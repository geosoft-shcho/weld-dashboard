# PipelineTraceGraph Scrollbar 렌더링 오류

## 목표
`Scrollbar's ScrollController has no ScrollPosition attached` 예외를 없앤다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_view.dart`
4. 없음

## 현재 상태
- `needsScroll`일 때 nested `Scrollbar` + 이중 `SingleChildScrollView`가 PrimaryScrollController에 묶이지 않아 예외가 난다.

## 바꿀 것
1. Scrollbar를 제거하거나, 전용 `ScrollController`를 명시해 ScrollView와 연결한다. 단순 이중 스크롤이면 Scrollbar 없이 `SingleChildScrollView`만 둔다.

## 유지할 것
- 최소 셀 레이아웃, path 연결, 줌 없음

## 이번 작업에서 만들지 않음
- 레이아웃 재설계, 목록 패널 변경

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
- Scrollbar ScrollPosition 예외가 나지 않는다
