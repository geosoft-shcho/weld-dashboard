# TimelineSpanDebugLog 제거

## 목표
`video_multimodal_view_model.dart`에서 `TimelineSpanDebugLog` 디버깅 호출을 제거하고, 다른 참조가 없으면 헬퍼 파일도 삭제한다.

## 먼저 읽을 것
1. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart`
2. `lib/src/presentation/features/video_multimodal/timeline_span_debug_log.dart`
3. 계약·화면안: 없음

## 바꿀 것
1. ViewModel의 `TimelineSpanDebugLog` import·호출 제거.
2. 참조가 없으면 `timeline_span_debug_log.dart` 삭제.

## 유지할 것
- 타임라인 span·playhead 실제 로직

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
- `TimelineSpanDebugLog` 참조가 없다
