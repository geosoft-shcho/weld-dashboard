# `/api/files` 이미지 GET Bearer

## 목표
`https://tks.faivv.ai/api/files/.../ocr_fallback_....png` 같은 이미지가 로그인 세션으로 열리게 한다. `<img>`/`CachedNetworkImage`는 Web에서 Authorization을 못 붙이므로, 영상과 같이 `MediaTagDataSource.readBytes`(Bearer) → `MemoryImage`로 표시한다.

## 먼저 읽을 것
- [`work_detail_image_viewer.dart`](lib/src/presentation/features/work_detail/widgets/work_detail_image_viewer.dart) `CachedNetworkImageProvider(networkUrl)` — 헤더 없음
- [`asset_preview_pane.dart`](lib/src/presentation/features/asset_lookup/widgets/asset_preview_pane.dart) `_ImagePreview` 동일
- [`media_tag_data_source.dart`](lib/src/data/datasources/remote/media_tag_data_source.dart) `readBytes` Bearer
- 영상 패턴: [`multimodal_video_player.dart`](lib/src/presentation/features/video_multimodal/widgets/multimodal_video_player.dart) `_createController`

## 현재 상태
- RPC·`readBytes`·영상 blob·업로드 POST는 Bearer 있음.
- 이미지 뷰어는 `CachedNetworkImageProvider(url)`만 써 Web에서 `/api/files` GET이 쿠키/Bearer 없이 401.

## 바꿀 것

### 1. 인증 이미지 로더 (얇은 위젯)
- `lib/src/presentation/core/authenticated_network_image.dart` (StatefulWidget 하나)
- `url`이 http(s)이면 `locator<MediaTagDataSource>().readBytes(url)` → `Image`/`PhotoView`용 `MemoryImage`
- asset 경로는 기존 `AssetImage` 유지
- 로딩·에러 슬롯(또는 builder)만 받음. 새 추상 ImageProvider 계층·캐시 패키지 교체 없음

### 2. 삽입
- [`work_detail_image_viewer.dart`](lib/src/presentation/features/work_detail/widgets/work_detail_image_viewer.dart) — `providerFor` / `PhotoView`·`WorkDetailImageFrame`이 인증 로더를 쓰게 변경
- [`asset_preview_pane.dart`](lib/src/presentation/features/asset_lookup/widgets/asset_preview_pane.dart) — `_ImagePreview` 동일

### 3. 문서
- `docs/2026-11-25/이미지_files_Bearer_프롬프트.md` 저장 후 구현
- [`로그인_권한_남은작업.md`](docs/2026-11-23/로그인_권한_남은작업.md)에 이미지 Bearer 한 줄 체크(또는 기존 Web 영상 항목에 이미지 포함 표기)

## 유지할 것
- 영상 blob·업로드 Bearer
- `downloadBrowserUrl`(이번 범위 밖; 내려받기도 401이면 후속)

## 이번 작업에서 만들지 않음
- 프록시·쿠키
- `CachedNetworkImage` headers만으로 Web 해결 시도(Web에서 미디어 태그처럼 헤더가 무시될 수 있음)
- PDF·오디오 전면 수정

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다. 로더는 StatefulWidget 하나.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- Network: 해당 png GET에 `Authorization: Bearer` (`readBytes`)
- 작업 상세·파일 미리보기에서 OCR/크롭 이미지 표시(401 스와치 아님)
