# (2026-11-19) done.stored ↔ postprocess.run succeeded 순서 — 서버 이슈·클라이언트 개선안

| 항목 | 내용 |
|------|------|
| 대상 Trace | `143` (`depth_front_view.mp4`, GetTrace 샘플) |
| 서버 원인 | 후처리 run 종료 직전에 Trace를 `done.stored`로 닫고, 직후 `postprocess.run` `succeeded`를 남겨 `at`이 1ms 역전될 수 있음 |
| 서버 예정 | `postprocess.run` **succeeded →** `done.stored` 순으로 기록 |
| 완료 판정 | **`Trace.status` / `last_event`** (이벤트 줄 순서로 완료를 판단하지 않음) |

---

## 1. 이슈 정리

### 서버에서 일어나는 일

의도된 의미 순서:

1. 후처리 run 종료 → `postprocess.run` (`succeeded`)
2. 클립 배치 등 → `postprocess.placed` (없으면 skipped)
3. 여정 완료 → `done.stored` (또는 `done.searchable`)

버그 시 기록 순서:

1. Trace를 먼저 완료로 갱신하며 `done.stored` 기록
2. 그다음 run 쪽 `postprocess.run` `succeeded` 기록  
→ `at`이 거의 같아도 **succeeded가 done보다 뒤**로 남을 수 있음. 동작(자산·run 상태)은 맞고 **이벤트 표시 순서만** 어색함.

### 샘플(143) 관찰

제공된 응답에서는 시간·배열 모두 정상 쪽에 가깝다.

| eventId | name | status | at |
|---------|------|--------|-----|
| 1805 | `postprocess.run` | succeeded | `…50.483428Z` |
| 1806 | `postprocess.placed` | skipped | `…50.484139Z` |
| 1807 | `done.stored` | ok | `…50.484139Z` |

`lastEvent` = `done.stored`, `status` = `TRACE_STATUS_DONE` → 완료 판정용 필드는 일관됨.  
개선안은 **역전 샘플이 다시 나와도** 클라이언트가 흔들리지 않게, 서버 수정과도 맞추는 쪽이다.

---

## 2. 클라이언트 As-Is (소스 기준)

### 완료·목록·필터 — 이미 status / lastEvent

| 위치 | 동작 |
|------|------|
| `TraceSnapshot.isTerminal` | `status`만 (done/failed) |
| `pipeline_trace_list` | 태그·색 = `status`, 부가 문구 = `lastEvent` |
| `stageId` / 단계 visual | `lastEvent`에서 stage 추출 |
| enrich 대상 | `status == running` (+ 선택 id) |
| 선택 path 활성 | `selected` + events, 완료 여부는 `status` |

**완료 여부·목록 필터는 이벤트 줄 순서에 의존하지 않는다.** 서버 가이드(“완료는 status / last_event”)와 맞다.

### path — events 출현 순 + 이름 중복 제거

`pipelinePathNodeIds` (`pipeline_trace_graph.dart`):

- `events`를 **배열 순(오래된 것부터)** 으로 훑고
- **같은 `name`은 첫 줄만** path에 넣음 (`seen`)
- 마지막에 `lastEvent`가 path에 없으면 보정

그래서 `postprocess.run`이 queued → running → succeeded로 여러 줄이어도 path 노드 `postprocess.run`은 **첫 줄(대개 queued)** 한 번만이다.  
`done.stored`와 `succeeded`의 앞뒤가 바뀌어도 **path 노드 집합**에는 거의 영향이 없다 (둘 다 다른 name).

활성 연결(`pipelinePathEdges`)은 그 path 연속 쌍이라, 역전 시에도 “succeeded 선이 done 뒤로 간다”기보다 **표시 타임라인·상세 스트립**이 더 민감하다.

### 노드 visual / 이벤트 스트립 — 같은 name 첫 매칭

`_visualForSelected` · `_FocusedNodeEventStrip`:

- `events`에서 `name == nodeId`인 **첫 이벤트**만 사용

완료된 Trace에서 `postprocess.run`을 탭하면 **queued** 줄이 잡혀 status가 어색할 수 있다.  
(마지막 `succeeded`가 있어도 무시.)  
노드 색은 `lastEvent`가 뒤 stage면 이전 노드를 done으로 보는 보정 분기가 있어, **칸 점등**은 역전보다 덜 깨진다.

### 매핑

`remote_trace_repository`는 GetTrace `events` 순서를 그대로 `TraceEventSnapshot` 리스트로 옮긴다. 클라이언트 재정렬 없음.

---

## 3. 서버 수정 방향과의 정렬

| 서버 To-Be | 클라이언트 기대 |
|------------|-----------------|
| `postprocess.run` succeeded 기록 후 `done.stored` | GetTrace 배열·`at`이 의미 순서와 일치 |
| `last_event` / `status`는 완료 시 계속 done 쪽 | 목록·필터·터미널 판정 유지 |
| 기존 역전 Trace는 DB에 남을 수 있음 | 구 데이터 내성(아래 개선) |

서버만 고쳐도 **새 Trace**의 타임라인·스트립은 자연스러워진다.  
클라이언트는 **완료 판정을 events 순서에 기대지 않는 현재 원칙을 유지**하고, 중복 name·구 데이터만 보강하면 된다.

---

## 4. 클라이언트 개선안

### 유지 (바꾸지 않음)

1. **완료·필터·집계 진행 여부** = `Trace.status` (+ 필요 시 `lastEvent`).  
   events의 `at` 비교나 “마지막 줄이 done인가”로 DONE을 재정의하지 않는다.
2. ListTraces 요약만으로 path를 확정하지 않고, 선택·RUNNING은 GetTrace events를 쓰는 현행.
3. path는 “알려진 노드 name의 최초 출현 순” 모델 유지 (그래프 골격과 맞춤).

### 권장 개선

| 우선 | 내용 | 이유 |
|------|------|------|
| A | **동일 `name` 매칭은 “마지막 의미 있는 줄”** (또는 run 계열은 마지막 status) | 스트립·선택 visual이 queued에 고정되지 않음. 서버 역전/정상 모두에서 `postprocess.run` → succeeded 표시 |
| B | 문서·주석: GetTrace events는 **오래된 순**, 완료는 **status/last_event**; `postprocess.run`은 여러 줄 | 서버 계약과 UI 가정을 맞춤 |
| C | (선택) path용으로 run 계열은 첫 출현만 두되, **live/done 판정은 lastEvent·status 우선** — 이미 상당 부분 있음. A와 중복되지 않게 visual만 A로 정리 | 점등과 상세 문구 일치 |
| D | 서버 수정 전·후 샘플(역전 / 정상) fixture로 테스트 | 회귀 방지 |

### 비권장

- 클라이언트에서 `at`으로 events를 전역 재정렬해 path를 다시 짜기 (서버 계약·중복 name와 충돌, 복잡)
- `done.stored`가 events 중간에 있으면 status를 RUNNING으로 되돌리기 (서버 status가 진실)
- 서버 수정 전에만 쓰는 임시 보정 플래그를 장기간 유지

### 구현 시 힌트 (A안)

`postprocess.run` / `tool.run`처럼 **같은 name가 여러 status로 쌓이는 이벤트**:

- 매칭: 앞에서 끊지 말고 **마지막 줄** (또는 `succeeded`/`failed`/`canceled`가 있으면 그 줄 우선)
- 그 외 단발 name: 첫 줄 또는 유일 줄

완료 Trace(`status == done`)이고 `lastEvent`가 `done.*`이면, path·점등은 현행대로 lastEvent/stage 추론을 우선해도 된다.

---

## 5. As-Is / To-Be 요약

| | As-Is | To-Be |
|--|-------|--------|
| 서버 기록 | done 먼저 → succeeded (역전 가능) | succeeded → done.stored |
| 클라이언트 완료 | status / lastEvent | **유지** |
| path | name 최초 출현 순 | **유지** (서버 순서 수정으로 타임라인 자연스러워짐) |
| run 노드 상세/visual | name **첫** 줄 (queued 고착 가능) | name **마지막(또는 종결 status)** 줄 |
| 구 역전 데이터 | 표시만 어색 | A안으로 상세는 succeeded 쪽으로, 완료는 status |

---

## 6. 검증

서버 수정 후:

- [ ] 신규 업로드 GetTrace: `postprocess.run` succeeded의 `at` ≤ `done.stored`의 `at`, 배열에서도 succeeded가 앞
- [ ] `status=DONE`, `lastEvent=done.stored|done.searchable`
- [ ] 대시보드: 목록 OK, 선택 path에 done 노드, 미선택 합산 점등 유지

클라이언트 A안 적용 시:

- [ ] 완료 Trace에서 `postprocess.run` 노드 탭 → status `succeeded`(또는 failed) 표시
- [ ] RUNNING 중 queued/running 줄만 있을 때는 그 상태가 보임

---

## 7. 결론

- **원인**: 서버가 Trace 완료(`done.stored`)를 run `succeeded`보다 먼저 남겨 이벤트 순서가 뒤집힐 수 있음. 제공 샘플은 정상 순서에 가깝고, `status`/`lastEvent`는 이미 완료로 맞음.
- **서버**: succeeded → done 순 수정이 근본 해결.
- **클라이언트**: 완료 판정은 지금처럼 status/lastEvent를 고수하고, **같은 name 다중 줄(특히 `postprocess.run`)은 마지막·종결 status를 쓰도록** 맞추면 서버 수정 전후·구 데이터에서도 표시가 안정된다.
