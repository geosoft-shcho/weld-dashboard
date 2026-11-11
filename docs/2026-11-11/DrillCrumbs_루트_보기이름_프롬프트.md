# DrillCrumbs 루트를 보기 이름으로

## 목표
드릴크럼브 루트가 `전체`/뷰 배지 대신 보기 이름(`장비별`/`작업자별`)으로 보여, view와 level의 「장비」 동어 중복을 없앤다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart` (`_DrillCrumbs`)
4. 없음

## 현재 상태
- 루트: `_LevelBadge`(장비/작업자) + `Text('전체')`
- ancestor: `_LevelBadge`(레벨) + 노드 라벨 → `[장비] 전체 › [장비] W-01`처럼 view/level 단어가 겹침

## 바꿀 것
1. 루트 버튼 라벨을 `collectedView`에 따라 `장비별` / `작업자별` 텍스트만 표시한다 (배지·「전체」 제거).
2. `_viewLabelOf`를 위 문구에 맞게 바꾸거나, 루트 전용으로 정리한다.
3. `didTapAncestor(0)`·ancestor 배지·구분자는 유지한다.

## 유지할 것
- ancestor 크럼브 형태, VM/조회 로직, 커맨드바 뷰 전환

## 이번 작업에서 만들지 않음
- API/VM 변경, 새 위젯·디자인 시스템

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
- 루트가 `장비별` / `작업자별`로 보인다
- 예: `장비별 › [장비] W-01 › [공사] …`
