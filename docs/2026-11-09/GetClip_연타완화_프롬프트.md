# GetClip 연타 완화

## 목표
타임라인에서 클립을 연타해도 선택·시크·Properties 요약은 바로 바뀌고, 네트워크 GetClip은 동시에 최대 1개만 나가며 대기 중이면 마지막 clipId만 남긴다. 프록시에 서로 다른 GetClip이 겹치지 않게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`didSelectSampleClip`, `_loadClipDetail`, `_clipDetailEpoch`)
4. `lib/src/presentation/features/video_multimodal/clip_detail_cache.dart`
5. 계약·화면안: 없음

## 현재 상태
- `didSelectSampleClip`은 선택·시크·Properties 오픈 후 항상 `unawaited(_loadClipDetail)`.
- `_clipDetailEpoch`로 낡은 응답은 UI에 안 붙이지만, 이미 나간 다른 clipId GetClip은 프록시에서 계속 돈다.
- `ClipDetailCache`는 같은 clipId inflight만 합친다. 다른 클립 병렬 GetClip은 막지 않는다.

## 바꿀 것
1. ViewModel에 GetClip 전역 상한 1 대기열을 둔다 (`_loadClipDetail` / UseCase 진입만). 캐시 히트는 대기열 없이 즉시 적용.
2. 미스여서 네트워크가 필요할 때: 이미 GetClip이 진행 중이면 대기 clipId를 최신 값으로 덮어쓴다(중간 연타분 폐기). 진행 중이 끝나면 대기 중인 최신 id만 1회 로드.
3. 선택 UX는 유지: `didSelectSampleClip`의 선택·시크·사이드·차트 준비·요약 표시는 로딩과 무관하게 즉시.
4. 기존 `_clipDetailEpoch`로 응답 적용 가드는 유지. 타임라인 보드에서 탭을 막거나 debounce UI는 넣지 않는다(방안 A 아님).

## 유지할 것
- Properties 타임라인 요약 + GetClip 부분 로딩 UI
- clipId당 결과 캐시·같은 id inflight 합치기
- 포즈 overlay await / 비포즈 overlay 백그라운드
- include_assets/include_target 요청 플래그, BatchGetClips, prefetch

## 이번 작업에서 만들지 않음
- GetClip 로딩 중 타임라인 탭 잠금(A)
- include 플래그 kind별 축소, BatchGetClips, 서버/프록시 변경
- 새 추상 큐 패키지·상태관리

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
- 관련 테스트가 있으면 `./scripts/agent_check.sh`에 해당 경로 포함 통과
- 캐시 없는 클립 A→B→C 연타 시 네트워크 GetClip이 동시에 2개 이상 나가지 않음
- 최종 선택 클립의 상세만 Properties에 반영
- 선택·시크·요약은 GetClip 대기와 무관하게 즉시
