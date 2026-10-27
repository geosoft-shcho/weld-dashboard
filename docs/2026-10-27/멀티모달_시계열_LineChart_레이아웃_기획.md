# (2026-10-27) 멀티모달 — 센서 시계열 LineChart 화면 레이아웃 기획

| 항목 | 내용 |
| --- | --- |
| PM | — |
| 개발 담당 | weld-dashboard |
| 리뷰어 | — |
| 관련 | `GetTimeline`, `CLIP_KIND_TIMESERIES`, `MultimodalTimelineBoard` |
| 갱신 | 트랙·클립 **영역 안 대치** + 기존 **토글** UX 반영 |

---

## 1. 문제 / 목표

타임라인 보드에서 `CLIP_KIND_TIMESERIES`(전류·전압·속도)는 짧은 클립 바(높이 ~20px, 레인 28px)만 보인다.  
상단 모니터 스테이지는 영상 전용이라, **보드의 트랙·클립 자리 자체에서** 파형을 대조할 수 없다.

목표:

1. 트랙 또는 클립 **선택 시**, LineChart가 **그 트랙·클립이 쓰던 영역만큼** 자리를 차지해 대치된다.
2. 펼침/접힘은 보드에 이미 있는 **토글** 패턴(레인 보이기, 모니터 카메라)과 같은 조작 언어를 쓴다.
3. 같은 작업 시각(플레이헤드) 기준으로 차트 커서와 보드가 맞는다.

이 문서는 레이아웃·판별·토글 기획이다. 샘플 CSV 로더 확정·위젯 구현은 다음 작업.

---

## 2. As-Is (토글·선택 참고)

```
[ PageToolbar ]
[ MultimodalVideoStage ]          ← 변경 없음(1차). 영상 모니터 유지
[ MultimodalTimelineBoard ]
    툴바 · Lanes 메뉴 · 상태(초안/제안/…)
    [ 트랙 라벨 | 레인·클립 바 ]
```

| 기존 토글 | 위치 | 동작 | LineChart에 빌려 쓸 점 |
| --- | --- | --- | --- |
| **레인 보이기** | Lanes 메뉴 `didTapToggleLaneKey` + 체크박스 | `_hiddenLaneKeys` — 행 자체 show/hide | 「차트 펼침」도 **트랙 단위 on/off**로 같은 토글 느낌 |
| **모니터** | 트랙 라벨 `videocam` / `videocam_outlined` → `didTapMonitorTrack` | 스테이지 그리드 최대 4 | 시계열은 스테이지가 아니라 **보드 행 펼침**. 아이콘만 차트용으로 병행 가능 |
| **사이드** | Assets / Properties / Ask / Labels | `_toggleSide` — 같은 버튼 재누르면 닫힘 | 차트도 **선택·토글 재누르면 접힘**(바 모드 복귀) |
| **재생** | `didTapTogglePlayback` | play/pause | 차트 `selectedTimeMs`만 플레이헤드 추종 |
| 선택 | `_selectedClipId`, 트랙 라벨/클립 탭 | 하이라이트·속성 | TIMESERIES면 **선택 = 펼침 트리거**(기본안) |

레인 높이: `TIMELINE_TRACK_LANE_HEIGHT = 28` × `laneCount`. 클립 바 높이 20.

---

## 3. 핵심 원칙 — 「영역 안 대치」

**차트를 스테이지·드로어·사이드에 새로 두지 않는다.**  
선택(또는 차트 토글 on)된 TIMESERIES **트랙 행** 또는 **클립 구간**이 쓰던 보드 자리를, 같은 가로 시간축 위에서 LineChart 높이로 **키워 바꾼다**.

```
접힘(기본 바):
  [라벨 videocam?  swatch  이름] | ====클립바====     height ≈ 28

펼침(차트 대치):
  [라벨 📊토글 on   이름     ] | ┌─────────────────────────┐
                               | │ 전류 LineChart           │  ← 클립 timeline 구간
                               | │ 전압                     │     가로폭 = 바 left~width
                               | │ 속도 (rpm 접기 가능)     │     행 높이 = 차트 예산
                               | └─────────────────────────┘
```

- **가로:** 클립의 `timeline_start_ns~end_ns` → 기존과 같이 `pixelsPerSecond`로 left/width. 차트 X축은 이 구간에 맞춤(보드 스크롤·줌과 동일).
- **세로:** 해당 행 `height`를 바(28)에서 차트 스택 예산(예: 채널당 ~72~96 + 간격)으로 올린다. 라벨 열도 **같은 row.height**를 쓴다(지금 `_trackLabel` / `_track`이 `row.height` 공유).
- **대치:** 펼친 동안 그 구간의 짧은 색 바는 그리지 않거나 차트 테두리만 남긴다. 같은 자리의 UI가 바→차트로 바뀌는 것이 핵심.
- **다른 트랙:** 높이 불변. 보드 세로 스크롤만 늘어남.

### 트랙 선택 vs 클립 선택

| 선택 | 대치 범위 |
| --- | --- |
| **TIMESERIES 클립** 선택 | 그 클립의 시간 폭·그 줄(laneIndex)만 차트. 같은 트랙의 다른 클립 바는 유지 |
| **트랙** 선택(라벨 탭 → 대표 클립)이면서 트랙에 TIMESERIES만 / 활성 클립이 TIMESERIES | 위와 동일하게 **활성·선택 클립** 구간 대치. 트랙 전체 전폭 차트는 하지 않음(빈 구간은 배경만) |
| 트랙에 TIMESERIES 여러 개 | **선택된 클립 하나**만 펼침(1차). 동시 다펼침은 높이 폭주 → 후속 |

「제안」(`TIMELINE_STATUS_SUGGESTED` / `provenance`): 펼침 게이트가 아님. 펼친 차트 헤더에 confidence·reviewed 배지만.

---

## 4. 토글 설계 (기존 UX 정렬)

### 4.1 상태

```
chartExpandedClipId : String   // 비면 전원 접힘. 1차 단일 펼침
```

(트랙 단위로만 쓸 경우 `chartExpandedTrackId`도 가능하나, 대치 단위가 클립 구간이므로 **클립 id** 권장.)

### 4.2 켜짐 / 꺼짐

| 입력 | 결과 |
| --- | --- |
| TIMESERIES 클립 탭(선택) | `selectedClipId` 설정 + **자동 펼침** (`chartExpandedClipId = clipId`) |
| 이미 펼친 같은 클립 재탭 / 차트 토글 off | 접힘 → 바 복귀. 선택은 유지 가능 |
| 다른 TIMESERIES 클립 탭 | 이전 접고 새 클립 펼침 |
| VIDEO 등 다른 kind 선택 | 차트 접힘 |
| 트랙 라벨의 **차트 토글 아이콘** | 해당 트랙의 대표 TIMESERIES(선택 클립 또는 플레이헤드 덮는 클립) 펼침/접힘 — `didTapMonitorTrack`과 같은 **아이콘 토글** |
| Lanes 체크 해제 | 행 hide(기존). 펼침 상태도 사실상 안 보임 |

### 4.3 아이콘 배치 (모니터와 나란히)

트랙 라벨 행 (`_trackLabel` Row):

```
[ 모니터 videocam ] [ 차트 show_chart 토글 ] [ swatch ] [ AI? ] [ 이름 ] [ #id ]
```

| 아이콘 | 활성 | 비활성 | 노출 조건 |
| --- | --- | --- | --- |
| 모니터 | `videocam` | `videocam_outlined` | 서버 트랙(기존) |
| 차트 | `show_chart` 채움/강조 | outlined 또는 숨김 | 트랙에 TIMESERIES 클립 ≥ 1 |

차트 아이콘 탭 → `didTapToggleTimeseriesChart(trackId)` (이름 가칭).  
레인 메뉴 체크박스와 같이 **한 번 더 누르면 off**.

Lanes 메뉴에 「차트 펼침」항목을 넣지 않는다(1차). 행 로컬 토글 + 선택으로 충분.

---

## 5. 레이아웃 와이어

### 추천안 — 보드 행·클립 구간 인라인 대치

```
┌─ Stage (영상) ─────────────────────────────────────┐
│  모니터 그리드 — 변경 없음                          │
└────────────────────────────────────────────────────┘
┌─ TimelineBoard ────────────────────────────────────┐
│ [초안▼] … [Lanes] [▶]                              │
│ 트랙라벨          │ 눈금 · 플레이헤드               │
│ cam chart name    │ ████ VIDEO 바                   │  28px
│ cam chart* SENSOR │ ┌ current ──────────────────┐   │
│                   │ │ voltage                   │   │  ~220px
│                   │ │ speed                     │   │  (펼침 행)
│                   │ └───────────────────────────┘   │
│ cam      other    │ ████                            │  28px
└────────────────────────────────────────────────────┘
```

`chart*` = 해당 행 차트 토글 on. 차트 블록의 **왼쪽·너비** = 선택 TIMESERIES 클립의 바 geometry.

### 비교용으로 버린 안

| 안 | 요지 | 이번 요구와의 관계 |
| --- | --- | --- |
| 스테이지 슬롯 치환 | 모니터 칸에 차트 | 트랙·클립 **영역 안** 대치가 아님 → 비채택 |
| 보드 위 전폭 드로어 | 스테이지·보드 사이 패널 | 클립 자리를 빼앗지 않음 → 비채택 |
| 레인 sparkline만 | 바 안 미니선 | 대치·가독 부족 → 후속 |

---

## 6. 판별 기준

| 기준 | 차트 영역(펼침 가능)? | 근거 |
| --- | --- | --- |
| 클립 `kind == TIMESERIES` | **예** | ClipKind = 렌더러 |
| 트랙에 TIMESERIES 없음 | 차트 토글 숨김 | |
| 타임라인 status = SUGGESTED만 | 자동 펼침 **아니오** | status ≠ kind |
| provenance 있는 TIMESERIES | 펼침 가능 + 배지 | 제안 클립 |
| VIDEO와 같은 트랙·같은 시각 | 바는 kind별. 펼침은 TIMESERIES 클립만 | |

전류·전압·속도: kind로 UI 게이트. 채널 존재는 로드 후 `WaveformSeriesBundle`(GetTimeline에 샘플 없음).

---

## 7. 차트·시간·위젯

| 항목 | 기획 |
| --- | --- |
| 위젯 | `WaveformChannelCharts` 재사용. 펼침 행 안에 스크롤 가능 Column |
| QualityLink | 1차 `links: []` |
| Master/Beginner/Robot | 1차 실측 시리즈만 |
| `selectedTimeMs` | 플레이헤드 → 클립 구간 로컬 ms 선형 맵 |
| `onTimeTapMs` | 타임라인 seek (보드·스테이지 공통 시계) |
| 줌 | `pixelsPerSecond` 변경 시 차트 폭·X매핑 재계산 |
| 드래그 편집 | 펼침 중 좌우 리사이즈는 1차 **잠금** 또는 차트 상단 핸들만(오픈 이슈) |

높이 예산(초안): 채널 3(전류·전압·속도) × 72 + 간격 ≈ 240. rpm은 토글/후속.  
보드 `Expanded` 영역이 작으면 트랙 목록 스크롤로 펼침 행을 보이게 (`revealOffsetForObjectRow` 재사용).

---

## 8. 오픈 이슈 / 다음 구현

1. 샘플 소스: Asset `content_url` CSV vs `timeseries_normalize` vs 패스 파형 API.
2. 펼침 중 클립 옮기기·자르기 UX.
3. 여러 TIMESERIES 동시 펼침 허용 여부(높이).
4. 차트 토글 아이콘 vs 모니터만 두고 **선택만으로 자동 펼침**만 할지(둘 다 두는 것이 기본 추천).
5. 채널 3 vs 4(rpm).

체크리스트:

- [ ] `chartExpandedClipId` + `didTapToggleTimeseriesChart`
- [ ] 트랙 라벨에 차트 토글 아이콘(모니터 옆)
- [ ] TIMESERIES 선택 시 행 높이 확대 + 클립 자리 `WaveformChannelCharts` 대치
- [ ] 접힘 시 28px 바 복귀
- [ ] playhead ↔ 차트 커서
- [ ] 제안 배지(선택)
- [ ] 로딩·빈·에러 상태

---

## 9. 결정 요약

| 항목 | 결정 |
| --- | --- |
| 배치 | **타임라인 보드의 트랙·클립 영역 안**에 LineChart 대치(인라인 펼침) |
| 트리거 | 클립/트랙 선택 시 자동 펼침 + **차트 토글**(레인·모니터 토글과 동일 언어) |
| 스테이지 | 1차 변경 없음 |
| 위젯 | `WaveformChannelCharts` |
| 비범위 | 스테이지 치환, 전폭 드로어, proto 변경 |
