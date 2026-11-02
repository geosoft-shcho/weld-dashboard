# 타임라인 spanLabel 시분초 표시

## 목표
`multimodal_timeline_board`의 `playheadLabel | spanLabel`에서 타임라인 길이(`spanLabel`)가 시·분·초로 읽히게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/multimodal_timeline_board.dart` (865–872)
4. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`spanLabel`, `_formatClock`)
5. 계약·화면안: 없음

## 현재 상태
- 보드 UI는 `'${viewModel.playheadLabel} | ${viewModel.spanLabel}'`만 표시한다. 포맷은 위젯에 없다.
- `spanLabel` → `_formatClock(spanSeconds)`, `playheadLabel`도 같은 `_formatClock`.
- `_formatClock`은 `MM:SS`만 보여 시(hour)가 없다.

## 바꿀 것
1. `VideoMultimodalViewModel._formatClock`을 **시:분:초** 표기로 고친다.
   - 형식: `H:MM:SS` (1시간 미만이면 `0:MM:SS`).
   - 같은 `_formatClock`을 쓰는 `playheadLabel`도 함께 통일한다.
2. 보드 위젯(865–872) 문자열 조합·스타일은 유지. 포맷 로직을 위젯에 두지 않는다.

## 유지할 것
- `spanSeconds` 계산(클립 최대 end)
- 보드 레이아웃·색·FontFeature

## 이번 작업에서 만들지 않음
- 타임라인 눈금 painter 포맷 변경
- 재생 배속·seek 로직

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 보드에 `현재시각 | 전체길이`가 시:분:초로 보인다.
- `spanSeconds`가 예를 들어 125초면 `0:02:05`처럼 시·분·초가 드러난다.
