# 드릴크럼브 루트 뷰 표기

## 목표
첫 단계(루트) 크럼브에서 현재 `CollectedNodeView`(장비/작업자)가 보이도록 해, `ListCollectionNodes`의 `parent.view`와 같은 맥락을 UI에서도 알 수 있게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart` (`_DrillCrumbs`)
4. `collection_monitoring_view_model.dart` (`collectedView`), `collection_command_bar.dart` / `collection_timeline_inspector.dart` (장비·작업자 라벨)

## 현재 상태
- `_DrillCrumbs` 루트: `Button` + `const Text('전체')`만 표시
- 하위 ancestor는 `_LevelBadge`(장비/공사/…) + 노드 라벨
- `viewModel.collectedView`로 장비/작업자 구분 가능 (기본 `equipment`)

## 바꿀 것
1. 루트 버튼을 ancestor와 같은 형태로: `_LevelBadge`(뷰 라벨) + `Text('전체')`
2. 라벨: `equipment` → `장비`, `worker` → `작업자` (커맨드바·인스펙터와 동일)

## 유지할 것
- `didTapAncestor(0)` 동작, ancestor 크럼브·레벨 배지, 조회 요청/VM 로직

## 이번 작업에서 만들지 않음
- API/VM/조회 파라미터 변경, 새 위젯 파일·디자인 시스템

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
- 루트에 `[장비] 전체` / `[작업자] 전체`가 뷰에 맞게 보임
- 루트 탭 시 기존처럼 최상단으로 복귀
