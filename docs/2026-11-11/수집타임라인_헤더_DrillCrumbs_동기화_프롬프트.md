# 수집 타임라인 헤더·DrillCrumbs 동기화

## 목표
리소스 헤더 드릴다운이 커맨드바·크럼브와 같은 조상 갱신 로직을 타서 `_DrillCrumbs` 표시와 맞는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/collection_monitoring_view_model.dart`
4. `lib/src/presentation/features/collection_monitoring/widgets/collection_resource_timeline_view.dart`
5. `lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart`

## 현재 상태
- 헤더는 `didTapTimelineNode`(append-only)를 쓴다.
- 레벨 콤보는 `didSelectLevelNode`(레벨 기준 조상 정리)를 쓴다.
- `_DrillCrumbs`는 `ancestors`만 표시한다.

## 바꿀 것
1. `didTapTimelineNode`: 자식 있는 노드는 `didSelectLevelNode(chosen.path.level, chosen.nodeKey)`로 위임한다.
2. 리프는 `didSelectRow` 유지한다.
3. 헤더·크럼브 UI 진입점은 유지한다.

## 유지할 것
- 크럼브 UI·`didTapAncestor`
- `loadBoard` / Present 흐름

## 이번 작업에서 만들지 않음
- 새 추상 계층
- 크럼브 위젯을 타임라인 안으로 이동
- 로드맵/하루 뷰 변경

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
- 헤더 드릴다운 시 크럼브 경로가 같이 쌓인다
- 크럼브로 올리면 타임라인 깊이가 맞는다
- 리프 클릭은 크럼브를 늘리지 않는다
