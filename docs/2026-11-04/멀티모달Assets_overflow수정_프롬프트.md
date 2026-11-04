# AssetsSideBody RenderFlex overflow 수정

## 목표
AssetsSideBody 행 Column 오버플로를, 실측 행 높이에 맞춘 pageSize와 안전한 목록 레이아웃으로 고친다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `assets_side_body.dart`, `video_multimodal_view_model.dart` ASSETS_ROW_HEIGHT·didReportAssetsViewport
4. 없음

## 현재 상태
- `ASSETS_ROW_HEIGHT=32`가 실제 SidePanelDataRow보다 작아 pageSize가 과도하다.
- 행 목록이 스크롤 없는 Column이라 overflow assert가 난다.

## 바꿀 것
1. `ASSETS_ROW_HEIGHT`를 40으로 올린다.
2. `_tableBody` 행 Column을 ListView로 바꿔 overflow assert를 막는다. 페이지 단위 로드는 유지.
3. viewport 콜백·`_appliedAssetsPageSize` 가드는 유지.

## 유지할 것
- pageToken 캐시·페이지 번호 UI
- 행 onTap/드래그
- `_bars`용 ListAssets 50

## 이번 작업에서 만들지 않음
- 에셋 상세 이동
- 페이지네이션 API 재설계

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
- Assets 사이드 yellow/black overflow 없음
