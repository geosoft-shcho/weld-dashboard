# 업로드 notes 스크롤 다이얼로그

## 목표
파일 조회 화면에서 업로드(및 동일 패턴의 선택 삭제) 결과 notes가 많아도 화면을 덮지 않고, 요약 + 스크롤 목록으로 확인·닫을 수 있게 한다.

## 권장 UI (확정)
Fluent `InfoBar`는 짧은 한 줄 알림용이다. notes가 여러 줄이면 **높이 제한 `ContentDialog`**가 맞다.

- 제목: `올리기 완료` / `선택 삭제`
- 본문 상단: 요약 한 줄 (`경고 N건 · 실패 M건` 또는 `지움 N건 · 건너뜀 M건`)
- 본문: `ConstrainedBox(maxHeight: 280)` + `SingleChildScrollView`로 note 목록
- 하단: `확인` 버튼 하나

짧은 notes(1~2줄)도 같은 다이얼로그로 통일한다. InfoBar/다이얼로그 분기는 두지 않는다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 워킹 트리 밖 읽기)
3. `lib/src/presentation/features/asset_lookup/asset_lookup_screen.dart` — `_didTapUpload` (353–363), `_showBulkDeleteInfoBar` (299–324)
4. 없음 (별도 계약·화면안 없음)

## 현재 상태
- `_didTapUpload`: `notes = warningNotes + failureNotes`를 `Text(notes.join('\n'))`로 `displayInfoBar`에 넣어, 10개 이상이면 InfoBar가 세로로 커져 화면을 덮음.
- `_showBulkDeleteInfoBar`: 같은 `join('\n')` InfoBar 패턴이라 동일 위험이 있음.

## 바꿀 것
1. `asset_lookup_screen.dart`에 로컬 헬퍼(예: `_showNotesDialog`)를 두고, notes + title + severity 요약에 맞는 `ContentDialog`를 `showDialog`로 연다.
2. `_didTapUpload`의 `displayInfoBar`를 이 다이얼로그로 교체한다.
3. `_showBulkDeleteInfoBar`도 같은 헬퍼를 쓰도록 맞춘다(동일 덮개 버그 예방).
4. 작업 프롬프트를 `docs/2026-11-23/AssetLookup_업로드notes_다이얼로그_프롬프트.md`에 저장한 뒤 그 문서만 보고 구현한다.

## 유지할 것
- 업로드·삭제 호출 흐름, `viewModel.load()` 재조회
- notes 문자열 내용 자체(포맷·문구 생성 로직)
- 다른 화면의 `displayInfoBar` 사용처

## 이번 작업에서 만들지 않음
- 공통 core 위젯/새 디자인 시스템
- asset_upload_dialog 내부 결과 모델 변경
- notes가 비어 있을 때의 success InfoBar 추가

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
- notes 10개 이상에서도 다이얼로그 높이가 제한되고 스크롤로 나머지를 볼 수 있음
- 확인 버튼으로 닫힘
