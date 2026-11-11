# DrillCrumbs 응답 건수 표기

## 목표
타임라인 툴바에 있던 응답 건수 문구를 `_DrillCrumbs` 옆에 옮겨, 드릴 경로와 현재 조회 응답 건수가 한곳에서 보이게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart` (`_DrillCrumbs`, `_Toolbar`, `_timelineCountLabel`)
4. `docs/2026-11-11/타임라인툴바_응답건수표기_프롬프트.md`

## 현재 상태
- `_Toolbar` 끝에 `_timelineCountLabel(timeline)`이 있다.
- `_DrillCrumbs`는 `viewModel`만 받아 경로 버튼만 그린다.
- 건수 단위 로직(`대`/`명`/`개`/`건`, 필요 시 `· N구간`)은 이미 `_timelineCountLabel`에 있다.

## 바꿀 것
1. `_DrillCrumbs`에 `board`(또는 `timeline`)를 넘겨 크럼브 뒤에 응답 건수 텍스트를 붙인다.
2. `_Toolbar`에서는 건수 `Text`를 제거한다.
3. 기존 `_timelineCountLabel` / `_nodeCountUnitOf` 표기 규칙은 그대로 쓴다.

## 유지할 것
- 크럼브 탭·루트 `장비별`/`작업자별`·레벨 배지, 툴바 뷰/줌, 건수 단위 규칙

## 이번 작업에서 만들지 않음
- Present/VM 변경, KPI·상태 테이블, 새 위젯 파일

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과 (`dart analyze`)
- 관련 테스트가 있으면 `./scripts/agent_check.sh <test 경로…>` 통과
- `_DrillCrumbs` 행에 경로와 건수가 함께 보인다
- `_Toolbar`에 건수 문구가 없다
