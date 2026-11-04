# AssetsSideBody ListAssets 페이지네이션 (1차)

## 목표
Assets 사이드 본문 높이에 들어가는 행 수만큼 `Asset.ListAssets` `pageSize`를 잡고, 페이지 번호 UI로 넘길 때 페이지별 `pageToken` 캐시를 쓴다. 행 클릭·상세 이동은 보류(2차).

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `assets_side_body.dart`, `video_multimodal_view_model.dart` `_loadSideAssets`
4. `list_asset_lookup_page_use_case.dart`, `job_lookup_detail_view_model.dart` 첨부 페이지 로드
5. `locator.dart` VideoMultimodalViewModel 등록

## 현재 상태
- `_loadSideAssets`가 `ListHistoryWorkAttachmentsUseCase`로 `pageSize=50` 한 번 받아 `_attachments`·`_bars`를 채운다. 토큰·총개수·페이지 번호 없음.
- `AssetsSideBody`는 전체 `_attachments`를 클라이언트 검색만 해 스크롤 목록으로 그린다.
- `ListAssetLookupPageUseCase`는 `jobId`·`pageSize`·`pageToken`·`totalCount`·`nextPageToken`을 이미 지원한다.

## 바꿀 것
1. `VideoMultimodalViewModel`에 `ListAssetLookupPageUseCase` 주입(locator·테스트 팩토리 수정).
2. 사이드 목록 전용 상태: `_assetsPageRows`, `_assetsPageIndex`, `_assetsPageSize`, `_assetsTotalCount`, `_assetsPageTokenByPage`, `_isLoadingAssetsPage`.
3. `didReportAssetsViewport({required double bodyHeight})` — 행 높이로 pageSize 계산, 바뀌면 토큰 리셋 후 1페이지 재조회.
4. `didSelectAssetsPage(int page)` — 캐시 token으로 ListAssets, 없으면 순회 채움.
5. 검색: `didChangeAssetsSearch` 후 토큰 리셋·1페이지 재조회(query 전달).
6. `_loadSideAssets`: `_bars`는 기존 UseCase 유지. 사이드 목록은 `ListAssetLookupPageUseCase`로 별도. UI는 `_assetsPageRows`만.
7. `assets_side_body.dart`: LayoutBuilder로 높이 측정, 현재 페이지만, foot에 페이지 번호. 행 onTap/드래그 유지. 상세 이동 없음.

## 유지할 것
- openTimeline 블로킹 → 보드 → 백그라운드
- `_bars`·드래그·선택
- AssetLookup·Job 첨부 탭

## 이번 작업에서 만들지 않음
- 이름·유형·길이·상세 → 에셋 상세 이동
- WorkDetailRepository listAttachments 대공사
- 무한 스크롤·새 디자인 시스템

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` (+ 관련 multimodal 테스트)
- 사이드 높이 변경 시 pageSize가 바뀌고 1페이지부터 다시 불러온다
- 페이지 번호 선택 시 캐시된 token으로 ListAssets가 호출되고 해당 페이지 행만 보인다
- `_bars`/드래그·openTimeline 동작 유지
- 상세 이동 UI는 없음
