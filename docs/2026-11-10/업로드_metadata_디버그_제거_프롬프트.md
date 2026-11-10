# 업로드 metadata 디버그 로그 제거

## 목표
에셋 업로드 `[MM-UPLOAD]` 디버그 로그와 관련 파일을 제거한다.

## 먼저 읽을 것
1. `lib/src/data/datasources/remote/asset_upload_debug_log.dart`
2. `lib/src/data/repositories/remote_asset_upload_repository.dart`
3. 계약·화면안: 없음

## 현재 상태
- `AssetUploadDebugLog.post`가 multipart·tus·register 경로에서 metadata를 print한다.

## 바꿀 것
1. `asset_upload_debug_log.dart` 삭제.
2. `remote_asset_upload_repository.dart`에서 import와 `AssetUploadDebugLog` 호출·그에만 쓰인 지역 변수를 제거한다.

## 유지할 것
- 업로드·register·tus 실제 전송 로직

## 이번 작업에서 만들지 않음
- 다른 로그 정리

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
- 코드에 `MM-UPLOAD` / `AssetUploadDebugLog`가 없다
