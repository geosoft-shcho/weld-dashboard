# 멀티모달 시계열 LineChart — 구현 가능 범위 + 구현 프롬프트

기준 기획: `docs/2026-10-27/멀티모달_시계열_LineChart_레이아웃_기획.md`

---

## 1. 구현 가능 범위 판정

### 판정 요약

| 구역 | 현재 앱으로 | 비고 |
| --- | --- | --- |
| 보드 인라인 펼침·바→차트 대치 | **가능** | `row.height`, `_track` / `_clip` Positioned, 라벨 동기 높이 |
| 선택 + 차트 토글(모니터·레인 패턴) | **가능** | `didTapMonitorTrack`, `didTapToggleLaneKey`, `_selectedClipId` |
| `WaveformChannelCharts` 배치 | **가능** | `links: []`, 단일 시리즈(`robot` 또는 master만 on) |
| kind 게이트 `TIMESERIES` | **가능** | `TimelineClipKind.timeseries` 매핑·라벨·색 이미 있음 |
| 플레이헤드 ↔ `selectedTimeMs` | **가능** | `playheadSeconds` + 클립 `startNs`/`endNs` 선형 맵 |
| Asset URL 확보 | **가능** | `GetTimeline(includeAssets: true)` → `TimelineClip.playbackUrl` |
| 실제 전류/전압/속도 점 로드 | **부분** | 패스 API·클립 CSV 파서 모두 **멀티모달 전용 유스케이스 없음** |
| 제안 confidence 숫자 배지 | **부분** | `showsToolBadge`(AI)만 있음. confidence/reviewed 미매핑 |
| 펼침 중 드래그 편집 | **보류** | 기획 오픈 이슈 — 1차 잠금 권장 |
| 스테이지 치환 / proto 변경 | **비범위** | 기획과 동일 |

**결론:** 레이아웃·토글·빈/로딩 차트 셸은 **지금 구현 가능**.  
실측 LineChart 곡선은 **데이터 경로를 새로 붙이거나**, 1차를 빈 시리즈+안내로 두고 2차에 로더를 넣는 분할이 현실적이다.

### 데이터 경로 (왜 부분인가)

| 후보 | 앱 현황 | 멀티모달 적합? |
| --- | --- | --- |
| `GetPassWaveform` / `LoadPassWaveformUseCase` | 패스 프로파일·품질용. `pass_id` 필수. 채널명 `current_a` 등 통일 | 클립에 `pass_id` 없음. 작업 타임라인 임의 TIMESERIES에 **직접 재사용 불가** |
| Asset `content_url` CSV | Asset 미리보기에 표용 `_parseCsv`만. `WaveformPoint` 변환 없음 | URL은 클립에 있음. **새 유스케이스**(HTTP 읽기 → 컬럼 매핑 → bundle) 필요. 원본 열 이름 불확실 |
| GetTimeline 본문 | 샘플 점 없음 | 차트 점 소스로 **불가** |

1차 구현 권장: UI + 토글 + 펼침 대치 + (시리즈 없으면 InfoBar 「파형 데이터 없음」).  
실곡선은 후속: `content_url` CSV → `WaveformSeriesBundle` 유스케이스(컬럼 가정 명시) 또는 서버에 클립/에셋 구간 파형 RPC가 생기면 교체.

### UI·상태 (가능 근거)

- 보드: `TIMELINE_TRACK_LANE_HEIGHT`(28), `TimelineBoardRow.height`, 클립 `Positioned(left, width)`.
- 모니터 아이콘 옆에 차트 토글 추가 여유(`_trackLabel` Row).
- 스테이지(`MultimodalVideoStage`) 손대지 않아도 기획 충족.
- `WaveformChannelCharts`는 core 위젯이라 presentation에서 재사용 가능.

---

## 2. 구현 프롬프트 (복사용)

```text
# 구현: 멀티모달 타임라인 — TIMESERIES 클립 인라인 LineChart

## 목적
기획 `docs/2026-10-27/멀티모달_시계열_LineChart_레이아웃_기획.md` 대로,
`CLIP_KIND_TIMESERIES` 트랙/클립을 보드 **행·클립 영역 안에서** `WaveformChannelCharts`로 대치해 보여 준다.
상단 `MultimodalVideoStage`는 변경하지 않는다.

## 필독
- 위 기획안 + `docs/2026-10-27/멀티모달_시계열_LineChart_구현가능범위_및_프롬프트.md` §1
- `multimodal_timeline_board.dart`, `timeline_board_helpers.dart`
- `video_multimodal_view_model.dart` (선택·모니터·레인 토글)
- `waveform_channel_charts.dart`, `WaveformSeriesBundle`
- `compose.proto` ClipKind TIMESERIES, GetTimeline
- README 목적: 같은 작업 시각 기준 멀티모달 가시화
- 구현 전 `.cursor/skills/apply-guidelines/SKILL.md`로 guidelines 레포를 워킹 트리 밖에서 읽고 폴더·이름 맞출 것. guidelines는 수정·커밋하지 말 것.

## 범위 (1차 — 반드시)

### ViewModel
- `chartExpandedClipId` (또는 동등). 동시에 펼침 1개.
- `didTapToggleTimeseriesChart(trackId)`: 트랙의 대표 TIMESERIES(선택 클립 또는 플레이헤드 덮는 TIMESERIES) 펼침/접힘. 재탭 off.
- TIMESERIES 클립 선택 시 자동 펼침. 다른 kind 선택·같은 클립 토글 off 시 접힘.
- `bool trackHasTimeseries(trackId)`, `bool isTimeseriesChartExpanded(clipId|trackId)`.
- 플레이헤드 → 펼친 클립 로컬 `selectedTimeMs` 환산 getter.
- `onTimeTapMs` → `didSeekToSeconds` (타임라인 공통 시계).
- 시리즈: 1차는 빈 `WaveformSeriesBundle` 또는 로드 스텁 + `timeseriesChartError` / loading 플래그. GetPassWaveform 무리 연결 금지(pass_id 없음).

### Board UI
- 트랙 라벨: 모니터 `videocam` 옆에 차트 토글(`show_chart`). TIMESERIES 있는 서버 트랙만.
- `chartExpandedClipId`에 해당하는 행: `row.height`를 차트 예산으로 확대(라벨·레인 동일). 예: 전류·전압·속도 3채널 기준 ~220–240.
- 해당 클립 Positioned 자리에 짧은 바 대신 차트 래퍼 배치(left/width = 기존 바 geometry, `pixelsPerSecond`).
- 접히면 28px 레인·바 복귀.
- 펼침 행이 보이도록 기존 `revealOffsetForObjectRow` 등 스크롤 보정.
- 펼침 중 해당 클립 수평 드래그 편집 1차 비활성.

### 차트 래퍼
- `WaveformChannelCharts(series:, links: const [], showMaster: false, showBeginner: false, showRobot: true, selectedTimeMs:, onTimeTapMs:, …)`
- QualityLink·Master/Beginner 비교·패스 레전드 금지.
- 로딩 ProgressBar / 빈·에러 InfoBar(보드 톤).

### 비범위 (1차)
- MultimodalVideoStage 치환, 전폭 드로어, 레인 sparkline
- proto 변경, GetPassWaveform 연결, confidence 숫자(AI 배지 기존 유지)
- 커밋/푸시(요청 없으면), manuals

## 범위 (2차 — 별도, 1차 후)
- Asset `content_url` CSV(또는 확정 RPC) → `WaveformPoint` 유스케이스. 컬럼은 `current_a`/`voltage_v`/`wire_feed_speed_mpm`/`rotation_speed_rpm` 가정 또는 매핑 테이블.
- Domain/Data에만 두고 ViewModel은 유스케이스만 호출.
- rpm 채널·제안 confidence 매핑은 여유 시.

## 완료 기준
- TIMESERIES 클립 선택 또는 차트 토글 시 그 클립 자리에 LineChart 영역이 바를 대체하고 행 높이가 늘어난다.
- 접으면 바·28px 복귀. 영상 스테이지 동작 회귀 없음.
- 플레이헤드 이동 시 차트 커서 연동; 차트 탭 시 시크.
- `flutter analyze` 해당 경로 치명 오류 없음.
- 실곡선 없어도 빈/에러 UI로 완결. 곡선은 2차.

## 구현 힌트
- 높이: `TimelineBoardRow`에 expanded 플래그/높이 override, 또는 helpers에서 expandedClipId 받아 height 계산.
- kind는 `viewModel`의 타임라인 클립에서 읽고, 보드 클립 모델에 kind를 실어 와도 됨.
- 기존 모니터·레인 토글 네이밍(`didTap…`) 유지.
```

---

## 3. 권장 스프린트 쪼개기

1. **P0 UI 셸** — 위 구현 프롬프트 1차 (빈 시리즈).
2. **P1 데이터** — content_url/CSV 또는 신규 RPC → bundle.
3. **P2** — 편집 잠금 해제, confidence, rpm, 다중 펼침.
