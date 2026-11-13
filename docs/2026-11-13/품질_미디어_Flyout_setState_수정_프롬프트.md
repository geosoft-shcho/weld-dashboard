# Flyout setState/hitTest 오류 수정

## 목표
미디어 Flyout을 연 채 목록이 갱신될 때 `setState during build`와 `!debugNeedsLayout` hitTest assertion이 나지 않게 한다.

## 원인
`quality_media_strip.dart`의 `didUpdateWidget`에서 즉시 `_snapshot.value = ...`를 한다. 부모(VM notify → Host rebuild) build 경로에서 ValueNotifier가 Flyout 안 `ValueListenableBuilder`에 setState를 유발하고, layout이 끝나기 전 hitTest가 들어와 `proxy_box.dart:3122 !debugNeedsLayout`이 난다.

## 바꿀 것
1. `quality_media_strip.dart`만 수정
2. `didUpdateWidget`에서 스냅샷이 실제로 바뀐 경우에만, `WidgetsBinding.instance.addPostFrameCallback`으로 `_snapshot.value` 갱신 (mounted 가드)
3. 동일 참조/동일 내용이면 notifier를 건드리지 않음 (entries 길이·selectedId·hasMore·loading 비교)

## 유지할 것
- Flyout 열린 채 더보기·목록 갱신 UX
- VM/Host API

## 이번 작업에서 만들지 않음
- Flyout UI 재설계
- ValueNotifier 제거 후 다른 상태 패턴 도입

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
- Flyout 연 채 더보기/선택 시 콘솔에 setState during build·debugNeedsLayout 없음
