# bars용 ListAssets pageSize=50 제거

## 목표
openTimeline 백그라운드의 `Asset.ListAssets jobId filter pageSize=50 bars` 호출을 제거한다. 사이드 목록은 `ListAssetsPage`만 쓴다.

## 바꿀 것
1. `_loadSideAssets`에서 `_listHistoryWorkAttachmentsUseCase.execute`와 bars 조립·해당 MM-LOAD ListAssets 로그를 제거한다.
2. 사이드를 연 뒤 `_loadAssetsPage(1)`만 호출한다.
3. `didPlaceUploadedRecording`의 첨부 재조회는 유지한다.

## 유지할 것
- ListAssetsPage 페이지네이션
- 행 선택·드래그·openTimeline 흐름

## 이번 작업에서 만들지 않음
- 에셋 상세 이동
- `_bars`를 다른 API로 대체하는 대공사

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- MM-LOAD에 `pageSize=50 bars` ListAssets가 더 이상 나오지 않는다
- ListAssetsPage·페이지 번호 UI는 동작한다
- 관련 테스트 통과
