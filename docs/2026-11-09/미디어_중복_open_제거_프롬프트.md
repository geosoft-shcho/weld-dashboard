# 미디어 중복 open 제거

## 목표
멀티모달 최초·재생 중 `[MM-FILES]`에 같은 `/api/files/...webm`이 `audio_open`/`video_open`으로 반복되지 않게 한다. covering이 잠깐 비거나 A→B→A로 돌아와도 이미 로드된 URL은 다시 열지 않는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/multimodal_timeline_audio_player.dart`
4. `lib/src/presentation/features/video_multimodal/widgets/multimodal_video_player.dart`
5. `lib/src/presentation/features/video_multimodal/widgets/multimodal_video_stage.dart`
6. 계약·화면안: 없음

## 현재 상태
- `multimodal_timeline_audio_player.dart`: `mediaUrl`이 비면 `_loadedUrl=''` 후 `stop()` → 같은 URL 복귀 시 재 `setUrl`. open 중 URL이 바뀌면 `_openInFlight` early return으로 desired URL을 버리고, 이후 다시 연다.
- `multimodal_video_stage.dart`: `ValueKey('$trackId|$mediaUrl')`라 URL이 바뀔 때마다 State가 새로 만들어져 항상 `_open()`한다. 같은 트랙에서 URL이 다시 와도 재initialize.
- `multimodal_video_player.dart`: didUpdateWidget에서 URL 변경 시에만 `_open()` — 키 때문에 State가 갈리면 이 가드가 의미 없음.

## 바꿀 것
1. **오디오 플레이어** (`multimodal_timeline_audio_player.dart`)
   - `mediaUrl`이 비면 `stop()`/unload 하지 말고 pause만. `_loadedUrl` 유지.
   - open 중이면 early return으로 버리지 말고 `_desiredUrl`을 갱신. 완료 후 desired ≠ loaded이면 한 번만 이어서 open.
   - `url == _loadedUrl`이면 `setUrl` 호출 금지(시크·play/pause만).
   - 비어 있지 않은 URL이 A→B→A처럼 빠르게 바뀔 때 재open이 겹치지 않도록, URL 적용만 짧게 debounce(약 200ms). settle된 URL만 `setUrl`.
2. **영상 플레이어 키·재open** (`multimodal_video_stage.dart`, `multimodal_video_player.dart`)
   - 키를 `ValueKey(trackId)`(레거시 단칸은 고정 키)로 바꿔 URL 변경 시 State 유지.
   - `_open()` 진입 시 이미 같은 `mediaUrl`이 로드돼 있으면 initialize 생략하고 시크/재생만.
3. `[MM-FILES]` 로그는 유지. 같은 URL 재open이 사라졌는지 확인용.

## 유지할 것
- covering 음성·모니터 영상 선택 로직(ViewModel)
- GetClip/캐시/LoadGate, 타임라인 URL 재사용
- `MediaFilesDebugLog` / `readBytes` 계측
- 실제로 다른 URL로 바뀔 때의 open

## 이번 작업에서 만들지 않음
- 다중 AudioPlayer/VideoPlayer LRU 캐시·프리패치 계층
- ViewModel covering 선택 정책 변경, 서버/프록시 변경
- 디버그 로그 전면 제거

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과 (`dart analyze`)
- 멀티모달 로드·재생 시 같은 webm에 대한 `audio_open`/`video_open`이 로그에 반복되지 않음
- covering 공백 구간에서도 이전 음성 source를 unload하지 않음
- 다른 URL로 바뀌면 기존처럼 1회 open
