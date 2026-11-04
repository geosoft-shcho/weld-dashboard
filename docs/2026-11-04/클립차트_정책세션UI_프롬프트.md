# 클립 차트 정책·세션·UI 리팩터

## 목표
타임라인 펼침 차트(audio / timeseries)의 kind 판별·상태·UI 매핑을 한 정책으로 맞춰, ViewModel·보드에 흩어진 `TimelineClipKind.audio|timeseries` 분기를 줄인다. GetClip·파형 UseCase 동작은 유지한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (차트 필드·`didSelectSampleClip`·`_fillChartsFromClipDetail`·토글)
4. `lib/src/presentation/features/video_multimodal/widgets/multimodal_timeline_board.dart`, `timeline_board_helpers.dart`
5. 계약·화면안: 없음

## 현재 상태
- audio/timeseries prepare·load·toggle·fill·보드 위젯·행 높이가 각각 `kind == audio|timeseries`를 반복한다.
- `_chartExpandedClipId`와 audio/timeseries loading·error·data·epoch가 ViewModel에 쌍으로 흩어져 있다.
- GetClip은 `_loadClipDetail` + `ClipDetailCache`로 이미 단일화되어 있다.

## 바꿀 것 (권장 순서 1→2→3)

### 1. 차트 kind 정책 한곳
- `lib/src/presentation/features/video_multimodal/clip_chart_kind.dart`에 `ClipChartKind { audio, timeseries }`와 `ClipChartKind? clipChartKindOf(TimelineClipKind)`를 둔다. audio/timeseries만 non-null.
- 행 높이도 같은 파일(또는 이 enum의 getter)에서 `expandedHeight`로 제공한다 (`TIMELINE_AUDIO_CHART_HEIGHT` / `TIMELINE_TIMESERIES_CHART_HEIGHT` 상수 재사용).
- ViewModel: `didSelectSampleClip`은 `prepareChartIfNeeded(clip)` / 차트 불가면 `_collapseChart`만. `_fillChartsFromClipDetail`은 `loadChartFor(clip, detail)`로 디스패치. `didTapToggleAudioChart` / `didTapToggleTimeseriesChart`는 내부에서 공통 `didTapToggleChart(trackId, ClipChartKind)`를 쓴다(보드 public API 시그니처는 유지).

### 2. 차트 세션 상태 묶기
- `lib/src/presentation/features/video_multimodal/clip_chart_session.dart`에 세션을 둔다: `clipId`, `kind`, `epoch`, `isLoading`, `error`, `audioAmplitudes`, `timeseriesSeries`.
- ViewModel의 개별 `_chartExpandedClipId` / `_audio*` / `_timeseries*` 필드를 `_chartSession`(또는 동일 역할)로 교체한다. prepare·clear·collapse·load success/fail이 세션을 갱신한다.
- 기존 getter(`chartExpandedClipId`, `audioAmplitudes`, `timeseriesSeries`, loading/error)는 세션에 위임해 보드 호출부를 깨지 않는다.

### 3. 보드 UI가 같은 정책 사용
- `timeline_board_helpers.dart`: `expandedClip?.kind == audio ? …` 대신 `clipChartKindOf` + `expandedHeight`.
- `multimodal_timeline_board.dart`: 확장 클립 위젯 선택을 `clipChartKindOf(clip.kind)`(또는 VM `expandedChartKind`)로 한다. audio → `AudioClipChart`, timeseries → `TimeseriesClipChart`.

## 유지할 것
- GetClip 단일 진입·`ClipDetailCache`
- `LoadAudioWaveformUseCase` / `LoadTimeseriesWaveformUseCase` 분리
- 보드의 `didTapToggleAudioChart` / `didTapToggleTimeseriesChart` 이름(내부만 공통화)
- 속성·포즈·대상 영상·STT·대기열 UX

## 이번 작업에서 만들지 않음
- audio/timeseries UseCase 통합
- kind별 strategy/factory 계층
- GetClip·캐시 로직 재변경
- `login_screen.dart`

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 변경 파일 `dart analyze` 무결함
- `./scripts/agent_check.sh test/job_timeline_edit_test.dart` (가능하면) 통과
- 음성/시계열 선택 시 차트 펼침·파형 로드·토글 접기/펼치기 이전과 동일
- 영상/포즈 선택 시 차트 접힘 유지
- VM·helpers·board에서 audio/timeseries kind 분기가 정책 함수/`ClipChartKind` 중심으로만 남음
