# 타임라인 트랙 소리 on/off

## 목표
영상/음성 트랙 라벨에서 소리를 켜고 끌 수 있게 한다. mute는 트랙 단위이며, 모니터 영상 오디오와 타임라인 덮는 음성 재생에 반영된다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/multimodal_timeline_board.dart` (`_trackLabel` 모니터·차트 토글)
4. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`didTapMonitorTrack`, `coveringAudioClip`)
5. `lib/src/presentation/features/video_multimodal/widgets/multimodal_video_stage.dart`
6. `lib/src/presentation/features/video_multimodal/widgets/multimodal_video_player.dart` (`setVolume` / step seek)
7. `lib/src/presentation/features/video_multimodal/widgets/multimodal_timeline_audio_player.dart`

## 현재 상태
- 라벨: 모니터(`videocam`)·차트·가리기만 있음. 트랙 mute 없음.
- 영상 소리는 `MultimodalVideoPlayer`의 `setVolume`(스텝 시킹 시 0, 아니면 1)과 데스크탑 컨트롤 mute.
- 덮는 음성은 `MultimodalTimelineAudioPlayer`가 stage Stack에서 재생. volume/mute prop 없음.

## 바꿀 것
1. **ViewModel**
   - `_mutedTrackIds` (기본 unmute).
   - `isTrackAudioMuted(trackId)`, `didTapToggleTrackAudioMute(trackId)`.
   - 아이콘 표시 조건용: 서버 트랙이고 (`trackHasVideo` 또는 `trackHasAudio`).
   - 덮는 음성 mute: `coveringAudioClip`의 `trackId`가 muted면 true인 getter (예: `isCoveringAudioMuted`).
2. **보드 UI** (`_trackLabel`)
   - 모니터 아이콘 옆에 `volume_up` / `volume_off` (기존 14px·색 톤).
   - 탭 → `didTapToggleTrackAudioMute`.
3. **영상**
   - `MultimodalVideoPlayer`에 `isAudioMuted` 추가.
   - volume: step seek면 0 유지; 아니면 muted면 0, 아니면 1.
   - stage `_player`에 `viewModel.isTrackAudioMuted(trackId)` 전달 (legacy `trackId ''`는 false).
4. **음성**
   - `MultimodalTimelineAudioPlayer`에 `isMuted` 추가, `_sync`에서 `setVolume(0/1)`.
   - stage에서 `isMuted: viewModel.isCoveringAudioMuted` 전달.
5. 전역 데스크탑 mute와 트랙 mute: 플레이어가 prop으로 재적용. 스텝 시킹 mute와 사용자 mute를 prop/`usesStepSeek`로 구분.

## 유지할 것
- 모니터·차트·가리기 토글
- playhead / covering 선택 로직
- 서버에 mute 저장 안 함

## 이번 작업에서 만들지 않음
- 클립별 mute
- 음성 전용 멀티 트랙 믹서 확장
- mute 서버 영속화
- 새 오디오 엔진·추상 플레이어

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
- 영상 트랙 mute → 해당 모니터 칸 무음, unmute → 소리 복귀(스텝 시킹 중 제외)
- 덮는 음성 트랙 mute → `MultimodalTimelineAudioPlayer` 무음
- 차트/모니터 토글과 독립
- mute 없을 때 아이콘은 `volume_up` 톤
