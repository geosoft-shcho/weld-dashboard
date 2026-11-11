# 멀티모달 playhead NowMarker UI

## 목표
`multimodal_timeline_board.dart`의 2px 빨간 막대를, 수집 모니터링 `_NowMarker`와 같은 **상단 역삼각형(12×8) + 세로 2px 선**으로 바꾼다. 색은 `MultimodalStudioPalette.DANGER` 유지.

## 바꿀 것
1. playhead `Positioned`를 수집과 같이 맞춤:
   - `left: playheadSeconds * pixelsPerSecond - 6`
   - `top: 0`, `bottom: 0`, width 12
   - `IgnorePointer` 유지
   - 자식: caret `CustomPaint` 12×8 + `Expanded` 안 width 2 세로선, 색 `DANGER`
2. 같은 파일에 private `_PlayheadCaretPainter`만 두고, 수집 위젯을 import·공용 추출하지 않는다.

## 유지할 것
- playhead 위치 계산·스크롤 추적·북마크 마커
- DANGER 색
- 눈금 `_ruler` / `TimelineRulerPainter`

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
- playhead에 상단 역삼각형 + 세로선이 보이고 색은 기존과 같음
- 삼각형 중심이 playhead 시각에 맞음 (`left - 6`)
