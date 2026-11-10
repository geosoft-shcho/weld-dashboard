# 에셋 상세 「정보」를 Asset.display만 남긴다

## 목표
에셋 상세 「정보」 영역에는 서버 proto `Asset.display[]`의 label/value만 보인다. 장비·크기·길이·파생 행은 제거한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/asset_lookup/asset_lookup_detail_screen.dart`
4. `lib/src/data/repositories/remote_asset_lookup_repository.dart` (`displayFields` 적재)
5. 없음 (별도 화면안 없음)

## 현재 상태
- `asset_lookup_detail_screen.dart` 「정보」`LookupDetailKvGrid`: 장비(`equipmentId`→이름), `asset.displayFields`, 크기(`sizeBytes`), 길이(`durationNs`), 파생(`childCount`)을 함께 표시한다.
- `displayFields`는 상세 조회 시 proto `Asset.display`의 label/value만 담는다.

## 바꿀 것
1. 「정보」`LookupDetailKvGrid`에서 장비·크기·길이·파생 행을 제거한다.
2. `displayFields`의 label/value만 표시한다.
3. `displayFields`가 비어 있으면 「정보」제목과 그리드를 숨긴다.

## 유지할 것
- 주제·상황·기록 시각, 후처리, properties Expander, 만든 경위 섹션
- repository의 `displayFields` 매핑·엔티티 구조
- PropertiesSideBody / clip detail 매핑

## 이번 작업에서 만들지 않음
- 제거한 장비·크기·길이·파생을 다른 섹션으로 옮기기
- repository/엔티티/API 변경
- 새 위젯·테스트 파일

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
- 「정보」에 `Asset.display` 항목만 보인다
- display가 없으면 「정보」섹션이 보이지 않는다
