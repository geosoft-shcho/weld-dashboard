# `/api/files` PDF·mkv Bearer 공통화

## 목표
`…/23764.pdf`, `….mkv` 같은 `/api/files` GET도 로그인 Bearer로 받게 하고, 이미지·영상·PDF가 같은 인증 fetch를 한 파일에서 쓰게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `authenticated_network_image.dart`, `authenticated_media_blob*.dart`
4. `pdfrx_document_source.dart` / `work_detail_pdf_viewer.dart` / `asset_preview_pane.dart`
5. `multimodal_video_player.dart` · `work_detail_chewie_stage.dart`의 `_createController`
6. 계약·화면안: 없음

## 현재 상태
- **PDF**: `PdfrxDocumentSource.uri` / `resolvePdfrxDocumentSource`가 http를 URI로만 넘김 → Web에서 Authorization 없이 GET → 401
  - `asset_preview_pane`, `work_detail_pdf_viewer`, `work_detail_report_panel`, `paper_scan_host`
- **영상**: Web은 이미 `readBytes` → blob. 다만 `mimeTypeForMediaUrl`에 `.mkv` 없음 → 기본 `video/mp4`로 blob 생성
- **이미지**: `AuthenticatedNetworkImage`가 `locator.readBytes`를 직접 호출 (공통 함수 없음)
- **영상 두 곳**: `readBytes` + blob 생성이 플레이어마다 복붙

## 바꿀 것
1. **공통 한 파일** `lib/src/presentation/core/authenticated_media.dart`
   - `readAuthenticatedMediaBytes(url)` → `MediaTagDataSource.readBytes`
   - `mimeTypeForMediaUrl`에 `.mkv`(및 기존 webm/mov/mp4)
   - blob create/revoke는 기존 conditional export를 이 파일에서 re-export
   - Web 영상용 `createAuthenticatedMediaBlobPlaybackUrl`(bytes+mime+blob)로 플레이어 중복 제거
2. **이미지**: `AuthenticatedNetworkImage`가 위 공통 함수만 호출
3. **영상**: `MultimodalVideoPlayer` · `WorkDetailChewieStage`가 공통 bytes+blob(+mime) 사용, mkv mime 반영
4. **PDF**: http(s)는 `readAuthenticatedMediaBytes` → `PdfrxDocumentSource.data`로 여는 얇은 StatefulWidget 하나(`AuthenticatedPdfrxDocument`). `asset_preview_pane`, `work_detail_pdf_viewer`, `work_detail_report_panel`, `paper_scan_host` 호출부를 그것으로 교체. asset/file 경로는 기존 `resolvePdfrxDocumentSource` 유지
5. **문서**: `docs/2026-11-23/로그인_권한_남은작업.md`에 PDF·mkv Bearer 반영

## 유지할 것
- 업로드 POST Bearer, 세션 토큰 저장 방식
- `downloadBrowserUrl` 브라우저 내려받기(이번 범위 밖; 401이면 후속)
- 기존 PhotoView / Chewie / pdfrx UI
- 비-Web 영상의 `httpHeaders` Bearer 경로

## 이번 작업에서 만들지 않음
- 프록시·쿠키, CORS 서버 설정
- 오디오 전면 개편, PDF 검색 UI 변경
- 새 ImageProvider/캐시 패키지, 새 상태관리

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
- Network: PDF·mkv(해당 미리보기) GET에 `Authorization: Bearer` (`readBytes`)
- PDF·mkv가 401 없이 표시/재생
