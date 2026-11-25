# Web `/api/files` Bearer 재생 (blob)

## 목표
`MEDIA_TAG_BASE_URL=https://tks.faivv.ai/api`를 배포·로컬 모두 유지한다. Web `<video>`는 헤더를 못 붙이므로 `MediaTagDataSource.readBytes`(이미 `Authorization: Bearer <token>`)로 파일을 받은 뒤 **blob object URL**로 재생한다. 프록시·쿠키 게이트웨이는 쓰지 않는다(이전에 롤백한 경로).

## 먼저 읽을 것
- [`multimodal_video_player.dart`](lib/src/presentation/features/video_multimodal/widgets/multimodal_video_player.dart) `_open`
- [`work_detail_chewie_stage.dart`](lib/src/presentation/features/work_detail/widgets/work_detail_chewie_stage.dart) `_load`
- [`media_tag_data_source.dart`](lib/src/data/datasources/remote/media_tag_data_source.dart) `readBytes` Bearer
- [`browser_open_url_web.dart`](lib/src/presentation/core/browser_open_url_web.dart) `createObjectURL` 패턴

## 현재 상태
- RPC/`readBytes`는 Bearer. Web `VideoPlayerController.networkUrl`은 `src`만 설정 → `/api/files` 401.
- `.env`는 tks 직행. 동일 출처 프록시·쿠키 심기는 롤백됨.

## 바꿀 것

### 1. blob URL 헬퍼 (조건부 import)
- `lib/src/presentation/core/authenticated_media_blob.dart` + `_web.dart` / `_stub.dart`
- Web: `Uint8List` → `Blob` → `URL.createObjectURL`, `revokeAuthenticatedMediaBlobUrl`
- stub: no-op revoke / 미사용

### 2. [`multimodal_video_player.dart`](lib/src/presentation/features/video_multimodal/widgets/multimodal_video_player.dart)
`_open`에서 http(s)일 때:
1. `locator<MediaTagDataSource>().readBytes(source)` (Bearer)
2. `kIsWeb`이면 blob URL로 `VideoPlayerController.networkUrl(Uri.parse(blobUrl))`
3. non-Web이면 `networkUrl(..., httpHeaders: {Authorization: Bearer …})` (토큰 있을 때)
4. dispose/`_release`에서 blob URL `revoke`
5. 기존 디버그 `_errorText`/`debugPrint` 유지

### 3. [`work_detail_chewie_stage.dart`](lib/src/presentation/features/work_detail/widgets/work_detail_chewie_stage.dart)
같은 Bearer→blob / httpHeaders 패턴으로 `_load` 맞춤(작업 상세 영상도 동일 401 방지).

### 4. 문서
- 확인된 프롬프트를 `docs/2026-11-25/웹_영상_Bearer_blob_프롬프트.md`로 저장 후 구현
- [`로그인_권한_남은작업.md`](docs/2026-11-23/로그인_권한_남은작업.md)에 blob 경로 한 줄 반영(프록시 항목은 열린 채로 두거나 blob으로 대체 표기)

## 유지할 것
- `MEDIA_TAG_BASE_URL=https://tks.faivv.ai/api` (로컬 `.env` 직행 유지)
- RPC Bearer 인터셉터
- 오디오(`just_audio`)·프록시 스크립트는 이번 범위 밖

## 이번 작업에서 만들지 않음
- 개발 API 프록시·`mediatag_session` 쿠키 재도입
- 서버 CORS 변경
- MSE/Range 스트리밍(전체 파일 blob; 대용량은 메모리 사용 증가 — 이번엔 단순 blob만)

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다. blob 헬퍼는 createObjectURL/revoke만.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- 로컬 Chrome: 로그인 후 멀티모달 `/api/files` 영상 재생(401·MEDIA_ERR_SRC_NOT_SUPPORTED 아님)
- Network: `readBytes`용 GET에 `Authorization: Bearer` (blob 재생 자체는 blob: URL)
- 배포용 BASE_URL tks 유지·프록시 불필요
