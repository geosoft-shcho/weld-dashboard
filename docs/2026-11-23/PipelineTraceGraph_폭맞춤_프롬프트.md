# PipelineTraceGraph 폭 맞춤 렌더링

## 목표
`PipelineTraceGraphView`가 최초·이후에도 가용 **가로 폭에 딱 맞게** 스케일되도록 한다.

## 먼저 읽을 것
- `pipeline_trace_graph_view.dart` (`FittedBox`, `_RailLayout`)

## 현재 상태
- 캔버스는 `_RailLayout` 고정 크기이고 `FittedBox(fit: BoxFit.contain, alignment: centerLeft)`로 넣는다.
- `contain`은 가로·세로 중 작은 쪽에 맞춰 비율을 유지하므로, 세로가 먼저 닿으면 **가로에 빈 여백**이 남는다.

## 바꿀 것
1. `BoxFit.contain` → **`BoxFit.fitWidth`**(또는 동등한 폭 기준 스케일)로 바꿔 부모 폭에 맞춘다.
2. 스케일 후 세로가 넘치면 `ClipRect`로 잘라 카드 밖으로 그리지 않는다.
3. alignment는 레일 기준 `centerLeft` 또는 `topLeft` 유지.

## 유지할 것
- `_RailLayout`·Stage 펼침 애니메이션·노드/path 그리기
- 하단 목록 패널 토글(탭 바디)

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
- 그래프가 가용 폭을 채운다
