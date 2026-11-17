# 트랙 CRUD 라벨 열 통합

## 목표
`TimelineBoardEditTools` 툴바 줄을 없애고, 트랙 추가·이름 수정·삭제를 `TimelineBoardTrackLabels`에서 처리한다.

## 바꿀 것
1. 라벨 헤더: `트랙 (n)` + Spacer + `+` 버튼 → 이름 입력 다이얼로그로 트랙 추가.
2. 선택된 서버 트랙 행에 수정·삭제 원형 버튼. 수정은 이름 다이얼로그, 삭제는 확인 후 삭제.
3. `TimelineBoardToolbar`에서 EditTools·관련 인자 제거.
4. 보드에서 트랙명 TextEditingController·동기·EditTools 연결 제거.
5. `TimelineBoardEditTools` 클래스 삭제(`track_tools.dart`에는 TrackMenu만 유지).

## 유지할 것
- `didSubmitNewTimelineTrack` / `didSubmitTimelineTrackName` / `didTapDeleteSelectedTimelineTrack`
- 선택 의미: 서버 클립이 선택된 트랙(`selectedServerTrack`)
- TrackMenu·클립 툴바

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
- EditTools 줄 없음, 라벨에서 추가·수정·삭제 가능
