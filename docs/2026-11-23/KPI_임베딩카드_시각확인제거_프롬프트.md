# KPI 임베딩 카드 · 시각 확인 제거

## 목표
「시각 확인 필요」카드를 제거하고, 임베딩·메타·코멘트 카드는 `GetCollectionSummary` 응답 필드의 분자/분모로 값을 표시한다.

## 먼저 읽을 것
- `lib/src/presentation/features/collection_monitoring/widgets/collection_kpi_cards.dart`
- `docs/2026-11-23/수집 현황 KPI · 타임라인 변경 안내.md` KPI 바인딩 표

## 현재 상태
- `timeUnverifiedAssetCount > 0`이면 「시각 확인 필요」카드를 그린다.
- 메타·코멘트는 분모>0·분자=0일 때 「집계 준비 중」문구를 쓴다.

## 바꿀 것
1. 「시각 확인 필요」카드 블록 제거. `KpiCardKind.timeUnverified` 미사용이면 enum에서도 제거.
2. 임베딩 진행: `embeddedClipCount / clipCount` (분모 0 → `—`, subtitle `분자 / 분모`).
3. 메타 임베딩: `attachedAssetCount > 0`일 때만 표시. 값=`embeddedAttachedAssetCount / attachedAssetCount` (비율·건수). 「집계 준비 중」분기 제거.
4. 코멘트 임베딩: `commentCount > 0`일 때만 표시. 값=`embeddedCommentCount / commentCount`. 「집계 준비 중」분기 제거.

## 유지할 것
- 파일·작업·용접·적재 카드
- summary 엔티티의 `timeUnverifiedAssetCount` 필드·매핑(표시만 제거)

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
- 샘플 기준: 임베딩 `100.0%` · `15,660 / 15,660`, 메타 `0.0%` · `0 / 17,666`, 코멘트 `0.0%` · `0 / 1`, 시각 확인 카드 없음
