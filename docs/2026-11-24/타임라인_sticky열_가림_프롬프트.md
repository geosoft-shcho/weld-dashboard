# 타임라인 sticky 리소스 열 가림 수정

## 목표
`_StickyResourceColumn`이 가로 스크롤된 타임라인 캔버스를 덮지 않게 한다. 리소스 라벨은 고정, 시간축·막대만 가로 스크롤되게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/collection_monitoring/widgets/collection_resource_timeline_view.dart`
4. `neon_timeline_flutter` `ResourceTimelineView` (resourceColumnWidth ≥ 120, 가로 스크롤에 리소스 열 포함)
5. 계약·화면안: 없음

## 현재 상태
- `Stack` 위에 `Positioned` sticky(`SURFACE_RAISED`)가 왼쪽을 덮는다.
- `ResourceTimelineView`는 리소스 열+캔버스를 한 가로 스크롤로 민다. 스크롤하면 캔버스가 sticky 아래로 들어가 안 보인다.

## 바꿀 것
1. `Stack` 오버레이 sticky 제거. `Row`(고정 sticky | `Expanded` 타임라인)로 배치.
2. 타임라인 쪽 `resourceColumnWidth`는 패키지 하한(120)만 쓰고 헤더는 비운다(거터). sticky는 기존 라벨 폭(176/220).
3. `canvasBudget`·「지금」선 좌표는 `Expanded` 폭 기준으로 맞춘다.
4. 세로 스크롤 동기화는 유지.
5. `ResourceTimelineView.resourceHeaderLabel`은 빈 문자열로 두어 sticky와 「공사」 헤더가 두 번 보이지 않게 한다.
6. 패키지 `resourceColumnWidth` 하한 120은 유지하되, 보드를 `-120` 오프셋+클립으로 숨겨 빈 거터가 보이지 않게 한다.

## 유지할 것
- sticky 라벨·더블클릭 드릴인
- Present·범례·상태 색

## 이번 작업에서 만들지 않음
- neon_timeline 패키지 수정
- 새 타임라인 위젯 교체

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
- 가로 스크롤 시 막대·시간축이 sticky에 가려지지 않음
- 리소스 이름 열은 고정
- 세로 스크롤 행 정렬 유지
