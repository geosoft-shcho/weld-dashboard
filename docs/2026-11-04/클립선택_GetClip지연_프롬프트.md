# 클립 선택 GetClip 지연 개선

## 목표
타임라인에서 트랙/클립을 고를 때 `GetClip`이 불필요하게 여러 번·매번 네트워크로 나가지 않게 해, 속성·파형 표시가 빨리 뜨게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`didSelectSampleClip`, `_loadClipDetail`, `_loadAudioChart`, `_loadTimeseriesChart`)
4. `lib/src/data/repositories/clip_detail_mapping.dart` (`buildGetClipRequest`)
5. 계약·화면안: `docs/2026-11-03/README.md` GetClip·`include_assets`/`include_target` 절

## 현재 상태
- `didSelectSampleClip`은 선택 시 항상 `unawaited(_loadClipDetail(clipId))`로 `GetClip`을 친다.
- 같은 선택에서 음성·시계열이면 `_expandAudioChart` / `_expandTimeseriesChart`가 `_loadAudioChart` / `_loadTimeseriesChart` 안에서 **또** `_getClipUseCase.execute`를 친다 → **선택 1번에 GetClip 2회**.
- `buildGetClipRequest`는 항상 `includeAssets: true`, `includeTarget: true`라 응답이 무겁다.
- 같은 클립을 다시 골라도 캐시가 없어 `GetClip`을 다시 친다.
- `GetTimeline(include_assets)` 자산에 `waveform_url`/`channels`가 있어도 `TimelineClip`에는 안 실리고, 차트는 GetClip 결과에만 의존한다.

## 바꿀 것
1. 클립 선택 경로에서 **GetClip은 `_loadClipDetail`만** 치도록 한다. `_loadAudioChart` / `_loadTimeseriesChart` 안의 `_getClipUseCase.execute`를 제거한다.
2. `_loadClipDetail`이 받은 `ClipDetail`로 음성·시계열 차트를 채운다. 이미 차트 확장 중인 클립이면 `waveformUrl`·`sourceStartNs`/`sourceEndNs` 또는 `channelNames`를 그 상세에서 넘겨 파형 로드만 이어 간다.
3. ViewModel에 `clipId → ClipDetail` 메모리 캐시를 둔다. `_loadClipDetail`은 캐시 히트면 네트워크 없이 쓰고, 미스면 `GetClip` 후 저장한다. 타임라인 교체·클립 생성·이동·삭제 등으로 타임라인을 다시 받은 뒤에는 캐시를 비운다.
4. 요청 플래그(`includeAssets`/`includeTarget`)와 속성 패널 필드는 유지한다. GetClip API·매핑 계층을 새로 두지 않는다.

## 유지할 것
- 포즈/비영상 대상 영상 스테이지(`include_target` 사용)
- 속성 사이드 `clipDetailFields` 표시
- 깊이 STT 가드·대기열·웹캠 STT UX
- `GetClip` 자체를 없애지 않음(속성·대상 영상용)

## 이번 작업에서 만들지 않음
- 서버/proto 변경, GetClip 필드 축소 요청
- `TimelineClip`에 waveform/channels 필드 확장(이번엔 ViewModel 캐시·단일 조회로 충분)
- GetQueue·업로드·첨부 탭 변경
- `login_screen.dart`

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
- 관련 테스트가 있으면 `./scripts/agent_check.sh`에 해당 경로 포함 통과 (`test/job_timeline_edit_test.dart` 등 선택 경로)
- 음성/시계열 클립 선택 시 네트워크에 GetClip이 **클립당 1회**만 나감
- 같은 클립 재선택 시 GetClip이 다시 나가지 않음(캐시)
- 속성 패널·음성 파형·시계열 차트·포즈/비영상 대상 영상 재생이 이전과 같이 동작
