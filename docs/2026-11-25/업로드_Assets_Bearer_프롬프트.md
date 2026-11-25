# POST `/api/assets` Bearer 부착

## 목표
로컬·배포에서 `https://tks.faivv.ai/api/assets` POST가 로그인 세션 토큰 없이 401 나지 않도록, Web `fetch` 업로드에 `Authorization: Bearer <token>`을 붙인다. 토큰은 기존 `MediaTagDataSource.sessionToken`(Login·restore와 동일).

## 먼저 읽을 것
- [`asset_multipart_upload_web.dart`](lib/src/data/datasources/asset_multipart_upload_web.dart) — POST `/assets` multipart, 헤더 없음
- [`asset_json_post_web.dart`](lib/src/data/datasources/asset_json_post_web.dart) — POST `/assets` JSON
- [`asset_tus_upload_web.dart`](lib/src/data/datasources/asset_tus_upload_web.dart) — POST `/uploads/` · PATCH · 마지막 POST `/assets`
- [`remote_asset_upload_repository.dart`](lib/src/data/repositories/remote_asset_upload_repository.dart) `_send` · `_postJsonAssets`

## 현재 상태
- Connect RPC는 `_attachBearer`로 Bearer 부착.
- 업로드는 `window.fetch`라 인터셉터를 타지 않아 Bearer가 없음 → 로그인 검사 켠 서버에서 `/api/assets` 401.

## 바꿀 것

### 1. 업로드 fetch에 `bearerToken` 인자
각 Web 함수에 `String? bearerToken` (또는 필수 `String bearerToken`) 추가. 비어 있지 않으면:

```dart
headers.set('Authorization', 'Bearer $token');
```

- [`asset_multipart_upload_web.dart`](lib/src/data/datasources/asset_multipart_upload_web.dart) / stub 시그니처 맞춤
- [`asset_json_post_web.dart`](lib/src/data/datasources/asset_json_post_web.dart) / stub
- [`asset_tus_upload_web.dart`](lib/src/data/datasources/asset_tus_upload_web.dart) / stub — create·PATCH 헤더 + 내부 `postAssetJson`에도 동일 토큰 전달  
  (큰 파일은 `/uploads`부터 막히므로 `/assets`만 고치면 불완전함)

### 2. Repository에서 토큰 전달
[`remote_asset_upload_repository.dart`](lib/src/data/repositories/remote_asset_upload_repository.dart):
- `_send` → `uploadAssetTus` / `_upload`에 `_mediaTag.sessionToken`
- `_postJsonAssets` → `postAssetJson`에 동일
- `AssetMultipartUpload` typedef에 `bearerToken` 파라미터 추가

### 3. 문서
- `docs/2026-11-25/업로드_Assets_Bearer_프롬프트.md` 저장 후 구현

## 유지할 것
- `readBytes`·영상 blob 경로
- RPC `_attachBearer`
- generated proto

## 이번 작업에서 만들지 않음
- 프록시·쿠키 게이트웨이
- `downloadBrowserUrl`의 fetch(별도; 요청 범위 밖)
- P3 권한 버튼 숨김

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다. 헤더는 fetch Headers에 한 줄로 붙인다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- Network: POST `/api/assets`에 `Authorization: Bearer …`
- (가능하면) tus POST `/uploads/` · PATCH에도 동일
- 로그인 후 작은 파일 multipart 업로드 성공(또는 401 해소)
