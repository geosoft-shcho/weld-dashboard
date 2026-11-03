# 작업조회 상세 ListAssets 지연 로드

## 목표
작업조회 상세 최초 로드에서는 ListAssets를 호출하지 않고, 첨부 탭을 눌렀을 때만 `pageSize=20`으로 한 번 조회한다. 기존 pageSize 200·1 중복 호출을 이 화면 경로에서 제거한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/job_lookup/job_lookup_detail_view_model.dart` `load` / `didSelectTab` / `_loadAttachments`
4. `lib/src/data/repositories/remote_job_admin_repository.dart` `getJobDetail`
5. `lib/src/data/repositories/remote_work_detail_repository.dart` `loadCatalog` / `listAttachments` (작업조회에서 끊을 근거만 확인)
6. 계약·화면안: 없음

## 현재 상태
- `JobLookupDetailViewModel.load()`가 `LoadWorkDetailCatalogUseCase`를 호출 → `RemoteWorkDetailRepository.listAttachments`가 **ListAssets pageSize 200**.
- 같은 `load()`에서 `JobAdminUseCase.getJobDetail` → `RemoteJobAdminRepository`가 **ListAssets pageSize 1**로 `totalCount`만 채움.
- 첨부 목록용 ListAssets 20은 `didSelectTab(attachments)` / `_loadAttachments`에 이미 있음. 기본 탭은 info라 최초에는 안 타지만, `load()` 끝의 `if (_tab == attachments)` 분기가 남아 있음.
- 탭 배지 `첨부 N`은 `viewModel.job.attachmentCount`를 씀. 최초에는 카탈로그 쪽 개수, `_applyDetail` 시에만 detail 개수로 맞춰짐.
- `GetJobResponse`에는 `attachment_count` 필드가 없음(ListJobs `JobSummary`에만 있음).
- `LoadWorkDetailCatalog`는 `work_detail_view_model.dart` 타임라인용으로도 쓰이므로 **repository의 pageSize 200은 유지**.

## 바꿀 것
1. **`job_lookup_detail_view_model.dart` `load()`**
   - `LoadWorkDetailCatalogUseCase` / `QueryWorkDetailUseCase` 호출 제거.
   - `getJobDetail`로 `_detail`·`_passes`를 채우고, `_applyDetail`로 `_job`(WorkHistoryItem)을 만든다. GetJob 장비·작업자 종류가 비면 빈 값 허용.
   - 최초 로드에서 `_loadAttachments` 호출 제거(첨부 탭 선택 시에만).
   - 더 이상 안 쓰는 catalog/query UseCase 의존성·import 제거.
2. **`remote_job_admin_repository.dart` `getJobDetail`**
   - ListAssets(pageSize 1) 제거. `attachmentCount`는 `0`으로 둔다(개수는 첨부 탭 ListAssets `totalCount`로만 채움).
3. **첨부 탭 로드 후 배지**
   - `_loadAttachments` 성공 시 `totalCount`가 있으면 `_attachmentsTotalCount`와 `_detail`/`_job.attachmentCount`를 `_applyDetail`로 갱신. 없으면 기존 detail 개수 유지(이미 있는 reload 규칙과 동일).
   - 올리기/떼기 후 `_reloadAttachments`도 같은 규칙 유지.
   - 작업 정보 저장 등으로 `getJobDetail`을 다시 받을 때, 서버 응답에 개수가 없으므로 **기존 `_detail.attachmentCount` / `_attachmentsTotalCount`를 덮어쓰지 않고 유지**.
4. **DI**
   - `locator.dart`에서 JobLookupDetailViewModel 생성 시 제거한 UseCase 인자 정리.

## 유지할 것
- 첨부 탭 인피니트 스크롤(`didScrollAttachmentsNearEnd`, pageSize 20)
- 후처리 열·기능 버튼·올리기/붙이기
- `RemoteWorkDetailRepository.listAttachments`(작업상세/타임라인용 pageSize 200)
- GetJob·패스·마스터·장비 로드

## 이번 작업에서 만들지 않음
- 작업상세(work_detail) 타임라인 ListAssets 변경
- GetJob proto에 attachment_count 추가
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
- 작업조회 상세 최초 로드: ListAssets 호출 0회(GetJob만)
- 첨부 탭 클릭: ListAssets `page_size=20` 1회, 목록·배지 반영
- 스크롤 끝 이어받기 유지
- analyze 통과
