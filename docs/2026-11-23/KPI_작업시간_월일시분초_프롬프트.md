# KPI 작업시간 월일 시분초 표시

## 목표
수집 KPI의 작업시간·용접시간 표시를 `1998h` 대신 월·일·시·분·초로 풀어 보여 준다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `lib/src/presentation/features/collection_monitoring/widgets/collection_kpi_cards.dart`
3. `lib/src/presentation/core/formatters/dashboard_formatters.dart`

## 현재 상태
- `_durationHours`가 초÷3600 후 `Nh`로만 표시한다.

## 바꿀 것
1. `DashboardFormatters`에 초 → 월(30일)·일·시·분·초 포맷 추가. 0인 단위는 생략, 전부 0이면 `0초`.
2. KPI 카드 작업시간 부제·용접시간 value에 그 포맷을 쓴다.

## 유지할 것
- summary 필드·카드 구성·다른 duration 포맷(타임라인 분 등)

## 이번 작업에서 만들지 않음
- 달력 월(28~31일) 계산, 새 카드 UI

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
- `7193078`초가 `2개월 23일 6시간 4분 38초` 형태로 보인다
