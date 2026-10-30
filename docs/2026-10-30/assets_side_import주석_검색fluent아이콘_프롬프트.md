# Assets 사이드 Import 주석 · 검색 Fluent 아이콘

## 목표
Assets 사이드 패널 헤더에서 Import 연결 버튼을 임시로 숨기고, 검색 TextField에 FluentIcons.search 아이콘을 두어 검색 입력임을 바로 알 수 있게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/widgets/assets_side_body.dart`
4. `lib/src/presentation/features/video_multimodal/widgets/side_panel_chrome.dart` (`sidePanelFieldDecoration`, `SidePanelHead`)
5. 없음 (별도 계약·화면안 없음)

## 현재 상태
- `assets_side_body.dart` `_head()`: `SidePanelHead` leading에 검색 `TextField`(hint `검색…`, `onChanged: viewModel.didChangeAssetsSearch`), actions에 `SidePanelAccentButton(label: 'Import')`가 있고 누르면 `didShowNotice('Import는 다음 단계에서 연결됩니다.')`만 호출한다.
- `sidePanelFieldDecoration`은 hint·테두리만 두고 prefix/suffix 아이콘 슬롯이 없다.
- 같은 패널 계열(`ask_side_body`, `labels_side_body`)은 `fluent_ui`를 `as fluent`로 가져와 `FluentIcons`를 쓴다.

## 바꿀 것
1. `assets_side_body.dart`의 Import `SidePanelAccentButton` 블록을 임시 주석 처리한다. 삭제하지 않고, 다시 켤 수 있게 주석으로 남긴다. `actions`는 빈 목록으로 두거나 주석만 남겨 `SidePanelHead`가 깨지지 않게 한다.
2. 검색 `TextField`에 Fluent 검색 아이콘을 붙인다. `sidePanelFieldDecoration('검색…')`을 복사·확장해 `prefixIcon`에 `fluent.FluentIcons.search`(크기·색은 패널 muted/ink에 맞춤, 다른 side panel IconButton과 비슷한 compact 크기)를 둔다. 장식만 바꾸고 검색 동작(`didChangeAssetsSearch`, 파일명 contains 필터)은 그대로 둔다.
3. 필요하면 `import 'package:fluent_ui/fluent_ui.dart' as fluent;`만 `assets_side_body.dart`에 추가한다. Material `Icons`는 쓰지 않는다.
4. `side_panel_chrome.dart`의 공통 `sidePanelFieldDecoration` 시그니처를 넓히지 않는다. 이번 아이콘은 Assets 검색 필드에만 국소적으로 적용한다.

## 유지할 것
- `viewModel.didChangeAssetsSearch` / `assetsSearchQuery` 필터 로직
- 에셋 테이블·드래그·선택·닫기 동작
- Import 관련 ViewModel 메서드·안내 문구 자체(버튼만 주석)
- `SidePanelFrame` / `SidePanelHead` / 공통 decoration 기본 계약

## 이번 작업에서 만들지 않음
- Import 실제 업로드·연결 구현
- 검색 제출 버튼·별도 검색 액션
- 다른 사이드 패널·공통 chrome API 변경
- ViewModel·테스트 추가 리팩터

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- Assets 헤더에 Import 버튼이 보이지 않고, 주석으로 코드가 남아 있다.
- 검색 입력란 왼쪽에 Fluent `search` 아이콘이 보인다.
- 검색어 입력 시 기존처럼 파일명 필터가 동작한다.
- close 버튼·에셋 목록 동작이 이전과 같다.
