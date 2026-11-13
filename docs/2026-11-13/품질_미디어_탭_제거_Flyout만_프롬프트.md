# 품질 미디어 탭 제거 · Flyout만

## 목표
`QualityMediaTabs` 레거시 경로를 제거하고 미디어 선택은 `QualityMediaStrip`(Flyout)만 사용한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `quality_media_host.dart`, `quality_media_strip.dart`, `quality_issue_screen.dart`, `quality_issue_view_model.dart`
4. 계약·화면안: 없음

## 현재 상태
- Flyout 조건이 아니면 `QualityMediaTabs`/`QualityMediaFiles`/`QualityReportPdfView` 레거시 분기
- Host·Screen·VM에 탭/인덱스 선택 API가 남아 있음

## 바꿀 것
1. `quality_media_host.dart`: 탭 분기 삭제. 항상 Strip(+ 메타/빈 상태). `group.media`도 entry에 포함. 탭 관련 props 제거.
2. `quality_issue_screen.dart`: 탭/인덱스 props·`_mediaKey`의 tab/index 제거.
3. `quality_issue_view_model.dart`: `selectedMediaTab`/`selectedMediaIndex`/`didSelectMediaTab`/`didSelectMediaIndex` 및 `_resolveMediaTab` 등 탭 전용 상태·호출 제거. 쓰이지 않는 갱신 제거.
4. 미사용 파일 삭제: `quality_media_tabs.dart`, `quality_media_files.dart`, `quality_report_pdf_view.dart`.
5. Strip의 `PaperScanHost`에 entry `pageCount` 반영(그룹 PDF용).

## 유지할 것
- Flyout 더보기·focusedMedia·jobMedia·reportPdfs
- QualityPaperMeta

## 이번 작업에서 만들지 않음
- Flyout UX 재설계
- 새 추상 계층

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
- QualityMediaTabs 참조 없음
- 미디어 UI는 Flyout만
