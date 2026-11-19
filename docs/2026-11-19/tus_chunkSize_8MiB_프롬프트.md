# tus chunkSize 8MiB

## 목표
프록시(tks.faivv.ai)가 tus 조각을 다 받은 뒤에야 본 서버로 넘기는 환경에서, Trace가 오래 `receive.started`/0%에 머무는 체감을 줄이기 위해 클라이언트 tus 조각 크기를 64MiB에서 8MiB로 줄인다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/data/datasources/asset_tus_upload_web.dart`
4. 없음

## 현재 상태
- `asset_tus_upload_web.dart`: `const chunkSize = 64 * 1024 * 1024;`

## 바꿀 것
1. `chunkSize`를 `8 * 1024 * 1024`로 변경. 필요하면 한 줄 주석으로 프록시·Trace 진행 이유를 짧게 남긴다.

## 유지할 것
- tus POST/PATCH 흐름, 진행률 콜백, Upload-Trace-Id 처리
- `tusMinBytes`(multipart vs tus 분기)는 변경하지 않음
- 업로드 UX 문구·대시보드 Trace UI는 이번 범위 밖

## 이번 작업에서 만들지 않음
- 로컬 진행 vs Trace 진행 이중 표시 UX
- 옛 안내 문서(2026-10-19/11-03) 일괄 수정
- 서버·프록시 설정 변경

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
- `chunkSize == 8 * 1024 * 1024`
