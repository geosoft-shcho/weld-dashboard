# 업로드 wait= 로그를 debugPrint로

## 목표
등록 분기·GetTrace 상태 로그가 Flutter Web 콘솔에서 `[upload] resolved …` 바로 아래에 `wait=Trace` 등으로 보이게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `lib/src/domain/use_cases/upload_asset_queue_use_case.dart`
3. `docs/2026-11-18/업로드_traceId_디버그로그_프롬프트.md`

## 현재 상태
- `resolved`는 data 레이어 `kDebugMode` + `debugPrint`로 콘솔에 보인다.
- `wait=Trace|Run|done`와 GetTrace status 로그는 `assert` + `developer.log`라 Web 콘솔에 안 보인다.

## 바꿀 것
1. `upload_asset_queue_use_case.dart`의 wait/GetTrace 디버그 로그를 `kDebugMode` + `debugPrint('[upload] …')`로 바꾼다.
2. `dart:developer` assert 로그는 제거한다.

## 유지할 것
- Trace/Run/즉시완료 분기 동작.
- tus·`_resultFrom`의 기존 `debugPrint`.

## 이번 작업에서 만들지 않음
- 새 헬퍼·로거 패키지·다른 파일 로그 정리.

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh test/upload_asset_queue_retry_postprocess_test.dart` 통과
- 다음 업로드 시 콘솔에 `resolved` 다음 `wait=Trace`가 보인다
