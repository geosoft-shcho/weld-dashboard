# (2026-11-19) 미선택 시 visibleTraces path 합집합 제거 권장안

| 항목 | 내용 |
|------|------|
| 화면 | 적재 파이프라인 · `PipelineTraceGraphView` 활성 연결선 |
| 질문 | 미선택일 때 `visibleTraces` path 합집합이 어색하다. 무엇을 쓸까? |
| 결론 | ~~미선택 = 활성 path 없음(골격만).~~ **철회·롤백됨.** 미선택 시 path 합집합 + 노드 합산 점등을 유지한다. 롤백: `PipelineTrace_미선택_골격만_롤백_프롬프트.md` |

---

## 1. 문제

활성 연결선이 미선택일 때 여러 Trace의 `events` path를 합친다.

- 여러 여정이 한 그래프에 겹쳐 “한 여정의 길”처럼 보인다
- DONE/FAILED는 events가 비는 경우가 많아 합집합이 불완전·들쭉날쭉하다
- 여정 선택은 목록(+GetTrace)으로 통일했는데, 미선택 path만 집계 규칙을 쓴다

연결선만 끄고 노드를 합산 점등하면, 미선택인데도 “지나온 길”처럼 보인다.  
**미선택 = 골격만**(회색 선 + idle 노드). 점등·path는 `selected` 한 건만.

---

## 2. As-Is / To-Be

| | As-Is | To-Be (권장) |
|--|-------|--------------|
| 미선택 활성 선 | visibleTraces path **합집합** | **없음** (회색 골격만) |
| 선택 활성 선 | `selected` path | 동일 (`selected` path) |
| 노드/단계 visual 미선택 | visibleTraces 합산 점등 | **전부 idle** |
| 목록 GetTrace | 유지 | 유지 |

---

## 3. 권장 규칙

1. `pipelineActivePathEdges` / `pipelineHighlightEdgeKeys`: `selected == null`이면 빈 결과. `traces` 합집합 분기 삭제.
2. `selected != null`이면 그 Trace의 path 연속 쌍만.
3. `pipelineNodeVisual` / `pipelineStageVisual` / `pipelineHighlightStageIds`: 미선택이면 idle/빈 목록.
4. UI는 골격 + active 레이어. 미선택이면 active 비고 노드는 idle.
5. 자동으로 첫 Trace를 고르거나 RUNNING만 합치는 우회는 하지 않는다.

추가 구현: `docs/2026-11-19/PipelineTrace_미선택_골격만_프롬프트.md`

---

## 4. 비권장

- 미선택 시 RUNNING path만 합치기 (여전히 “누구의 길인지” 불명)
- 미선택 시 lastEvent만으로 가짜 path 잇기

---

## 5. 구현

프롬프트: `docs/2026-11-19/PipelineTrace_미선택_path합집합제거_프롬프트.md`
