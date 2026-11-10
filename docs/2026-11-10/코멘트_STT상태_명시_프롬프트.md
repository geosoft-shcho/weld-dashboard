# 코멘트 STT 상태 UI 명시

## 목표
코멘트 리스트에서 보이는 상태 칩·상세가 `comment.stt.status`(도메인 `sttLabel`/`sttMessage`)임을 사용자가 바로 알 수 있게, 헤더·본문 라벨을 「STT 상태」로 명시한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/widgets/screen_comment_list.dart`
4. `lib/src/domain/entities/screen_comment.dart` (`screenCommentSttLabel`)
5. 계약·화면안: 없음 (API `stt.status` → `POSTPROCESS_STATUS_*` 매핑은 기존 유지)

## 현재 상태
- `screen_comment_list.dart`: Expander 헤더에 `_StatusMark(label: status)`로 `완료`/`처리 중`/`실패` 등만 표시. 본문 섹션 제목은 `'상태'`, 본문 텍스트는 `sttMessage`가 비면 `sttLabel`만 표시.
- `screen_comment.dart`: `POSTPROCESS_STATUS_*` → `ScreenCommentSttKind` → `맡기지 못함`/`처리 중`/`완료`/`실패`/`취소`.
- 매핑은 `remote_asset_upload_repository.dart`에서 이미 수행. `POSTPROCESS_STATUS_SUCCEEDED`는 UI에서 `완료`.

## 바꿀 것
1. `screen_comment_list.dart`만 수정한다.
   - Expander 본문 섹션 제목: `'상태'` → `'STT 상태'`.
   - 헤더 `_StatusMark` 표시 문구: `status` → `'STT · $status'` (예: `STT · 완료`). 색상은 기존처럼 원본 `sttLabel`(`완료`/`처리 중`/…)으로 `_statusColor`를 계산한다.
   - 본문 상태 텍스트: `sttMessage`가 비어 `sttLabel`만 쓰일 때도 `'STT · $status'`로 표시한다. `sttMessage`가 있으면 메시지 본문은 그대로 두고, 위 제목 `'STT 상태'`로 종류만 명시한다.
2. `_statusColor` 스위치 키(`완료`, `처리 중`, `실패`, `취소`)는 바꾸지 않는다. 표시 문자열에 `STT ·`를 붙인 뒤에도 색 판별은 원본 `sttLabel`만 쓴다.

## 유지할 것
- `sttLabel`/`sttMessage` 매핑, 재생·저장·삭제, ViewModel·repository·proto
- 칩 색상 규칙과 Expander/레이아웃 구조
- 카드 UI·새 디자인 시스템 도입 없음

## 이번 작업에서 만들지 않음
- STT 폴링·상태 값 변경, raw `POSTPROCESS_STATUS_*` 노출
- 도메인 라벨 문구(`완료` 등) 자체 변경
- 새 위젯 파일·추상 계층

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
- 코멘트 타일 헤더에 `STT · 완료`(또는 해당 라벨)가 보인다
- 펼친 본문 제목이 `STT 상태`이다
- 성공만 있고 메시지가 없을 때도 본문에 `STT · …`로 STT임이 드러난다
- `_statusColor`가 `STT ·` 접두 때문에 깨지지 않는다
