# RetryPostprocess 실패 재시도

## 목표
업로드 후처리가 실패했을 때 화면에서 `RetryPostprocess(asset_id)`로 다시 걸고, 기존과 같이 `GetRun` 폴링으로 대기·처리·완료/실패를 보여 준다. 사용자는 파일을 다시 올리지 않고 후처리만 재시도한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `docs/2026-11-03/README.md` 「후처리 다시 걸기 · STT」
4. `lib/src/domain/use_cases/upload_asset_queue_use_case.dart`, `lib/src/presentation/features/asset_lookup/asset_upload_dialog.dart`, `lib/src/domain/repositories/asset_upload_repository.dart`, `lib/src/data/repositories/remote_asset_upload_repository.dart`

## 현재 상태
- generated에 `AssetService.retryPostprocess` 있음(1단계).
- 업로드는 등록 후 `GetRun`만 돌리고, `postprocessFailed`면 메시지만 표시. 재시도 버튼·RPC 없음.
- `AssetUploadResult.assetId`는 실패 후에도 행에 남아 재시도에 쓸 수 있음.
- 다이얼로그는 `uploadQueue` 콜백만 받음(`asset_lookup_screen`, `job_attachment_tab`).

## 바꿀 것
1. **Repository**: `AssetUploadRepository.retryPostprocess({required String assetId})` → `Future<String>`(runId). `RemoteAssetUploadRepository`에서 `assetService.retryPostprocess(RetryPostprocessRequest(assetId: …))` 호출. 빈 assetId·오류는 기존 업로드 예외 패턴으로.
2. **UseCase**: `UploadAssetQueueUseCase.retryPostprocess({required String assetId, required AssetUploadQueueItem base, required onItemUpdated})`
   - `retryPostprocess` → 새 `runId`
   - 상태를 `postprocessQueued`로 두고 기존 `_waitForPostprocess` 재사용
   - `StartRun` 호출 금지
3. **Dialog**: `showAssetUploadDialog`에 `retryPostprocess` 콜백 추가. `postprocessFailed`이고 `result.assetId`가 있으면 행에 **후처리 다시 걸기** 버튼. 누르면 해당 행만 재시도·진행 갱신. 업로드 중(`_isUploading`)이면 비활성.
4. **호출부**: asset_lookup / job_attachment에서 `viewModel`의 queue use case `retryPostprocess`를 넘김(필요 시 ViewModel에 thin 래퍼).
5. **테스트**: repository/use case 단위로 RetryPostprocess → GetRun 성공·실패 경로. `StartRun` 미사용 확인.

## 유지할 것
- 업로드·tus·등록 흐름, `_waitForPostprocess` 상태 매핑
- 웹캠 녹화 업로드 경로(이번엔 다이얼로그만)
- 대기열 이름/순번 표시, 웹캠 STT UX(3단계)
- `login_screen.dart` 로컬 임시 변경

## 이번 작업에서 만들지 않음
- 에셋 상세/목록의 일반 후처리 재시도 UI
- `Asset.postprocess` 목록 필터 화면
- `ToolRun.queue` 표시, 웹캠 STT 대상 UX
- proto 재생성

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 후처리 실패 행에서 **후처리 다시 걸기** → `RetryPostprocess` 후 대기/처리/완료 표시
- 네트워크에 `StartRun(asset-postprocess)` 없음
- 관련 테스트·analyze 통과
- 사용자 검증 후 3단계로 진행
