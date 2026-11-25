# Web TextField DOM assertion 완화

## 목표
터미널의 `The DOM element of this text editing strategy is not currently active` assertion이 Asset 상세에서 재현되지 않게 한다(앱 쪽 포커스 레이스 제거).

## 먼저 읽을 것
1. `asset_lookup_detail_screen.dart` `_didTapEditSubjectSituation` — 저장 시 `busy=true` → `_MultilineTextInput(enabled: !busy)`
2. 같은 파일 「내려받기」버튼 — 긴 `downloadBrowserUrl` 중 포커스 유지 가능
3. Flutter Web engine: focused `TextField`가 `enabled`/config 갱신될 때 `text_editing.dart` assert (알려진 엔진 이슈)

## 현재 상태
- 스택: `EditableText.didUpdateWidget` → `TextInput.updateConfig` → `activeDomElement` assert
- 편집 다이얼로그에서 저장 누르면 포커스된 `TextField`가 바로 `enabled: false`로 바뀜 → Web에서 DOM 전략이 비활성인데 config 갱신
- 내려받기 변경과 직접 무관하나, 버튼 클릭 직후 포커스/리빌드와 겹치면 같은 assert가 날 수 있음

## 바꿀 것
1. `_didTapEditSubjectSituation` 저장 핸들러: `setDialogState(busy=true)` **전에** `FocusManager.instance.primaryFocus?.unfocus()`
2. 에러로 `busy=false` 복구할 때도 불필요하면 포커스 강요하지 않음(현행 유지)
3. 「내려받기」`onPressed`: `unfocus()` 후 `downloadBrowserUrl` 호출
4. 프롬프트 `docs/2026-11-25/Web_TextField_포커스_assertion_프롬프트.md` 저장 후 구현

## 유지할 것
- Material `TextField` + `WaveformMaterialScope` 패턴
- 내려받기 Bearer 로직
- Flutter SDK 업그레이드(이번 범위 밖)

## 이번 작업에서 만들지 않음
- Flutter 엔진 패치·SDK bump
- TextField → Fluent TextBox 전면 교체
- upload_dialog 전면 점검(동일 패턴이 재현되면 후속)

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
- Asset 상세: 주제·상황 편집에서 입력 중 「저장」→ assert 없이 저장/닫힘
- 「내려받기」클릭 직후 동일 assert가 콘솔에 새로 쌓이지 않음
