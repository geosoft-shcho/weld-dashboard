# 타임라인 Marker 도구 제거

## 목표
툴바 「Marker」로 재생 위치에 로컬 북마크를 찍고, 보드에서 탭하면 시크하던 동작을 없앤다.

## 현재 동작 (확인)
- `timeline_board_toolbar.dart` Marker → `didTapAddMarker`
- `video_multimodal_view_model.dart` `_markerSeconds`에 `playheadSeconds` append (서버 저장 없음)
- `multimodal_timeline_board.dart` 북마크 아이콘 나열, 탭 → `didTapMarker` → `didSeekToSeconds`
- `_PlayheadMarker`는 재생 헤드 UI — 유지

## 바꿀 것
1. 툴바: Marker `TimelineBoardToolButton` 제거
2. ViewModel: `_markerSeconds` · `markerSeconds` · `didTapAddMarker` · `didTapMarker` 제거
3. 보드: `markerSeconds` 루프 제거
4. 본 프롬프트 저장 후 구현

## 유지할 것
- 클립 선택·관계·삭제, 트랙 목록
- `_PlayheadMarker`·룰러 시크

## 이번 작업에서 만들지 않음
- 서버 마커·대체 북마크 UI
- 관계 모드·클립 도구 리팩터

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- 툴바에 Marker 없음, 보드에 사용자 북마크 아이콘 없음
