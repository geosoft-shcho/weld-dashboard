# orphan subtitle이 span을 밀지 않게 한다

## 목표
GetTimeline에 영상·음성(~44초)과 함께 `startNs≈925088582000000` 같은 잘못된 subtitle이 있어도 `spanLabel`은 미디어 구간의 max end(예: `0:00:44`)를 쓴다.

## 현재 상태
- `[MM-SPAN]` 로그: clip 18692–18694 subtitle endSec≈925128 → spanLabel `256:58:48`
- video/audio·정상 subtitle은 0–44초대

## 바꿀 것
1. span 계산: assetDur>0 또는 video/audio로 미디어 앵커 max end를 구한 뒤, `start > mediaEnd+60`인 클립은 span에서 제외
2. ViewModel `spanSeconds`가 그 로직을 사용
3. 테스트로 orphan subtitle이 span을 밀지 않음을 검증
4. `[MM-SPAN]` 로그에 span 제외 여부 표시

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 및 관련 테스트 통과
- 로그 케이스에서 spanLabel `0:00:44`
