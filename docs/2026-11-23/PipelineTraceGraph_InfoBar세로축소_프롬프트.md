# PipelineTraceGraph InfoBar 세로 축소 방지

## 목표
자동 갱신 `InfoBar`가 떠도 `PipelineTraceGraphView` 세로 영역이 줄지 않게(또는 최소 높이를 지키게) 한다.

## 먼저 읽을 것
- `collection_monitoring_screen.dart` (InfoBar + Expanded 탭)
- `pipeline_trace_tab_body.dart` (그래프 Expanded + 목록 고정 260)

## 현재 상태
- InfoBar가 Column에 들어가면 탭 `Expanded` 높이가 줄어든다.
- 하단 목록이 `SizedBox(height: 260)` 고정이라 **줄어든 높이를 그래프 `Expanded`만** 흡수한다.

## 바꿀 것
1. `PipelineTraceTabBody`에서 목록 높이를 `LayoutBuilder`로 계산한다. 그래프 최소 높이(~160)를 먼저 확보하고, 목록은 `min(260, 남는 높이)`로 양보한다.
2. 자동 갱신 InfoBar는 Column에 유지(커맨드바를 가리는 오버레이는 쓰지 않음). 탭 높이가 줄면 **목록이 먼저** 줄어 그래프 세로를 지킨다.

## 유지할 것
- 접힘 바·목록 토글·그래프 fitWidth
- 잘못된 시간 범위 InfoBar(에러) 동작

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
- 자동 갱신 ON 시 그래프 세로가 눈에 띄게 줄지 않음
