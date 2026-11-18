# 파이프라인 embed 거짓 점등 수정

## 목표
embed 이벤트 없이 `done.*`만 있는 Trace 때문에 임베딩 칸이 완료로 켜지지 않게 한다. embed 증거가 없으면 tool처럼 열을 숨긴다.

## 먼저 읽을 것
- `lib/src/domain/entities/pipeline_trace_graph.dart`
- `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
- `lib/src/presentation/features/collection_monitoring/widgets/pipeline_stage_chips.dart`
- `test/pipeline_trace_graph_test.dart`

## 현재 상태
- `lastOrder > stageOrder`면 embed 이벤트 없이도 embed를 done으로 친다.
- 진행 중 Trace에 embed/done 이벤트가 없어도 cells에 `embed:done`이 찍힌다.
- tool만 조건부 표시, embed는 항상 보인다.

## 바꿀 것
1. `pipelineTraceTouchesStage` / `pipelineListHasEmbedStage` 추가.
2. 미선택 집계: embed는 touched일 때만 지나감→done. collect는 기존 하드코딩 유지.
3. 선택 모드·노드 visual: embed를 안 거쳤으면 skipped/idle(순서만으로 done 금지).
4. `visibleStages`·chips: embed 증거 없으면 숨김. done 열은 유지.
5. 테스트: `done.stored`만 → embed idle; embed 이벤트 후 → embed done.

## 복잡한 코드 제거 및 금지
- 새 상태관리·추상 계층 금지
- collect 하드코딩 선행 제거 금지
- done 단계 삭제 금지
- 디버그 로그 대정리 금지

## 완료 확인
- `./scripts/agent_check.sh test/pipeline_trace_graph_test.dart` 통과
- embed 이벤트 없으면 embed 칸 done 아님(숨김 또는 idle/skipped)
- embed 이벤트 있으면 점등
