# 에셋 상세 properties를 들여써 표시한다

## 목표
에셋 상세 「원래 properties 보기」에서 properties를 들여쓴 JSON으로 읽기 쉽게 본다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/asset_lookup/asset_lookup_detail_screen.dart`
4. `lib/src/presentation/features/asset_lookup/widgets/asset_preview_pane.dart` (`JsonEncoder.withIndent` 패턴)
5. 없음

## 현재 상태
- `asset_lookup_detail_screen.dart` Expander content가 `asset.propertiesJson`을 한 줄 `SelectableText`로 보여 준다.
- repository는 `jsonEncode(asset.properties.toProto3Json())`로 compact JSON을 넣는다.
- `asset_preview_pane.dart`의 JSON 미리보기는 `JsonEncoder.withIndent('  ')`를 쓴다.

## 바꿀 것
1. Expander content에서 `propertiesJson`을 파싱한 뒤 `JsonEncoder.withIndent('  ')`로 표시한다.
2. 파싱 실패 시 기존 원문을 그대로 표시한다.

## 유지할 것
- Expander·표시 조건(`propertiesJson.isNotEmpty`)
- repository의 `propertiesJson` 적재 방식
- 「정보」display 섹션·후처리·만든 경위

## 이번 작업에서 만들지 않음
- KV 그리드 전환
- 새 위젯 파일
- repository에서 미리 들여쓰기 저장

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
- properties가 들여쓰기된 JSON으로 보인다
- 파싱 실패 시 원문이 보인다
