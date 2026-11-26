# 적재 배지 ListTraces 싱크

## 목표
「적재 파이프라인」탭 배지의 실패·진행 수를 탭 본문(ListTraces)과 같은 기준으로 맞춰, Summary 전체 누계와 어긋나지 않게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/collection_monitoring_screen.dart`
4. `lib/src/presentation/features/collection_monitoring/pipeline_trace_view_model.dart`
5. `docs/2026-11-26/수집 날짜 조회 · 데이터 유형 변경 안내.md` §2 적재 배지

## 현재 상태
- 탭 라벨 `_pipelineTabLabel(kpi)`: `GetCollectionSummary`의 `failedTraceCount`/`runningTraceCount`(조건 무관 전체 누계)
- 탭 칩·목록: `PipelineTraceViewModel.failedCount`/`runningCount`(ListTraces 최근 창, 상태 필터 반영)
- 안내 문서: 배지는 탭으로 옮기고, 탭은 `ListTraces`로도 셀 수 있다고 명시

## 바꿀 것
1. `_pipelineTabLabel`이 `PipelineTraceViewModel`의 `failedCount`·`runningCount`를 쓰도록 변경(실패 우선, 없으면 진행)
2. `_MonitoringTabView`에서 이미 watch 중인 `pipeline`을 라벨에 넘김
3. KPI/`trace_failed_count` 매핑 제거·서버 칸 삭제는 하지 않음(이번 범위 밖)

## 유지할 것
- ListTraces 조회·폴링·상태 필터·칩의 실패/진행 집계 방식
- KPI 네 장, Summary의 running/failed 필드 매핑(아직 응답에 있음)

## 이번 작업에서 만들지 않음
- Summary에서 `trace_*_count` 제거
- ListTraces `total_count` 전용 추가 RPC/호출
- 파이프라인 탭 UI 개편

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- 탭 배지 실패·진행 수가 파이프라인 칩의 실패·진행과 같다
