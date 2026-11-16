# WaveformChannelCharts 채널 구분 강화

## 목표
네 채널 차트를 패널·헤더·왼쪽 액센트로 구분해, 사용자가 전류/전압/속도/회전 속도를 한눈에 알아볼 수 있게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/core/widgets/waveform_channel_charts.dart`
4. `lib/src/presentation/core/themes/app_theme.dart`
5. `lib/src/presentation/features/pass_profile/widgets/pass_compare_summary.dart` (패널 톤 참고)

## 현재 상태
- `_WaveformChannelChart`는 제목 `Text` + `CHART_PLOT` 배경의 `LineChart`만 세로로 쌓음.
- 채널 간 시각 구분은 제목 문자열뿐. 패널·액센트 없음.
- 시리즈 색(명장/작업자/로봇)은 이미 `CHART_MASTER` 등으로 구분.

## 바꿀 것
1. `waveform_channel_charts.dart`만 수정.
2. 각 `_WaveformChannelChart`를 `PassCompareSummary`와 비슷한 `SURFACE_RAISED` 패널로 감싼다 (padding, radius 4).
3. 채널별 **왼쪽 세로 액센트**(얇은 막대) + 헤더에 채널명·단위:
   - 전류 → `CHART_MASTER` 액센트, 헤더 `전류` / `A`
   - 전압 → `STATUS_WARN` 액센트, 헤더 `전압` / `V`
   - 속도 → `STATUS_OK` 액센트, 헤더 `속도` / `m/min`
   - 회전 속도 → `CHART_ROBOT` 액센트, 헤더 `회전 속도` / `rpm`
4. `showAxisTitles == false`(컴팩트)일 때도 같은 패널·액센트·짧은 헤더를 유지하되 padding·차트 높이는 기존 컴팩트 값을 유지.
5. 플롯 영역(`CHART_PLOT`)·라인 색·밴드·커서·축 동작은 그대로.

## 유지할 것
- `WaveformChannelCharts` public API·호출부(pass_profile / quality_issue 등)
- 명장/작업자/로봇 시리즈 색·토글
- `AppTheme` 신규 색 상수 추가 없음(기존 색 재사용)

## 이번 작업에서 만들지 않음
- 채널 on/off 토글
- 비교 지표와 색 동기화 작업
- 새 디자인 시스템·카드 컴포넌트 공통화 파일

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- 패스 프로필에서 네 차트가 패널+액센트로 구분되어 보임
- 컴팩트 모드(`showAxisTitles: false`)에서도 채널 구분이 유지됨
- 시리즈 라인·품질 밴드·커서 동작 변화 없음
