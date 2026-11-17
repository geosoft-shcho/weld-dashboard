# 수집 모니터링 Trace 파이프라인 그래프

## 목표
수집 모니터링에서 TraceService로 적재 여정(받기→등록→후처리→도구→임베딩→완료)을 단계 열·노드·상태색·흐름으로 보여 주고, 탭 본문이 작으면 탭 위 밴드로 요약을 두며, 여정 선택 시 GetTrace·GetQueue 앞줄을 측면에 보여 준다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `docs/2026-11-17/수집모니터링_Trace파이프라인_화면검증.md` (확정 기획)
4. `docs/2026-11-17/README.md` §4 Trace
5. `lib/src/presentation/features/collection_monitoring/collection_monitoring_screen.dart`
6. `lib/src/presentation/features/collection_monitoring/collection_monitoring_view_model.dart`
7. `lib/src/domain/repositories/trace_repository.dart`
8. `lib/src/data/repositories/remote_trace_repository.dart`
9. `lib/src/domain/entities/upload_trace.dart`
10. `lib/src/domain/repositories/tool_run_repository.dart` (`getQueue`)
11. `lib/src/presentation/core/di/locator.dart`
12. `lib/src/presentation/core/themes/app_theme.dart`

## 현재 상태
- 수집 모니터링: CommandBar → KPI → 탭(`일자별 수집 타임라인`만 활성). Trace 그래프 없음.
- Trace: `getTrace`만 있음. 업로드 큐 폴링에만 사용.
- `getQueue`는 ToolRunRepository에 있음. Trace UI 연동 없음.

## 바꿀 것
1. `TraceRepository`/`RemoteTraceRepository`/`TraceUseCase`에 `listTraces` 추가(status 비움·pageSize로 RUNNING+DONE+FAILED 포함).
2. 도메인에 파이프라인 표시용 스냅샷·단계/노드 상태 매핑(고정 골격 + events/last_event). 새 추상 계층·팩토리 없이 단순 함수/엔티티.
3. `collection_monitoring`에 Trace 전용 ViewModel(폴링 1~2초, 필터, 선택, GetTrace, GetQueue 앞줄). locator 등록.
4. 화면 레이아웃: 탭 `적재 파이프라인` 추가. 탭 본문 필요 높이 < 가용 높이면 **탭 위 파이프라인 밴드**(칩+축약 흐름). 파이프라인 탭이 본문을 채우면 밴드는 칩 한 줄 또는 접기.
5. 파이프라인 탭 본문: 단계 칩(체크=열 숨김) · 필터(전체/진행/완료/실패) · 캔버스(열·노드·선·선택 경로 입자) · 줌 ±/− · 선택 시 측면 패널(요약·이벤트·GetQueue 앞줄). 기본은 패널 접힘.
6. `tool` 열: 목록에 tool.* 없으면 칩·열 숨김.
7. 다크 `AppTheme`만 사용. IoT 레퍼런스 노드명 하드코딩 금지.

## 유지할 것
- 기존 일자별 타임라인·CommandBar·KPI·보드 ViewModel 로드 흐름
- Retry/Cancel 없음(조회만)
- 업로드 큐의 기존 Trace 폴링
- 새 앱 라우트/메뉴 없음

## 이번 작업에서 만들지 않음
- SSE/WS · 음성 · RetryPostprocess UI
- Redis/`/pipeline/live` 클라이언트
- 공정 전용 이름·별도 디자인 시스템·카드 UI 남발
- 과도한 글로우/다층 그림자

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
- 관련 테스트가 있으면 `./scripts/agent_check.sh <test 경로…>` 통과
- 적재 파이프라인 탭에서 칩·열·노드가 Trace 폴링으로 갱신된다
- 선택 시 측면에 GetTrace·GetQueue 앞줄이 보인다
- 탭 본문이 작을 때 탭 위 밴드가 보인다(또는 접힘 규칙이 동작한다)
- tool 열은 데이터 없을 때 숨겨진다
