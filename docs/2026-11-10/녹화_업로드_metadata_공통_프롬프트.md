# 녹화 업로드 metadata 공통

## 목표
녹화 업로드도 에셋 올리기와 같은 `uploadFile` 호출로 metadata(`jobId`, `passId`, `equipmentId`, `timeOrigin`, `subject`, `situation`)를 채운다. 전송은 기존 `RemoteAssetUploadRepository` 한곳만 쓴다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/camera_recording_view_model.dart`
4. `lib/src/presentation/features/video_multimodal/widgets/camera_recording_dialog.dart`
5. `lib/src/domain/use_cases/upload_asset_use_case.dart`
6. `lib/src/data/repositories/remote_asset_upload_repository.dart`
7. 계약·화면안: 없음 (`POST /assets` metadata)

## 현재 상태
- 에셋 올리기: `uploadFile`에 job/pass/equipment/timeOrigin/subject/situation을 넘긴다.
- 녹화: `UploadAssetUseCase.execute` → `upload`(pass·equipment 빈값, subject·situation 없음)만 호출한다.
- `[MM-UPLOAD]`는 공통 `_send`에서 이미 찍힌다.

## 바꿀 것
1. `CameraRecordingViewModel`에 `subject`, `situation`, `equipmentId` 상태와 변경 콜백을 둔다. 기존 `passId`(Args)·`jobId`·`recordedAt`(=timeOrigin)과 함께 쓴다.
2. `_uploadFile`은 `execute` 대신 `uploadAssetUseCase.uploadFile(...)`을 호출해 영상·음성에 동일 metadata를 넣는다.
3. 녹화 패널 UI에 주제·상황 입력란을 추가한다. `commentBody`(CreateComment body)와 라벨을 분리한다. 장비 ID는 선택 입력란으로 두고 비우면 metadata에서 생략된다.
4. `CameraRecordingArgs`에 `equipmentId` 초기값을 받을 수 있게 하고 locator에 연결한다(기본 `''`).
5. 타임라인 배치·CreateComment·후처리 대기·`[MM-UPLOAD]` 로그 경로는 유지한다.

## 유지할 것
- `RemoteAssetUploadRepository.uploadFile` / `_metadataJson` / multipart·tus
- 에셋 올리기 다이얼로그·큐 UX
- CreateComment의 `body` = `commentBody` (Asset subject와 혼동하지 않음)

## 이번 작업에서 만들지 않음
- 에셋 올리기 수준의 작업/패스/장비 콤보·목록 UI
- `UploadAssetUseCase.execute` 삭제(다른 호출이 있으면 유지)
- 서버·proto 변경

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
- 관련 테스트가 있으면 `./scripts/agent_check.sh test/screen_comment_test.dart` 통과
- 녹화 업로드 `[MM-UPLOAD]` metadata에 입력한 subject/situation(및 장비·패스가 있으면 해당 키)이 보인다
- 주제/상황을 비우면 기존처럼 jobId+timeOrigin만 나갈 수 있다
- 코멘트 글은 CreateComment body로만 가고 Asset subject와 섞이지 않는다
