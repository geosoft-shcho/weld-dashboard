# 첨부 탭 ListAssets 20건·인피니트 스크롤

## 목표
첨부 탭에서 ListAssets를 **처음 20건**만 받고, 스크롤이 끝에 가까워지면 `nextPageToken`으로 다음 페이지를 이어 붙인다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/job_lookup/job_lookup_detail_view_model.dart` `_loadAttachments` / `_reloadAttachments`
4. `lib/src/presentation/features/job_lookup/widgets/job_attachment_tab.dart`
5. 참고: `lib/src/presentation/features/asset_lookup/asset_lookup_view_model.dart` `didScrollNearEnd`, `lib/src/presentation/core/widgets/catalog_lookup_table.dart` near-end 임계

## 현재 상태
- `_loadAttachments`는 `pageSize: 200`, `pageToken: ''` 한 번만 호출한다.
- `nextPageToken`·`isLoadingMore`·이어 받기 메서드 없음.
- 첨부 탭은 전체 `_attachments`를 `ListView`에 그리고 스크롤 감지가 없다.
- 앱 기준 배치 크기는 `WorkHistoryQuery.BATCH_SIZE`(20)이다.

## 바꿀 것
1. **ViewModel**
   - `pageSize = 20` (`WorkHistoryQuery.BATCH_SIZE`)
   - `_attachmentsNextPageToken`, `_isLoadingMoreAttachments` 추가. getter: `doesHaveMoreAttachments`, `isLoadingMoreAttachments`
   - `_loadAttachments`: 첫 페이지(`pageToken: ''`), 토큰·행 저장. `_reloadAttachments`도 토큰 리셋 후 첫 페이지만.
   - `didScrollAttachmentsNearEnd`: 더 있고 로딩 중이 아니면 다음 토큰으로 조회해 행 append(중복 `assetId` 스킵).
   - `_reloadAttachments`에서 `attachmentCount`를 로컬 행 수로 덮어쓰지 않는다. ListAssets `totalCount`가 있으면 그 값을 쓰고, 없으면 기존 `detail.attachmentCount` 유지.
2. **UI**
   - 바깥 `ListView`를 `NotificationListener<ScrollNotification>`으로 감싸 끝 근처면 `didScrollAttachmentsNearEnd` 호출.
   - 이어 받기 중이면 목록 아래에 `ProgressRing` 표시.

## 유지할 것
- 후처리 열·기능 버튼·올리기/붙이기
- ListAssets job 필터 자체

## 이번 작업에서 만들지 않음
- 에셋 관리 목록 페이지 크기 변경
- 첨부 필터 ComboBox

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 첨부 탭 첫 요청 `page_size=20`
- 스크롤 끝에서 다음 페이지가 이어 붙음
- analyze 통과
