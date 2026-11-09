# spanLabel을 클립 span 기준으로 표시

## 목표
타임라인 보드 `playhead | span`의 span이 GetTimeline 클립 최대 `timelineEndNs`를 초로 환산한 값으로 보이게 한다. 예: endNs `44280000000` → 약 44초 → `0:00:44`. `24:00:00`처럼 하루 clamp에 걸린 오표시를 없앤다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/timeline_playhead_clock.dart`
4. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` `spanSeconds` / `spanLabel`
5. `lib/src/domain/timeline_time.dart`
6. 계약·화면안: 없음

## 현재 상태
- span 계산은 클립 endNs 최대값 기준(비어 있으면 `EMPTY_SPAN_SECONDS` 60)
- 포맷만 86400초 상한 → 하루 이상(또는 잘못된 큰 endNs)이면 `24:00:00`으로 뭉개짐

## 바꿀 것
1. **`formatPlayheadClock`** (`timeline_playhead_clock.dart`)
   - `clamp(0, 86400)` 제거
   - 음수·NaN·무한대만 0으로 가드
   - `H:MM:SS`는 실제 초 기준(시간이 24를 넘어도 그대로 표시). playhead/span/Properties 구간 라벨이 같은 함수를 쓰므로 동일 규칙
2. **`spanSeconds`** (`video_multimodal_view_model.dart`)
   - 유지: max clip endNs → seconds
   - 보강: `assetDurationNs`가 있고 `(end-start)`가 asset 길이보다 비정상적으로 크면(예: assetDur*2+60초 초과) span 기여는 `start+assetDur`로 잡는다. epoch ns 등 잘못된 end가 하루 clamp/`24:00:00`으로 보이던 경우를 클립 span 기준으로 되돌림
3. **테스트**: `secondsFromNanoseconds('44280000000')` ≈ 44.28, `formatPlayheadClock(44.28)` == `0:00:44` (기존 test 폴더에 짧은 단위 테스트 추가)

## 유지할 것
- GetTimeline 매핑(`_clipFrom`), playhead 동작, EMPTY_SPAN 60
- 보드 UI 레이아웃, MM-FILES 로그

## 이번 작업에서 만들지 않음
- 눈금 painter 성능 개편, 서버 proto 변경, 새 시계열 UI

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
- `./scripts/agent_check.sh test/<추가한>_test.dart` 통과
- 샘플 endNs 44.28초 → spanLabel `0:00:44`
- 86400 clamp로 인한 `24:00:00` 고정 표시 없음
