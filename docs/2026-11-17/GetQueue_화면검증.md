# (2026-11-19) GetQueue 화면 검증 방법

| 항목 | 값 |
|------|-----|
| 근거 | [`README.md`](./README.md) §3 GetQueue · §2 `wait` · §4 Trace `run.queue` |
| API | `mediatag.run.v1.RunService/GetQueue` |
| 화면 | 수집 모니터링 → 탭 **적재 파이프라인** |
| 구현 | 폴링마다 GetQueue. 포커스 queue(선택 또는 RUNNING+queue) 우선, 없으면 **`postprocess` 기본** → **대기열 앞줄** 고정 표시 |
| 관련 코드 | `PipelineTraceViewModel` · `pipeline_trace_list.dart` · `pipeline_trace_tab_body.dart` `_QueueFrontPanel` |

이 문서는 **지금 앱에서 손으로 검증하는 절차**다. 코드를 고치지 않는다.

---

## 1. 화면에서 무엇이 보이는지

```text
[적재 파이프라인]
  단계 칩 · 가로 스테퍼
  여정 목록 (최근 80건)
    RUN #7 file.mp4   postprocess.run · 후처리 · 앞 1건   ← lastEvent 원문 + wait
  ┌─ 선택 시(선택 요약) ──────────────────┐
  │ 파일명 · lastEvent · queueWaitLabel     │
  └───────────────────────────────────────┘
  ┌ 대기열 앞줄 (클릭 없이도) ────────────┐
  │ 후처리 · 워커 N · 진행 N · 대기 N      │  ← GetQueue 매칭 결과
  │ ● run 91 · queued · …                 │  ← ● = 포커스 run
  │ ○ run 90 · queued · …                 │
  └───────────────────────────────────────┘
```

| UI | 데이터 출처 |
|----|-------------|
| 목록 오른쪽 `postprocess.* · 후처리 · 앞 N건` | Trace `lastEvent` 원문 + `run.wait` → `queueWaitLabel` |
| 선택 요약 한 줄 | 선택한 Trace의 파일명 · lastEvent · wait |
| **대기열 앞줄** 제목(워커/진행/대기) | GetQueue의 매칭된 `queues[]` 항목 |
| 앞줄 run 목록 | 그 항목의 `runs`(오래된 순) |
| `N초 대기` | `now - run.created_at` (전용 대기시간 필드 없음) |

**GetQueue를 치는 조건**

1. 선택한 Trace에 `run.queue`가 있으면 그 이름.
2. 아니면 목록에서 **RUNNING** 이고 `run.queue`가 비어 있지 않은 **첫 줄**의 queue.
3. 둘 다 없으면 기본 **`postprocess`**. 유휴(`workers`만 있고 runs 없음)여도 앞줄을 유지한다.
4. `postprocess.*`가 빨리 끝나도 앞줄 박스는 **접히지 않는다**.

---

## 2. 검증 준비

1. 서버가 **RunService** 배포본인지 확인한다 (`ToolService/GetQueue`는 404).
2. 앱: 수집 모니터링 → **적재 파이프라인** 탭.
3. 커맨드바 **새로고침 주기**를 `1초` 또는 `5초`로 둔다.
4. (권장) Chrome DevTools → Network에서 `GetQueue` / `GetTrace` / `ListTraces`를 필터한다.

---

## 3. 시나리오별 검증

### A. 미선택 + queue 줄 없음 — 기본 postprocess 앞줄

1. 목록에 RUNNING+`run.queue` 줄이 **없고**, 아무 여정도 고르지 않는다.
2. Network를 본다.
3. **통과:** 폴링에 **`RunService/GetQueue`**가 나간다.
4. **통과:** 하단에 「대기열 앞줄」이 보인다. 유휴면 `후처리 · 워커 N · 진행 0 · 대기 0` +「대기열에 run이 없습니다.」.

---

### A2. 미선택 + 후처리 진행 줄 — 클릭 없이 앞줄·●

1. 목록에 `postprocess.* · 후처리 · 앞 N건`(또는 wait 문구)이 보이는 **진행 중** 줄이 있다.
2. **여정을 클릭하지 않는다.**
3. **통과:** 목록 오른쪽에 `lastEvent` **원문**(`postprocess.run` 등)과 wait가 보인다.
4. **통과:** **대기열 앞줄**이 보이고 ●는 그 첫 RUNNING+queue 줄의 `run.runId`와 같다.

---

### B. 선택했지만 queue 없음 — 기본 postprocess 앞줄 유지

1. 목록에 RUNNING+`run.queue` 줄이 없는 상태에서, `run`이 없거나 `queue`가 빈 **완료(DONE)** 여정을 고른다.
2. **통과:** 파일명 · lastEvent 한 줄은 보일 수 있다.
3. **통과:** 「대기열 앞줄」은 **기본 postprocess**로 **유지**된다(유휴 문구 가능).

---

### C. 후처리 대기 — 정상 앞줄 (핵심)

**만드는 법:** 파일을 **여러 개** 연속 업로드해 후처리 대기열을 쌓는다.

1. 목록에서 `lastEvent`가 `postprocess.*`이고 wait(`후처리 · 앞 N건` 등)가 **같은 줄에** 보이는지 확인한다(클릭 전).
2. (선택) 그 줄을 고르면 요약 한 줄에도 wait가 보인다.
3. **대기열 앞줄** 박스를 본다(클릭 없이도 이미 있을 수 있음).

**통과 기준**

| 확인 | 기대 |
|------|------|
| 목록 | `postprocess.*` 원문 + `후처리 · 앞 N건`(또는 자리 없음 등) |
| Network | 폴링(또는 선택) 시 **`RunService/GetQueue`** 1회 이상 |
| 응답 | body에 `queues[]` (옛 `workers_by_queue` 없음) |
| 제목 | `후처리 · 워커 … · 진행 … · 대기 …` (`postprocess` → 후처리) |
| 목록(앞줄) | `○/● run {id} · queued/running · …` 오래된 것이 위 |
| 내 run | 포커스 Trace `run.runId`와 같은 줄이 **●** 이고 색/굵기 강조 |
| wait 일치 | 목록/요약의 「앞 N건」≈ 내 run보다 **위에 있는 queued 수** |
| 대기 시간 | `created_at` 있으면 `N초 대기` / `N분 대기` |

4. DevTools에서 GetQueue JSON을 연다 → `queue == "postprocess"` 항목의 `runs` 순서·id가 화면과 같은지 대조한다.

---

### D. 폴링 중 앞줄이 같이 움직이는지

1. 시나리오 C(또는 A2) 상태를 유지한 채 10~20초 본다.
2. **통과:** 새로고침 주기마다(포커스 queue가 유지되면) `GetQueue`가 다시 호출된다.
3. **통과:** 앞줄에서 앞 run이 빠지거나 `running`으로 바뀌고, 목록의 「앞 N건」도 줄어든다.
4. **통과:** 해당 run이 끝나면 ● 강조가 사라지거나 여정이 완료로 바뀌고, **앞줄 박스는 유휴 상태로 유지**된다(접히지 않음).

---

### E. 대기열 이름 없음

1. (스테이징에서) `run.queue`가 GetQueue `queues`에 없는 이름인 경우를 만들거나 목으로 확인한다.
2. **통과:** 앞줄 박스 제목은 「대기열 앞줄」 또는 유사, 본문에 **`같은 이름의 대기열이 없습니다.`**
3. **통과:** 다른 대기열의 runs를 **잘못 보여 주지 않는다**.
4. **통과:** 목록/요약의 `queueWaitLabel`은 그대로 남을 수 있다.

---

### F. GetQueue 실패

1. 네트워크 차단·서버 5xx 등으로 GetQueue만 실패시킨다(RUNNING+queue 또는 선택+queue 상태).
2. **통과:** 빨간 글씨 **`대기열을 불러오지 못했습니다.`**
3. **통과:** 목록/요약의 wait 문구(`후처리 · 앞 N건` 등)는 **유지**된다.
4. **통과:** 잘못된 빈 runs를 성공처럼 그리지 않는다.

---

### G. 선택 해제

1. 앞줄이 보이는 상태에서 선택을 해제한다.
2. **통과:** 앞줄·GetQueue는 **유지**된다(RUNNING+queue면 그 포커스, 없으면 기본 postprocess).

---

### H. wait.reason 문구 (여건 될 때)

목록/요약의 `queueWaitLabel`만 보면 된다. 앞줄과 모순되면 실패.

| 서버 `wait.reason` | 화면에 보여야 할 말 |
|--------------------|---------------------|
| `QUEUE_AHEAD` | `앞 N건` 또는 `대기열` |
| `WORKERS_BUSY` | `자리 없음` |
| `RETRY` | `재시도 대기` |
| `DISPATCH_OFF` | `디스패치 꺼짐` |

`WORKERS_BUSY`일 때 GetQueue 해당 queue의 `running` ≈ `workers`, `waiting`이 작으면 앞줄 runs가 거의 running만 있어도 정상일 수 있다.

---

### I. API 계약 스모크 (Network 한 번)

적재 파이프라인 폴링에서 GetQueue가 나간 응답을 연다.

- [ ] 경로에 `RunService` / `GetQueue` (ToolService 아님)
- [ ] 최상위 `queues` 배열
- [ ] 유휴여도 `postprocess` · `work` 키가 올 수 있음(서버 규칙)
- [ ] 외부 주소형 queue는 run 있을 때만 출현할 수 있음
- [ ] 각 항목: `queue`, `workers`, `running`, `waiting`, `runs`

---

## 4. 한 장 체크리스트

- [ ] 미선택 + queue 줄 없음 → GetQueue · 기본 postprocess 앞줄(유휴 가능)
- [ ] 미선택 + 목록에 `postprocess.* · 후처리 · 앞 N건` → 클릭 없이 앞줄·●
- [ ] queue 없는 선택이어도 기본 postprocess 앞줄 유지
- [ ] queue 있는 선택 → 그 queue · 「후처리 · 워커…」· runs 목록
- [ ] 내/포커스 run이 ● 강조(없으면 전부 ○)
- [ ] 목록 wait와 앞줄 순서가 맞음
- [ ] 폴링 시 앞줄이 갱신됨 · postprocess 빨리 끝나도 패널 유지
- [ ] 이름 없음 → `같은 이름의 대기열이 없습니다.`
- [ ] GetQueue 실패 → 빨간 안내 + wait 유지
- [ ] 선택 해제 후에도 앞줄 유지

---

## 5. 실패 시 볼 곳

| 증상 | 의심 |
|------|------|
| 목록에 wait가 안 보임 | ListTraces/GetTrace에 `run`·`wait` 없음 · 목록 UI가 wait를 안 그림 |
| 클릭해도/안 해도 앞줄이 안 나옴 | GetQueue 실패 · `doesShowQueueFront`/패널 조건 · 핫 리로드 미반영 |
| GetQueue 404 | ToolService 경로 · 구서버 |
| 앞줄이 항상 비어 있음 | `queue` 이름 불일치 · 매칭 실패 문구 확인 |
| wait는 있는데 앞줄 에러 | GetQueue만 실패 — 네트워크/권한 |
| 내 run이 ○만 있음 | Trace `run.runId`와 GetQueue `runs[].runId` 불일치 |

---

## 6. 참고

- 가이드: [`README.md`](./README.md)
- 연동 프롬프트: [`docs/2026-11-19/GetQueue_파이프라인연동_프롬프트.md`](../2026-11-19/GetQueue_파이프라인연동_프롬프트.md)
- 무클릭 표시 프롬프트: [`docs/2026-11-19/GetQueue_무클릭표시_프롬프트.md`](../2026-11-19/GetQueue_무클릭표시_프롬프트.md)
- 앞줄 고정 표시 프롬프트: [`docs/2026-11-19/GetQueue_앞줄고정표시_프롬프트.md`](../2026-11-19/GetQueue_앞줄고정표시_프롬프트.md)
- 단위 테스트: `test/pipeline_trace_view_model_get_queue_test.dart`
