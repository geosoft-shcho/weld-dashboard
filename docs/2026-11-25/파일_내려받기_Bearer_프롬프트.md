# 파일 내려받기 Bearer

## 목표
Asset 상세 「내려받기」 등에서 `https://tks.faivv.ai/api/files/...` GET에 `Authorization: Bearer`를 붙여 401 없이 저장한다.

## 먼저 읽을 것
1. `browser_open_url_web.dart` — `window.fetch(url)`만 호출, 헤더 없음
2. `authenticated_media.dart` — `readAuthenticatedMediaBytes`
3. 호출부: `asset_lookup_detail_screen.dart` 122–131, `asset_lookup_screen`, `asset_preview_pane` `_UnsupportedPreview`

## 현재 상태
- `downloadBrowserUrl`이 쿠키/Bearer 없이 fetch → 401 후 `openBrowserUrl`(새 탭도 무인증)
- 미리보기 영상은 Bearer blob 경로가 있으나 내려받기는 미적용

## 바꿀 것
1. `browser_open_url_web.dart`: http(s)면 `readAuthenticatedMediaBytes(url)` → `Blob` → object URL → `<a download>` (기존 UX 유지). 실패 시 짧은 실패만(무인증 `window.open` 폴백 제거 — 401만 반복됨)
2. stub은 시그니처 유지
3. 공통 fetch는 기존 `authenticated_media.dart`만 사용 (새 계층 없음)
4. `docs/2026-11-25/파일_내려받기_Bearer_프롬프트.md` 저장 후 구현
5. `로그인_권한_남은작업.md`에 내려받기 Bearer 한 줄

## 유지할 것
- 버튼 UI·호출부 문구
- 영상/이미지/PDF 미리보기 Bearer 경로

## 이번 작업에서 만들지 않음
- 대용량 Range/스트리밍 내려받기(2GB+는 메모리 한계 — 별도)
- 서버 변환·코덱 이슈
- 프록시·쿠키

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- Network: 내려받기 GET에 `Authorization: Bearer`
- 소용량 `/api/files`는 저장됨(대용량 OOM은 후속)
