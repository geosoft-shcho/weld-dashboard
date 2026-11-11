# DrillCrumbs 건수를 경로 라벨 옆에

## 목표
응답 건수가 Wrap 끝 단독 텍스트가 아니라, 현재 경로의 마지막 라벨(`Text(label)`) 바로 옆에 붙는다. 조상이 없으면 루트 라벨 옆에 붙는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart` (`_DrillCrumbs`)
4. 없음

## 현재 상태
- 건수가 크럼브 버튼들과 별도 Wrap 자식으로 뒤에 붙어 있다.

## 바꿀 것
1. 마지막 ancestor 버튼 Row에서 `Text(label)` 옆에 건수 텍스트를 넣는다.
2. ancestor가 없으면 루트 버튼 라벨 옆에 건수를 넣는다.
3. Wrap 끝의 단독 건수 `Text`는 제거한다.

## 유지할 것
- `_timelineCountLabel` 단위 규칙, 탭 동작, 레벨 배지

## 이번 작업에서 만들지 않음
- 툴바·VM·Present 변경

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
- 드릴 시 마지막 경로 라벨 옆에 `3건` 등이 보인다
- Wrap 끝 단독 건수 문구가 없다
