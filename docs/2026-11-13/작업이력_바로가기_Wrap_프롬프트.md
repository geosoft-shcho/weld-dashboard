# 작업 이력 바로가기 Wrap

## 목표
바로가기 열 아이콘+라벨이 가로로 넘치지 않게, 길면 다음 줄로 내려가게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/work_history/widgets/work_history_table.dart`
4. 없음

## 현재 상태
- 바로가기 `Row(mainAxisSize: min)`가 가용 폭(~336)보다 커 RenderFlex overflow(약 43px)가 난다.

## 바꿀 것
1. 바로가기 `Row`를 `Wrap`(spacing/runSpacing 4)으로 바꾼다. `SizedBox(width: 4)` 간격은 Wrap spacing으로 대체한다.
2. 버튼·라벨·권한 분기는 유지한다.

## 유지할 것
- `_ActionIcon` 라벨·열 flex·네비게이션

## 이번 작업에서 만들지 않음
- 열 flex 재조정, 라벨 문구 변경

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
- 바로가기 열이 좁아도 overflow 없이 줄바꿈된다
