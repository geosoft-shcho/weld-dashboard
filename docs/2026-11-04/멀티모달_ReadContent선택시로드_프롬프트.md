# 진입 ReadContent 제거 · 클립 선택 시 로드

## 목표
멀티모달 진입(`[MM-LOAD]`)에서 ReadContent를 호출하지 않는다. 클립을 선택했을 때만 타임라인 오버레이·포즈 본문을 HTTP로 가져오고, 포즈는 JSON(`parsePoseOverlay`)으로 파싱한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` `openJob` · `_loadOverlayBodies` · `_startPosePlayback` · `didSelectSampleClip` · `_replaceTimelineFromServer`
3. `video_overlay_json.dart` · `video_subtitle_text.dart`
4. 계약·화면안: 없음

## 현재 상태
- `openJob` 백그라운드에 `_loadOverlayBodiesInBackground` → 모든 오버레이·포즈 URL을 일괄 ReadContent.
- 포즈 클립 선택 시 `_startPosePlayback`이 `pose.assetContentUrl`을 다시 ReadContent + `parsePoseOverlay`.
- 자막은 `_cuesByAssetId`, 보드 포즈 막대는 `_framesByAssetId` → `_poseBoardMarksByClipId`에 의존(진입 일괄 로드).
- `_replaceTimelineFromServer`도 `_loadOverlayBodies`를 await.

## 바꿀 것
1. **진입에서 제거**: `openJob`의 `Future.wait`에서 `_loadOverlayBodiesInBackground` 제거. 진입 `[MM-LOAD]`에 ReadContent 없음.
2. **선택 시 로드**: `_ensureOverlayBodiesForSelection(TimelineClip clip)`를 두고 `didSelectSampleClip` → `_loadClipDetail` / `_applyLoadedClipDetail` 경로에서 호출.
   - **pose**: URL이 `_framesByAssetId`에 없으면 ReadContent → `parsePoseOverlay` → 캐시 → `_rebuildPoseBoardMarks`. `_startPosePlayback`은 캐시를 쓰거나 같은 ensure를 재사용해 이중 GET을 피한다.
   - **subtitle**: 해당 asset `contentUrl` ReadContent → `parseSubtitleCues` → `_cuesByAssetId`.
   - **video**: 이 영상 구간과 겹치는 `TimelineOverlayKind.subtitle`만 ensure(캐시 미스 시 ReadContent).
3. **타임라인 교체**: `_replaceTimelineFromServer`는 `_overlayEpoch` 증가 + 맵 clear만 하고 일괄 ReadContent는 하지 않는다.
4. 일괄 `_loadOverlayBodies` / `_loadOverlayBodiesInBackground`는 제거하고 ensure·캐시 경로로 대체한다.

## 유지할 것
- GetTimeline 블로킹 + ListAssets/Labels/ListRuns 백그라운드
- 포즈 스테이지 오버레이는 선택 후에만
- `parsePoseOverlay` / `parseSubtitleCues` 동작
- MM-LOAD 로거(진입에 ReadContent step만 사라짐)
- `login_screen.dart` 비커밋

## 이번 작업에서 만들지 않음
- 프리페치·워커 큐·새 캐시 클래스 파일
- 자막을 영상 선택 없이 전역 프리로드
- proto/서버 변경

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `dart analyze` on `video_multimodal`
- `test/job_timeline_edit_test.dart` 포즈·오버레이 관련 + `test/video_overlay_test.dart` 통과
- 진입 `[MM-LOAD]`에 ReadContent 없음
- 포즈 클립 선택 시 ReadContent + JSON 파싱·스테이지 표시
- 영상 선택 시 겹치는 자막 ensure 후 `activeVideoCaptions` 동작
