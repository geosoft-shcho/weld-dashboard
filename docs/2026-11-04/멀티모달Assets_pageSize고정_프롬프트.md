# Assets ListAssets pageSize 고정·중복 조회 제거

## 목표
진입 시 `ASSETS_DEFAULT_PAGE_SIZE=20`으로 1페이지만 조회한다. LayoutBuilder 높이로 pageSize를 다시 잡지 않고, 진입 직후 ListAssets가 두 번 이상 나가지 않게 한다.

## 바꿀 것
1. `ASSETS_DEFAULT_PAGE_SIZE`를 20으로 변경.
2. `AssetsSideBody`에서 `didReportAssetsViewport` 호출(LayoutBuilder post-frame) 제거.
3. `didReportAssetsViewport`는 높이로 pageSize를 바꾸지 않거나 호출되지 않게 둔다(죽은 코드면 제거).

## 유지할 것
- 페이지 번호·pageToken 캐시
- ListAssetsPage 경로

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 진입 시 ListAssetsPage pageSize=20 한 번
- LayoutBuilder로 인한 재조회 없음
