# 업로드 traceId 경로 디버그 로그

## 목표
tus 헤더·등록 JSON으로 `traceId`를 받는 지점과 Trace/Run/즉시완료 분기에, debug에서만 보이는 짧은 로그를 넣어 화면 검증과 Network를 맞출 수 있게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/data/datasources/asset_tus_upload_web.dart`
4. `lib/src/data/repositories/remote_asset_upload_repository.dart`
5. `lib/src/domain/use_cases/upload_asset_queue_use_case.dart`
6. 계약: `protos/mediatag/trace/v1/trace.proto` 상단 주석(Upload-Trace-Id · JSON traceId)

## 현재 상태
- `asset_tus_upload_web.dart`: 시작 응답에서 `Upload-Trace-Id`를 읽어 `(body, traceId)` 반환. 로그 없음.
- `remote_asset_upload_repository.dart`: tus면 헤더 `traceId`, multipart면 `''`. `_resultFrom`은 헤더 우선·없으면 JSON `traceId`. 로그 없음.
- `upload_asset_queue_use_case.dart`: `traceId` 있으면 `_waitForTrace`, 없으면 `runId`면 `_waitForPostprocess`, 둘 다 없으면 즉시 완료. 로그 없음.
- domain은 `package:flutter`를 쓰지 않는다.

## 바꿀 것
1. `asset_tus_upload_web.dart` — tus 시작 응답에서 `Upload-Trace-Id`를 읽은 직후, debug일 때만 `[upload] tus Upload-Trace-Id=…` (없으면 empty 표기).
2. `remote_asset_upload_repository.dart` `_resultFrom` — 최종 `traceId` 출처(header|json|none)와 `runId` 유무를 debug 한 줄.
3. `upload_asset_queue_use_case.dart` 등록 직후 분기 — `wait=Trace|Run|done` 한 줄. domain은 Flutter import 없이 `assert` 또는 `dart:developer`로 debug-only.
4. `_waitForTrace` — status가 바뀌거나 done/failed로 끝날 때만 한 줄(매 1초 스팸 금지).

## 유지할 것
- traceId 우선순위(헤더 > JSON), Trace/Run/즉시완료 분기, API·UI·재시도(GetRun) 동작.
- stub tus(`asset_tus_upload_stub.dart`)는 UnsupportedError 유지(로그 불필요).

## 이번 작업에서 만들지 않음
- 로거 패키지·새 헬퍼 파일·UI 변경·수집 모니터링 Trace 화면 로그.
- release에서 항상 찍히는 print.

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
- 관련 테스트: `./scripts/agent_check.sh test/upload_asset_queue_retry_postprocess_test.dart` 통과
- debug 실행 시 콘솔에 tus 헤더 / resolved traceId / wait 분기 로그가 보인다
- release/profile에서는 해당 로그가 나오지 않는다(kDebugMode 또는 assert)
