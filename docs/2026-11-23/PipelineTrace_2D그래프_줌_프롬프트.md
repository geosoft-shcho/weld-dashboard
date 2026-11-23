# PipelineTrace 2D 그래프 스크롤 → 줌

## 목표

`pipeline_trace_graph_view.dart` 94–174 구간의 가로·세로 `SingleChildScrollView`를 없애고, 캔버스를 **줌인/아웃**으로 축소·확대한다. 최소 셀 크기로 캔버스가 뷰포트보다 커져도 스크롤 대신 줌·팬으로 탐색한다.

## 먼저 읽을 것

1. `pipeline_trace_graph_view.dart` — `_CellLayout.fromViewport`, `needsScroll`, 163–171 스크롤 분기
2. 클래스 주석 13행: `줌 없음` → 동작에 맞게 수정

## 현재 상태

- 레이아웃은 `_minColumnWidth`/`_minRowHeight`를 하한으로 두어 캔버스가 뷰포트보다 커질 수 있다.
- `needsScroll == true`이면 이중 `SingleChildScrollView`로 가로·세로 스크롤한다.
- 줌 API는 없다.

## 바꿀 것

1. **스크롤 제거** — `needsScroll` 필드·계산·`SingleChildScrollView` 분기 삭제.
2. **줌 래퍼** — 캔버스를 `InteractiveViewer`로 감싼다.
   - `minScale: 0.4`, `maxScale: 2.5`, `constrained: false` (큰 캔버스 팬 가능)
   - `TransformationController`를 State에 두고 dispose.
3. **초기 맞춤** — 레이아웃 직후, 뷰포트에 캔버스가 들어가도록 `Matrix4` 균등 스케일(`fit = min(1, vw/cw, vh/ch)`)을 한 번 적용. 이후 사용자 줌이 덮어쓴다.
4. **줌 버튼** — Expanded 영역 우상단에 `+`/`−`(Fluent `IconButton`)로 `scale *= 1.2` / `/= 1.2` (클램프). 휠·핀치와 동일 컨트롤러를 쓴다.
5. 주석 `줌 없음` 제거/수정. `_LiveStatusSummary`·노드 탭·painter는 그대로.

## 유지할 것

- Stage/Node 배치·연결선 painter·포커스 스트립·ViewModel 연동
- O3D 뷰·브리지 파일은 손대지 않음

## 이번 작업에서 만들지 않음

- 새 패키지, 새 추상 레이어, 줌 상태 영속화, O3D 카메라 연동

## 복잡한 코드 제거 및 금지

- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯이 있으면 그것을 쓴다. `InteractiveViewer`만 쓴다.
- 이번 변경으로 쓰이지 않는 `needsScroll`·스크롤 분기·관련 주석은 제거한다.
- 조건 중첩·모드 플래그로 경우를 늘리지 않는다.
- 새 상태관리·디자인 시스템·카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖 리팩터·이름 정리·스타일 통일을 끼워 넣지 않는다.

## 완료 확인

- `./scripts/agent_check.sh` 통과
- 그래프에 스크롤바가 없고, `+`/`−`·휠(또는 핀치)로 축소·확대된다
- 큰 그래프도 초기 맞춤 후 줌·팬으로 전체를 볼 수 있다
