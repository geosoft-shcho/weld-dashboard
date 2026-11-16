# legacy stage 트랙 mute 반영

## 목표
모니터 미선택(legacy 1칸)으로 맨 위 트랙 덮는 영상이 재생될 때, 해당 영상/음성 트랙 mute가 stage 소리에 반영되게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/multimodal_video_stage.dart`
4. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`_activeVideoClip`, `isTrackAudioMuted`, `isCoveringAudioMuted`)

## 현재 상태
- `_singleLegacy`가 `_player(trackId: '')`를 넘긴다.
- `_player`는 `trackId.isEmpty`이면 `isAudioMuted: false` 고정 → 트랙 mute 무시.
- 덮는 음성은 `isCoveringAudioMuted`(클립 trackId)로 이미 연결됨.

## 바꿀 것
1. ViewModel: `activeVideoTrackId` getter (`_activeVideoClip()?.trackId ?? ''`).
2. `_singleLegacy`: `trackId: viewModel.activeVideoTrackId` 전달.
3. `_player`: `isAudioMuted: viewModel.isTrackAudioMuted(trackId)` (빈 id면 기존처럼 false).

## 유지할 것
- 모니터 그리드 경로
- 덮는 음성 `isCoveringAudioMuted`
- playhead / covering 선택 로직

## 이번 작업에서 만들지 않음
- 자동 모니터 선택
- mute 서버 영속화
- 새 오디오 엔진

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
- legacy 1칸에서 영상 트랙 mute → 영상 무음
- 덮는 음성 트랙 mute → 덮는 음성 무음
- 모니터 켠 뒤 mute도 기존과 동일
