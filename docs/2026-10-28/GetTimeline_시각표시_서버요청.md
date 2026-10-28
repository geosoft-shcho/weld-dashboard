# 서버 요청 — `{현재 T} | {타임라인 끝}` 표시를 위한 GetTimeline

요청 측: weld-dashboard (멀티모달 타임라인 보드)  
대상: `MediaComposeService.GetTimeline` (`mediatag.compose.v1`)  
화면 표시: 보드 헤더 `{현재 T} | {타임라인 끝}` (가이드 §8 `T 00:28 / 00:55`와 동일 축)  
관련 proto: `protos/mediatag/compose/v1/compose.proto`  
관련 가이드: `docs/2026-10-19/타임라인 그리기와 재생 안내.md` §1·§2·§6·§8

---

## 1. 배경

화면은 GetTimeline이 주는 **타임라인 축**만으로 현재 바늘과 전체 끝을 보여 주려 한다.

- 축 원점: proto 공통 규칙 — **0 = `job.started_at`**
- 클립 위치: `Clip.timeline_start_ns` · `timeline_end_ns`
- 가이드 §2: 타임라인 전체 길이 = **모든 클립 `timeline_end_ns` 중 최댓값** (영상 하나의 `duration` 아님)

지금은 클라이언트가 응답 클립을 훑어 `max(timeline_end_ns)`를 만들고, 재생 중 `T`는 로컬 playhead다.  
표시가 서버·가이드와 어긋나지 않게 **계약 확인**과, 가능하면 **응답에 끝·원점 메타를 명시**해 달라고 요청한다.

---

## 2. 요청 목적

1. `{현재 T}` · `{타임라인 끝}`이 같은 축(작업 시작 기준 ns)임을 서버와 화면이 공유한다.
2. 클립이 없을 때·패스로 열 때·시점 태그(`start = end`)만 있을 때 **끝 시각을 무엇으로 둘지**를 서버가 정하거나 문서화한다.
3. 절대시각(`job.started_at + T`)이 필요할 때 GetTimeline만으로도 원점을 알 수 있게 한다(선택).

---

## 3. 계약 확인 요청 (API 변경 없이 먼저)

아래를 서버 문서/응답 주석에 확정해 달라.

| # | 항목 | 화면 가정 | 확인 요청 |
| --- | --- | --- | --- |
| C1 | 시간 원점 | `timeline_*_ns`의 0 = 해당 job의 `started_at` | proto 주석과 동일하게 유지·명시 |
| C2 | job 전체 열기(`pass_id` 없음)의 **타임라인 끝** | `max(clips[].timeline_end_ns)` (구간은 `[start, end)`) | 가이드 §2와 동일한지. `Job.ended_at`과의 관계(끝이 다르면 어느 쪽을 UI “전체”로 쓰는지) |
| C3 | 클립 0개 draft | 지금 화면은 임의 폴백(예: 60초). 서버 권장 끝이 있는지 | `0` / 비움 / 최소 span 정책 |
| C4 | kind=tag 시점 (`start_ns = end_ns`) | max 계산에 **포함** | 시점만 있는 타임라인에서 끝이 그 시각이 되는지 |
| C5 | `pass_id` 응답 | `window_start_ns`·`window_end_ns` = 패스 구간(같은 job 축). 클립은 창과 겹치는 것만 | **표시용 `T`는 계속 job 축(0=started_at)** 인지, 창 상대인지. 보드 “끝” 라벨을 `window_end`로 쓸지 `max(clip ends)`로 쓸지 |
| C6 | 잘린 응답 | GetTimeline은 페이지 없이 해당 범위 클립 전부 | “전체 끝”이 응답에 안 들어온 클립 때문에 짧아지지 않는지(패스 필터 제외) |

---

## 4. API 보강 요청 (권장)

화면이 매번 max를 다시 만들지 않고, 원점·끝을 한곳에서 읽도록 **`GetTimelineResponse`에 읽기 전용 필드를 추가**해 달라.

### 4.1 필수에 가깝게 (표시·클램프에 직접 사용)

```text
GetTimelineResponse {
  ...
  // 읽기 전용. 이 응답 기준 타임라인 축에서의 “끝”(ns).
  // job 전체: 권장 = max(clips.timeline_end_ns). 클립 없으면 0 또는 문서화된 기본값.
  // pass_id 있음: 권장 = window_end_ns (창 끝). window와 max(clip)이 다르면 주석으로 어느 필드를 UI “끝”에 쓰는지 명시.
  optional int64 timeline_end_ns = ?;

  // (선택) 창이 있을 때와 구분하려면 이름을 나누어도 됨:
  // optional int64 content_end_ns = ?;  // max(clip ends), pass여도 “내용 끝”
}
```

**사용처 (화면)**  
- `{타임라인 끝}` 라벨 = `timeline_end_ns`  
- playhead `T` clamp·재생 종료 = 같은 값  
- 보드 가로 span = 같은 값 (패스면 window 길이/끝과 일치)

### 4.2 권장 (절대시각·툴팁)

```text
GetTimelineResponse {
  ...
  // 읽기 전용. 이 타임라인 축 0에 해당하는 절대시각 = Job.started_at
  google.protobuf.Timestamp job_started_at = ?;
}
```

**사용처**  
- 보조 표시: `job_started_at + T`  
- 화면이 Job API를 한 번 더 치지 않아도 “0의 의미”를 툴팁/디버그에 표시

`Job.ended_at`을 UI 끝에 쓰고 싶다면 동일하게 `job_ended_at` 또는 `job_ended_at` 기준 ns(`ended_at − started_at`)를 줄지 **C2와 함께** 정해 달라.  
클립 max와 job 종료가 다르면 **보드 “타임라인 끝” 정의 한 줄**이 필요하다.

### 4.3 이미 있는 필드 — 유지·매핑만

| 필드 | 요청 |
| --- | --- |
| `window_start_ns` / `window_end_ns` | pass 열 때 채움 유지. 화면이 줌/초기 스크롤에 사용. **job 축 ns**임을 주석에 고정 |
| `Clip.timeline_start_ns` / `timeline_end_ns` | 필수 구간 유지. 클라이언트 playhead·클립 배치의 근거 |

---

## 5. 하지 말아 달라는 것

- 타임라인 끝을 **특정 영상 Asset.duration**이나 파일 `duration`으로 정의하지 말 것.
- `{현재 T}`를 서버가 저장·반환할 필요는 없음. `T`는 화면 재생 시계(세션). 서버는 **축·끝·원점**만.
- 고정 fps·프레임 번호로 보드 시계를 대체하지 말 것(가이드 §6).

---

## 6. 수락 기준 (서버)

- [ ] C1–C6이 proto 주석 또는 공개 안내 문서에 반영됨.
- [ ] (보강 시) `GetTimeline` 응답에 `timeline_end_ns`(또는 동등)가 채워지고, 클립 max / pass window와 문서가 일치함.
- [ ] (보강 시) `job_started_at`이 채워지거나, “GetTimeline만으로 원점 불가 — Job API 사용”이 명시됨.
- [ ] 빈 draft·시점 태그만 있는 job·pass 필터 각각에 대해 예시 응답 1건씩(끝 필드 값 포함).

---

## 7. 화면 측 (참고 — 서버 작업 범위 밖)

- `{현재 T}`: 로컬 playhead, 축은 GetTimeline과 동일(0 = job.started_at).
- 서버가 `timeline_end_ns`를 주기 전까지는 현행대로 `max(clip.timeline_end_ns)` 폴백.
- pass 진입 시 `pass_id` + `window_*` 매핑은 앱 미연결이면 별도 프론트 작업.

---

## 8. 한 줄 요약

**확인:** 타임라인 끝 = (job 전체) max `timeline_end_ns`, 원점 = `job.started_at`.  
**추가 권장:** `GetTimelineResponse.timeline_end_ns` + `job_started_at`으로 `{T} | {끝}`과 절대시각을 응답만으로 맞출 수 있게 해 달라.
