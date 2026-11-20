# PipelineTraceGraphView DataFlow 모션 개선

## 목표
2D 캔버스에서 이벤트 노드·연결이 DataFlow처럼 읽히고, live path는 숨쉬기 대신 **흐름이 수행**되게 한다. 색은 mapper로 통일한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_view.dart`
4. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_status_mapper.dart`
5. `.agents/skills/motion-doctrine/SKILL.md` (No idle wobble / Sequenced UI life)
6. `.agents/skills/hyperframes/references/motion.md` (연속 모션·선형 progress)

## 현재 상태
- `pipeline_trace_graph_view.dart`: 셀 배치, `_PipelineFlowPainter` Bezier, live 점선+단일 입자, 노드 링 `sin` pulse, 요약 칩 glow pulse; `_fillOf`/`_borderOf` 로컬 중복
- `pipeline_status_mapper.dart`: `PipelineNodeVisual` 색·라벨 공용 API 있음, 2D 미사용
- 도메인·3D·탭 토글은 이번 범위 밖

## 바꿀 것
1. 노드 fill/border/ink를 `pipelineStatusFill` / `pipelineStatusBorder` / `pipelineStatusInk`로 교체하고 로컬 `_fillOf`/`_borderOf` 제거
2. live 엣지: dash offset이 **진행 방향(좌→우 current)** 으로 흐르고, path 위 **입자 2~3개**가 등간격으로 진행(선형 `pulse`, ease 없음)
3. live 노드: sine 링 wobble 제거 → 고정 강조 링 + (선택) path 진행과 맞춘 얇은 아크/하이라이트만
4. 상단 요약: running/failed의 숨쉬기 glow 제거 → running>0일 때 점 색/굵기 고정 강조만
5. 포커스 스트립·탭·레이아웃·스크롤·줌 없음·도메인 API는 유지

## 유지할 것
- `_CellLayout`, skeleton/active edge, 노드 탭→`_FocusedNodeEventStrip`, compact, ViewModel 계약
- 3D 뷰·탭 바디·도메인 엔티티

## 이번 작업에서 만들지 않음
- HyperFrames HTML/GSAP/영상 파이프라인
- 새 추상 계층·애니메이션 프레임워크·카드 UI
- 3D Three 애니메이션 변경

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
- 관련 테스트 있으면 `./scripts/agent_check.sh test/pipeline_trace_graph_test.dart` 통과
- live path에 흐르는 dash+다중 입자, idle 노드 sine wobble 없음, 색이 mapper와 일치
