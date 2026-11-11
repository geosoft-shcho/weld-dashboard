# DrillCrumbs 최상위를 「전체」로 바꾸고 레벨을 보이게 한다

## 목표
크럼브 최상위가 “전체로 돌아가기”로 읽히고, 각 칸이 장비·공사·품목·작업인지 바로 보인다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart`
4. `lib/src/domain/entities/collected_node.dart` (`CollectedNodeLevel`)
5. 없음

## 현재 상태
- 루트 버튼 문구가 「수집」이라 범례·unspecified 라벨과 겹친다.
- 조상 칸은 이름만 보여 장비/공사 구분이 어렵다.

## 바꿀 것
1. 루트 문구를 「전체」로 바꾼다 (`didTapAncestor(0)` 유지).
2. 조상 칸에 레벨 배지(장비/작업자/공사/품목/작업) + 이름을 넣는다.

## 유지할 것
- `didTapAncestor`·`›` 구분·헤더 드릴다운 VM

## 이번 작업에서 만들지 않음
- present/VM 레벨 체계 변경
- 새 디자인 시스템

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
- 루트가 「전체」이다
- 조상 칸에 레벨 배지가 보인다
