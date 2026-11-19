# TraceEvent 동일 name → 마지막·종결 status 매칭

## 목표
`postprocess.run`처럼 같은 name가 queued/running/succeeded로 여러 줄일 때, 노드 visual·이벤트 스트립이 **첫 줄(queued)에 고정되지 않고** 종결 status(또는 마지막 줄)를 쓰게 한다. 완료 판정은 계속 `Trace.status` / `lastEvent`다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `docs/2026-11-19/done.stored_postprocess.run순서_서버이슈_클라이언트개선안.md` (권장 A·B·D)
4. `lib/src/domain/entities/upload_trace.dart`
5. `lib/src/domain/entities/pipeline_trace_graph.dart` (`_visualForSelected`)
6. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_view.dart` (`_FocusedNodeEventStrip`)
7. `test/pipeline_trace_graph_test.dart`

## 현재 상태
- visual·스트립이 `events`에서 `name` **첫** 매칭만 사용 → 완료 Trace에서도 `postprocess.run`이 queued로 보임
- path는 name 최초 출현만 (유지)
- 완료·필터는 status/lastEvent (유지)

## 바꿀 것
1. `upload_trace.dart`(또는 graph 도메인)에 `traceEventNamed(events, name)`: 같은 name 중 `succeeded`/`failed`/`canceled`가 있으면 그 줄(여러면 마지막 종결), 없으면 **마지막** 줄. 주석에 GetTrace 오래된 순·완료는 status/last_event.
2. `_visualForSelected`와 `_FocusedNodeEventStrip`이 이 헬퍼를 쓴다.
3. `pipelinePathNodeIds` 주석: path는 최초 출현 유지, 상세/visual은 `traceEventNamed`.
4. 테스트: queued→running→succeeded인 Trace에서 `postprocess.run` visual/매칭이 succeeded; RUNNING 중 queued만 있으면 queued.

## 유지할 것
- path name 최초 출현
- 완료 = status / lastEvent
- events `at` 전역 재정렬 없음

## 이번 작업에서 만들지 않음
- 서버 호출 변경, detail Struct 매핑, 전역 이벤트 타임라인 UI

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh test/pipeline_trace_graph_test.dart` 통과
- 완료 Trace의 postprocess.run 상세/visual이 succeeded
- path·완료 판정 동작 유지
