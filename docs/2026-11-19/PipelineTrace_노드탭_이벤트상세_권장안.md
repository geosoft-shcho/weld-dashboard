# (2026-11-19) PipelineTraceGraph 노드 탭 → 이벤트 상세 권장안

| 항목 | 내용 |
|------|------|
| 화면 | 수집 모니터링 · 적재 파이프라인 · `PipelineTraceGraphView` |
| 질문 | 노드 탭으로 “근처 여정 하나 집어 선택”이 어색하다. 노드 상세를 읽을 수 있는가? 대안은? |
| 결론 | **노드 단위 GetTrace/노드 API는 없다.** 상세는 **선택된 Trace의 `events`에서 같은 `name`인 줄**로 읽는다. 탭은 여정 선택이 아니라 **그 이벤트 요약 표시**로 바꾼다. |

---

## 1. 상세를 읽을 수 있는가

### 계약 (proto)

`GetTrace` → `Trace` + `repeated TraceEvent`.  
이벤트에 `name`, `status`, `run_id`, `detail`(Struct), `error_*`, `at`가 있다.  
**노드(그래프 정점) 전용 RPC는 없다.** 여정 단위다.

### 앱 도메인 (지금)

`TraceEventSnapshot`에 매핑된 것:

| 필드 | 있음 |
|------|------|
| `name` | O |
| `status` | O |
| `errorMessage` | O |
| `runId` | O |
| `at` | O |
| `detail` (Struct) | **X** (매퍼가 버림) |

선택·enrich된 Trace면 **노드 ID = event.name**으로 매칭해 위 필드를 읽을 수 있다.  
Struct `detail`(queue·clip_ids 등)은 **추가 매핑 없이는 불가** → 이번 범위 밖.

### 미선택일 때

`visibleTraces`만으로는 “이 노드의 상세”가 Trace마다 다를 수 있다.  
지금 `_selectNear`는 lastEvent가 비슷한 **첫 Trace를 임의 선택**한다 → UX가 어색한 원인.

---

## 2. As-Is / To-Be

| | As-Is | To-Be (권장) |
|--|-------|--------------|
| 노드 탭 | `_selectNear` → 근처 Trace `didSelectTrace` | **여정 선택 안 함** |
| 여정 선택 | 목록(+노드 탭 부작용) | **목록만** (`didSelectTrace` / GetTrace 유지) |
| 노드 탭 결과 | 그래프가 다른 여정 path로 바뀜 | **포커스 노드의 이벤트 요약** (선택 Trace 기준) |
| 미선택 + 노드 탭 | 목록 첫/근처 Trace 강제 선택 | 안내: 목록에서 여정 선택 후 노드를 탭 |
| Struct detail | 없음 | 이번 작업에서 매핑하지 않음 |

---

## 3. 권장 규칙

1. **`_selectNear` 제거.** 노드 탭이 GetTrace/선택을 유발하지 않는다.
2. 노드 탭 → 로컬 `_focusedNodeId` (같은 노드 재탭 시 해제).
3. 그래프 하단(또는 인접)에 요약 스트립:
   - **선택 있음 + events에 name 일치**: 라벨·status·at·runId·errorMessage
   - **선택 있음 + 일치 없음**: “이 여정에 이 이벤트 기록이 없습니다.”
   - **선택 없음**: “목록에서 여정을 선택하면 이 노드 이벤트를 볼 수 있습니다.”
4. 목록 선택·GetTrace·path 합집합/선택 path 로직은 유지.
5. `detail` Struct·새 패널 화면·새 ViewModel 필드는 만들지 않는다.

---

## 4. 비권장

- 노드 탭으로 “비슷한 단계 Trace”를 자동 선택
- 노드마다 별도 RPC
- 이번 작업에서 proto `detail` 전체 JSON UI

---

## 5. 구현

프롬프트: `docs/2026-11-19/PipelineTrace_노드탭_이벤트상세_프롬프트.md`
