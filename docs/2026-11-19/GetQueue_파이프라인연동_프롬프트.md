# GetQueue 파이프라인 연동

## 목표
적재 파이프라인에서 여정을 고르고 `run.queue`가 있으면 RunService.GetQueue로 같은 대기열 앞줄(runs)을 보여 준다.

## 먼저 읽을 것
- `docs/2026-11-17/README.md` §3·§4
- `docs/2026-11-17/GetQueue_화면검증.md`
- `lib/src/domain/use_cases/tool_run_use_case.dart`
- `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
- `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_tab_body.dart`
- `lib/src/presentation/core/di/locator.dart`

## 현재 상태
- Repository GetQueue(`queues[]`)는 있다. UseCase·PipelineTraceViewModel·UI 앞줄은 없다.
- 선택 시 `run.queueWaitLabel`만 표시한다.

## 바꿀 것
1. `ToolRunUseCase.getQueue()` 추가.
2. `PipelineTraceViewModel`에 `ToolRunUseCase` 주입. 선택+`run.queue` 있을 때 GetQueue, 이름 매칭, 실패/미매칭 안내. refresh·선택 시 갱신, 해제 시 클리어.
3. `locator` DI 갱신.
4. `pipeline_trace_tab_body`에 대기열 앞줄(요약·runs·내 run 강조·에러).
5. `ToolRunSnapshot.createdAt` 매핑(있으면 대기 시간 표시).
6. VM/매칭 테스트 + `./scripts/agent_check.sh`.

## 복잡한 코드 제거 및 금지
- 새 라우트·전용 화면·상태관리 프레임워크 금지
- ToolService GetQueue 금지
- 집계 모드 상시 GetQueue 폴링 금지
- generated 수정·범위 밖 리팩터 금지

## 완료 확인
- 선택+queue → GetQueue·같은 대기열 runs
- 내 run 강조, 실패 시 wait 유지+안내
- queue 없거나 해제 시 앞줄 숨김
- `./scripts/agent_check.sh` (+관련 테스트) 통과
