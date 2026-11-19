# (2026-11-19) PipelineTraceList 선택 → GetTrace → 그래프 반영 권장안

| 항목 | 내용 |
|------|------|
| 화면 | 수집 모니터링 · 적재 파이프라인 |
| 질문 | 목록 선택 시 GetTrace를 치고, 그 결과로 `PipelineTraceGraphView` path/상태를 그리는 것이 맞는가? |
| 결론 | **맞다. 권장.** |

---

## 1. 문제

그래프의 path 활성·노드 상태는 `selected.events`(+ `lastEvent`)에 의존한다.  
지금은 목록 클릭 시 `_traces`에 이미 `events`가 있으면 **GetTrace를 건너뛴다**.

그래서:

- DONE/FAILED인데 폴링 enrich를 한 번도 안 받은 행 → events 없음 → 클릭 때만 GetTrace (여기까지는 OK)
- 예전에 RUNNING enrich로 남은 **옛 events 캐시**가 있으면 → 클릭해도 GetTrace 안 함 → 그래프가 최신 여정과 어긋날 수 있음
- ListTraces 요약(`lastEvent`)만으로 추론한 표시와, GetTrace 전체 이벤트 path가 다를 수 있음

사용자는 “이 여정을 골랐다 = 그 여정의 서버 상세로 그래프를 본다”를 기대한다.

---

## 2. As-Is / To-Be

| | As-Is | To-Be (권장) |
|--|-------|--------------|
| 목록 선택 | events 캐시 있으면 GetTrace 생략 | **항상 GetTrace** |
| 그래프 `selected` | 캐시 또는 GetTrace | **GetTrace 응답** |
| 폴링 enrich | RUNNING + 선택 ID GetTrace | 유지 (실시간 갱신) |
| 같은 행 재클릭 | no-op | 유지 (중복 요청 방지) |

---

## 3. 권장 규칙

1. **`didSelectTrace`**: 선택이 바뀌면 반드시 `GetTrace(traceId)`. preloaded 스킵 제거.
2. GetTrace 성공 시 `_selected`를 상세로 두고, 같은 id의 `_traces` 항목도 상세로 바꿔 목록·그래프가 같은 events를 본다.
3. **`PipelineTraceGraphView`**: 기존처럼 `viewModel.selected`의 path/visual만 사용 (추가 API 없음).
4. 폴링 `refresh`의 RUNNING(+선택) enrich는 유지. 선택 중 여정은 폴링마다 최신 events로 그래프가 갱신된다.
5. GetTrace 실패 시: 선택 해제 또는 목록 요약만 유지하는 현행 `_loadSelection` catch 정책을 유지하되, 캐시 events로 “성공한 척” 하지 않는다.

---

## 4. 비권장

- 클릭 시 ListTraces/`lastEvent`만으로 path를 확정하는 것
- events 캐시가 있으면 GetTrace를 영구 생략하는 것

---

## 5. 구현

프롬프트: `docs/2026-11-19/PipelineTrace_선택시_GetTrace_프롬프트.md`
