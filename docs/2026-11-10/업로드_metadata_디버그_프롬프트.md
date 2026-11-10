# 업로드 metadata 디버그

## 목표
녹화 업로드와 에셋 올리기가 `POST /assets`(또는 tus 등록)할 때 보내는 metadata JSON을 debug 콘솔에서 같은 태그로 확인할 수 있게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/data/repositories/remote_asset_upload_repository.dart`
4. `lib/src/data/datasources/remote/media_files_debug_log.dart` (로그 패턴 참고)
5. 계약·화면안: 없음 (`POST /assets` multipart metadata)

## 현재 상태
- 녹화·에셋 올리기 모두 `RemoteAssetUploadRepository.uploadFile` → `_metadataJson` → `_send`(multipart `/assets` 또는 tus)를 탄다.
- metadata에 jobId·passId·equipmentId·timeOrigin·subject·situation을 넣지만 전송 직전 로그가 없다.

## 바꿀 것
1. `kDebugMode`에서만 찍는 `[MM-UPLOAD]` 로그 헬퍼를 추가한다(`MediaFilesDebugLog`와 같은 스타일).
2. `uploadFile`과 `registerUploaded`에서 실제 전송/등록 직전 metadata·파일명·전송 방식(multipart|tus|register)을 로그한다.
3. 녹화·에셋 UI는 바꾸지 않는다. 공통 repository 한곳에서만 로그한다.

## 유지할 것
- metadata 스키마·uploadFile/tus 분기·녹화 배치·코멘트 흐름
- release 빌드에서 로그가 나오지 않음(`kDebugMode`)

## 이번 작업에서 만들지 않음
- 주제·상황 등 메타데이터 UI 추가
- 업로드 전송 방식 변경
- 응답 body 전체 덤프

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
- 녹화 업로드 시 `[MM-UPLOAD]`에 metadata가 보인다
- 에셋 올리기 시에도 같은 태그로 metadata가 보인다
- `kDebugMode`가 아니면 로그가 없다
