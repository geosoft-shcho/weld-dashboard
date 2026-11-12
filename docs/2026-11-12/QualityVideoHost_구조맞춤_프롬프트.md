# QualityVideoHost PaperScanHost 구조 맞춤

## 목표
품질 이슈 미디어의 video 호스트를 pdf(`PaperScanHost`)와 같은 StatefulWidget·뷰포트 구조로 맞추고, 높이를 540으로 통일한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/quality_issue/widgets/paper_scan_host.dart`
4. `lib/src/presentation/features/quality_issue/widgets/quality_video_host.dart`
5. 계약·화면안: 없음

## 현재 상태
- `QualityVideoHost`: `StatelessWidget`, `VIEWPORT_MIN_HEIGHT = 320`, `_slot`으로 고정 높이
- 빈 `videoFile`이면 `_slot`만 반환(헤더 없음). 경로 해석은 `build` 안에서 즉시 수행
- `PaperScanHost`: `StatefulWidget`, `VIEWPORT_MIN_HEIGHT = 540`, `initState`/`didUpdateWidget` → `_prepare`, 빈 파일은 `_unavailableSlot`(헤더+뷰포트), 본문은 `_viewport`

## 바꿀 것
1. `quality_video_host.dart`만 수정
2. `QualityVideoHost`를 `StatefulWidget`으로 전환 (`_QualityVideoHostState`)
3. `VIEWPORT_MIN_HEIGHT`를 **540**으로 변경 (State 쪽, `PaperScanHost`와 동일)
4. `PaperScanHost`와 같은 골격으로 맞춤:
   - `_prepare`에서 `videoFile` trim·asset 경로 해석 (`http(s)`는 그대로, 그 외 `resolveQualityVideoAssetPath`)
   - `initState` / `didUpdateWidget`(videoFile 변경 시)에서 `_prepare` 호출
   - 빈 경로 → `_unavailableSlot` (헤더 + `_viewport` + 안내 문구)
   - 정상 경로 → 헤더(배지·파일명) + `_viewport`(없거나 `WorkDetailChewieStage`)
   - `_slot` → `_viewport`로 이름·구현 정렬 (`ConstrainedBox` + `SizedBox(height: 540)` + `ColoredBox`)
5. public props(`videoFile`, `seekToMs`, `seekToken`)와 top-level `qualityVideoDisplayName` / `resolveQualityVideoAssetPath`는 유지

## 유지할 것
- `QualityMediaHost` 등 호출부 시그니처·동작
- Chewie seek(`seekToMs` / `seekToken`) 전달
- 배지 문구 `video_player + chewie · QualityVideoHost`
- `paper_scan_host.dart` 및 다른 파일 수정 없음

## 이번 작업에서 만들지 않음
- 미디어 탭/스트립 레이아웃 변경
- 새 추상 계층·공통 베이스 클래스
- seek/재생 로직 변경

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
- video 선택 시 뷰포트 높이가 pdf와 같이 540으로 보임
- 빈/미존재 경로 안내와 헤더 구조가 PaperScanHost와 대응됨
