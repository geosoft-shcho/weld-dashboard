# 파이프라인 실패 칸 Trace id 로그

## 목표
`[pipeline] cells`에 failed로 켜진 단계마다, 그 실패를 만든 Trace id를 같이 찍는다.

## 먼저 읽을 것
- `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart` (`_debugLogLitCells`)

## 현재 상태
- 시그니처 변경 시 running Trace와 `cells stage:visual`만 로그한다.
- `register:failed` 원인 Trace id는 안 보인다.

## 바꿀 것
1. `_debugLogLitCells`에서 non-idle 칸이 `failed`일 때, 해당 stage에 머문 `UploadTraceStatus.failed` Trace id를 같은 로그(또는 바로 다음 한 줄)에 짧게 붙인다.

## 복잡한 코드 제거 및 금지
- 새 로거/추상 계층 금지
- UI·집계 visual 규칙 변경 금지
- `kDebugMode` 밖 상시 로그 금지

## 완료 확인
- `./scripts/agent_check.sh` 통과
- failed 칸이 있으면 로그에 원인 Trace id가 보인다
