# GetClip 공통 중복 제거 · 캐시 분리

## 목표
클립 종류와 무관하게 GetClip은 한 진입점으로만 나가게 하고, 같은 clipId의 동시·재요청은 캐시·inflight로 합친다. 캐시 관리는 ViewModel에서 분리한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`didSelectSampleClip`, `_loadClipDetail`, `_expandAudioChart`, `_expandTimeseriesChart`)
4. `docs/2026-11-04/클립선택_GetClip지연_프롬프트.md`
5. 계약·화면안: 없음 (기존 GetClip 계약 유지)

## 현재 상태
- GetClip 네트워크 호출은 `_loadClipDetail`에만 있으나, 음성/시계열은 `_expand*Chart`가 `_loadClipDetail`을 걸고 `didSelectSampleClip`은 `detailQueuedByChart`로 스킵하는 **종류별 분기**다.
- 영상·포즈 등은 선택당 `_loadClipDetail` 1회지만, 같은 clipId에 `_loadClipDetail`이 겹치면(토글+선택·빠른 재클릭) 캐시 적재 전 **병렬 GetClip**이 날 수 있다.
- `_clipDetailCache` Map이 ViewModel 안에 있다.

## 바꿀 것
1. `lib/src/presentation/features/video_multimodal/clip_detail_cache.dart`를 추가한다. 책임은 `get` / `put` / `clear` / `getOrLoad(clipId, loader)`다. `getOrLoad`는 캐시 히트면 즉시 반환하고, 미스면 **clipId당 inflight Future 하나**만 두어 동시 호출을 합친 뒤 성공 시 put한다.
2. ViewModel의 `_clipDetailCache` Map을 제거하고 `ClipDetailCache`를 쓴다. `_replaceTimelineFromServer` 성공 시 `clear()`한다.
3. GetClip의 **유일한** 네트워크 진입은 `_loadClipDetail` → `cache.getOrLoad(..., () => _getClipUseCase.execute(...))`로 통일한다.
4. 종류별 `detailQueuedByChart` 분기를 없앤다. 공통 흐름:
   - `_prepareAudioChart` / `_prepareTimeseriesChart`(또는 기존 expand를 준비만 하도록 변경): 확장 UI·로딩 플래그만 두고 **GetClip을 호출하지 않는다**.
   - `didSelectSampleClip`: 차트 준비/접기 후 **항상** `unawaited(_loadClipDetail(clipId))` 한 번.
   - `didTapToggleAudioChart` / `didTapToggleTimeseriesChart`: 확장 시 준비 후 `_loadClipDetail` 한 번(접을 때는 호출 없음).
5. `_loadClipDetail` 성공 후 `_fillChartsFromClipDetail`로 음성·시계열 파형만 채우는 흐름은 유지한다.

## 유지할 것
- 속성 패널·포즈/대상 영상 스테이지·파형 로드 UseCase
- `includeAssets`/`includeTarget` 요청 플래그
- 대기열·STT UX

## 이번 작업에서 만들지 않음
- TimelineClip에 waveform/channels 확장
- 서버/proto 변경
- GetClip 필드 축소
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
- `./scripts/agent_check.sh` 통과 시도; 변경 파일 `dart analyze` 무결함
- `./scripts/agent_check.sh test/job_timeline_edit_test.dart` 통과
- 모든 클립 종류 선택 시 GetClip은 clipId당 네트워크 1회(재선택은 캐시, 동시는 inflight 합침)
- 음성/시계열 차트·속성·포즈/대상 영상 동작 유지
