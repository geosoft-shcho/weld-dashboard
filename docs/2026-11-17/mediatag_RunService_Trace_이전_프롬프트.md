# mediatag RunService·Trace 이전

## 목표
운영 서버에서 도구 실행·후처리 조회가 404 없이 되고, 업로드 한 건은 Trace로 받기→등록→후처리→임베딩 진행을 보여 준다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `docs/2026-11-17/README.md`
4. `protos/mediatag/run/v1/run.proto`, `protos/mediatag/trace/v1/trace.proto`, `protos/mediatag/tool/v1/tool.proto`, `protos/mediatag/asset/v1/asset.proto`
5. `lib/src/data/datasources/remote/media_tag_data_source.dart`
6. `lib/src/data/repositories/tool_run_requests.dart`
7. `lib/src/data/repositories/remote_tool_run_repository.dart`
8. `lib/src/data/repositories/remote_asset_lookup_repository.dart`
9. `lib/src/data/repositories/remote_asset_upload_repository.dart`
10. `lib/src/data/repositories/clip_detail_mapping.dart`
11. `lib/src/domain/entities/tool_run.dart`
12. `lib/src/domain/use_cases/upload_asset_queue_use_case.dart`
13. `lib/src/data/datasources/asset_tus_upload_web.dart` 및 stub/multipart 경로

## 현재 상태
- 생성 코드(`lib/src/data/datasources/generated/mediatag/{run,trace,tool,asset}/v1/`)는 이미 새 proto다. `ToolService`에는 도구 관리만 남고, 실행 RPC는 `RunService`에 있다.
- 앱은 아직 `_mediaTag.toolService.startRun/getRun/listRuns/cancelRun`을 호출한다.
- `PostprocessStatus`/`PostprocessRun` 참조가 lookup·upload·clip_detail·테스트에 남아 있다.
- Trace·GetQueue·업로드 `traceId`/`Upload-Trace-Id`는 앱에 없다. 업로드 후처리는 `GetRun(runId)`만 쓴다.

## 바꿀 것
1. **P0** `MediaTagDataSource`에 `RunServiceClient runService`, `TraceServiceClient traceService` 추가. `toolService`는 ListTools 등 유지.
2. **P0** `tool_run_requests.dart` / `remote_tool_run_repository.dart`의 실행 요청·응답을 `mediatag/run/v1`로 이전. `toolRunSnapshotFrom(Run)`에서 `toolId` 또는 `stage` 매핑.
3. **P0** lookup/upload/clip_detail의 `PostprocessStatus` → `run.pbenum.RunStatus` (`RUN_STATUS_*`). 라벨 prefix `POSTPROCESS_STATUS_` → `RUN_STATUS_`.
4. **P0** 깨진 테스트(`test/tool_run_test.dart`, `test/clip_detail_test.dart` 등) 수정.
5. **P1** `ToolRunSnapshot`에 `stage`, wait 필드 추가. QUEUED 메시지는 `wait.reason`/`ahead` 우선.
6. **P1** tus 시작 응답 헤더 `Upload-Trace-Id`, multipart/등록 JSON `traceId`를 `AssetUploadResult.traceId`로 수집.
7. **P1** `TraceSnapshot` + `TraceRepository`/`RemoteTraceRepository` + `TraceUseCase`(getTrace) + locator 등록.
8. **P1** `UploadAssetQueueUseCase`: `traceId` 있으면 1초마다 `GetTrace`. `RUNNING`→last_event/progress/run.wait, `DONE`→완료, `FAILED`→실패. `traceId` 없고 `runId`만 있으면 기존 `GetRun`. `RetryPostprocess`는 `GetRun` 유지.
9. **P2** `ToolRunRepository.getQueue` → `runService.getQueue`, `queues[]`를 단순 도메인 목록으로 매핑. UI 없음.
10. `buf generate`는 생성물이 proto와 맞으면 다시 돌리지 않는다.

## 유지할 것
- `RetryPostprocess` 경로
- `ListTools` on `ToolService`
- 도메인 `ToolRun*` 이름
- 기존 업로드 큐 UI 상태 enum
- 공정 전용 화면 없음

## 이번 작업에서 만들지 않음
- 대기열 모니터 화면
- Trace 전용 새 화면/라우트
- `ToolRun`→`Run` 전역 이름 리네임
- 새 상태관리·디자인 시스템

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
- `./scripts/agent_check.sh test/tool_run_test.dart test/clip_detail_test.dart` (및 업로드/후처리 관련 테스트가 있으면 포함)
- StartRun/GetRun/ListRuns/CancelRun이 `mediatag.run.v1.RunService`를 호출한다
- postprocess/STT 상태 매핑이 `RunStatus`다
- 업로드 결과에 `traceId`가 오면 GetTrace 폴링으로 진행 메시지를 갱신한다
