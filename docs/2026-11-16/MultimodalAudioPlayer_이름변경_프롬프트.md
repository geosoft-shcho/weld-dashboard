# MultimodalAudioPlayer 이름 변경

## 목표
`MultimodalTimelineAudioPlayer` 위젯과 파일명을 `MultimodalAudioPlayer` / `multimodal_audio_player.dart`로 바꾼다.

## 바꿀 것
1. 파일 rename + 클래스·State 이름 변경
2. `multimodal_video_stage.dart` import·생성자 참조 갱신

## 유지할 것
- mute·seek·재생 동작 동일

## 이번 작업에서 만들지 않음
- 과거 docs 프롬프트 일괄 수정
- 동작 변경

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
- 옛 파일·클래스명 참조 없음(제품 코드)
