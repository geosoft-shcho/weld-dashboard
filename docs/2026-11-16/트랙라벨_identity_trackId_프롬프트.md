# 트랙 라벨 identity를 trackId로

## 목표
라벨 보조 식별자를 clipId(클립 1개일 때만)에서 **항상 trackId**로 바꾼다. 클립 목록은 Tooltip으로 본다.

## 권장 안
1. 행이 트랙 단위(가리기·mute·모니터)이므로 identity는 `trackId`가 맞다.
2. 클립 id 전부 상시 표시는 폭·가독성이 깨진다 → Tooltip에 `trackId` + clipId 목록.
3. 클립 0개 트랙도 trackId를 보이게 한다.

## 바꿀 것
1. `_trackLabelRow`: `identity = row.trackId`, 빈 클립도 전달.
2. identity `Text`를 Tooltip으로 감싸 클립 id 목록(없으면 ‘클립 없음’).

## 유지할 것
- 라벨 이름·선택·아이콘 순서
- `_TRACK_IDENTITY_STYLE` ellipsis

## 이번 작업에서 만들지 않음
- clipId 전부 본문 나열
- 라벨 폭 알고리즘 전면 개편

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
- 모든 트랙 라벨에 trackId 보조 표시
- Tooltip에 해당 트랙 clipId 목록
