# DrillCrumbs 경로 라벨마다 건수

## 목표
루트·각 ancestor 경로 라벨 옆에, 그 부모로 조회해 둔 자식 응답 건수가 붙는다. 마지막만 아니라 모든 경로 칸에 표시한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `collection_timeline_host.dart` (`_DrillCrumbs`)
4. `collection_monitoring_view_model.dart` (`_nodesByParentKey`)

## 현재 상태
- 건수는 현재 board 응답만 쓰며 마지막 라벨(또는 루트만)에 붙는다.
- 부모별 자식 목록은 `_nodesByParentKey`에 남아 있다.

## 바꿀 것
1. ViewModel에 부모 path 기준 캐시 자식 목록/건수를 읽는 얇은 접근자를 둔다.
2. 루트는 `CollectedNodePath.root(view)` 자식 건수, 각 ancestor는 `node.path` 자식 건수를 라벨 옆에 표시한다.
3. 단위는 자식 레벨(장비 `대`, 작업자 `명`, 파일 `개`, 그 외 `건`). 현재 board와 같은 부모의 마지막 칸만 구간 수 보칙(`· N구간`)를 유지한다.
4. `isLast` 전용 분기는 제거한다.

## 유지할 것
- 크럼브 탭·배지·조회 로직, `_nodesByParentKey` 저장 방식

## 이번 작업에서 만들지 않음
- 새 추상화, KPI 변경, 캐시 미존재 시 추가 API 호출

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
- 예: `장비별 2대 › [장비] A 3건 › [공사] B 1건 › [품목] C 3건`
- 각 칸 건수가 해당 부모 캐시(또는 현재 board)와 맞다
