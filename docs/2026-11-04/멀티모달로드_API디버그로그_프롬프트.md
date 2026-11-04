# 멀티모달 최초 로드 API 디버그 로그

## 목표
멀티모달 화면 진입 시 `loadAttachments()`가 돌리는 서버 요청(논리 RPC·콘텐츠 GET)을 콘솔에서 순서·소요 시간과 함께 확인할 수 있게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/video_multimodal_screen.dart` (`..loadAttachments()`)
4. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` `loadAttachments` · `_loadProjectId` · `_loadOverlayBodies` · `loadLabelSections` · `_restoreActiveToolRun`
5. `lib/src/presentation/features/video_multimodal/playhead_covering_log.dart` (기존 디버그 로그 패턴)
6. 계약·화면안: 없음

## 현재 상태
- 화면 생성 시 `locator<VideoMultimodalViewModel>..loadAttachments()`만 호출한다.
- `loadAttachments` 순서는 대략: GetTimeline → 작업 첨부 목록 → projectId → 오버레이 content GET(N) → ListLabels → ListRuns(·필요 시 ListTools).
- 이 구간에 요청 이름을 모은 디버그 로그는 없다. PLAYHEAD/POSE 로그만 있다.

## 바꿀 것
1. `lib/src/presentation/features/video_multimodal/multimodal_load_api_log.dart` 추가.
   - 접두사 `[MM-LOAD]`.
   - `kDebugMode`일 때만 출력. `print` 사용(playhead 로그와 같이 debugPrint 쓰로틀 회피).
   - `begin(jobId)` / `step(name, {detail})` / `stepDone(name, {detail, error})` / `end()` — 단계 시작·끝과 elapsed ms.
2. `loadAttachments`와 하위 호출에만 심는다(최초·새로고침 동일 경로).
   - `GetTimeline` (`_getJobTimelineUseCase.execute`)
   - `ListWorkAttachments` (첨부 use case; 실제 호출명에 맞게 표기)
   - `GetJob/projectId` (`_loadJobProjectIdUseCase`)
   - `ReadContent×N` (`_loadOverlayBodies` — 건수·assetId 요약)
   - `ListLabels`
   - `ListRuns` (+ 활성 run 있으면 `ListTools`)
3. release 빌드에서는 로그 없음. HTTP 클라이언트를 전역으로 바꾸지 않는다(범위: `video_multimodal`).

## 유지할 것
- GetClip 캐시·차트 세션·기존 PLAYHEAD/POSE 로그
- 로드 순서·예외 처리

## 이번 작업에서 만들지 않음
- Connect/HTTP 전역 인터셉터
- 네트워크 패널 UI
- release용 원격 텔레메트리
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
- `dart analyze` on `video_multimodal` 무결함
- Chrome에서 멀티모달 진입 시 콘솔에 `[MM-LOAD]`로 단계·ms가 순서대로 보임
