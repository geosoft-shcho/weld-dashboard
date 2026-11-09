# 타임라인 contentUrl 재사용 (GetClip 보완만)

## 목표
GetTimeline에 이미 있는 재생·오버레이 주소를 GetClip 선택 시 다시 미디어로 쓰지 않는다. 같은 URL이면 스테이지 영상을 재open하지 않고 시크만 하며, 포즈 JSON·waveform.json 등 필요한 본문만 읽는다. GetClip은 Properties 메타·타임라인에 없는 URL 보완용으로 유지한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart`
4. `lib/src/data/repositories/remote_job_timeline_repository.dart`
5. `lib/src/data/repositories/clip_detail_mapping.dart`
6. `lib/src/domain/entities/job_timeline.dart`
7. 계약·화면안: `docs/2026-11-05/README.md` GetTimeline include_assets / GetClip 절

## 바꿀 것
1. TimelineClip에 `waveformUrl` 추가. GetTimeline `_clipFrom`에서 asset.properties의 `waveform_url`을 채운다.
2. 스테이지 영상: 타임라인 playbackUrl 우선, GetClip URL은 비었을 때만.
3. 같은 재생 URL이면 `_playbackVideoClip` 교체·`_playbackToken` 증가 없이 시크만.
4. 포즈 JSON: 타임라인 overlay/pose URL 우선.
5. 오디오 차트: 타임라인 `waveformUrl` 우선.
6. 선택 시 포즈 오버레이만 지우고, 영상 선택 시 스테이지 영상을 불필요하게 비우지 않는다.

## 유지할 것
- GetClip 호출·캐시·LoadGate·Properties 요약/상세
- include_assets / include_target 요청 플래그
- ClipDetailCache, 자막 overlay_bg

## 이번 작업에서 만들지 않음
- GetClip prefetch, include 플래그 kind별 축소
- 제네릭 미디어 캐시 계층, IndexedStack
- 프록시/서버 변경

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
- 관련 테스트가 있으면 해당 경로 포함 통과
- 같은 webm covering 유지한 채 클립 선택 시 불필요 `_open()` 반복 없음
- 포즈 JSON·waveform은 타임라인 URL이 있으면 그걸로 readContent
- Properties GetClip 상세는 유지
